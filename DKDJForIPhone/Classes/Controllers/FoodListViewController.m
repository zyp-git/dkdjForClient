//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FoodListViewController.h"
#import "LoadCell.h"
#import "FoodListCell.h"
#import "FoodModel.h"
#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "FileController.h"
#import "CommitOrderViewController.h"
#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJAppConfig.h"
#import "FoodAttrModel.h"
#import "FoodDetailViewController.h"
#import "ShopDetailViewController.h"
#import "CommonMacro.h"
#import "UIImageView+WebCache.h"
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"
@implementation FoodListViewController{
    UIImageView * bottomCountImgView;
    UIImageView * bottomImgView;
    UILabel * bottomCountLabel;
    UIView * VerticalBlockView;
    BOOL isCartViewOpen;
    UIButton * shadow;
    UIView* bottomLabelView;
    NSMutableArray <NSMutableArray *>* sectionCountArr;
    NSMutableDictionary * FoodDict;
}

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    self.indexSelected = -1;
    page = 1;
    self.shopid = [NSString stringWithFormat:@"%d", app.mShopModel.shopid];
    self.foodtypeid = @"-1";
    [self refreshFields];
    
    sectionCountArr= [NSMutableArray array];
    self.foods= [[NSMutableArray alloc] init];
    foodTypes = [[NSMutableArray alloc] init];
    
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 1)];
    line.backgroundColor=[UIColor clearColor];
    [self.view addSubview:line];
    //zyp-mark 点餐界面 tabele
    CGFloat tableViewH=667-190-50;
    if (buyType == 3) {//RectMake_LFL
        self.tableView = [[UITableView alloc] initWithFrame:RectMake_LFL(0, 0.3, 375, tableViewH)];
    }else{
        self.typeTableView = [[UITableView alloc] initWithFrame:RectMake_LFL(0, 0.3, 70, tableViewH)];
        self.typeTableView.delegate = self;
        self.typeTableView.dataSource = self;
        self.typeTableView.separatorStyle = UITableViewCellSelectionStyleNone;//去掉分割线
        self.typeTableView.backgroundColor = [UIColor clearColor];
        self.typeTableView.tag = 2;
        [self.view addSubview:self.typeTableView];
        
        self.tableView = [[UITableView alloc] initWithFrame:RectMake_LFL(70, 0.3, 375-70, tableViewH)];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tag = 1;
    [self.view addSubview:self.tableView];
    
    VerticalBlockView =[[UIView alloc]initWithFrame:RectMake_LFL(0, 20, 3, 20)];
    VerticalBlockView.backgroundColor=app.sysTitleColor;
    
    UIView * view = [[UIView alloc] init];
    self.cartView=view;
    self.cartView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cartView];
    
    bottomView = [[UIView alloc] initWithFrame:RectMake_LFL(0.0, tableViewH, 375, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    
    UIView * bottomLine=[[UIView alloc]initWithFrame:RectMake_LFL(0,0, 375, 0.5)];
    bottomLine.backgroundColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    [bottomView addSubview:bottomLine];
    isCartViewOpen=NO;
    //zyp 底部结算按钮
    bottomButon = [[UIButton alloc] init];
    bottomButon.frame=RectMake_LFL(375-100, 0, 100, 50);
    [bottomButon setTitle:[NSString stringWithFormat:@"%.1f元起送",app.startMoney] forState:UIControlStateNormal];
    [bottomButon setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1]];
    [bottomButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomButon.titleLabel.textAlignment=NSTextAlignmentCenter;
    [bottomButon.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [bottomButon addTarget:self action:@selector(gotoShopCart:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:bottomButon];
    
    bottomLabelView =[[UIView alloc]initWithFrame:RectMake_LFL(70, 0, 100, 50)];
    [bottomView addSubview:bottomLabelView];
    //总价
    bottomLabel = [[HJLabel alloc] init];
    bottomLabel.textColor = [UIColor colorWithRed:281.0/255.0 green:80.0/255.0 blue:71.0/255.0 alpha:1];
    bottomLabel.font = [UIFont systemFontOfSize:21];
    bottomLabel.frame=RectMake_LFL(0 ,11, 100, 15);
    bottomLabel.text=@"￥0";
    [bottomLabelView addSubview:bottomLabel];
    //配送费
    UILabel * bottomSendMoneylabel=[[UILabel alloc]initWithFrame:RectMake_LFL(0, 50-17, 100, 12)];
    bottomSendMoneylabel.text=[NSString stringWithFormat:@"配送费￥%.2f", app.SendMoney];
    bottomSendMoneylabel.font=[UIFont systemFontOfSize:13];
    bottomSendMoneylabel.textColor=[UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1];
    [bottomLabelView addSubview:bottomSendMoneylabel];
    
    bottomImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"购物车_empty"]];
    bottomImgView.frame = RectMake_LFL(10,tableViewH +5, 40, 40);
    bottomImgView.userInteractionEnabled=YES;
    bottomImgView.multipleTouchEnabled = YES;
    [self.view addSubview:bottomImgView];
    UITapGestureRecognizer * gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomImgViewClick)];
    [bottomImgView addGestureRecognizer:gesture];
    
    
    bottomCountImgView=[[UIImageView alloc]initWithFrame:RectMake_LFL(27, -12, 20, 20)];
    bottomCountImgView.image=[UIImage imageNamed:@"椭圆"];
    [bottomImgView addSubview: bottomCountImgView];
    bottomCountLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 20, 20)];
    bottomCountLabel.backgroundColor=[UIColor clearColor];
    bottomCountLabel.textColor=[UIColor whiteColor];
    bottomCountLabel.textAlignment=NSTextAlignmentCenter;
    bottomCountLabel.font=[UIFont systemFontOfSize:13];
    bottomCountImgView.hidden=YES;
    [bottomCountImgView addSubview:bottomCountLabel];
    shadow=[[UIButton alloc]initWithFrame:self.view.bounds];
    shadow.backgroundColor=[UIColor blackColor];
    [shadow addTarget:self action:@selector(bottomImgViewClick) forControlEvents:UIControlEventTouchUpInside];
    shadow.alpha=0.3;
}
#pragma mark - 购车车View
-(void)bottomImgViewClick{
    
    [self showCartViewWithAnimated:YES];
}
-(void)showCartViewWithAnimated:(BOOL)animated{
    for (id view in self.cartView.subviews) {
        [view removeFromSuperview];
    }
    
    int i=0;
    if (!isCartViewOpen &&app.shopCart.shopCartArry.count) {
        [self.view insertSubview:shadow belowSubview:self.cartView];
        CGFloat y;
        isCartViewOpen=YES;
        for (FoodModel * model in app.shopCart.shopCartArry[0].foodArry) {
            UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, y, 375, 40)];
            [self.cartView addSubview:view];
            
            UILabel *label=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 200, 40)];
            label.text=[NSString stringWithFormat:@"%@ x %d份",model.foodname,model.count];
            label.backgroundColor=[UIColor clearColor];
            [view addSubview:label];
            
            label=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 357-80, 40)];
            label.text=[NSString stringWithFormat:@"￥%.1f",model.price];
            label.textAlignment=NSTextAlignmentRight;
            [view addSubview:label];
            
            UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 40, 375, 0.5)];
            line.backgroundColor=[UIColor lightGrayColor];
            [view addSubview:line];
            
            UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            minusButton.frame = RectMake_LFL(375-70, 10, 20, 20);
            minusButton.tag = i;
            [minusButton setBackgroundImage: [UIImage imageNamed:@"减少"] forState:UIControlStateNormal];
            [minusButton setBackgroundImage:[UIImage imageNamed:@"减少"] forState:UIControlStateSelected];//设置选择状态
            
            //[minusButton setTitle:@"-" forState:UIControlStateNormal];
            [minusButton addTarget:self action:@selector(minusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:minusButton];
            
            //4.
            CGRect numValueRect = RectMake_LFL(375-50, 10, 20, 20);
            UILabel *numValue = [[UILabel alloc] initWithFrame:
                                 numValueRect];
            numValue.textAlignment = NSTextAlignmentCenter;
            numValue.font = [UIFont boldSystemFontOfSize:12];
            numValue.tag = i;
            numValue.text=[NSString stringWithFormat:@"%d",model.count];
            [view addSubview:numValue];
            
            //5. +
            UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            plusButton.frame = RectMake_LFL(375-30, 10, 20, 20);
            plusButton.tag=i;
            [plusButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            [plusButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateSelected];
            [plusButton addTarget:self action:@selector(plusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:plusButton];
            y+=40;
            i++;
        }
        self.cartView.frame=RectMake_LFL(0, 667-190-50, 375, y);
        if (animated) {
            [UIView animateWithDuration:0.5 animations:^{
                self.cartView.frame=RectMake_LFL(0, 667-190-50-y, 375, y);
                bottomImgView.frame = RectMake_LFL(10, 667-190-50+5-y-50, 40, 40);
                bottomLabelView.frame=RectMake_LFL(10, 0, 100, 50);
            } completion:^(BOOL finished) {
                
            }];
        }else{
            self.cartView.frame=RectMake_LFL(0, 667-190-50-y, 375, y);
            bottomImgView.frame = RectMake_LFL(10, 667-190-50+5-y-50, 40, 40);
            bottomLabelView.frame=RectMake_LFL(10, 0, 100, 50);
        }
        
    }else{
        [shadow removeFromSuperview];
        isCartViewOpen=NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.cartView.frame=RectMake_LFL(0, 667-190-50, 375, 0);
            bottomImgView.frame = RectMake_LFL(10, 667-190-50+5, 40, 40);
            bottomLabelView.frame=RectMake_LFL(70, 0, 100, 50);
        } completion:nil];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    
}
- (void)viewWillAppear:(BOOL)animated {
    if (self.foods != nil) {
        [self updateTable];
        [self updateView];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(app.mShopModel.shopType != 1){
        [self updateView];
    }
    if (app.foodID != 0) {
        app.foodID = 0;
    }
    
}
-(void)startReadFood:(ShopDetailModel *)shop{
    page = 1;
    app.mShopModel.shopType = shop.Star;
    sentmoney =  shop.sendmoney;
    startSend = shop.startMoney;
    fullFree = shop.fullFreeMoney;
    app.SendMoney = sentmoney;
    app.startMoney = startSend;
    app.fullFree = fullFree;
    shopType = shop.Star;
    isBespeak = 0;//0不支持预约，1支持预约
    [self GetFoodType];
}

#pragma mark - 去结算按钮响应

- (void)gotoShopCart:(id)senser
{
   
    if( (![self IsLogin]) ){
        return;
    }
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_detail_shopcart_empt", @"购物车为空") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(FoodListViewControllerLetShopPushController:isPush:)]) {
            CommitOrderViewController * vc=[[CommitOrderViewController alloc]init];
            UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:vc];
            [self.delegate FoodListViewControllerLetShopPushController:navi isPush:NO];
        }
    }
}




