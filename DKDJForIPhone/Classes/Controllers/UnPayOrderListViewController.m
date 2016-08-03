//
//  ShopCartViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-16.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "UnPayOrderListViewController.h"
#import "FoodInOrderModel.h"
#import "AddOrderViewController.h"
#import "FileController.h"
#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJEditShopCartNumberPopView.h"
#import "OrderDetailNewViewController.h"
@implementation UnPayOrderListViewController

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

@synthesize shopidSC;
//@synthesize shopcartDictSC;
@synthesize shopcartLabelSC;
@synthesize tableView;
@synthesize keyboardToolbar;

@synthesize btnAllCheck;
//@synthesize shopcartDictSCTemp;
//@synthesize shopcartDictForSaveFile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 
	}
	app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
}

-(void)getShopCart
{
    //还原购物车
    
    //self.shopcartDictForSaveFile = [NSMutableDictionary dictionaryWithDictionary:[FileController loadShopCart]];
    
    //NSString* xString = [[NSString alloc] initWithFormat:@"%d",shopcartDictForSaveFile.count];
    
    //NSLog(@"viewWillAppear shopcartDict.count:%@",xString );
    
    //[self.shopcartDictSCTemp removeAllObjects];
    //[self.shopcartDictSC removeAllObjects];
    /*for (int i = 0; i < [app.shopCart count]; i++) {
        app.shopCart
    }*/
    
    /*for(NSString *key in self.shopcartDictForSaveFile)
    {
        NSDictionary *dic = [self.shopcartDictForSaveFile objectForKey:key];
        
        FoodInOrderModel *fmodelSC = [[FoodInOrderModel alloc] initWithDictionary:dic];
        
        [self.shopcartDictSC addObject:fmodelSC];
    }*/
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
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"上一项", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"下一项", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"确定", @"")
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
    today = @"0";
    state = @"-1";
    pageindex = 1;
    uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    self.title = @"未付款订单";
    
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, 320, 60)];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    
    self.btnAllCheck = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 0.0, 85.0, 30.0)];
    
//    UIImage *backgroundImage = [[UIImage imageNamed:@"cart_unok.jpg"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 23, 23,23)];
//    UIImage *backgroundImage1 = [[UIImage imageNamed:@"cart_ok.jpg"] resizableImageWithCapInsets:UIEdgeInsetsMake(23, 23, 23,23)];
    
    /*[self.btnAllCheck setImage:backgroundImage forState:UIControlStateNormal];
    [self.btnAllCheck setImage:backgroundImage1 forState:UIControlStateSelected];
    [self.btnAllCheck setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnAllCheck setTitle:@" 全选" forState:UIControlStateNormal];
    [self.btnAllCheck addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.btnAllCheck];*/
    
    
    price = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 210, 15)];
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont boldSystemFontOfSize:18];
    price.textColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
    price.text = @"合计：￥0.00元";
    [bottomView addSubview:price];
    
    UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 35, 310, 2.0)];
    lineImageView.image = hImage;
    
    [bottomView addSubview:lineImageView];
    [lineImageView release];
    
    
    
    
    UIButton *goTo = [[UIButton alloc] initWithFrame:CGRectMake(200, 42, 90, 30)];
    //[goTo setImage:[UIImage imageNamed:@"go_buy.png"] forState:UIControlStateNormal];
    [goTo setTitle:@"确认支付" forState:UIControlStateNormal];
    [goTo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goTo setBackgroundColor:[UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0]];
    [goTo addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:goTo];
    [goTo release];
    [self.view addSubview:self.tableView];
    [self.view addSubview:bottomView];
    
    orderList = [[OrderDetailList alloc] init];
    [self getOrderListData:YES];
    
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduseridX = [defaults objectForKey:@"userid"];
    
    NSLog(@"islogin userid:%@", uduseridX);
    
    if([uduseridX intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        //LoginController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

//清空购物车
- (void)cancel:(id)sender
{
    //清除购物车
    
    [app SetTab:1];
    
}

- (void)gotoNext:(id)sender
{
    if( (![self IsLogin]) )
    {
        return;
    }
    
    
    
    /*if(app.shopCart.allPrice > 0.0f)
    {
        if (sumPriceSC < app.startMoney) {
            NSString *msg = [NSString stringWithFormat:@"您购买的物品总价未达到商家的起送金额%.2f", app.startMoney];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:msg  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (sumPriceSC < app.fullFree && app.fullFree > 0.0f) {//保存运费
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:[NSString stringWithFormat:@"%.2f", app.SendMoney] forKey:@"shopcartsentmoney"];
            
            
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:@"0.00" forKey:@"shopcartsentmoney"];
        }
        
        AddOrderViewController *addorderView = [[[AddOrderViewController alloc] initWithShopId:shopidSC ] autorelease];
        
        [self.navigationController pushViewController:addorderView animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"购物车中尚无餐品，请先选择餐品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }*/
}

- (void)dealloc {
    [self.tableView release];
    [price release];
    [bottomView release];
    [orderList release];
    
    [self.shopidSC release];
    [self.shopcartLabelSC release];
    [self.keyboardToolbar release];
    [backClick release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkAll:YES];
    /*if (app.shopCart == nil || app.shopCart.foodCount == 0) {
        self.tableView.frame = CGRectMake(320, 0, 0, 0);
        bottomView.frame = CGRectMake(320, 0, 0, 0);
    }else{
        self.tableView.frame = CGRectMake(0, 0, 320, viewHeight);
        bottomView.frame = CGRectMake(0, viewHeight, 320, 60);
    }
    price.text = [NSString stringWithFormat:@"合计：￥%.2f元", app.shopCart.cAllPrice];*/
}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}
-(void)updateShopCartWitchInOrderModel:(FoodInOrderModel *)food{//传的是指针，原来的数据
    [self UpdateShopCartSC:food];
    //[self updateTableSC];
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
        
        self.shopcartLabelSC.text = [[NSString alloc] initWithFormat:@"    已点: %d份 配送费：%.2f元 合计: %.2f元",sumCountSC, app.SendMoney, sumPriceSC];
        
        
    }else{
        self.shopcartLabelSC.text = [[NSString alloc] initWithFormat:@"    已点: %d份 配送费：0.00元 合计: %.2f元",sumCountSC, sumPriceSC];
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
#pragma mark GetOrderList
-(void)getOrderListData:(BOOL)isShowProcess
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d" , pageindex],@"pageindex",uduserid,@"userid",state,@"state",today,@"today",state,@"ordertype", @"20", @"pagesize",nil];
    
    [twitterClient getOrderList:param];
    if (isShowProcess) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];
    }
    [param release];
}

