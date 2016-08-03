//
//  ChangePasswordViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "OrderDetailNewViewController.h"
#import "LoginNewViewController.h"
#import "FoodInOrderModelFix.h"
#import "CommendDetailViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayModel.h"
#import "DataSigner.h"

#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"
@implementation OrderDetailNewViewController

@synthesize result;//这里声明为属性方便在于外部传入。支付宝
@synthesize btnPayOnLine;//支付按钮
@synthesize userid;
@synthesize orderID;
@synthesize userName;
@synthesize keyboardToolbar;
@synthesize dic;
@synthesize payId;
- (id)initOrderID:(NSString *)orderid{

    if (self=[super init]) {
        self.orderID = orderid;
    }
    return self;
}
- (id)initWithGotoCommandDetailWith:(NSString *)orderid{
    
    if (self=[super init]) {
        self.orderID = orderid;
        
    }
    return self;
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    LineCount = 3;
    startTag = 1;

    
    self.title = CustomLocalizedString(@"showorder_title", @"订单详情");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];
    self.userName = [defaults objectForKey:@"username"];
    foods = [[NSMutableArray alloc] init];
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
    [self getOrderDetail];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appComeBack:) name:APP_URL_COMBACK object:nil];//注册更新函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appComeBack:) name:APP_WX_PAY_COMBACK object:nil];//注册更新函数
    
   
}
-(void)appComeBack:(id)sender{
    
    [self getOrderDetail];
}
#pragma mark 确认收货
-(void)updateOrderState
{
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(changeOrderStateDidReceive:obj:)];
     NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"3", @"status", self.orderID, @"orderid", nil];
    [twitterClient setOrderState:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"更新中...");
    [_progressHUD show:YES];
}

- (void)changeOrderStateDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }

    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    if (obj == nil){
        return;
    }
    //1. 获取信息
    NSDictionary *dict = (NSDictionary*)obj;
    int state = [[dict objectForKey:@"state"] intValue];
    if (state == 1) {
        orderState = 3;
     
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"order_detail_re_food_failed", @"确认收货失败，请稍候再试！") delegate:self cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
    }
    [self gotoCommandDetail:nil];
}

-(void)gotoCommandDetail:(UIButton *)btn
{

    if (sendState != 3) {
        //确认收货
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提醒" message: @"您确认收到商品？"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"没有", nil];
        alert.delegate = self;
        alert.tag = 2;
        [alert show];
    }else{
        FoodInOrderModelFix *food = [[FoodInOrderModelFix alloc] init];
        food.foodCount = 0;
        food.foodid = [self.dic objectForKey:@"TogoId"];
        food.foodname = @"";
//        NSLog(@"%@",self.dic);
        CommendDetailViewController *viewController = [[CommendDetailViewController alloc] initWithFood:food orderID:self.orderID];
        UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:viewController];
        [self presentViewController:navi animated:YES completion:nil];

    }
    
}

