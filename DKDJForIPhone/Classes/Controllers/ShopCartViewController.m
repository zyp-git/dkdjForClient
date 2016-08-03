//
//  ShopCartViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-16.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "AddOrderViewController.h"
#import "FileController.h"
#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJEditShopCartNumberPopView.h"
#import "AddOrderToServerNewViewController.h"
@implementation ShopCartViewController

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

@synthesize shopidSC;

@synthesize shopcartLabelSC;
@synthesize tableView;
@synthesize keyboardToolbar;
@synthesize colorArry;
@synthesize uduserid;//用户编号
@synthesize btnAllCheck;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    }
	app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
 
    [self updateShowView];
    //刷新表格数据
    //[self.foodsTableViewSC beginUpdates];

    int count = [app.shopCart foodAttrLine];
    
    NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];

    for (int i = 0; i < count; ++i) 
    {
        [newPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    [self.tableView reloadData];

    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"public_last", @"上一项")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"public_next", @"下一项")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"public_ok", @"确定")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        
        [previousBarItem release];
        [nextBarItem release];
        [spaceBarItem release];
        [doneBarItem release];
    }
    
    viewHeight = 310;
    if (is_iPhone5) {
        viewHeight = 380;
    }
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    self.title = CustomLocalizedString(@"shop_cart_title", @"我的购物车");
    self.colorArry = [[NSArray alloc] initWithObjects:[UIColor colorWithRed:87/255.0 green:180/255.0 blue:239/255.0 alpha:1.0], [UIColor colorWithRed:243/255.0 green:179/255.0 blue:133/255.0 alpha:1.0],[UIColor colorWithRed:252/255.0 green:121/255.0 blue:155/255.0 alpha:1.0],[UIColor colorWithRed:83/255.0 green:190/255.0 blue:176/255.0 alpha:1.0],nil];
    colorIndex = 0;
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight + 60)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.image = [UIImage imageNamed:@"cart_empty_bg.png"];
    [backImageView setHidden:YES];
    [self.view addSubview:backImageView];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height - 170)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 320, 90)];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    
    self.btnAllCheck = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 0.0, 85.0, 30.0)];
    
//    UIImage *backgroundImage = [[UIImage imageNamed:@"cart_unok.jpg"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 23, 23,23)];
//    UIImage *backgroundImage1 = [[UIImage imageNamed:@"cart_ok.jpg"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 23, 23,23)];
    /*
    [self.btnAllCheck setImage:backgroundImage forState:UIControlStateNormal];
    [self.btnAllCheck setImage:backgroundImage1 forState:UIControlStateSelected];
    [self.btnAllCheck setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAllCheck setTitle:@" 全选" forState:UIControlStateNormal];
    [self.btnAllCheck addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.btnAllCheck];*/
    
    price = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 15)];
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont boldSystemFontOfSize:12];
    price.textColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
    price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
    [bottomView addSubview:price];
    
    price1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 15)];
    price1.textAlignment = NSTextAlignmentRight;
    price1.font = [UIFont boldSystemFontOfSize:12];
    price1.textColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
    price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];
    [bottomView addSubview:price1];
    
    UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 40, 310, 2.0)];
    lineImageView.image = hImage;
    
    [bottomView addSubview:lineImageView];
    [lineImageView release];
    
    
    
    
    UIButton *goTo = [[UIButton alloc] initWithFrame:CGRectMake(200, 50, 90, 30)];
    //[goTo setImage:[UIImage imageNamed:@"go_buy.png"] forState:UIControlStateNormal];
    [goTo setTitle:CustomLocalizedString(@"shop_cart_ok", @"生成订单") forState:UIControlStateNormal];
    [goTo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goTo setBackgroundColor:[UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0]];
    [goTo addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:goTo];
    [goTo release];
    [self.view addSubview:self.tableView];
    [self.view addSubview:bottomView];
    
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    //[headerView release];
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



//清空购物车
- (void)cancel:(id)sender
{

    [app SetTab:1];
    
}