//商家页面进入餐品列表页面
- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full bspeak:(int)type  shopType:(int)shoptype
{
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    hasMore = false;
    
    self.navigationItem.title = app.mShopModel.shopname;
    page = 1;
    self.shopid = Shopid;
    sentmoney =  [sentmoneyString floatValue];
    startSend = [start floatValue];
    fullFree = full;
    
    app.SendMoney = sentmoney;
    app.startMoney = startSend;
    app.fullFree = full;
    shopType = shoptype;
    isBespeak = type;
    
    return self;
}

- (id)initWithTypeId:(NSString*)type
{
    self = [super init];
    if (self) {
        shopType = type;
    }
    return self;
}

#pragma mark 获取商品分类

-(void) GetFoodType{
    
    
    NSString *url = APP_PATH  @"GetFoodTypeListByShopId.aspx";
    NSDictionary * dic=@{@"shopid":[NSString stringWithFormat:@"%d", app.mShopModel.shopid]};
    //    NSLog(@" \n    start     GetFoodType %d",app.mShopModel.shopid);
    [MHNetworkManager postReqeustWithURL:url params:dic successBlock:^(NSDictionary *returnData) {
        
        NSDictionary * dic=returnData;
        NSArray *ary = [dic objectForKey:@"foodtypelist"];
        
        NSLog(@"   ary   %lu",(unsigned long)ary.count);////
        FoodTypeModel *model = [[FoodTypeModel alloc] init];
        self.foodtypeid=@"0";
        [self GetData];
        //int j = 1;
        // 将获取到的数据进行处理 形成列表
        for (int i = 0; i < [ary count]; ++i) {
            
            NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            model = [[FoodTypeModel alloc] initWithJsonDictionary:dic];
            
            [foodTypes addObject:model];
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"GetFoodType  %@",error);
    } showHUD:NO];
    
    
}

