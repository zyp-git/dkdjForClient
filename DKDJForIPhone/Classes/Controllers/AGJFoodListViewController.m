//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FoodDetailViewController.h"
#import "LoadCell.h"
#import "FoodListCell.h"
#import "FoodModel.h"
#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "FileController.h"

#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJAppConfig.h"
#import "FoodAttrModel.h"
#import "AGJFoodListViewController.h"


@implementation AGJFoodListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70
@synthesize foods1;
@synthesize foods2;
@synthesize shopid;
//@synthesize shopcartDict;

@synthesize imLeft;
//@synthesize shopcartDictForSaveFile;
@synthesize foodtypeid;
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize tableView;
@synthesize imRight;
@synthesize foodModel;
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    page = 1;
    if (is_iPhone5) {
        viewHeight = 440;
    }else{
        viewHeight = 350;
    }
    self.foodtypeid = @"0";
    [self refreshFields];
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
    
    UIImageView *order = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_ico.png"]];
    gotoShopCartClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoShopCart:)];
    
    [order addGestureRecognizer:gotoShopCartClick];
    
    //[singleTap release];
    UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithCustomView:order];
    
    
    self.navigationItem.rightBarButtonItem = orderButton;
    [orderButton release];
    [order release];
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    showFoodTypeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowFoodType:)];
    
    [foodType addGestureRecognizer:showFoodTypeClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    self.foods1 = [[NSMutableArray array] retain];
    self.foods2 = [[NSMutableArray array] retain];
    
    //myDelegte.shopCart = @"123 ";
    //self.foodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, 320, 350) style:UITableViewStylePlain];
    //self.foodsTableView.delegate = self;
    //self.foodsTableView.dataSource = self;
    //[self.view addSubview:self.foodsTableView];
    
    imgTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    imgTapRecognize.numberOfTapsRequired = 1;
    [imgTapRecognize setEnabled :YES];
    [imgTapRecognize delaysTouchesBegan];
    [imgTapRecognize cancelsTouchesInView];
    
    self.imLeft = [[UIImageView alloc] initWithFrame:
                           CGRectMake(70, 10, 90, 30)];
    self.imLeft.image = [UIImage imageNamed:@"left_btn_pressed.png"];
    self.imLeft.userInteractionEnabled = YES;//接受用户操作
    [self.imLeft addGestureRecognizer:imgTapRecognize];
    
    
    //shopcartLabel.backgroundColor = [UIColor grayColor];
    //self.shopcartLabel.text = @"已点：0份 合计：0.00元";
    [self.view addSubview:self.imLeft];
    
    
    imgTapRecognize1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick1:)];
    imgTapRecognize1.numberOfTapsRequired = 1;
    [imgTapRecognize1 setEnabled :YES];
    [imgTapRecognize1 delaysTouchesBegan];
    [imgTapRecognize1 cancelsTouchesInView];
    self.imRight = [[UIImageView alloc] initWithFrame:
                          CGRectMake(160,10, 90, 30)];
    self.imRight.image = [UIImage imageNamed:@"right_btn_normal.png"];
    self.imRight.userInteractionEnabled = YES;
    [self.imRight addGestureRecognizer:imgTapRecognize1];
    
    
    [self.view addSubview:self.imRight];
    //[self.view addSubview: self.shopcartLabel];
    //[self.shopcartLabel release];
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    //self.shopcartDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //添加footimage
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, viewHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    /*self.tableView.tableHeaderView = headerView;
    [self.tableView addSubview:headerView];*/
    self.tableView.tag = 1;
    //self.imageDownload = [[CachedD
    [self.view addSubview:self.tableView];
    
    
    
    
}

-(void) imgClick:(UITapGestureRecognizer *)recognizer{
    self.imLeft.image = [UIImage imageNamed:@"left_btn_pressed.png"];
    self.imRight.image = [UIImage imageNamed:@"right_btn_normal.png"];
    self.foodtypeid = @"0";
    page = 1;
    [self GetFoodListData:YES];
}