- (void)gotoNext:(id)sender
{
    if( (![self IsLogin]) )
    {
        return;
    }
    
    if(app.shopCart.foodCount > 0)
    {
        if(app.shopCart.cFoodCount < 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:@"您未勾选任何商品无法提交！"  delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        for (int i = 0; i < [app.shopCart.shopCartArry count]; i++) {
            ShopCardModel *shopCard = [app.shopCart.shopCartArry objectAtIndex:i];
            if(shopCard.cAllPrice < shopCard.startMoney)
            {
                NSString *msg = [NSString stringWithFormat:CustomLocalizedString(@"shop_cart_can_buy_notice", @"您购买的物品总价未达到商家%@的起送金额%.2f"), shopCard.shopName, shopCard.startMoney];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:msg  delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        }
        
        AddOrderToServerNewViewController *addorderView = [[[AddOrderToServerNewViewController alloc] init ] autorelease];
        
        [self.navigationController pushViewController:addorderView animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_emp", @"购物车中尚无餐品，请先选择餐品") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)dealloc {
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    if (twitterClient) {
        [twitterClient release];
        twitterClient = nil;
    }
    [backImageView release];
    [self.uduserid release];
    [self.tableView release];
    [price release];
    [price1 release];
    [bottomView release];
    [self.colorArry release];
    [self.shopidSC release];
    [self.shopcartLabelSC release];
    [self.keyboardToolbar release];
    [backClick release];
    [super dealloc];
}

- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
}

- (BOOL)IsLogin{
    [self refreshFields];
    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[[LoginNewViewController alloc] init] autorelease];
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:LoginController] autorelease];
        [self presentViewController:navController animated:YES completion:nil];
        return NO;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![self IsLogin]) {
        return;
    }
    app.shopCart.userID = self.uduserid;
    [self chechAll:YES];

}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        twitterClient = nil;
    }
}
-(void)updateShopCartWitchInOrderModel:(FoodInOrderModel *)food{//传的是指针，原来的数据
    [self UpdateShopCartSC:food];

}
//餐品数量增加1
-(void)plusFoodToOrderSC:(id)sender 
{
    int row;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row = (int)[self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview] ].row;
    }else{
        row = (int)[self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    
    [app.shopCart  addFoodAttr:[app.shopCart getFoodInOrderModel:&row] attrIndex:0];
    
    
    
    [self updateTableSC];
    price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
    price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];
     
}

//餐品数量减少1
-(void)minusFoodToOrderSC:(id)sender 
{
     //NSUInteger row = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    int row;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row = (int)[self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview] ].row;
    }else{
        row = (int)[self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    
    [app.shopCart  delFoodAttr:[app.shopCart getFoodInOrderModel:&row] attrIndex:0];
    price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
    price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];

     
     [self updateTableSC];
     
}

//餐品数量减少1
-(void)removeFoodToOrderSC:(id)sender
{
    NSInteger row;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row = [self.tableView indexPathForCell:(UITableViewCell *)[[sender superview] superview] ].row;
    }else{
        row = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    deleteIndex = row;
    //NSUInteger row = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_del_food_notice", @"您确定要删除该商品吗？")  delegate:self cancelButtonTitle:CustomLocalizedString(@"public_cancel", @"取消") otherButtonTitles:CustomLocalizedString(@"public_ok", @"确定"), nil];
    alert.tag = 1;
    
    [alert show];
    [alert release];
    
}

#pragma mark UIAlterView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 1) {
        FoodModel *foodmodel = [app.shopCart getFoodInOrderModel:&deleteIndex];
        [app.shopCart removeFood:foodmodel attrIndex:deleteIndex];
        price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
        price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];
        [self updateTableSC];
        if (app.shopCart.foodCount == 0) {
            self.tableView.frame = CGRectMake(320, 0, 0, 0);
            bottomView.frame = CGRectMake(320, 0, 0, 0);
        }
    }
}

