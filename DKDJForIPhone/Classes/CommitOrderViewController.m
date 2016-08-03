//
//  CommitOrderViewController.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/3.
//
//

#import "CommitOrderViewController.h"
#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "AddOrderViewController.h"
#import "FileController.h"
#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJEditShopCartNumberPopView.h"
#import "AddOrderToServerNewViewController.h"
#import "UserAddressListViewController.h"
#import "HJPopViewNotice.h"
#import "FoodModel.h"
#import "AliPayModel.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"

@interface CommitOrderViewController ()

@end

@implementation CommitOrderViewController{
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    UILabel * userAddressLable;
    UILabel * userNamesLabel;
    NSString * userTel;
    NSString * userNames;
    UILabel * OderTimeInfo;
    UserAddressListViewController *UserAddressListVC;
    UIScrollView * scrollV;
    NSMutableArray *   address;
    BOOL                hasMore;
    NSMutableArray* payIconImgViewArr;
    NSInteger payType;
    BOOL addOrderSucess;
    UITextField* markTextField;
    CGFloat   HaveMoney;
    BOOL HaveMoneyPay;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    }
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    UserAddressListVC=[[UserAddressListViewController alloc]init];
    return self;
}
-(void)changeUserInfo{
    UserAddressListViewController* viewController = [[UserAddressListViewController alloc] initWithDefault];
    viewController.isFromOrder=YES;
    viewController.delegate=self;
    UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void) loadUserInfoView{
    UIColor * lineColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    UIView * userInfoView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 10, 375, 118)];
    userInfoView.backgroundColor=[UIColor whiteColor];
    [scrollV addSubview:userInfoView];
    
    
    UIImageView * lineImageView=[[UIImageView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 10)];
    lineImageView.image=[UIImage imageNamed:@"鸭子"];
    [userInfoView addSubview:lineImageView];
    
    userAddressLable=[[UILabel alloc]init];
    userAddressLable.frame=RectMake_LFL(10, 15, 300 , 15);
    userAddressLable.font=[UIFont systemFontOfSize:16];
    [userInfoView addSubview:userAddressLable];
    
    userNamesLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 40, 300, 13)];
    userNamesLabel.font=[UIFont systemFontOfSize:14];
    userNamesLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [userInfoView addSubview:userNamesLabel];
    
    
    UIButton * userInfoBtn=[[UIButton alloc]initWithFrame:RectMake_LFL(0,15, 375, 68-15)];
    [userInfoBtn addTarget:self action:@selector(changeUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [userInfoView addSubview:userInfoBtn];
    
    UILabel * lable =[[UILabel alloc]initWithFrame:RectMake_LFL(10, 73, 200, 40)];
    lable.text=@"送达时间";
    lable.font=[UIFont systemFontOfSize:16];
    [userInfoView addSubview:lable];
    
    UILabel * sendStateLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(375-100-45, 73, 100, 40)];
    sendStateLabel.textAlignment=NSTextAlignmentRight;
    sendStateLabel.text=@"立刻配送";
    sendStateLabel.font=[UIFont systemFontOfSize:14];
    [userInfoView addSubview:sendStateLabel];
    
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 68, 375, 0.5)];
    line.backgroundColor=lineColor;
    [userInfoView addSubview:line];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:RectMake_LFL(375-18, 30, 8, 15)];
    imageView.image=[UIImage imageNamed:@"icon_left"];
    [userInfoView addSubview:imageView];
    
    imageView=[[UIImageView alloc]initWithFrame:RectMake_LFL(375-18, 85, 8, 15)];
    imageView.image=[UIImage imageNamed:@"icon_left"];
    [userInfoView addSubview:imageView];
}
-(void)PayBtnClick:(UIButton *)btn{
    
    if (payIconImgViewArr.count==3) {
        payType=btn.tag==0? 3: btn.tag==1 ? 1 : 5;
    }else{
        payType=btn.tag==0? 1 : 5;
    }
    for (UIImageView * iv in payIconImgViewArr) {
        if (iv.tag==btn.tag) {
            iv.image=[UIImage imageNamed:@"CheckMark选择"];
        }else{
            iv.image=[UIImage imageNamed:@"CheckMark"];
        }
    }
}