- (void)ordersDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
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
    
    NSInteger prevCount = [orderList.OrderDetailArry count];//已经存在列表中的数量
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    pageindex = [[dic objectForKey:@"page"] intValue];
    NSString *totalString = [dic objectForKey:@"total"];
    
    
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic objectForKey:@"orderlist"];
    
    
    
    if ([ary count] == 0) {
        hasMore = false;
        return;
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    if(totalpage > pageindex)
    {
        ++pageindex;
        hasMore = true;
    }else{
        hasMore = NO;
    }
    
    // 将获取到的数据进行处理 形成列表
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        OrderDetailModel *model = [[OrderDetailModel alloc] initWithJsonDictionary:dic];
        [orderList.OrderDetailArry addObject:model];
        [model release];
    }
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [self.tableView reloadData];
    }
    else {
        
        int count = (int)[ary count];
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
    
}

-(void)updateShowView
{
    price.text = [NSString stringWithFormat:@"合计：￥%.2f元", orderList.cAllPrice];
    if ([orderList.OrderDetailArry count] != orderList.cFoodCount) {
        btnAllCheck.selected = NO;
    }else{
        btnAllCheck.selected = YES;
    }
}

-(void)checkAll:(BOOL)check
{
    [orderList checkAll:check];
    [self updateTableSC];
    price.text = [NSString stringWithFormat:@"合计：￥%.2f元", orderList.cAllPrice];
}

-(void)checkboxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn == btnAllCheck) {
        [self checkAll:btn.selected];
    }else{
        NSInteger row;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            row = [self.tableView indexPathForCell:(UITableViewCell *)[[[btn superview] superview] superview]].row;
            
        }else{
            row = [self.tableView indexPathForCell:((UITableViewCell *)[[btn superview] superview])].row;
            
        }
        OrderDetailModel *foodmodel = [orderList.OrderDetailArry objectAtIndex:row];
        
        if (btn.tag == 9) {
            
            [orderList checkOrder:foodmodel.OrderId check:btn.selected];
            [self updateShowView];
        }
    }
    
    
}

#pragma mark HJPopView
-(void)HJPopViewBaseClose{
    [self updateTableSC];
    btnCur.selected = !btnCur.selected;
    [self updateShowView];
}


