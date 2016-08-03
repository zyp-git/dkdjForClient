//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ActivityDetailViewController.h"
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

#import "SearchShopListViewController.h"
#import "ShopDetailViewController.h"

@implementation SearchShopListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70
static NSString *CellTableIdentifier = @"CellTableIdentifier";
@synthesize activitys;
@synthesize shops;
@synthesize shopid;
//@synthesize shopcartDict;

@synthesize imLeft;
//@synthesize shopcartDictForSaveFile;
@synthesize foodtypeid;
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize dateTableView;
@synthesize imRight;


-(void)removeAllTableView{
    isRemoveAllCell = YES;
    [self.dateTableView reloadData];
    UITableViewCell *cell = [self.dateTableView dequeueReusableCellWithIdentifier:CellTableIdentifier];;
    while (1) {
        if (cell) {
            [cell removeFromSuperview];
        }else{
            break;
        }
        cell = [self.dateTableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
}

-(void) imgClick:(UITapGestureRecognizer *)recognizer{
    if (getType != 0) {
        self.imLeft.image = [UIImage imageNamed:@"search_shop_activity_sel.png"];
        self.imRight.image = [UIImage imageNamed:@"search_shop_shop.png"];
        getType = 0;
        
        [self removeAllTableView];
        
        //[self.dateTableView setHidden:NO];
        //[self.dateTableView1 setHidden:YES];
        if ([self.activitys count] == 0) {
            [self GetActivityListData:YES];
        }else{
            isRemoveAllCell = NO;
            [self.dateTableView reloadData];
        }
    }
    
    
}

-(void) imgClick1:(UITapGestureRecognizer *)recognizer{
    if (getType != 1) {
        getType = 1;
        self.imLeft.image = [UIImage imageNamed:@"search_shop_activity.png"];
        self.imRight.image = [UIImage imageNamed:@"search_shop_shop_sel.png"];
        
        //self.dateTableView dele
        //[self.dateTableView1 setHidden:NO];
        //[self.dateTableView setHidden:YES];
        [self removeAllTableView];
        if ([self.shops count] == 0) {
            [self GetShopListData:YES];
        }else{
            isRemoveAllCell = NO;
            [self.dateTableView reloadData];
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

#pragma mark GetShopList
-(void) GetShopListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", shopPage];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize", @"-1", @"type", pageindex, @"pageindex", @"0", @"isbuy", @"0", @"bespeak", @"27", @"shopTypeID", nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
    
    [twitterClient getShopListByLocation:param];
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

- (void)shopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    NSInteger prevCount = [self.shops count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    shopTotalPage = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",shopPage);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];
    
    if ([ary count] == 0) {
        hasMoreShop = false;
        [loadCell setType:MSG_TYPE_NO_MORE];
        [self.dateTableView reloadData];
        return;
    }
    
    //判断是否有下一页
    
    
    if( shopTotalPage > shopPage )
    {
        ++shopPage;
        hasMoreShop = true;
    }
    else
    {
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMoreShop = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = (int)[self.shops count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FShop4ListModel *model = [[FShop4ListModel alloc] initWithJsonDictionary:dic];
        
        model.picPath = [imageDownload1 addTask:[NSString stringWithFormat:@"%d", model.shopid] url:model.icon showImage:nil defaultImg:@"" indexInGroup:index++ Goup:2];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.shopname);
        [self.shops addObject:model];
        [model release];
    }
    
    [imageDownload1 startTask];
    isRemoveAllCell = NO;
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        
        [self.dateTableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.dateTableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
//            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}

#pragma mark GetActivityList
-(void) GetActivityListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", activityPage];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", @"2", @"type", pageindex, @"pageindex", @" 0", @"isbuy",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(activitysDidReceive:obj:)];
    
    [twitterClient getActivityListByShopId:param];
    
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


- (void)activitysDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    NSInteger prevCount = [self.activitys count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    activityTotalPage = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",activityPage);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
   
    if ([ary count] == 0) {
        hasMoreActivity = false;
        [loadCell setType:MSG_TYPE_NO_MORE];
        [self.dateTableView reloadData];
        return;
    }
    
    //判断是否有下一页
    
    
    if( activityTotalPage > activityPage )
    {
        ++activityPage;
        hasMoreActivity = true;
    }
    else
    {
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMoreActivity = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index =(int) [self.activitys count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ActivityModel *model = [[ActivityModel alloc] initWithJsonDictionary:dic];
        
        model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.dataID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.name);
        [self.activitys addObject:model];
        [model release];
    }
    isRemoveAllCell = NO;
    [imageDownload startTask];
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [self.dateTableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.dateTableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
//            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}




- (void)gotoShopCart:(id)senser
{
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[[NSString alloc] initWithFormat:@"购物车为空"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        [app SetTab:2];
        
    }
}

- (void)goToActivityDetail:(id)senser
{
    NSUInteger row1;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        row1 = [self.dateTableView indexPathForCell:(UITableViewCell *)[[[[senser superview] superview] superview] superview]].row;
    }else{
        row1 = [self.dateTableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    if (row1 == 0) {
        row1 = [self.dateTableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    row1 *= 2;
    
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
         self.dateTableView.frame = CGRectMake(0, 30, 320, viewHeight);
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
        self.dateTableView.frame = CGRectMake(100, 30, 220, viewHeight);
        
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
        [activitys removeAllObjects];
        
        self.foodtypeid = SortID;
        [self GetData];
    }
}

#pragma mark ViewLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    shopPage = 1;
    activityPage = 1;
    if (is_iPhone5) {
        viewHeight = 460;
    }else{
        viewHeight = 370;
    }
    self.foodtypeid = @"1";
    getType = 1;
    
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:10 Delegate:self];
    imageDownload1 = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    showFoodTypeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowFoodType:)];
    
    [foodType addGestureRecognizer:showFoodTypeClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    /*UISearchBar* searchbar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    
    
    
    
   
    
    searchbar.delegate = self;
    //[searchbar setShowsCancelButton:NO];
    //[searchbar setShowsCancelButton:NO animated:YES];
    //searchbar.barStyle = UIBarStyleBlackTranslucent;
    //searchbar.showsCancelButton=YES;
    //searchbar.barStyle=UIBarStyleDefault;
    searchbar.placeholder=@"输入餐厅名称";
    searchbar.keyboardType= UIKeyboardTypeDefault;
    searchbar.backgroundColor=[UIColor clearColor];
    
    
    searchbar.showsCancelButton=NO;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:searchbar];
    
    
    self.navigationItem.rightBarButtonItem = rightButton;
    [searchbar release];
    [rightButton release];*/
    
    
    self.activitys = [[NSMutableArray array] retain];
    self.shops = [[NSMutableArray array] retain];
    
    
    /*imgTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    imgTapRecognize.numberOfTapsRequired = 1;
    [imgTapRecognize setEnabled :YES];
    [imgTapRecognize delaysTouchesBegan];
    [imgTapRecognize cancelsTouchesInView];
    
    self.imLeft = [[UIImageView alloc] initWithFrame:
                   CGRectMake(80, 10, 80, 20)];
    self.imLeft.image = [UIImage imageNamed:@"search_shop_activity_sel.png"];
    self.imLeft.userInteractionEnabled = YES;//接受用户操作
    [self.imLeft addGestureRecognizer:imgTapRecognize];
    
    [self.view addSubview:self.imLeft];
    
    
    imgTapRecognize1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick1:)];
    imgTapRecognize1.numberOfTapsRequired = 1;
    [imgTapRecognize1 setEnabled :YES];
    [imgTapRecognize1 delaysTouchesBegan];
    [imgTapRecognize1 cancelsTouchesInView];
    self.imRight = [[UIImageView alloc] initWithFrame:
                    CGRectMake(160,10, 80, 20)];
    self.imRight.image = [UIImage imageNamed:@"search_shop_shop.png"];
    self.imRight.userInteractionEnabled = YES;
    [self.imRight addGestureRecognizer:imgTapRecognize1];
    
    
    [self.view addSubview:self.imRight];*/
    
    
    
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
    self.dateTableView.delegate = self;
    self.dateTableView.dataSource = self;
    self.dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    /*self.dateTableView.tableHeaderView = headerView;
     [self.dateTableView addSubview:headerView];*/
    self.dateTableView.tag = 1;
    //self.imageDownload = [[CachedD
    self.dateTableView.backgroundColor = [UIColor clearColor];
    self.dateTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.dateTableView];
    [self GetShopListData:YES];
    
    
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //self.shopcartLabel.text = [NSString stringWithFormat:@"已点：%d份 合计：%.2f元", app.shopCart.foodCount, app.shopCart.allPrice];
    /*if (app.foodID != 0) {
        
        [self GetFoodDetailWithFoodID:app.foodID];
        app.foodID = 0;
    }else{
        if (getType == 0 && [self.activitys count] == 0) {
            [self GetActivityListData:YES];
        }else if(getType == 1 && [self.shops count] == 0){
            [self GetShopListData:YES];
        }
        
    }*/
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
    
    /*if (!app.mShopModel.mBUpdate) {
        [self.navigationController popViewControllerAnimated:YES];//返回上一界面
        return;
    }
    if (activitys != nil) {
        [self updateTable];
    }else{
        [self doSum];
    }*/

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//商家页面进入餐品列表页面
- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full
{
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    hasMoreActivity = NO;
    hasMoreShop = NO;
    self.navigationItem.title = @"菜单";
    shopPage = 1;
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

#pragma mark ImageDowload

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        if (task.groupType == 1) {
            ActivityModel *model1;
            if (task.index >= 0 && task.index < [self.activitys count]) {
                model1 = (ActivityModel *)[self.activitys objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }else{
            FShop4ListModel *model1;
            if (task.index >= 0 && task.index < [self.shops count]) {
                model1 = (FShop4ListModel *)[self.shops objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }
        
        
    }
    
}

-(void)updataUI:(int)type{
   
    [self.dateTableView reloadData];
    
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
    [self.dateTableView release];
    //[self.foodtypes release];
    [self.foodtypeid release];
    activitys = nil;
    [self.activitys release];
    [self.shops release];
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
            if (activitys == nil || [activitys count] == 0) {
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
    NSLog(@"islogin userid:%@", self.uduserid);
    
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





/*-(void)imageSingClick:(UITapGestureRecognizer*) gesture
{
}*/

//更新列表显示
-(void) updateTable
{
    [self doSum];
    [self.dateTableView reloadData];
}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (isRemoveAllCell) {
        return 0;
    }
    if (getType == 0) {
        if ([self.activitys count] == 0) {
            return 0;
        }
        count = (int)[self.activitys count];
    }else{
        if ([self.shops count] == 0) {
            return 0;
        }
        count = (int)[self.shops count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//show load more cell
    //if (tableView.tag == 1)
    {
        
            
            
        
            
            
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            if (getType == 0) {
                UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
                UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 300, 2)];
                line1.image = hImage;
                [cell.contentView addSubview:line1];
                [line1 release];
                
                
                UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 10.0, 60.0, 60.0)];
                backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [cell.contentView addSubview:backGImg];
                
                
                UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 12.0, 56.0, 56.0)];
                ico.tag = 1;
                [cell.contentView addSubview:ico];
                [ico release];
                
                //1. 名称
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(75.0, 10.0, 235, 60)];
                
                
                
                UIImageView *typeIco = [[UIImageView alloc] init];
                [typeIco setTranslatesAutoresizingMaskIntoConstraints:NO];
                typeIco.image = [UIImage imageNamed:@"detail_ico.png"];
                [view addSubview:typeIco];
                
                UILabel *nameLabel = [[UILabel alloc] init];
                [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                nameLabel.textColor = [UIColor blackColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                nameLabel.numberOfLines = 1;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:18];
                nameLabel.tag = 3;
                
                [view addSubview: nameLabel];
                
                //3. 简介
                
                UILabel *intr = [[UILabel alloc] init];
                [intr setTranslatesAutoresizingMaskIntoConstraints:NO];
                intr.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];;
                intr.textAlignment = NSTextAlignmentLeft;
                intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                intr.numberOfLines = 2;
                //nameLabel.text = shopmodel.shopname;
                intr.font = [UIFont boldSystemFontOfSize:14];
                intr.tag = 5;
                
                [view addSubview: intr];
                
                
                
                
                
                
                
                
                //3.去看看
                
                NSDictionary *dict1 = NSDictionaryOfVariableBindings(typeIco, nameLabel,intr);
                NSDictionary *metrics = @{@"hPadding":@5, @"vPadding":@5, @"linePadding":@0,@"nameTopPadding":@0,@"typeIcoWigth":@15,@"nameRightPadding":@-0};
                NSString *vfl = @"H:|-hPadding-[nameLabel]-nameRightPadding-[typeIco(typeIcoWigth)]";
                NSString *vfl1 = @"H:|-205-[typeIco]-15-|";
                NSString *vfl2 = @"H:|-hPadding-[intr]-hPadding-[typeIco]";
                
                NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-10-[intr]";
                
                
                NSString *vfl4 = @"V:|-25-[typeIco(typeIcoWigth)]";
                
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [cell.contentView addSubview:view];
                [typeIco release];
                [nameLabel release];
                [intr release];
                [view release];
                
                
            }else{
                UIImageView *ivBack = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10, 310, 120)];
                ivBack.image = [UIImage imageNamed:@"shop_img_back.png"];
                
                UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 7.0, 145.0, 105.0)];
                ico.tag = 1;
                
                [ivBack addSubview:ico];
                [ico release];
                
                //1. 名称
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(165.0, 10.0, 145, 110)];
                
                
                
                
                UILabel *nameLabel = [[UILabel alloc] init];
                [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                nameLabel.textColor = [UIColor blackColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                nameLabel.numberOfLines = 1;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:16];
                nameLabel.tag = 3;
                
                [view addSubview: nameLabel];
                
                
                //3. 简介
                
                UILabel *intr = [[UILabel alloc] init];
                [intr setTranslatesAutoresizingMaskIntoConstraints:NO];
                intr.textColor = [UIColor darkGrayColor];
                intr.textAlignment = NSTextAlignmentLeft;
                intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                intr.numberOfLines = 3;
                //nameLabel.text = shopmodel.shopname;
                intr.font = [UIFont boldSystemFontOfSize:12];
                intr.tag = 5;
                
                [view addSubview: intr];
                
                
                //2.价格
                UILabel *priceLabel1 = [[UILabel alloc] init];
                priceLabel1.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                priceLabel1.numberOfLines = 1;
                [priceLabel1 setTranslatesAutoresizingMaskIntoConstraints:NO];
                priceLabel1.textAlignment = NSTextAlignmentLeft;
                priceLabel1.font = [UIFont boldSystemFontOfSize:12];
                priceLabel1.textColor = [UIColor colorWithRed:237.0/255.0 green:0/255.0 blue:50/255.0 alpha:1.0];
                priceLabel1.tag = 71;
                [view addSubview: priceLabel1];
                
                
                
                
                UILabel *priceLabel = [[UILabel alloc] init];
                priceLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                priceLabel.numberOfLines = 1;
                [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                priceLabel.textAlignment = NSTextAlignmentLeft;
                priceLabel.font = [UIFont boldSystemFontOfSize:17];
                priceLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:0/255.0 blue:50/255.0 alpha:1.0];
                priceLabel.tag = 7;
                [view addSubview: priceLabel];
                
                
                UIImageView *line1 = [[UIImageView alloc] init];
                [line1 setTranslatesAutoresizingMaskIntoConstraints:NO];
                line1.image = [UIImage imageNamed:@"search_shop_shop_list_right.png"];
                [view addSubview: line1];
                
                
                //3.去看看
                
                NSDictionary *dict1 = NSDictionaryOfVariableBindings(nameLabel, priceLabel,intr,priceLabel1,line1);
                NSDictionary *metrics = @{@"hPadding":@5, @"rightPadding":@15, @"linePadding":@0,@"nameTopPadding":@8,@"typeIcoWigth":@20,@"nameRightPadding":@-15};
                NSString *vfl = @"H:|-hPadding-[nameLabel]-rightPadding-|";
                NSString *vfl1 = @"H:|-hPadding-[priceLabel1]-3-[priceLabel]-hPadding-[line1]";
                NSString *vfl2 = @"H:|-hPadding-[intr]-rightPadding-|";
                //NSString *vfl10 = @"V:[nameLabel]-0-[intr]-hPadding-[priceLabel1]";
                
                NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-0-[intr(>=45)]";
                
                
                NSString *vfl6 = @"V:[priceLabel]-5-|";
                NSString *vfl7 = @"V:[priceLabel1(15)]-5-|";
                NSString *vfl8 = @"V:[line1(typeIcoWigth)]-15-|";
                NSString *vfl9 = @"H:[line1(typeIcoWigth)]-25-|";
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl8
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl9
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [ivBack addSubview:view];
                [cell.contentView addSubview:ivBack];
                [nameLabel release];
                [intr release];
                [priceLabel1 release];
                [priceLabel release];
                [line1 release];
                [view release];
                [ivBack release];
                
                
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            
            
        }
        if (getType == 0) {
            ActivityModel *foodmodel = [self.activitys objectAtIndex:indexPath.row];
            //[deleteDic ]
            UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            
            
            nameLabel.text = foodmodel.tName;
            
            
            intr.text = foodmodel.name;
            
            
            
            
            
            
            
            return cell;
        }else{
            FShop4ListModel *foodmodel = [self.shops objectAtIndex:indexPath.row];
            UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
//            UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:7];
            UILabel * priceLabel1 = (UILabel *)[cell.contentView viewWithTag:71];
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            
            
            nameLabel.text = foodmodel.shopname;
            
            
            intr.text = foodmodel.des;
            priceLabel1.text = foodmodel.Explain;
            return cell;
        }
        
        

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (getType == 0) {
        return 77;
    }else{
        return 125;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = self.dateTableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.dateTableView.bounds;          // UIScrollView 可视高度
    CGSize size = self.dateTableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.dateTableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(getType == 0 && twitterClient == nil && hasMoreActivity){
            //读取更多数据
            //page++;
            [self GetActivityListData:NO];
        }else if(getType == 1 && twitterClient == nil && hasMoreShop){
            //读取更多数据
            //page++;
            [self GetShopListData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (getType == 0) {
        
        
        //加载更多数据的行被点击了，则加载下一页数据
        if (indexPath.row < [self.activitys count]) {
            if (indexPath.row < [self.activitys count]) {
                ActivityDetailViewController *controller = [[[ActivityDetailViewController alloc] initWithFood:(ActivityModel *)[self.activitys objectAtIndex:indexPath.row]]autorelease];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        
    }else{
        if (indexPath.row < [self.shops count]) {
            ShopDetailViewController *controller = [[[ShopDetailViewController alloc] initWithShopId:[NSString stringWithFormat:@"%d", ((FShop4ListModel *)[self.shops objectAtIndex:indexPath.row]).shopid] shopType:-1]autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }
}




- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[deleteDic removeObjectForKey:[self.activitys objectAtIndex:indexPath.row]];
    
}

#pragma mark searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    /*ShopListViewController *controller = [[[ShopListViewController alloc] initWithKeywords:searchBar.text] autorelease];
     
     [self.navigationController pushViewController:controller animated:true];*/
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)handleSearchForTerm:(NSString *)searchterm{
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    //searchBar.showsScopeBar = YES;
    
    //[searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    return YES;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    //  searchBar.showsScopeBar = NO;
    
    // [searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
    
}

@end