-(void)initView:(NSDictionary *)json{
    self.dic = json;
    if (isInitionView) {
        [scrollView removeFromSuperview];
    }
    
    isInitionView = YES;

    int x1 = 10;
    int l1 = 100;
//    self.edgesForExtendedLayout =UIRectEdgeNone;
    UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 315, 0.1)];
    [self.view addSubview:view];
    scrollView = [[UIScrollView alloc] initWithFrame:RectMake_LFL(0, 65, 375, 667-110)];
    [self.view addSubview:scrollView];
    
    int height = 0;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, height, l1, 30)];
    lb.text = @"订单明细";
    lb.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:lb];
    height += 30;
    
    UIView * whiteView=[[UIView alloc]init];
    whiteView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:whiteView];

    totalMoney = [[self.dic objectForKey:@"TotalPrice"] floatValue];
    sendMoney = [[self.dic objectForKey:@"sendmoney"] floatValue];
    payMoeny = [[self.dic objectForKey:@"paymoney"] floatValue];
    packetFee = [[self.dic objectForKey:@"Packagefree"] floatValue];
    foodMoeny = totalMoney - sendMoney - packetFee;
    countMoney = [[self.dic objectForKey:@"promotionmoney"] floatValue];
    cardPayMoney = [[self.dic objectForKey:@"cardpay"] floatValue];
    sendState=[[self.dic objectForKey:@"sendstate"] intValue];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:RectMake_LFL(5, height, 375, 40)];
    [btn setTitle:[self.dic objectForKey:@"TogoName"] forState:UIControlStateNormal];
    btn.titleLabel.font= [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:btn];
    height += 40;
    
    
    UIColor * lineColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    height+=0.5;
    NSString * foodName;
    for (int i = 0; i < [foods count]; i++) {
        FoodInOrderModelFix *model = [foods objectAtIndex:i];
        if (model.foodname!=foodName) {
            
        UIView *view = [[UIView alloc] initWithFrame:RectMake_LFL(0, height+0.5, 375, 23)];
        view.backgroundColor = [UIColor whiteColor];
        
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, 10, 180, 13)];
        lb.text = [NSString stringWithFormat:@"%@ x%d",model.foodname,model.foodCount];
        lb.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
        lb.numberOfLines = 2;
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:14];
        [view addSubview:lb];

        
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 10, 100, 13)];
        lb.text = [NSString stringWithFormat:@"%@%.1f", CustomLocalizedString(@"public_moeny_0", @"￥"), model.price* model.foodCount];
        lb.textAlignment = NSTextAlignmentRight;
        lb.font = [UIFont systemFontOfSize:14];
        [view addSubview:lb];
        
        [scrollView addSubview:view];

        height += 23;
        }
        foodName=model.foodname;
    }
    height += 10;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1];
    [scrollView addSubview:line];
    height+=0.5;
    height+=10;
    
    //配送费信息
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, height, l1, 13)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text =@"包装费";
    [scrollView addSubview:lb];

    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, height, 100, 13)];
    lb.font =  [UIFont systemFontOfSize:14];
    lb.textAlignment = NSTextAlignmentRight;
    lb.text = [NSString stringWithFormat:@"%@%.2f", CustomLocalizedString(@"public_moeny_0", @"￥"), packetFee];
    [scrollView addSubview:lb];

    height+=23;
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, height, l1, 13)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"配送费";
    [scrollView addSubview:lb];
    
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, height, 100, 13)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textAlignment = NSTextAlignmentRight;
    lb.text = [NSString stringWithFormat:@"%@%.2f", CustomLocalizedString(@"public_moeny_0", @"￥"), sendMoney];
    [scrollView addSubview:lb];

    height += 23;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    height+=0.5;
    height+=10;
    
    //优惠券信息
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, height, 27, 13)];
    lb.textColor = [UIColor lightGrayColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"优惠";
    [scrollView addSubview:lb];
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(27 + x1, height, 50, 13)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textAlignment = NSTextAlignmentRight;
    lb.text = [NSString stringWithFormat:@"-%@%.1f", CustomLocalizedString(@"public_moeny_0", @"￥"), cardPayMoney+countMoney];
    [scrollView addSubview:lb];
    
    //合计
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计：￥%.1f", totalMoney ]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(3,str.length-3)];
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(375-110, height, 100, 13)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textAlignment = NSTextAlignmentRight;
    lb.attributedText = str;
    [scrollView addSubview:lb];
    
    height +=23;
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    height+=0.5;
    
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=RectMake_LFL(0, height, 357/2, 40);
    [btn setTitle:@"提交订单并评论" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(updateOrderState) forControlEvents:UIControlEventTouchUpInside];
    if (sendState==3) {
        [btn setTitleColor:app.sysTitleColor forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setEnabled:NO];
    }
    [scrollView addSubview:btn];
    //支付按钮。。。
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=RectMake_LFL(375/2, height, 357/2, 40);
    self.btnPayOnLine=btn;
    [btn setTitle:payStatus==0? @"去支付":@"已支付" forState:UIControlStateNormal];
    [btn setTitleColor:app.sysTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];

    line=[[UIView alloc]initWithFrame:RectMake_LFL(375/2, height, 0.5, 40)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    
    height +=40;

    whiteView.frame=RectMake_LFL(0, 30, 375, height-30);
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, height, l1, 30)];
    lb.text = @"其他信息";
    lb.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:lb];
    height += 30;

    
    whiteView=[[UIView alloc]init];
    whiteView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:whiteView];
    whiteView.frame=RectMake_LFL(0, height, 375,300);
    //订单编号
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单号：%@",self.orderID]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4,str.length-4)];
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, height, 375, 40)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.attributedText = str;
    [scrollView addSubview:lb];
    height += 40;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    height+=0.5;
    
    height+=20;
    
    //收获信息
    NSString * value = [NSString stringWithFormat:@"%@ %@ %@", [self.dic objectForKey:@"UserName"], [self.dic objectForKey:@"Tel"], [self.dic objectForKey:@"Address"]];
    
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收货信息：%@\t%@",[self.dic objectForKey:@"UserName"],[self.dic objectForKey:@"Tel"]]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(5,str.length-5)];
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, height, 375, 20)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.attributedText = str;
    [scrollView addSubview:lb];
    
    height += 20;
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(70, height, 375, 20)];
    lb.textColor = [UIColor lightGrayColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = [self.dic objectForKey:@"Address"];
    [scrollView addSubview:lb];
    
    height +=30;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    height+=0.5;
    //支付方式
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付方式：%@",payMode==1 ? @"支付宝": payMode==3 ? @"余额支付": payMode==5 ?@"微信":@"其他"]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(5,str.length-5)];
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1, height, 375, 40)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.attributedText = str;
    [scrollView addSubview:lb];
    height += 40;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 375-20, 0.5)];
    line.backgroundColor=lineColor;
    [scrollView addSubview:line];
    height+=0.5;
    height+=10;
    //备注信息
    value = [self.dic objectForKey:@"Remark"];
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"备注信息：%@",[self.dic objectForKey:@"Remark"]]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(5,str.length-5)];
    NSDictionary * attr = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGFloat H =[value boundingRectWithSize:SizeMake_LFL(375-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(x1,height, 375-20, H)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.numberOfLines=0;
    lb.attributedText = str;
    [scrollView addSubview:lb];
    
    height+=100;
    
    [scrollView setContentSize:CGSizeMake(375, height + 50)];
    
    UIBarButtonItem * cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"取消订单" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOrder)];
    self.navigationItem.rightBarButtonItem=cancelBtn;
}