-(void) doSum
{
   /* sumCountSC = 0;
    
    sumPriceSC = (float)0.0;
    FoodInOrderModel *fmodelSC;
    
    for (int i = 0; i < [app.shopCart count]; ++i)
    {   
        //NSDictionary *dic = [self.shopcartDictForSaveFile objectForKey:key];
        
        fmodelSC = [app.shopCart objectAtIndex:i];
        
        sumPriceSC = sumPriceSC + fmodelSC.price;
        sumCountSC = sumCountSC + fmodelSC.foodCount;
    }
    
    //@"已点：0份 合计：0.0元"
    if (sumPriceSC < app.fullFree && app.fullFree > 0.0f) {
        sumPriceSC += app.SendMoney;
        
        self.shopcartLabelSC.text = [[NSString alloc] initWithFormat:@"    已点: %d份 配送费：%.2f 合计: %.2f",sumCountSC, app.SendMoney, sumPriceSC];
        
        
    }else{
        self.shopcartLabelSC.text = [[NSString alloc] initWithFormat:@"    已点: %d份 配送费：0.00元 合计: %.2f",sumCountSC, sumPriceSC];
        // app.SendMoney = 0.0;
    }

   // self.shopcartLabelSC.text = [[NSString alloc] initWithFormat:@"       已点：%d份 配送费：%.1f元 合计：%.1f元",sumCountSC, sentmoney,sumPriceSC];
    
    //if(sumCountSC > 0 )
    {
        //修改 tabbar 的 badgeValue 底部导航右上角的数字
        UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
        tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",sumCountSC];
    }*/
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCartSC:(FoodInOrderModel *)foodmodel
{
    [self updateTableSC];
    
}

//更新列表显示
-(void) updateTableSC
{
    [self doSum];
    [self.tableView reloadData];
}
#pragma mark 获取购物车
-(void)getShopCartList
{
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addressDidReceive:obj:)];

    NSString *string = [app.shopCart getTogoIDJSONString];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:string,@ "check", nil];
    
    [twitterClient getUserInShopCardList:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"shop_cart_inition_notice", @"初始化中...");
    [_progressHUD show:YES];
    
}





- (void)addressDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    
    [twitterClient release];
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
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic1 objectForKey:@"shoplist"];
    [app.shopCart checkShopCard:ary];
    
}

#pragma mark UIToolBar

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 0 ? NO : YES];
    [nextBarItem setEnabled:tag == app.shopCart.foodAttrLine - 1 ? NO : YES];
}



- (void)previousField:(id)sender
{
    
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = selectIntex;
        NSUInteger previousTag = tag == 0 ? 0 : tag - 1;
        [firstResponder resignFirstResponder];
        //[self checkBarButton:previousTag];
        //[self animateView:previousTag];
        //[firstResponder resignFirstResponder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:previousTag inSection:0];
        UITextField *previousField = (UITextField *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:6];
        [previousField becomeFirstResponder];
        
    }
}

- (void)nextField:(id)sender
{
    
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        NSUInteger tag = selectIntex;
        NSUInteger nextTag = tag == app.shopCart.foodAttrLine - 1 ? app.shopCart.foodAttrLine - 1 : tag + 1;
        
        //[self checkBarButton:nextTag];
        //[self animateView:nextTag];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nextTag inSection:0];
        UITextField *nextField = (UITextField *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:6];
        if ([nextField canBecomeFirstResponder]) {
            [nextField becomeFirstResponder];
        }
        
    }
}

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        NSTimeInterval animationDuration = 0.30f;
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        [self animateView:0];
        //[self resetLabelsColors];
    }
}

- (id)getFirstResponder
{
    selectIntex = 0;
    int endTag = app.shopCart.foodAttrLine;
    while (selectIntex <= endTag) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectIntex inSection:0];
        UITextField *textField = (UITextField *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:6];
        if ([textField isFirstResponder]) {
            return textField;
        }
        selectIntex++;
    }
    
    return NO;
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag >= 1) {
        rect.origin.y = -100.0f * tag;
    } else {
        rect.origin.y = 0;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect.origin.y += 64;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)updateShowView
{
    price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
    price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];
    if (app.shopCart.foodCount != app.shopCart.cFoodCount) {
        btnAllCheck.selected = NO;
    }else{
        btnAllCheck.selected = YES;
    }
}

#pragma mark UITextFiled
-(void)startInPut:(id)sender{
    
    NSUInteger n;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        n = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]].row;
    }else{
        n = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    
    //UITextField *textField = sender;
    [self checkBarButton:n];
    [self animateView:n];
}

-(void)endInPut:(id)sender{
    NSUInteger n;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        n = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]].row;
    }else{
        n = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    UITextField *number = (UITextField *)sender;
    
    int num = [number.text intValue];
    number.text = [NSString stringWithFormat:@"%d", num];//];
    [app.shopCart setFoodWithAttrLine:(int)n Count:num];
    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
    tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",app.shopCart.foodCount];
    
    [self updateTableSC];
    price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
    price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];
}