#pragma mark UITableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = self.tableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.tableView.bounds;          // UIScrollView 可视高度
    CGSize size = self.tableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(twitterClient == nil && hasMore){
            //读取更多数据
            //page++;
            [self getOrderListData:NO];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderList.OrderDetailArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 131)];
        bgview.image = [UIImage imageNamed:@"user_opt_bg.png"];
        bgview.userInteractionEnabled = YES;
        
        UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
        

        
        UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 12.0, 20.0, 20.0)];
        btnCheck.tag = 9;
        [btnCheck setImage:[UIImage imageNamed:@"cart_unok.jpg"] forState:UIControlStateNormal];
        [btnCheck setImage:[UIImage imageNamed:@"cart_ok.jpg"] forState:UIControlStateSelected];
        
        [btnCheck addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:btnCheck];
        [btnCheck release];
        
        
        //1. 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 210, 15)];
        nameLabel.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 1;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [bgview addSubview: nameLabel];
        [nameLabel release];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, 42, 293, 2.0)];
        lineImageView.image = hImage;
        
        [bgview addSubview:lineImageView];
        [lineImageView release];
        //3. 简介
        
        UILabel *intr = [[UILabel alloc] initWithFrame:CGRectMake(50, 62, 210, 15)];
        intr.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        intr.textAlignment = NSTextAlignmentLeft;
        intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
        intr.numberOfLines = 0;
        //nameLabel.text = shopmodel.shopname;
        intr.font = [UIFont boldSystemFontOfSize:14];
        intr.tag = 3;
        intr.backgroundColor = [UIColor clearColor];
        
        [bgview addSubview: intr];
        [intr release];
        
        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, 90, 293, 2.0)];
        lineImageView.image = hImage;
        
        [bgview addSubview:lineImageView];
        [lineImageView release];
        
        //2.价格
        //CGRect priceLabelRect = CGRectMake(120,45, 180, 12);
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                               CGRectMake(50,102, 180, 12)];
        
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont boldSystemFontOfSize:13];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.tag = 2;
        //priceLabelRect.backgroundColor = [UIColor clearColor];
        
        [bgview addSubview: priceLabel];
        [priceLabel release];
        
        
        
        
        //4.
       /* UILabel *numValue = [[UILabel alloc] initWithFrame:
                             CGRectMake(50, 80, 50, 12)];
        
        //numValue.textAlignment = NSTextAlignmentLeft;
        numValue.font = [UIFont boldSystemFontOfSize:13];
        numValue.textColor = [UIColor blackColor];
        numValue.tag = 6;
        numValue.textAlignment = NSTextAlignmentCenter;
        
        
        [bgview addSubview:numValue];
        [numValue release];*/
        
        /*lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 120, 310, 2.0)];
        lineImageView.image = hImage;
        lineImageView.tag = 11;
        [lineImageView setHidden:YES];
        [bgview addSubview:lineImageView];
        [lineImageView release];*/
        
        [cell.contentView addSubview:bgview];
        [bgview release];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
    NSInteger n = indexPath.row;
    OrderDetailModel *foodmodel = [orderList.OrderDetailArry objectAtIndex:n];
    
    if( foodmodel == nil)
    {
        return nil;
    }
   
    
    UIButton *btnCheck = (UIButton *)[cell.contentView viewWithTag:9];
    btnCheck.selected = foodmodel.checked;
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    nameLabel.text = [NSString stringWithFormat:@"订单编号：%@", foodmodel.OrderId];
    
    UILabel *intr = (UILabel *)[cell.contentView viewWithTag:3];
    intr.text = [NSString stringWithFormat:@"下单时间：%@", foodmodel.OrderTime];
    
    UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:2];
    priceLabel.text = [NSString stringWithFormat:@"订单金额：￥%.2f", foodmodel.togoPrice];
    
//    UILabel *numValue = (UILabel *)[cell.contentView viewWithTag:6];
    //numValue.text = [NSString stringWithFormat:@"X %d", attr.count ];
    
   /* UIImageView *lineImageView = (UIImageView *)[cell.contentView viewWithTag:11];
    
    if (indexPath.row == app.shopCart.foodAttrLine - 1) {
        [lineImageView setHidden:NO];
    }else{
        [lineImageView setHidden:YES];
    }*/
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 151;
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row < [orderList.OrderDetailArry count]) {
        OrderDetailModel *foodmodel = [orderList.OrderDetailArry objectAtIndex:indexPath.row];
        UIViewController *viewController = [[[OrderDetailNewViewController alloc] initOrderID:foodmodel.OrderId] autorelease];
        [self.navigationController pushViewController:viewController animated:true];
    }

    
}

@end