-(void) imgClick1:(UITapGestureRecognizer *)recognizer{
    self.imLeft.image = [UIImage imageNamed:@"left_btn_normal.png"];
    self.imRight.image = [UIImage imageNamed:@"right_btn_pressed.png"];
    self.foodtypeid = @"2";
    page = 1;
    [self GetFoodListData:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //self.shopcartLabel.text = [NSString stringWithFormat:@"已点：%d份 合计：%.2f元", app.shopCart.foodCount, app.shopCart.allPrice];
    if (app.foodID != 0) {
        
        [self GetFoodDetailWithFoodID:app.foodID];
        app.foodID = 0;
    }else{
        if ([foods count] == 0) {
            [self GetFoodListData:YES];
        }
        
    }
}

-(void) GetFoodDetailWithFoodID:(int)foodId
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", foodId], @"id",nil];
    
    
    twitterClient1 = [[TwitterClient alloc] initWithTarget:self action:@selector(foodDetailDidReceive:obj:)];
    
    [twitterClient1 getFoodDetailByShopId:param];
    
    _progressHUD1 = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD1.dimBackground = YES;
    
    [self.view addSubview:_progressHUD1];
    [self.view bringSubviewToFront:_progressHUD1];
    _progressHUD1.delegate = self;
    _progressHUD1.labelText = @"加载中...";
    [_progressHUD1 show:YES];
    
    
    [param release];
    
    
}

- (void)foodDetailDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    [twitterClient release];
    twitterClient = nil;
    
    if (_progressHUD1)
    {
        [_progressHUD1 removeFromSuperview];
        [_progressHUD1 release];
        _progressHUD1 = nil;
    }
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    
    
    if (obj == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"改产品已下架！请选择其他产品！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 3;
        [alert show];
        [alert release];
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    //[self.foodModel release];
    self.foodModel = [[FoodModel alloc] initWithJsonDictionary:dic];
    FoodDetailViewController *controller = [[[FoodDetailViewController alloc] initWithFood:self.foodModel]autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}




- (void)gotoShopCart:(id)senser
{
    if( (![self IsLogin]) ){
        return;
    }
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[[NSString alloc] initWithFormat:@"购物车为空"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        ShopCartViewController *viewController = [[[ShopCartViewController alloc] init] autorelease];
        
        [self.navigationController pushViewController:viewController animated:true];
    }
}

- (void)goToFoodDetail:(id)senser
{
    NSUInteger row1;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        row1 = [self.tableView indexPathForCell:(UITableViewCell *)[[[[senser superview] superview] superview] superview]].row;
    }else{
        row1 = [self.tableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    if (row1 == 0) {
        row1 = [self.tableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    row1 *= 2;
    FoodModel *foodmodel;
    UIButton *btn = (UIButton *)senser;
    if(btn.tag == 10){
        row1++;
    }
    foodmodel = [foods objectAtIndex:row1];
    app.shopCart.buyType = 0;
    FoodDetailViewController *controller = [[[FoodDetailViewController alloc] initWithFood:foodmodel ShowGoToShop:YES shopType:0] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)ShowFoodType:(id)senser
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)FoodTypeTableHide:(id)sender
{
    if (isShowType) {
        isShowType = NO;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
         [UIView beginAnimations:nil context:context];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
         self.tableView.frame = CGRectMake(0, 30, 320, viewHeight);
         [UIView setAnimationDelegate:self];
         // 动画完毕后调用animationFinished
         //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
         [UIView commitAnimations];
    }
    
}

-(void)FoodTypeTableShow:(id)sender
{
    if (!isShowType) {
        isShowType = YES;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.tableView.frame = CGRectMake(100, 30, 220, viewHeight);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
        

    }
}

- (void) FoodTypeViewControllerValueChanged:(NSString *)typevalue
{
    NSString *SortID = typevalue;
    
    if([SortID compare:@"0" ] == NSOrderedSame)
    {
        
    }
    else
    {
        [foods removeAllObjects];
        
        self.foodtypeid = SortID;
        [self GetFoodListData:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
    
    /*if (!app.mShopModel.mBUpdate) {
        [self.navigationController popViewControllerAnimated:YES];//返回上一界面
        return;
    }*/
    if (foods != nil) {
        [self updateTable];
    }else{
        [self doSum];
    }

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//商家页面进入餐品列表页面
- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full
{
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    hasMore = false;
    
    self.navigationItem.title = @"菜单";
    page = 1;
    [self.shopid release];
    self.shopid = Shopid;
    [self.shopid retain];
    sentmoney =  [sentmoneyString floatValue];
    startSend = [start floatValue];
    fullFree = full;
    
    app.SendMoney = sentmoney;
    app.startMoney = startSend;
    app.fullFree = full;
    
    
    
    return self;
}

- (id)initWithTypeId:(NSString*)type
{
    return self;
}

#pragma mark GetFoodList
-(void) GetFoodListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", page];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", self.foodtypeid, @"type", pageindex, @"pageindex", @"0", @"isbuy", self.uduserid, @"userid", nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(foodsDidReceive:obj:)];
    
    [twitterClient getFoodListByShopId:param];
    if (isShowProcess) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];
    }
    
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
    
    
}

- (void)foodsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    [twitterClient release];
    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [foods count] / 2;//已经存在列表中的数量
    if ([foods count] % 2 != 0) {//事实上为了方便，要求每次数据反悔偶数个，这样如果不是最后一页的话，不可能会存在在后一行存在左边有商品，右边没有的
        prevCount++;
    }
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total 
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    totalPage = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",page);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodlist"];
    NSMutableArray *food;
    if (page == 1) {
        prevCount = 0;
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([self.foods2 count] != 0) {
                [self.foods2 removeAllObjects];
            }
            
            food = self.foods2;
            select = 2;
        }else{
            if ([self.foods1 count] != 0) {
                [self.foods1 removeAllObjects];
            }
            
            food = self.foods1;
            select = 1;
        }
    }else{
        food = foods;
    }
    if ([ary count] == 0) {
        hasMore = false;
        foods = food;
        [loadCell setType:MSG_TYPE_NO_MORE];
        food = nil;
        [self.tableView reloadData];
        return;
    }
    
    //判断是否有下一页
    
    
    if( totalPage > page )
    {
        ++page;
        hasMore = true;
    }
    else
    {
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMore = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错 
    // 将获取到的数据进行处理 形成列表
    int index = [food count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FoodModel *model = [[FoodModel alloc] initWithJsonDictionary:dic];
        
        model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.foodid] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.foodname);
        [food addObject:model];
        [model release];
    }
    
    [imageDownload startTask];
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        foods = food;
        food = nil;
        [self.tableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count] / 2;
        if([ary count] % 2 != 0){
            count++;
        }
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"FoodListViewController->foodsDidReceive %d",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
}

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    FoodModel *model1;
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        if (task.index >= 0 && task.index < [foods count]) {
            model1 = (FoodModel *)[foods objectAtIndex:task.index];
            /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                
            }*/
            model1.picPath = task.locURL;
            
            [model1 setImg:model1.picPath  Default:@"暂无图片"];
        }
        
    }
    
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
}