-(void)loadShopCartView{
    
    float y=128;
    UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(0, y, 375, 30)];
    label.text=@"   选择支付方式";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [scrollV addSubview:label];
    y+=30;
    
    
    NSArray * arr= HaveMoney>0 ? @[@"余额支付",@"支付宝",@"微信钱包"]: [NSArray arrayWithObjects:@"支付宝",@"微信钱包", nil];
    payIconImgViewArr =[NSMutableArray array];
    
    int i=0;
    for (NSString * str in arr) {
        UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, y, 375, 40)];
        view.backgroundColor =[UIColor whiteColor];
        [scrollV addSubview:view];
        
        UILabel * label =[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 200, 40)];
        label.text=str;
        label.font=[UIFont systemFontOfSize:16];
        [view addSubview:label];
        
        UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(10, 0.5, 355, 0.5)];
        line.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [view addSubview:line];
        
        
        UIImageView * iv =[[UIImageView alloc]initWithFrame:RectMake_LFL(375-30, 10, 20, 20)];
        iv.image=[UIImage imageNamed:@"CheckMark"];
        iv.tag=i;
        [view addSubview:iv];
        [payIconImgViewArr addObject:iv];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        btn.frame=view.bounds;
        [btn addTarget:self action:@selector(PayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        i++;
        y+=40;
    }
    //做个默认选择；
    UIButton * btn=[UIButton new];
    btn.tag=0;
    [self PayBtnClick:btn];
    
    label=[[UILabel alloc]initWithFrame:RectMake_LFL(0, y, 375, 30)];
    label.text=@"   明细";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [scrollV addSubview:label];
    y+=30;
    
    UIColor * lineColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    MyShopCart *   MyShopCartModel=app.shopCart;
    //FoodModel  ShopCardModel
    ShopCardModel * model=MyShopCartModel.shopCartArry[0];
    //    app.shopCart.cPackageFee;
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    [scrollV addSubview:view];
    UILabel * shopNamelabel=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 300, 40)];
    shopNamelabel.text=model.shopName;
    shopNamelabel.font=[UIFont boldSystemFontOfSize:17];
    [view addSubview:shopNamelabel];
    
    UIView * line =[[UIView alloc]initWithFrame:RectMake_LFL(10, 40, 355, 0.5)];
    line.backgroundColor=lineColor;
    [view  addSubview:line];
    CGFloat foodY =50;
    for (FoodModel * foodModel in model.foodArry) {
        UILabel * foodInfoLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(10, foodY, 250, 13)];
        foodInfoLabel.font=[UIFont systemFontOfSize:14];
        foodInfoLabel.text =[NSString stringWithFormat:@"%@ x%d",foodModel.foodname,foodModel.count];
        [view addSubview:foodInfoLabel];
        
        UILabel * foodPriceLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(375-110, foodY, 100, 13)];
        foodPriceLabel.font=[UIFont systemFontOfSize:14];
        foodPriceLabel.textAlignment=NSTextAlignmentRight;
        foodPriceLabel.text=[NSString stringWithFormat:@"￥%.2f",foodModel.price];
        [view addSubview:foodPriceLabel];
        foodY+=23;
    }
    //    foodY-=13;
    line =[[UIView alloc]initWithFrame:RectMake_LFL(10, foodY, 355, 0.5)];
    line.backgroundColor=lineColor;
    [view  addSubview:line];
    foodY +=10;
    
    UILabel *lable1=[[UILabel alloc ]initWithFrame:RectMake_LFL(10, foodY, 100, 13)];
    lable1.text=@"打包费";
    lable1.font=[UIFont systemFontOfSize:14];
    [view addSubview:lable1];
    
    UILabel * label11=[[UILabel alloc]initWithFrame:RectMake_LFL(375-110, foodY, 100, 13)];
    label11.text=[NSString stringWithFormat:@"￥%.1f", model.packageFee];
    label11.font=[UIFont systemFontOfSize:14];
    label11.textAlignment=NSTextAlignmentRight;
    [view addSubview:label11];
    
    foodY +=23;
    
    UILabel *lable=[[UILabel alloc ]initWithFrame:RectMake_LFL(10, foodY, 100, 13)];
    lable.text=@"配送费";
    lable.font=[UIFont systemFontOfSize:14];
    [view addSubview:lable];
    
    lable=[[UILabel alloc]initWithFrame:RectMake_LFL(375-110, foodY, 100, 13)];
    lable.text=[NSString stringWithFormat:@"￥%.1f", model.sendMoney];
    lable.textAlignment=NSTextAlignmentRight;
    lable.font=[UIFont systemFontOfSize:14];
    [view addSubview:lable];
    
    foodY +=23;
    
    line =[[UIView alloc]initWithFrame:RectMake_LFL(10, foodY, 355, 0.5)];
    line.backgroundColor=lineColor;
    [view  addSubview:line];
    foodY +=10;
    
    NSMutableAttributedString * aStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"总计：￥%.1f", model.cAllPrice+model.sendMoney+model.packageFee]];
    
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
    lable=[[UILabel alloc]initWithFrame:RectMake_LFL(375-110, foodY, 100, 13)];
    lable.attributedText=aStr;
    lable.textAlignment=NSTextAlignmentRight;
    lable.font=[UIFont systemFontOfSize:14];
    [view addSubview:lable];
    foodY +=20;
    view.frame= RectMake_LFL(0, y, 375, foodY);
    CGFloat atScrollY=y+foodY;
    
    
    label=[[UILabel alloc]initWithFrame:RectMake_LFL(10, atScrollY, 355, 30)];
    label.text=@"备注";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [scrollV addSubview:label];
    
    atScrollY+=30;
    UIView * textBackView=[[UIView alloc]initWithFrame:RectMake_LFL(0, atScrollY, 375, 70)];
    textBackView.backgroundColor=[UIColor whiteColor];
    [scrollV addSubview:textBackView];
    
    markTextField =[[UITextField alloc]initWithFrame:RectMake_LFL(10, 10, 355, 50)];
    markTextField.borderStyle=UITextBorderStyleRoundedRect;
    markTextField.placeholder=@"例：多双筷子 少放醋";
    [textBackView addSubview:markTextField];
    
    
    scrollV.contentSize=SizeMake_LFL(375, atScrollY+70);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    app.shopCart.userID = self.uduserid;
    [app.shopCart checkAll:YES];
    self.title=@"确认订单";
    payType=404;//让支付id 不在0~2 范围
    UIColor * lineColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    scrollV=[[UIScrollView alloc]initWithFrame:RectMake_LFL(0, 0, 376, 667-49)];
    scrollV.backgroundColor=lineColor;
    [self.view addSubview:scrollV];
    [self loadUserInfoView];
    
    [self getAddrList];
    
    NSString *url = APP_PATH  @"getuserinfo.aspx";
    
    [MHNetworkManager postReqeustWithURL:url params:@{@"userid":self.uduserid} successBlock:^(NSDictionary *returnData) {
        
        HaveMoney=[[returnData objectForKey:@"HaveMoney"] floatValue];
        [self loadShopCartView];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:YES];
    
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=app.sysTitleColor;
    btn.frame=RectMake_LFL(0, 667-49, 375, 49);
    [btn addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认下单" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    btn.titleLabel.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:btn];
    
}
- (BOOL)IsLogin{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    if([self.uduserid intValue]  > 0 )  {
        return YES;
    }else{
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        [self.navigationController pushViewController:LoginController animated:YES];
        return NO;
    }
}


-(void)getAddrList{
    int page=1;
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addressDidReceive:obj:)];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",self.uduserid,@"userid",@"100",@"pagesize", nil];
    [twitterClient getUserAddressList:param];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
    
}
- (void)addressDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    int page=1;
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    NSInteger prevCount = (int)[address count];//已经存在列表中的数量
    if (obj == nil){
        return;
    }
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"total: %@",totalString);
        NSLog(@"page: %d",page);
    }
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];
    
    if ([ary count] == 0) {
        hasMore = false;
    }
    //判断是否有下一页
    int totalpage = 1;//[totalString intValue];
    if( totalpage > page ){
        ++page;
        hasMore = true;
    }else{
        hasMore = false;
    }
    NSDictionary* dic1 = (NSDictionary*)obj;
    //2. 获取list
    NSArray *arr = nil;
    arr = [dic1 objectForKey:@"shoplist"];
    [app.shopCart checkShopCard:arr];
    if (page == 1) {
        [address removeAllObjects];
        prevCount = 0;
    }
    if ([ary count]) {
        UserAddressMode *model = [[UserAddressMode alloc] initWithJsonDictionary:[ary objectAtIndex:0]];
        [self UpdateUserAddressViewWithModel:model];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:@"isShowNotice"];
    if (value == nil || [value compare:@"1"] != NSOrderedSame){
        HJPopViewNotice *pop = [[HJPopViewNotice alloc] initWithView:app.window];
        [pop showDialog];
        [defaults setObject:@"1" forKey:@"isShowNotice"];
        [defaults synchronize];
    }
    
}
//选择地址后传来的代理数据
-(void)UserAddressListViewController:(UserAddressListViewController *)VC withModel:(UserAddressMode *)UserAddressMode{
    [self UpdateUserAddressViewWithModel:UserAddressMode];
}
-(void)UpdateUserAddressViewWithModel:(UserAddressMode *)model{
    self.tfAddress=model.buildingName;
    userAddressLable.text=model.address;
    userNamesLabel.text =[NSString stringWithFormat:@"%@\t%@",model.receiverName,model.phone];
    userNames=model.receiverName;
    userTel=model.phone;
}
- (void)gotoNext:(id)sender{
    if( (![self IsLogin]) ){
        return;
    }
   
    if(app.shopCart.foodCount > 0){
        if(app.shopCart.cFoodCount < 1){

            UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"您未勾选任何商品无法提交！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addAction:aa1];
            
            [self presentViewController:ac animated:YES completion:nil];
            return;
        }
        for (int i = 0; i < [app.shopCart.shopCartArry count]; i++) {
            ShopCardModel *shopCard = [app.shopCart.shopCartArry objectAtIndex:i];
            if(shopCard.cAllPrice < shopCard.startMoney)
            {
                NSString *msg = [NSString stringWithFormat:@"您购买的物品总价未达到商家%@的起送金额%.2f", shopCard.shopName, shopCard.startMoney];
                UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
               
                [ac addAction:aa1];
                [self presentViewController:ac animated:YES completion:nil];
                return;
            }
        }

        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_emp", @"购物车中尚无餐品，请先选择餐品") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    
    switch (payType) {
        case 3:{
            HaveMoneyPay=YES;
            if (HaveMoney>app.shopCart.allPrice) {
                UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"请输入登录密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    app.shopCart.payPassword=ac.textFields[0].text;

                    [self addToServer:nil];
                }];
                
                [ac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"登录密码";
                    textField.textColor = app.sysTitleColor;
                    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    textField.borderStyle = UITextBorderStyleRoundedRect;
                    textField.secureTextEntry = YES;
                }];
                [ac addAction:aa1];
                [self presentViewController:ac animated:YES completion:nil];
                app.shopCart.payMode = 3;
            }else{
                UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"余额不足，请选择其他支付补差价" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    payType=1;
                    app.shopCart.payMode = 1;
                    [self addToServer:nil];
                }];
                UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"微信支付" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    payType=5;
                    app.shopCart.payMode = 5;
                    [self addToServer:nil];
                }];

                [ac addAction:aa1];
                [ac addAction:aa2];
                
                [self presentViewController:ac animated:YES completion:nil];
            }
            
        }
            break;
        case 1:
            app.shopCart.payMode = 1;
            [self addToServer:nil];
            break;
        case 5:
            app.shopCart.payMode = 5;
            [self addToServer:nil];
            break;
        default:
            break;
    }
    
}
-(NSString *)getSystemTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateformatter stringFromDate:senddate];
}
-(void)addToServer:(id)sender
{
    
    
    app.shopCart.custName = userNames;
    app.shopCart.phone = userTel;
    app.shopCart.Address = userAddressLable.text;
    app.shopCart.note =markTextField.text;
    app.shopCart.Address = [NSString stringWithFormat:@"%@", app.shopCart.Address];
    app.shopCart.uLat = [NSString stringWithFormat:@"%f", app.useLocation.lat];
    app.shopCart.uLng = [NSString stringWithFormat:@"%f", app.useLocation.lon];
    app.shopCart.addTime = [self getSystemTime];
    app.shopCart.sendTime = [self getSystemTime];
    app.shopCart.areaID = @"0";
    app.shopCart.userID = self.uduserid;
    app.shopCart.userName = userNames;
    app.shopCart.areaID = app.Area.cID;
    
    if (twitterClient) return;
    
    //联网提交订单
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
    
    NSString *value = [app.shopCart getJSONString];
    NSLog(@"%@",value);
    
    [twitterClient SubmitOrder:value orderType:app.shopCart.buyType];

    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"shop_cart_add_order", @"提交中...");
    [_progressHUD show:YES];
    
    
    
}