#pragma mark 获取食物列表
-(void) GetData{
    
    NSDictionary*param = [[NSDictionary alloc] initWithObjectsAndKeys:self.foodtypeid, @"shopsortid",[NSString stringWithFormat:@"%d", app.mShopModel.shopid], @"shopid", @"500", @"pagesize", [NSString stringWithFormat:@"%d", page], @"pageindex", self.uduserid, @"userid", nil];
    NSString *url = APP_PATH  @"getfoodlistbyshopid.aspx";
    
//    NSLog( @"zyp%@",param);
    [MHNetworkManager postReqeustWithURL:url params:param successBlock:^(NSDictionary *returnData) {
        [self foodsDidReceive:returnData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];

    
}
- (void)foodsDidReceive:(NSDictionary *)dic{
    
    
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodlist"];

    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FoodModel *model = [[FoodModel alloc] initWithJsonDictionary:dic];
        if (i==0) {
            [self.foods addObject:model];
        }else{
            [self.foods insertObject:model atIndex:0];
        }
    }
    FoodDict=[NSMutableDictionary dictionary];
    for (FoodTypeModel *model in foodTypes) {
        [FoodDict setObject:[NSMutableArray array] forKey:model.SortID];
    }

    for (FoodModel * model in self.foods) {
        for (NSString * str in FoodDict) {
            if ([model.FoodType isEqualToString:str]) {
                NSMutableArray * arr=[FoodDict objectForKey:str];
                [arr addObject:model];
            }
        }
    }
    NSMutableArray *tmpArr=[NSMutableArray array];
    for (FoodTypeModel *model in foodTypes) {
        NSMutableArray * arr=[FoodDict objectForKey:model.SortID];
        if (arr) {
            [sectionCountArr addObject:arr];
            [tmpArr addObject:model];
        }
    }
    foodTypes=tmpArr;

    [self.typeTableView reloadData];
    [self.tableView reloadData];
}


-(void)updataUI:(int)type{
    [self.tableView reloadData];
    [self updateView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        if(alertView.tag == 2){
            //显示购物车
            [app SetTab:3];
        }else if(alertView.tag == 3){
            if (self.foods == nil || [self.foods count] == 0) {
                [self GetData];
            }
        }
    }
    else if( buttonIndex == 1 )
    {
        if (alertView.tag == 1) {
            //清空购物车
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"shopcartshopid"];
            [defaults synchronize];
            //加入新的餐品到购物车
            [self AddtoCart];
        }else if(alertView.tag == 2){
            FoodListViewController *foodlistView = [[FoodListViewController alloc]initWithShopid:@"1" sentmoney:@"0.0" startSend:@"0.0" fullFree:0.0 bspeak:1 shopType:1 ];
            
            [self.navigationController pushViewController:foodlistView animated:YES];
        }
    }
}



- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
}

- (BOOL)IsLogin{
    [self refreshFields];
    if([self.uduserid intValue]  > 0 ){
        return YES;
    }
    else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(FoodListViewControllerLetShopPushController:isPush:)]) {
            LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
            LoginController.title =CustomLocalizedString(@"login", @"会员登录");
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:LoginController];
            [self.delegate FoodListViewControllerLetShopPushController:navi isPush:NO];
        }
        return NO;
    }
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCart:(FoodModel *) foodmodel{
    
}

-(void)AddtoCart
{
    FoodModel *foodmodel = [self.foods objectAtIndex:row];
    if ([foodmodel.attr count] != 1) {
        UIAlertTableView *alert = [[UIAlertTableView alloc] initWitchData:&foodmodel updateTableView:self];
        [alert show];
        return;
    }
    NSString *count = [[NSString alloc] initWithFormat:@"%d",foodmodel.count + 1];
    FoodAttrModel *attr = [foodmodel.attr objectAtIndex:0];
    foodmodel.price = foodmodel.price + attr.price;
    attr.count++;
    foodmodel.count = count;
    [self UpdateShopCart:foodmodel];
}
-(void)updateView {
    bottomLabel.text = [NSString stringWithFormat:@"￥%.2f",app.shopCart.allPrice];
    if (app.shopCart.foodCount > 0) {
        
        bottomImgView.image=[UIImage imageNamed:@"购物车"];
        [bottomButon setBackgroundColor:app.sysTitleColor];
        bottomButon.titleLabel.text=@"去结算";
        bottomCountImgView.hidden=NO;
        bottomCountLabel.text=[NSString stringWithFormat:@"%d",app.shopCart.foodCount];
        [self updateTable];
    }else{
        bottomImgView.image=[UIImage imageNamed:@"购物车_empty"];
        [bottomButon setBackgroundColor:[UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0 alpha:1]];
        bottomButon.titleLabel.text=[NSString stringWithFormat:@"%.1f元起送",app.startMoney];
        bottomCountImgView.hidden=YES;
        bottomCountLabel.text=[NSString stringWithFormat:@"%d",app.shopCart.foodCount];
        
    }
}
//餐品数量增加1
-(void)plusFoodToOrder:(UIButton *)sender
{
    if (app.mShopModel.status == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_detail_close_notice", @"商家不在营业中无法下单！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
   
    if (sender.tag<1000) {
        
        isCartViewOpen =!isCartViewOpen;
        [app.shopCart addFoodAttr:app.mShopModel food:app.shopCart.shopCartArry[0].foodArry[sender.tag] attrIndex:0];
        [self showCartViewWithAnimated:NO];
    }else{
        
        NSIndexPath * indexPath;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
        }else{
            indexPath = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])];
        }
        if (indexPath ==nil) {
            indexPath = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])];
        }
        FoodModel *foodmodel = [sectionCountArr[indexPath.section] objectAtIndex:indexPath.row];
        if (app.shopCart == nil ) {
            app.shopCart = [[MyShopCart alloc] init];
        }else{
            
            if ([app.shopCart.shopCartArry count] > 0) {
                //只支持一个商家点餐
                if (app.mShopModel.shopid != ((ShopCardModel *)[app.shopCart.shopCartArry objectAtIndex:0]).shopID) {
                    [app.shopCart Clean];
                }
                foodmodel.tid = app.mShopModel.shopid;
            }
            
        }
        [app.shopCart addFoodAttr:app.mShopModel food: foodmodel attrIndex:0];
    }
    
    [self updateView];
    [self updateTable];
}