-(void)chechAll:(BOOL)check
{
    [app.shopCart checkAll:check];
    [self updateTableSC];
    price.text = [NSString stringWithFormat:@"%@￥%.2f %@￥%.2f %@￥%.2f", CustomLocalizedString(@"order_detail_food_moeny", @"商品合计："), app.shopCart.cAllPrice, CustomLocalizedString(@"order_detail_packet_fee", @"打 包 费："), app.shopCart.cPackageFee, CustomLocalizedString(@"order_detail_send_fee", @"配  送  费 :"), app.shopCart.cSendMoney];
    price1.text = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_all_price", @"合计："), (app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee)];
}

-(void)checkboxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn == btnAllCheck) {
        [self checkboxClick:btn.selected];
    }else{
        NSInteger row;
        NSInteger index;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            row = [self.tableView indexPathForCell:(UITableViewCell *)[[[btn superview] superview] superview]].row;
            
        }else{
            row = [self.tableView indexPathForCell:((UITableViewCell *)[[btn superview] superview])].row;
            
        }
        if (row == 0) {
            row = [self.tableView indexPathForCell:((UITableViewCell *)[[btn superview] superview])].row;
        }
        index = row;
        FoodModel *foodmodel = [app.shopCart getFoodInOrderModel:&row];
//        FoodAttrModel * foodAttr = (FoodAttrModel *)[foodmodel.attr objectAtIndex:row];
        if (btn.tag == 10) {
            
            CGRect inFrame;
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                inFrame = [[btn superview] superview].frame;
            }else if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
                inFrame = [[[btn superview] superview] superview].frame;
            }else{
                inFrame = [btn superview].frame;
            }
            //row = [self.tableView indexPathForCell:((UITableViewCell *)[[btn superview] superview])].row;
            CGRect rect = [self.tableView convertRect:inFrame toView:[tableView superview]];
            //row = [self.tableView indexPathForSelectedRow];
            CGPoint point = CGPointMake(rect.origin.x + 50, rect.origin.y + 40);
            
            
            HJEditShopCartNumberPopView *popView = [[HJEditShopCartNumberPopView alloc] initWithView:self.view FoodModel:foodmodel FShop4ListModel:nil MyShopCart:app.shopCart childViewPosition:point index:index];
            popView.delegate = self;
            btnCur = btn;
            [popView showDialog];
            [popView release];
        }else{
            //foodAttr.isSelect = btn.selected;
            [app.shopCart checkFood:foodmodel attrIndex:(int)row check:btn.selected];
            [self updateShowView];
        }
    }
    
    
}

#pragma mark HJPopView
-(void)HJPopViewBaseClose:(int)type{
    [self updateTableSC];
    btnCur.selected = !btnCur.selected;
    [self updateShowView];
}