- (void)addorderDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    twitterClient = nil;
    //1. 获取信息
    NSDictionary *dic = (NSDictionary*)obj;
    //注意此处必须 用self.dic 不能直接使用dic 否则在其他函数中 self.dic是null
    int state;
    if (app.shopCart.buyType < 2) {
        state = [[dic objectForKey:@"orderstate"] intValue];
        
        self.payMoney = [[dic objectForKey:@"totalprice"] floatValue];
        self.orderId = [dic objectForKey:@"orderid"];
        
        if(state == 1){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userAddressLable.text forKey:@"Reciver"];
            [defaults setObject:userTel forKey:@"Phone"];
            [defaults setObject:self.tfAddress forKey:@"RoomDr"];
            [defaults synchronize];
            [app.shopCart Clean];
            addOrderSucess = YES;

            
        }else{
            NSString *msg = [dic objectForKey:@"msg"];
            if (msg == nil) {
                msg = CustomLocalizedString(@"public_net_or_data_error", @"网络或数据错误！请稍后再试！");
            }

            UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];

            [ac addAction:aa1];

            [self presentViewController:ac animated:YES completion:nil];
        }
    }
    if(addOrderSucess){
        if (HaveMoneyPay) {
            if (HaveMoney>self.payMoney) {
                UIAlertController * ac =[UIAlertController alertControllerWithTitle:@"余额支付成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                }];
                
                [ac addAction:aa1];
                
                [self presentViewController:ac animated:YES completion:nil];
            }else{
//                NSLog(@"%f,%f,%f",self.payMoney,HaveMoney,self.payMoney-HaveMoney);
                [self getPayID:self.payMoney-HaveMoney];
            }
        }else{
            [self getPayID:self.payMoney];
        }
        
    }
    
    
}
#pragma mark 获取支付数据
-(void)getPayID:(float)moeny{
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(payIDDidReceive:obj:)];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderId, @"orderid", [NSString stringWithFormat:@"%.2f", moeny],@"price", nil];
    
    [twitterClient getPayID:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"pay_load_id", @"获取支付数据中...");
    [_progressHUD show:YES];
    
}