//餐品数量减少1
-(void)minusFoodToOrder:(UIButton *)sender
{
    
    
    if (sender.tag<1000) {
        isCartViewOpen =!isCartViewOpen;
        [app.shopCart delFoodAttr:app.mShopModel food:app.shopCart.shopCartArry[0].foodArry[sender.tag] attrIndex:0];
        [self showCartViewWithAnimated:NO];
    }else{
        NSIndexPath * indexPath;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]];
        }else{
            indexPath = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])];
        }
        if (indexPath ==nil) {
            indexPath = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])];
        }
        FoodModel *foodmodel = [sectionCountArr[indexPath.section] objectAtIndex:indexPath.row];
        [app.shopCart delFoodAttr:app.mShopModel food:foodmodel attrIndex:0];
    }
    
    [self updateView];
    [self updateTable];
    
}


//更新列表显示
-(void) updateTable{
    [self.tableView reloadData];
}


#pragma mark tableVIew
- (void)scrollViewDidScroll:(UIScrollView *)sender
{

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1) {
        return FoodDict.count;
//        return [foodTypes count];
    }else{
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1) {//[FoodDict allKeys];
        if (foodTypes.count) {
            return foodTypes[section].SortName;//foodTypes[section].SortName;
        }else{
            return @"";
        }
    }else{
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1 ) {
        return sectionCountArr[section].count;
    }
    else if(tableView.tag == 2){
        return [foodTypes count];
    }else{
        return nil;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (tableView.tag == 1) {
        
        
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: CellTableIdentifier] ;
            //自定义布局 分别显示以下几项
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            int w = 175;
            if(buyType == 3)
            {
                w = 250;
            }
            CGFloat cellH=70,cellW=375-70,space=10,icoH=50,y=space;
            
            UIImageView *ico = [[UIImageView alloc] initWithFrame:RectMake_LFL(space, space, icoH, icoH)];
            ico.tag = 4;
            [cell.contentView addSubview:ico];
            
            
            //1. 名称
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:RectMake_LFL(cellH ,y, 250, 14)];
            
            nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:16];
            nameLabel.tag = 1;
            
            [cell.contentView addSubview: nameLabel];
            y+=7.5+14;
            //3. 销量
            
            UILabel *intr = [[UILabel alloc] initWithFrame:RectMake_LFL(cellH  , y, 70, 12)];
            intr.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