#pragma mark UITableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self resignKeyboard:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return app.shopCart.foodAttrLine;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        /*if(colorIndex == 4){
            colorIndex = 0;
        }
        
        UILabel *hLine = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 12.0, 4.0, 108.0)];
        hLine.backgroundColor = (UIColor *)[self.colorArry objectAtIndex:colorIndex];
        [cell.contentView addSubview:hLine];
        [hLine release];
        colorIndex++;*/
        
        UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 3, 310, 2.0)];
        lineImageView.image = hImage;
        
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];

        
        
        
        
        
        /*UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 100.0, 75.0)];
        backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
        [cell.contentView addSubview:backGImg];*/
        
        UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 60.0, 60.0)];
        ico.tag = 4;
        [cell.contentView addSubview:ico];
        
        //1. 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 210, 15)];
        nameLabel.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:12];
        nameLabel.tag = 1;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        //3. 简介
        
        UILabel *intr = [[UILabel alloc] initWithFrame:CGRectMake(65, 28, 210, 15)];
        intr.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        intr.textAlignment = NSTextAlignmentLeft;
        intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
        intr.numberOfLines = 0;
        //nameLabel.text = shopmodel.shopname;
        intr.font = [UIFont boldSystemFontOfSize:12];
        intr.tag = 3;
        intr.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: intr];
        [intr release];
        
        //2.价格
        //CGRect priceLabelRect = CGRectMake(65,45, 180, 12);
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                               CGRectMake(65,46, 180, 12)];
        
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont boldSystemFontOfSize:13];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.tag = 2;
        //priceLabelRect.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: priceLabel];
        [priceLabel release];
        
        
        UILabel *Label = [[UILabel alloc] initWithFrame:
                               CGRectMake(65,65, 80, 12)];
        Label.text = CustomLocalizedString(@"shop_cart_count", @"购买数量：");
        Label.textAlignment = NSTextAlignmentLeft;
        Label.font = [UIFont boldSystemFontOfSize:13];
        Label.textColor = [UIColor blackColor];
        //priceLabelRect.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: Label];
        [Label release];
        
        //3. -
        UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(125, 59, 30, 30)];
        [minusButton setBackgroundImage: [UIImage imageNamed:@"number_minus.png"] forState:UIControlStateNormal];
        [minusButton setBackgroundImage:[UIImage imageNamed:@"number_minus_sel.png"] forState:UIControlStateSelected];//设置选择状态
        minusButton.tag = 5;
        [minusButton addTarget:self action:@selector(minusFoodToOrderSC:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:minusButton];
        minusButton.backgroundColor = [UIColor clearColor];
        [minusButton release];
        
        //4.
        UILabel *numValue = [[UILabel alloc] initWithFrame:
                             CGRectMake(152, 67, 30, 12)];
        
        //numValue.textAlignment = NSTextAlignmentLeft;
        numValue.font = [UIFont boldSystemFontOfSize:13];
        numValue.textColor = [UIColor redColor];
        numValue.tag = 6;
        numValue.textAlignment = NSTextAlignmentCenter;
        //numValue.keyboardType = UIKeyboardTypeNumberPad;
        //numValue.inputAccessoryView = self.keyboardToolbar;
        //UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"number_bg.png"]];
        //[numValue setBackgroundColor:color];
        //[numValue addTarget:self action:@selector(startInPut:) forControlEvents:UIControlEventEditingDidBegin];
        //[numValue addTarget:self action:@selector(endInPut:) forControlEvents:UIControlEventEditingDidEnd];
        
        [cell.contentView addSubview:numValue];
        [numValue release];
        
        
        
        //5. +
        UIButton *plusButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        plusButton.frame = CGRectMake(182, 59, 30, 30);
        plusButton.tag = 7;
        
        [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus.png"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus_sel.png"] forState:UIControlStateSelected];//设置选择状态
        
        [plusButton addTarget:self action:@selector(plusFoodToOrderSC:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:plusButton];
        [plusButton release];
        
        //5. +
        UIButton *removeButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        removeButton.frame = CGRectMake(215, 58, 23, 18);
        removeButton.tag = 8;
        
        [removeButton setBackgroundImage:[UIImage imageNamed:@"detele_ico_1.png"] forState:UIControlStateNormal];
        [removeButton setBackgroundImage:[UIImage imageNamed:@"detele_ico_hover.png"] forState:UIControlStateSelected];//设置选择状态
        
        [removeButton addTarget:self action:@selector(removeFoodToOrderSC:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:removeButton];
        [removeButton release];
        
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 88, 310, 2.0)];
        lineImageView.image = hImage;
        lineImageView.tag = 11;
        [lineImageView setHidden:YES];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
    }
    //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
    int n = (int)indexPath.row;
    FoodModel *foodmodel = [app.shopCart getFoodInOrderModel:&n];
    
    if( foodmodel == nil)
    {
        return nil;
    }
    FoodAttrModel *attr = [foodmodel.attr objectAtIndex:n];
    UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:4];
    ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
    ico.image = foodmodel.image;
    
    /*UIButton *btnCheck = (UIButton *)[cell.contentView viewWithTag:9];
    btnCheck.selected = attr.isSelect;*/
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    nameLabel.text = foodmodel.foodname;
    
    UILabel *intr = (UILabel *)[cell.contentView viewWithTag:3];
    intr.text = [NSString stringWithFormat:@"%@%@", CustomLocalizedString(@"shop_cart_shop_name", @"商家："), foodmodel.tName];
    
    UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:2];
    NSString* priceString;
    priceString = [NSString stringWithFormat:@"%@￥%.2f", CustomLocalizedString(@"public_price", @"单价："), attr.price];
    priceLabel.text = priceString;
    
    UILabel *numValue = (UILabel *)[cell.contentView viewWithTag:6];
    numValue.text = [NSString stringWithFormat:@"%d", attr.count ];
    
    UIImageView *lineImageView = (UIImageView *)[cell.contentView viewWithTag:11];
    
    if (indexPath.row == app.shopCart.foodAttrLine - 1) {
        [lineImageView setHidden:NO];
    }else{
        [lineImageView setHidden:YES];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}

@end