-(void)cancelOrder{
    
    UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"取消订单提示" message:@"取消已支付的订单会停止配送并退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确认取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self agreeCanleOrder];
    }];
    UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"保留订单" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:aa2];
    [ac addAction:aa1];
    
    [self presentViewController:ac animated:YES completion:nil];
    
}
-(void)agreeCanleOrder{
    
    __block UIAlertController * ac;
    __block UIAlertAction * aa;
    
    
    [self getOrderDetail];
    if ([[self.dic objectForKey:@"paystate"] isEqualToString:@"0"]) {
        
        ac=[UIAlertController alertControllerWithTitle:@"提示" message:@"未支付的订单不能取消" preferredStyle:UIAlertControllerStyleAlert];
        aa=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:aa];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    
    if ([[self.dic objectForKey:@"IsShopSet"]isEqualToString:@"0"] && ([[self.dic objectForKey:@"PayMode"] isEqualToString:@"1"]||[[self.dic objectForKey:@"PayMode"] isEqualToString:@"5"])) {
        
        NSString *url = @"http://122.114.94.150:/App/shop/saveorderstate.aspx";
        [MHNetworkManager postReqeustWithURL:url params:@{@"orderid":[self.dic objectForKey:@"OrderID"],@"state":@"2",@"shopid":[self.dic objectForKey:@"TogoId"]} successBlock:^(NSDictionary *returnData) {
            if ([[returnData objectForKey:@"state"]isEqualToString:@"0"]) {
                //取消失败已接单
                ac=[UIAlertController alertControllerWithTitle:@"提示" message:@"配送小哥正在路上，请耐心等待"  preferredStyle:UIAlertControllerStyleAlert];
                aa=[UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4001663779"]];
                }];
                [ac addAction:aa];
                aa=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self goBack];
                    
                }];
                [ac addAction:aa];
                [self presentViewController:ac animated:YES completion:nil];
                
            }else if([[returnData objectForKey:@"state"]isEqualToString:@"1"]){
                ac=[UIAlertController alertControllerWithTitle:@"提示" message:@"订单已经取消，请耐心等待回款" preferredStyle:UIAlertControllerStyleAlert];
                aa=[UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4001663779"]];
                }];
                [ac addAction:aa];
                aa=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                [ac addAction:aa];
                [self presentViewController:ac animated:YES completion:nil];
                
            }
            
        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
        
        
    }else if ([[self.dic objectForKey:@"IsShopSet"]isEqualToString:@"1"]){
        ac=[UIAlertController alertControllerWithTitle:@"提示" message:@"配送小哥正在路上，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        aa=[UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4001663779"]];
        }];
        [ac addAction:aa];
        aa=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:aa];
        [self presentViewController:ac animated:YES completion:nil];
        
        
    }else if ([[self.dic objectForKey:@"IsShopSet"]isEqualToString:@"2"]){
        ac=[UIAlertController alertControllerWithTitle:@"提示" message:@"订单已经取消，请耐心等待回款" preferredStyle:UIAlertControllerStyleAlert];
        aa=[UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://4001663779"]];
        }];
        [ac addAction:aa];
        aa=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:aa];
        [self presentViewController:ac animated:YES completion:nil];
        
    }
}
#pragma mark 在线支付