//            intr.text=@"月售:20";
            intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            intr.numberOfLines = 0;
            intr.font = [UIFont systemFontOfSize:14];
            intr.tag = 9;
            
            [cell.contentView addSubview: intr];
            
            
            //2.价格
            CGRect priceLabelRect = RectMake_LFL(70,50, 100, 16);
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                                   priceLabelRect];
            priceLabel.textAlignment = NSTextAlignmentLeft;
            priceLabel.font = [UIFont systemFontOfSize:15];
            priceLabel.textColor = [UIColor colorWithRed:251.0/255.0 green:79.0/255.0 blue:69.0/255.0 alpha:1];
            priceLabel.tag = 2;
            
            [cell.contentView addSubview: priceLabel];
            
            UIView *btnView = [[UIView alloc] initWithFrame:RectMake_LFL(cellW-45-35, (70-25)/2, 45, 25)];
            btnView.tag = 5;
            //                btnView.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:btnView];
            
            UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            minusButton.frame = RectMake_LFL(0, 0, 25, 25);
            minusButton.tag = indexPath.row+1000;
            [minusButton setBackgroundImage: [UIImage imageNamed:@"减少"] forState:UIControlStateNormal];
            [minusButton setBackgroundImage:[UIImage imageNamed:@"减少"] forState:UIControlStateSelected];//设置选择状态
            
            //[minusButton setTitle:@"-" forState:UIControlStateNormal];
            [minusButton addTarget:self action:@selector(minusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:minusButton];
            
            //4.
            CGRect numValueRect = RectMake_LFL(25, 0, 20, 25);
            UILabel *numValue = [[UILabel alloc] initWithFrame:
                                 numValueRect];
            
            numValue.textAlignment = NSTextAlignmentCenter;
            numValue.font = [UIFont boldSystemFontOfSize:12];
            //                numValue.textColor = [UIColor redColor];
            numValue.tag = 3;
            
            [btnView addSubview:numValue];
            
            //5. +
            UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            plusButton.frame = RectMake_LFL(cellW-35, (cellH-25)/2, 25, 25);
            plusButton.tag = indexPath.row+1000;
            //[plusButton setTitle:@"+" forState:UIControlStateNormal];
            
            [plusButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            [plusButton setBackgroundImage:[UIImage imageNamed:@"添加"] forState:UIControlStateSelected];//设置选择状态
            
            [plusButton addTarget:self action:@selector(plusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:plusButton];
            
            
            UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(10, 70, 305, 0.3)];
            line.backgroundColor=[UIColor lightGrayColor];
            [cell.contentView addSubview:line];
            
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        
        FoodModel *foodmodel = [sectionCountArr[indexPath.section] objectAtIndex:indexPath.row];
        
        if( foodmodel == nil){
            return nil;
        }
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:4];
        

        [ico sd_setImageWithURL:[NSURL URLWithString:foodmodel.ico] placeholderImage:[UIImage imageNamed:@"暂无图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            foodmodel.image= image;
        }];

        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = foodmodel.foodname;
        
        UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:2];
        NSString* priceString;
        priceString = [NSString stringWithFormat:@"￥%.2f", [(FoodAttrModel *)[foodmodel.attr objectAtIndex:0] price]];
        priceLabel.text = priceString;
        
        UILabel * saleCount = (UILabel *)[cell.contentView viewWithTag:9];
        saleCount.text=[NSString stringWithFormat:@"已售：%d",foodmodel.sale];
        
        //zyp-mark 加餐按钮控制
        UILabel *numLabel = (UILabel *)[cell.contentView viewWithTag:3];
        int count = [app.shopCart getFoodCountInAttrWitchShopID:app.mShopModel.shopid foodID:foodmodel.foodid attrId:foodmodel.foodid];
        numLabel.text = [NSString stringWithFormat:@"%d", count];
        UIView *btnView = (UIView *)[cell.contentView viewWithTag:5];
        if (count > 0) {
            
            [btnView setHidden:NO];
        }else{
            
            [btnView setHidden:YES];
        }
        
        return cell;
        
        
    }else {
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
            
            if (indexPath.row==0) {
                [cell.contentView addSubview:VerticalBlockView];
            }
            
            UILabel *textFiled = [[UILabel alloc] initWithFrame:RectMake_LFL(0,  0, 70, 60)];
            
            //UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 50)];
            textFiled.tag = 2;
            textFiled.backgroundColor = [UIColor clearColor];
            textFiled.font = [UIFont systemFontOfSize:16];
            textFiled.textAlignment = NSTextAlignmentCenter;
            
            textFiled.numberOfLines = 2;
            
            [cell addSubview:textFiled];
            
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor =  [UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        UILabel *name = (UILabel *)[cell viewWithTag:2];
        FoodTypeModel *model = [foodTypes objectAtIndex:indexPath.row];
        name.text = model.SortName;
        
        if (indexPath.row == selectIndex) {
            cell.backgroundColor=[UIColor whiteColor];
            
        }else{
            cell.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
        }
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return CGRectGetMaxY(RectMake_LFL(0, 0, 0, 70));
    }else{
        return CGRectGetMaxY(RectMake_LFL(0, 0, 0, 60));
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        FoodModel *foodmodel = [sectionCountArr[indexPath.section] objectAtIndex:indexPath.row];
        FoodDetailViewController * foodDetailVC=[[FoodDetailViewController alloc]initWithFood:foodmodel ShowGoToShop:YES shopType:nil];

        if (self.delegate && [self.delegate respondsToSelector:@selector(FoodListViewControllerLetShopPushController:isPush:)]) {
            [self.delegate FoodListViewControllerLetShopPushController:foodDetailVC isPush:YES];
        }
    }else{
        selectIndex =indexPath.row;
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView addSubview:VerticalBlockView];
        
        int temp = (int)indexPath.row;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:temp];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [tableView reloadData];
    }
}
//header消失时改变左边选中颜色

-(void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{

    if (tableView.tag == 1&&section-1==self.indexSelected) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:section+1 inSection:0];
        UITableViewCell * cell=[self.typeTableView cellForRowAtIndexPath:indexPath];
        selectIndex =indexPath.row;
        [cell.contentView addSubview:VerticalBlockView];
        [self.typeTableView reloadData];
        self.indexSelected=section;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        if (section==self.indexSelected) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:section inSection:0];
            UITableViewCell * cell=[self.typeTableView cellForRowAtIndexPath:indexPath];
            selectIndex =indexPath.row;
            [cell.contentView addSubview:VerticalBlockView];
            [self.typeTableView reloadData];
            self.indexSelected--;
        }
        
    }
}
@end