- (void)dealloc {
    //[loadCell release];
    
    if (_progressHUD1)
    {
        [_progressHUD1 removeFromSuperview];
        [_progressHUD1 release];
        _progressHUD1 = nil;
    }
    if (twitterClient1) {
        [twitterClient1 release];
        twitterClient1 = nil;
    }
    
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
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [imgTapRecognize release];
    [imgTapRecognize1 release];
    [self.tableView release];
    //[self.foodtypes release];
    [self.foodtypeid release];
    foods = nil;
    [self.foods1 release];
    [self.foods2 release];
    [self.uduserid release];
    [self.shopid release];
    [self.imLeft release];
    [self.defaultPath release];
    [self.imRight release];
    [gotoShopCartClick release];
    [showFoodTypeClick release];
    //[_progressHUD release];
    //[twitterClient release];
    
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        if(alertView.tag == 2){
            //显示购物车
            [app SetTab:3];
        }else if(alertView.tag == 3){
            if (foods == nil || [foods count] == 0) {
                [self GetFoodListData:YES];
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
            //去水吧
            
        }
        
        
    }
}



- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
}

- (BOOL)IsLogin
{
    [self refreshFields];

    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        //[self.navigationController pushViewController:LoginNewViewController animated:true];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

-(void) doSum
{
}

-(void) updateShopCart:(FoodModel *)food{
    [self UpdateShopCart:food];
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCart:(FoodModel *) foodmodel
{
    
}

-(void)AddtoCart
{
    FoodModel *foodmodel = [foods objectAtIndex:row];
    if ([foodmodel.attr count] != 1) {
        UIAlertTableView *alert = [[UIAlertTableView alloc] initWitchData:&foodmodel updateTableView:self];
        //UIAlertTableView *alert = [[UIAlertTableView alloc] initWithTitle:@"cc" message:@"tt" delegate:self cancelButtonTitle:@"q" otherButtonTitles:@"s", nil];
        [alert show];
        [alert release];
        //[self updateTable];
        return;
    }
    NSString *count = [[NSString alloc] initWithFormat:@"%d",foodmodel.count + 1];
    FoodAttrModel *attr = [foodmodel.attr objectAtIndex:0];
    foodmodel.price = foodmodel.price + attr.price;
    attr.count++;
    foodmodel.count = count;
    
    //根据行号获取food信息 根据 foodid更新购物车中的餐品
    //[foods replaceObjectAtIndex:row withObject:foodmodel];
    
    [self UpdateShopCart:foodmodel];
}

//餐品数量增加1
-(void)plusFoodToOrder:(id)sender
{
    if (app.mShopModel.status == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"商家不在营业中无法下单！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    
    //检查购物车 如果不是此商家的则 需要清除购物车
    NSString *shopcartshopid = [[NSUserDefaults standardUserDefaults] stringForKey:@"shopcartshopid"];
    
    if([self.shopid compare:@"1"] == NSOrderedSame || shopcartshopid == nil || [shopcartshopid compare:@"1"] == NSOrderedSame || [self.shopid compare:shopcartshopid ] == NSOrderedSame || shopcartshopid== nil || [shopcartshopid isEqualToString:@""])
    {
        row = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
        NSLog(@"row:%lu", (unsigned long)row);
        //CGSize size = [HJAppConfig GetScreen];
        
        [self AddtoCart];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的购物车中有其他商家的餐品，清空购物车吗？" delegate:self
                                              cancelButtonTitle:@"取消." otherButtonTitles:@"清空",nil];
        alert.tag = 1;
        
        [alert show];
        [alert release];
    }
}

//餐品数量减少1
-(void)minusFoodToOrder:(id)sender 
{
    
    
    NSUInteger row1 = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    //更新 foods中对应餐品的数量
    
    //根据行号更新购物车中的餐品信息
    NSLog(@"row:%lu", (unsigned long)row1);
    
    FoodModel *foodmodel = [foods objectAtIndex:row1];
    if ([foodmodel.attr count] != 1) {
        UIAlertTableView *alert = [[UIAlertTableView alloc] initWitchData:&foodmodel updateTableView:self];
        //UIAlertTableView *alert = [[UIAlertTableView alloc] initWithTitle:@"cc" message:@"tt" delegate:self cancelButtonTitle:@"q" otherButtonTitles:@"s", nil];
        [alert show];
        [alert release];
        //[self updateTable];
        return;
    }
    NSString *count = @"0";
    
    if( foodmodel.count == 0)
    {
        count = @"0";
    }
    else
    {
        count = [[NSString alloc] initWithFormat:@"%d",foodmodel.count - 1];
    }
    FoodAttrModel *attr = [foodmodel.attr objectAtIndex:0];
    foodmodel.price = foodmodel.price - attr.price;//[NSString stringWithFormat:@"%.2f", foodmodel.price - attr.price];
    attr.count--;
    foodmodel.count = count;
    
    //根据行号获取food信息 根据 foodid更新购物车中的餐品
    //[foods replaceObjectAtIndex:row1 withObject:foodmodel];
    
    [self UpdateShopCart:foodmodel];
    
    [self updateTable];
}

/*-(void)imageSingClick:(UITapGestureRecognizer*) gesture
{
}*/

//更新列表显示
-(void) updateTable
{
    [self doSum];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (tableView.tag == 1) {
        if ([foods count] == 0) {
            return 0;
        }
        count = [foods count] / 2;
        if([foods count] % 2 != 0){
            count++;
        }
        return count;
    }else{
        return [app.arryFoodType count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//show load more cell
    if (tableView.tag == 1) {
        
            static NSString *CellTableIdentifier = @"CellTableIdentifier";
            
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
            
            if (cell == nil) {
                
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier: CellTableIdentifier] autorelease];
                //自定义布局 分别显示以下几项
                
                /*UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 80.0, 80.0)];
                backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [cell.contentView addSubview:backGImg];*/
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 155, 200.0)];
                view.tag = 11;
                UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 160.0, 120.0)];
                ico.tag = 1;
               // backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [view addSubview:ico];
                [ico release];
                
                //1. 名称
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 120, 160, 15)];
                nameLabel.textColor = [UIColor redColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:12];
                nameLabel.tag = 3;
                
                [view addSubview: nameLabel];
                [nameLabel release];
                
                //3. 简介
                
                UILabel *intr = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140, 160, 15)];
                intr.textColor = [UIColor darkGrayColor];
                intr.textAlignment = NSTextAlignmentLeft;
                intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                intr.numberOfLines = 0;
                //nameLabel.text = shopmodel.shopname;
                intr.font = [UIFont boldSystemFontOfSize:11];
                intr.tag = 5;
                
                [view addSubview: intr];
                [intr release];
                
                //2.价格
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                                       CGRectMake(0.0,160, 80, 12)];
                
                priceLabel.textAlignment = NSTextAlignmentLeft;
                priceLabel.font = [UIFont boldSystemFontOfSize:14];
                priceLabel.textColor = [UIColor blackColor];
                priceLabel.tag = 7;
                
                [view addSubview: priceLabel];
                [priceLabel release];
                
                //3.去看看
                UIButton *btnGo = [[UIButton alloc] initWithFrame:
                                       CGRectMake(105.0,160, 50, 20)];
                
                [btnGo setTitle:@"去看看" forState:UIControlStateNormal];
                btnGo.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnGo setBackgroundColor:[UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0]];
                [btnGo addTarget:self action:@selector(goToFoodDetail:) forControlEvents:UIControlEventTouchUpInside];
                btnGo.tag = 9;
                
                [view addSubview:btnGo];
                [btnGo release];
                
                [cell.contentView addSubview:view];
                [view release];
                
                view = [[UIView alloc] initWithFrame:CGRectMake(160.0, 0.0, 155, 200.0)];
                view.tag = 12;
                
                ico = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 160.0, 120.0)];
                ico.tag = 2;
                // backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [view addSubview:ico];
                [ico release];
                
                //1. 名称
                
                nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 120, 160, 15)];
                nameLabel.textColor = [UIColor redColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:14];
                nameLabel.tag = 4;
                
                [view addSubview: nameLabel];
                [nameLabel release];
                
                //3. 简介
                
                intr = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140, 160, 15)];
                intr.textColor = [UIColor darkGrayColor];
                intr.textAlignment = NSTextAlignmentLeft;
                intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                intr.numberOfLines = 0;
                //nameLabel.text = shopmodel.shopname;
                intr.font = [UIFont boldSystemFontOfSize:12];
                intr.tag = 6;
                
                [view addSubview: intr];
                [intr release];
                
                //2.价格
                priceLabel = [[UILabel alloc] initWithFrame:
                                       CGRectMake(0.0,160, 80, 12)];
                
                priceLabel.textAlignment = NSTextAlignmentLeft;
                priceLabel.font = [UIFont boldSystemFontOfSize:14];
                priceLabel.textColor = [UIColor blackColor];
                priceLabel.tag = 8;
                
                [view addSubview: priceLabel];
                [priceLabel release];
                
                //3.去看看
                btnGo = [[UIButton alloc] initWithFrame:
                                   CGRectMake(105.0,160, 50, 20)];
                
                [btnGo setTitle:@"去看看" forState:UIControlStateNormal];
                btnGo.titleLabel.font = [UIFont boldSystemFontOfSize:12];
                [btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnGo setBackgroundColor:[UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0]];
                [btnGo addTarget:self action:@selector(goToFoodDetail:) forControlEvents:UIControlEventTouchUpInside];
                btnGo.tag = 10;
                
                [view addSubview:btnGo];
                [btnGo release];
                
                [cell.contentView addSubview:view];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
                [view release];
                
                
               
            }
            int row = indexPath.row * 2;
            UIView *view = [cell.contentView viewWithTag:11];
            if(row >= [foods count]){
                [view setHidden:YES];
                return cell;
            }else{
                [view setHidden:NO];
            }
            FoodModel *foodmodel = [foods objectAtIndex:row];
            
            
            UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
            /*if (ico.image && ico.image != foodmodel.image) {
                [ico.image release];
            }*/
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            /*if (foodmodel.foodid == 28) {
                row++;
                row--;
            }*/
            
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
            nameLabel.text = foodmodel.foodname;
            
            UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
            intr.text = foodmodel.Disc;
            
            UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:7];
            NSString* priceString;
            priceString = [NSString stringWithFormat:@"%.2f￥", [(FoodAttrModel *)[foodmodel.attr objectAtIndex:0] price]];
            
            
            
            priceLabel.text = priceString;
            
            /*UILabel *pointLabel = (UILabel *)[cell.contentView viewWithTag:5];
            if (foodmodel.publicPoint != nil && foodmodel.publicPoint.length > 0) {
                [pointLabel setHidden:NO];
                pointLabel.text = [NSString stringWithFormat:@"公益积分：%@", foodmodel.publicPoint];
            }else{
                [pointLabel setHidden:YES];
            }*/
            row++;
            view = [cell.contentView viewWithTag:12];
            if(row >= [foods count]){
                [view setHidden:YES];
                return cell;
            }else{
                [view setHidden:NO];
            }
            foodmodel = [foods objectAtIndex:row];
            

            
            ico = (UIImageView *)[cell.contentView viewWithTag:2];
            /*if (ico.image && ico.image != foodmodel.image) {
             [ico.image release];
             }*/
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            /*if (foodmodel.foodid == 28) {
             row++;
             row--;
             }*/
            
            nameLabel = (UILabel *)[cell.contentView viewWithTag:4];
            nameLabel.text = foodmodel.foodname;
            
            intr = (UILabel *)[cell.contentView viewWithTag:6];
            intr.text = foodmodel.Disc;
            
            priceLabel = (UILabel *)[cell.contentView viewWithTag:8];
            
            priceString = [NSString stringWithFormat:@"%.2f￥", [(FoodAttrModel *)[foodmodel.attr objectAtIndex:0] price]];
            
            
            
            priceLabel.text = priceString;
            
            return cell;
        

    }else{
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            cell.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0];
            
            UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 30.0, 30.0)];
            backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
            [cell.contentView addSubview:backGImg];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30,  30)];
            imageView.tag = 1;
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *textFiled = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 40)];
            
            //UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 50)];
            textFiled.tag = 2;
            textFiled.backgroundColor = [UIColor clearColor];
            textFiled.font = [UIFont boldSystemFontOfSize:10];
            textFiled.textColor = [UIColor whiteColor];
            //textFiled.contentStretch = UIControlContentVerticalAlignmentCenter;//剧中显示
            
            textFiled.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            textFiled.numberOfLines = 0;
            [cell.contentView addSubview:textFiled];
            
            [textFiled release];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 100, 2)];
            line.backgroundColor = [UIColor colorWithRed:8/255.0 green:8/255.0 blue:8/255.0 alpha:1.0];
            [cell.contentView addSubview:line];
            [line release];
        }
        //UIImage *image;
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *name = (UILabel *)[cell viewWithTag:2];
        FoodTypeModel *model = [app.arryFoodType objectAtIndex:indexPath.row];
        imageView.image = model.image;
        name.text = model.SortName;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 180;
    }else{
        return 50;//(indexPath.row == [foods count]) ? 60 : 40;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
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
            [self GetFoodListData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (tableView.tag == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        
        //加载更多数据的行被点击了，则加载下一页数据
        if (indexPath.row == [foods count]) {
            if(hasMore){
                if (twitterClient) return;
                
                [loadCell.spinner startAnimating];
                
                NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
                
                //读取商家列表 一次读取8个商家
                //pageindex=1&op=sid&shopname=test&lat=120.000&lng=30.000&nearfilter=1000&sid=103000000000
                twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(foodsDidReceive:obj:)];
                
                NSDictionary* param;// = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",self.self.shopid,@"shopid", nil];
                if([self.foodtypeid compare:@"0" ] == NSOrderedSame)
                {
                    param = [[NSDictionary alloc] initWithObjectsAndKeys:self.shopid,@"shopid", pageindex,@"pageindex", nil];
                }
                else
                {
                    param = [[NSDictionary alloc] initWithObjectsAndKeys:self.shopid,@"shopid",self.foodtypeid, @"typeid",pageindex,@"pageindex", nil];
                }
                
                [twitterClient getFoodListByShopId:param];
                
                NSLog(@"FoodListViewController->didSelectRowAtIndexPath : indexPath.row == [shops count]");
            }
        }
        else {
            FoodDetailViewController *controller = [[[FoodDetailViewController alloc] initWithFood:(FoodModel *)[foods objectAtIndex:indexPath.row]]autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }else{
        selectIndex = indexPath.row;
        FoodTypeModel *model = (FoodTypeModel * )[app.arryFoodType objectAtIndex:indexPath.row];
        self.foodtypeid = model.SortID;
        self.typeNameView.text = model.SortName;
        [self FoodTypeTableHide:nil];
        page = 1;
    }*/
}

@end