-(void)gotoOnLinPay:(float)payMoney orderid:(NSString *)odid
{
    if (payMoney > 0.0f) {
        //payMoney = 0.01;//测试用
        if (self.payId == nil) {
            [self getPayID:payMoney];
            return;
        }
        if (payMode == 1) {//支付宝
            [self aliPay:odid money:payMoney type:1];
        }else if(payMode == 5){
            //微信
            [app WXsendPay:odid payid:self.payId price:payMoney];
            self.payId = nil;
        }
        
    }
}

-(void)gotoPay:(UIButton *)btn{
    
    if (payStatus==0) {
        [self gotoOnLinPay:totalMoney - cardPayMoney orderid:self.orderID];
    }
    
}
#pragma mark 获取支付数据
-(void)getPayID:(float)moeny{
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(payIDDidReceive:obj:)];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderID, @"orderid", [NSString stringWithFormat:@"%.2f", moeny],@"price", nil];
    
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
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    
    if (obj == nil){
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic1 = (NSDictionary*)obj;
    
    int state = [[dic1 objectForKey:@"state"] intValue];
    if (state == 1) {
        self.payId = [dic1 objectForKey:@"batch"];
        [self gotoOnLinPay:totalMoney - cardPayMoney orderid:self.orderID];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"pay_load_id_error", @"获取支付数据失败！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark 支付宝
-(void)aliPay:(NSString *)odid money:(float)payMoney type:(int)payType{

    AliPayModel *order = [[AliPayModel alloc] init];
    order.partner = AliPartner;
    order.seller = AliSeller;
    
    order.tradeNO = self.payId; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@%@%@", app.appName, CustomLocalizedString(@"shop_cart_pay_title", @"IOS支付 订单编号："), odid]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"%@%@，支付编号：%@", CustomLocalizedString(@"order_detail_id", @"订单编号："), odid, self.payId]; //商品描述
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
}

#pragma mark 获取订单详情
-(void)getOrderDetail
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(orderDidReceive:obj:)];
    [twitterClient getOrderByOrderId:self.orderID];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
}

- (void)orderDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    if (obj == nil){
        return;
    }
    //1. 获取信息
    self.dic = (NSDictionary*)obj;
    //2. 获取list
//    NSLog(@"zypzyp%@",dic);
    NSArray *ary = nil;
    ary = [self.dic objectForKey:@"foodlist"];
    payStatus=[[self.dic objectForKey:@"paystate"] intValue];
    payMode=[[self.dic objectForKey:@"PayMode"]intValue];
//    NSLog(@"payMode:%d  payStatus:%d  \n%@" ,payMode,payStatus,self.dic);
    // 将获取到的数据进行处理 形成列表PayMode
    int index = (int)[foods count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dict = (NSDictionary*)[ary objectAtIndex:i];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FoodInOrderModelFix *model = [[FoodInOrderModelFix alloc] initWithDictionaryFix:dict];
        
        model.picPath = [imageDownload addTask:model.foodid url:nil showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        [foods addObject:model];
    }
    [self initView:self.dic];
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{  
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;  
} 

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    scrollView.contentOffset=CGPointMake(0, 0);
    
}



@end