- (void)payIDDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    
    
    twitterClient= nil;
    
    if (client.hasError) {
        [client alert];
        client = nil;
        return;
    }
    client = nil;
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic1 = (NSDictionary*)obj;
    
    int state = [[dic1 objectForKey:@"state"] intValue];
    if (state == 1) {
        self.payId = [dic1 objectForKey:@"batch"];
        if (HaveMoneyPay) {
            if (HaveMoney>self.payMoney) {
                
            }else{
                [self gotoOnLinPay:self.payMoney-HaveMoney orderid:self.orderId];
            }
        }else{
            [self gotoOnLinPay:self.payMoney orderid:self.orderId];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"pay_load_id_error", @"获取支付数据失败！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark 在线支付

-(void)gotoOnLinPay:(float)payMoney orderid:(NSString *)odid
{
    switch (payType) {
        case 0:
            break;
        case 1:
            
            [self aliPay:odid money:payMoney type:1];
            break;
        case 5:
            NSLog(@"%f",(double)self.payMoney-(double)HaveMoney);
            [app WXsendPay:odid payid:self.payId price:payMoney];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            
            [app SetTab:1];
            break;
        default:
            break;
    }
}
#pragma mark 支付宝

-(void)aliPay:(NSString *)odid money:(float)payMoney type:(int)payType{
    
    
    AliPayModel *order = [[AliPayModel alloc] init];
    order.partner = AliPartner;
    order.seller = AliSeller;
    
    order.tradeNO = self.payId; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@%@%@", app.appName, CustomLocalizedString(@"shop_cart_pay_title", @"IOS支付 订单编号："), odid]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"订单编号：%@,%@", self.payId,odid]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",payMoney]; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"http%%3A%%2F%%2F%@%%2FAlipay%%2Fiosnotify.aspx", HOST];//回调URL
    //@"http%3A%2F%2Fmapdc.ihangjing.com%2FAlipay%2Fiosnotify.aspx"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"AliPayHangJing";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    self.payId = nil;//每次支付都要重新获取
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AliPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            int state = [[resultDic objectForKey:@"resultStatus"] intValue];
            NSNotification* notification;
            if (state == 9000) {
                notification = [NSNotification notificationWithName:APP_URL_COMBACK object:nil];
            }else if(state == 6001){
                notification = [NSNotification notificationWithName:APP_URL_COMBACK_CANCEL object:nil];
            }else{
                notification = [NSNotification notificationWithName:APP_URL_COMBACK_FAILD object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
        
    }
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [app SetTab:1];
}



-(void)goToBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
