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
#import "UIAlertTableView.h"
#import "HJAppConfig.h"
#import "FoodAttrModel.h"
#import "ShopNewTopListViewController.h"
#import "ShopDetailViewController.h"
#import "AreaListViewController.h"
#import "SearchOnMapViewController.h"
#import "HJButton.h"
#import "FoodListViewController.h"
@implementation ShopNewTopListViewController

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
@synthesize foodType;
@synthesize getShopTypeID;//获取商家分类id
@synthesize shops;
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize dateTableView;
@synthesize searchKey;







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
    _progressHUD1.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD1 show:YES];
    
    
    [param release];
    
    
}

#pragma mark GetShopList
-(void) GetShopListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", shopPage];
    NSDictionary* param;
    NSString *lat;
    NSString *lon;
    if (app.useLocation != nil) {
        lat = [NSString stringWithFormat:@"%f", app.useLocation.lat ];
        lon = [NSString stringWithFormat:@"%f", app.useLocation.lon ];
    }else{
        lat  = @"0.0";
        lon = @"0.0";
    }
    param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize", @"0", @"shoptype", pageindex, @"pageindex", sortFlag, @"sortflag", sortname, @"sortname", @"1", @"isrem", lat, @"lat", lon, @"lng", nil];//isbuy 0表示线上商品，1表示线下商品 type
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
    
    [twitterClient getShopListByLocation:param];
    
    if (shopPage == 1) {
        [processView setHidden:NO];
        [noDataView setHidden:YES];
    }
    
    
    
    [param release];
    
    
}

- (void)shopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    [twitterClient release];
    twitterClient = nil;
    
    /*if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }*/
    [processView setHidden:YES];
    
    if (client.hasError) {
        [noDataView setHidden:NO];
        processInfo.text = CustomLocalizedString(@"public_net_or_data_failed", @"获取数据失败");
        processInfo1.text = CustomLocalizedString(@"public_net_or_data_error", @"请检查网络后点击重新加载");
        [client alert];
        return;
    }
    
    NSInteger prevCount = [self.shops count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        [noDataView setHidden:NO];
        processInfo.text = CustomLocalizedString(@"public_net_or_data_failed", @"获取数据失败");
        processInfo1.text = CustomLocalizedString(@"public_net_or_data_error", @"请检查网络后点击重新加载");
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
    NSMutableArray *activity;
    if (shopPage == 1) {
        prevCount = 0;
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([self.shops2 count] != 0) {
                [self.shops2 removeAllObjects];
            }
            
            activity = self.shops2;
            select = 2;
        }else{
            if ([self.shops1 count] != 0) {
                [self.shops1 removeAllObjects];
            }
            
            activity = self.shops1;
            select = 1;
        }
    }else{
        activity = shops;
    }
    if (prevCount == 0 && [ary count] == 0) {
        [noDataView setHidden:NO];
        processInfo.text = CustomLocalizedString(@"shop_list_no_shop",@"对不起！该区域暂未开通服务！");
        processInfo1.text = @"";
    }
    if ([ary count] == 0) {
        hasMoreShop = false;
        shops = activity;
        activity = nil;
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
        hasMoreShop = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = [activity count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FShop4ListModel *model = [[FShop4ListModel alloc] initWithJsonDictionary:dic imageDow:imageDownload Group:index];
        
        model.picPath = [imageDownload1 addTask:[NSString stringWithFormat:@"%d", model.shopid] url:model.icon showImage:nil defaultImg:@"" indexInGroup:index++ Goup:2];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.shopname);
        [activity addObject:model];
        [model release];
    }
    
    [imageDownload1 startTask];
    isRemoveAllCell = NO;
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        shops = activity;
        activity = nil;
        [self.dateTableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count] ;
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        //刷新表格数据
        [self.dateTableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}


#pragma mark 获取商家分类
-(void) GetGuidShopTypeListData
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", pageShopType];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"1", @"pid",pageindex, @"indexpage", @"20", @"pagesize",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    twitterClient1 = [[TwitterClient alloc] initWithTarget:self action:@selector(guidShopTypeDidReceive:obj:)];
    
    [twitterClient1 getShopTypeWithParams:param];
    
    
    
    [param release];
    
    
}

- (void)guidShopTypeDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    [twitterClient1 release];
    twitterClient1 = nil;
    
    
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
//    NSInteger prevCount = [shopTypeArry count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    totalPageShopType = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",pageShopType);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    
    if ([ary count] == 0) {
        hasMoreShopType = false;
        [self.dateTableView reloadData];
        return;
    }
    //判断是否有下一页
    if( totalPageShopType > pageShopType )
    {
        ++pageShopType;
        hasMoreShopType = true;
    }
    else
    {
        hasMoreShopType = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = [shopTypeArry count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ShopTypeModel *model = [[ShopTypeModel alloc] initWithJsonDictionary:dic imageDow:imageDownload1 GoupId:index];
        /*model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.typeID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:-1];
        [model setImg:model.picPath Default:@"暂无图片"];*/
        
        [shopTypeArry addObject:model];
        [model release];
    }
    //[imageDownload startTask];
}


- (void)gotoShopCart:(id)senser
{
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice",@"提醒") message:[[NSString alloc] initWithFormat:CustomLocalizedString(@"shop_detail_shopcart_empt",@"购物车为空")] delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok",@"确定") otherButtonTitles:nil];
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

-(void)ShowShopType:(id)senser
{
    //[self.navigationController popViewControllerAnimated:YES];
    if (!hasShowMenu) {
        hasShowMenu = YES;
        ShopTyePopView *popView = [[ShopTyePopView alloc] initinitWithView:self.view WithArry:shopTypeArry];
        popView.delegate = self;
        [popView showDialog];
        [popView release];
    }
    
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



#pragma mark ViewLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    shopPage = 1;
    activityPage = 1;
    isChangeCity = YES;
    sortname = @"SortNum";
    sortFlag = @"1";
    if (is_iPhone5) {
        viewHeight = 440;
    }else{
        viewHeight = 350;
    }
    if(getType == nil || getType.length < 1)
    {
        getType = @"2";
        self.title = CustomLocalizedString(@"nav_2", @"推荐");
        self.getShopTypeID = @"0";
        gotoCityClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoCity:)];
        
        
        /*UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 5.0, 20, 20)];
        icon.image = [UIImage imageNamed:@"icon_my_address.png"];
        [self.lbTitle addSubview:icon];
        [icon release];*/
        
        
        //self.navigationItem.title=@"";
       // [leftButton release];
        //[foodType release];
        shopTypeArry = [[NSMutableArray alloc] init];
        ShopTypeModel *model = [[ShopTypeModel alloc] init];
        model.typeID = 0;
        model.typeName = @"全部分类";
        [shopTypeArry addObject:model];
        [model release];
        [self GetGuidShopTypeListData];
    }
    else
    {
      self.title = @"商家列表";
        UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
        backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
        
        
        
        [foodType addGestureRecognizer:backClick];
        
        //[singleTap release];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
        
        
        self.navigationItem.leftBarButtonItem = leftButton;
        [leftButton release];
        [foodType release];
    }
    self.getShopTypeID = @"0";
    self.searchKey = @"";
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:15 Delegate:self];
    imageDownload1 = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    
    
   
    
    
    
    
    self.shops1 = [[NSMutableArray array] retain];
    self.shops2 = [[NSMutableArray array] retain];
    
    
    
    
    
    
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight - 5)];
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
    
    processView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 40.0, self.view.frame.size.width, self.view.frame.size.height - 40)];
    processView.backgroundColor = [UIColor colorWithRed:231/255.0 green:236/255.0 blue:232/255.0 alpha:1.0];
    UIActivityIndicatorView *processIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35, self.view.frame.size.height / 2 - 10, 20, 20)] autorelease];
    [processIndicator startAnimating];
    [processView addSubview:processIndicator];
    
    UILabel *lbProcessInfo = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 15, self.view.frame.size.height / 2 - 10, 50, 20)];
    lbProcessInfo.text = CustomLocalizedString(@"loading", @"加载中...");
    lbProcessInfo.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:98/255.0 alpha:1.0];
    lbProcessInfo.font = [UIFont boldSystemFontOfSize:13];
    [processView addSubview:lbProcessInfo];
    [lbProcessInfo release];
    [self.view addSubview:processView];
    
    
    
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 40.0, self.view.frame.size.width, self.view.frame.size.height - 40)];
    
    errViewClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GetShopListDataAgain)];
    [noDataView addGestureRecognizer:errViewClick];
    noDataView.backgroundColor = [UIColor colorWithRed:231/255.0 green:236/255.0 blue:232/255.0 alpha:1.0];
    noDateImag = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 25, self.view.frame.size.height / 2 - 35, 50, 50)];
    noDateImag.image = [UIImage imageNamed:@"bg_wifi.png"];
    [noDataView addSubview:noDateImag];
    
    noDataViewInfo = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 120, self.view.frame.size.height / 2 + 20, 240, 50)];
    processInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
    processInfo.text = CustomLocalizedString(@"fetch_data_failed",@"获取数据失败");
    processInfo.textAlignment = NSTextAlignmentCenter;
    processInfo.font = [UIFont boldSystemFontOfSize:16];
    [noDataViewInfo addSubview:processInfo];
    
    processInfo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 240, 20)];
    processInfo1.text = CustomLocalizedString(@"check_network_then_click_for_retry",@"请检查网络后点击重新加载");
    processInfo1.textAlignment = NSTextAlignmentCenter;
    processInfo1.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:98/255.0 alpha:1.0];
    processInfo1.font = [UIFont boldSystemFontOfSize:13];
    [noDataViewInfo addSubview:processInfo1];
    
    [noDataView addSubview:noDataViewInfo];
    
    
    
    
    [self.view addSubview:noDataView];
    [noDataView setHidden:YES];
    
    shopPage = 1;
    [self GetShopListData:YES];
    
   // [self initBaiduMap];
    
    
    
    
    
}

-(void)GetShopListDataAgain
{
    shopPage = 1;
    [self GetShopListData:YES];
}







-(void)GotoCity:(id)sel
{
    
    SearchOnMapViewController *viewController = [[[SearchOnMapViewController alloc] init] autorelease];
    
    //LoginController.title =@"会员登录";
    
    //注意：此处这样实现可以显示有顶部navigationbar的试图
    UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:viewController] autorelease];
    //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
    [self presentViewController:navController animated:YES completion:nil];
    
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    //[self locationUpdate:nil];
    /*if (app.useLocation.addressDetail.length > 0) {
        [self setTitle:app.useLocation.addressDetail];
    }else{
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"定位中...，请稍后！";
        [_progressHUD show:YES];
        [self setTitle:@"定位中..."];
    }*/
    
    
}





- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
   

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



- (id)initWithTypeId:(NSString*)type
{
    self = [super init];
    getType = @"-1";
    self.getShopTypeID = type;
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
        if (type == 1) {
            FShop4ListModel *model1;
            if (task.index >= 0 && task.index < [self.shops count]) {
                model1 = (FShop4ListModel *)[self.shops objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }else if(type == 15){
            if (task.locURL.length == 0) {
                task.locURL = nil;
            }
            FShop4ListModel *model1 = (FShop4ListModel *)[self.shops objectAtIndex:task.groupType];
            ShopTagMode *tagModel = [model1.shopTagList objectAtIndex:task.index];
            tagModel.picPath = task.locURL;
            [tagModel setImg:tagModel.picPath Default:nil];
        }else{
            ShopTypeModel *model1;
            if (task.index >= 0 && task.index < [shopTypeArry count]) {
                model1 = (ShopTypeModel *)[shopTypeArry objectAtIndex:task.index];
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
    if (imageDownload1 != nil) {
        [imageDownload1 stopTask];
        [imageDownload1 release];
    }
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [processInfo1 release];
    [processInfo release];
    [processView release];
    [noDataView release];
    [noDataViewInfo release];
    [noDateImag release];
    [errViewClick release];
    [self.searchKey release];
    
    [self.foodType release];
    [shopTypeArry release];
    [self.dateTableView release];
    self.shops = nil;
    //[self.foodtypes release];
    [self.shops1 release];
    [self.shops2 release];
    [self.uduserid release];
    [self.defaultPath release];
    [gotoCityClick release];
    [showFoodTypeClick release];
    [self.getShopTypeID release];
    [backClick release];
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
#pragma mark HJPopViewDelete
- (void) HJPopViewBaseClose:(int)type
{
    hasShowMenu = NO;
    if (type == 0) {
        self.getShopTypeID = @"0";
        [self.foodType setTitle:@"全部分类" forState:UIControlStateNormal];
    }else{
        ShopTypeModel *model = [shopTypeArry objectAtIndex:type];
        self.getShopTypeID = [NSString stringWithFormat:@"%d", model.typeID];
        [self.foodType setTitle:model.typeName forState:UIControlStateNormal];
    }
    shopPage = 1;
    [self GetShopListData:YES];
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
    
        if ([self.shops count] == 0) {
            return 0;
        }
        count = [self.shops count];
    
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
            
            
                
                UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 2.0, 320, 240)];
                ico.tag = 1;
                
                [cell.contentView addSubview:ico];
                [ico release];
            
            UIImageView *openStatus = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            openStatus.image = [UIImage imageNamed:@"open_status.png"];
            openStatus.tag = 2;
            [cell.contentView addSubview:openStatus];
            [openStatus release];
            
            
                
                //1. 名称
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 245.0, 320, 70)];
                
                
                
                
                UILabel *nameLabel = [[UILabel alloc] init];
                [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                nameLabel.textColor = [UIColor blackColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                nameLabel.numberOfLines = 1;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:14];
                nameLabel.tag = 3;
                
                [view addSubview: nameLabel];
            
            UIView *tagView = [[UIView alloc] init];
            tagView.backgroundColor = [UIColor clearColor];
            tagView.tag = 10;
            [view addSubview:tagView];
            [tagView release];
            
            UIImage *grenBac = [UIImage imageNamed:@"green_round_rec_1.png"];
            UIEdgeInsets insets = UIEdgeInsetsMake(3, 3, 3, 3);
            grenBac = [grenBac resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            
            UIImageView *iZInfo = [[UIImageView alloc] init];
            [iZInfo setTranslatesAutoresizingMaskIntoConstraints:NO];
            iZInfo.tag = 9;
            iZInfo.image = grenBac;
            [view addSubview:iZInfo];
            
            UILabel *statusLabel = [[UILabel alloc] init];
            [statusLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            statusLabel.textColor = [UIColor whiteColor];
            statusLabel.textAlignment = NSTextAlignmentLeft;
            statusLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            statusLabel.numberOfLines = 1;
            //nameLabel.text = shopmodel.shopname;
            statusLabel.font = [UIFont boldSystemFontOfSize:16];
            statusLabel.tag = 4;
            
            [view addSubview: statusLabel];
            
            
            //3. 简介
            
            UILabel *intr = [[UILabel alloc] init];
            [intr setTranslatesAutoresizingMaskIntoConstraints:NO];
            intr.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];//[UIColor darkGrayColor];
            intr.textAlignment = NSTextAlignmentLeft;
            intr.lineBreakMode = NSLineBreakByTruncatingHead;//自动换行
            intr.numberOfLines = 1;
            //nameLabel.text = shopmodel.shopname;
            intr.font = [UIFont boldSystemFontOfSize:10];
            intr.tag = 5;
            
            [view addSubview: intr];
            
            
            //2.价格
            UILabel *priceLabel1 = [[UILabel alloc] init];
            priceLabel1.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            priceLabel1.numberOfLines = 3;
            [priceLabel1 setTranslatesAutoresizingMaskIntoConstraints:NO];
            priceLabel1.textAlignment = NSTextAlignmentLeft;
            priceLabel1.font = [UIFont boldSystemFontOfSize:10];
            priceLabel1.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
            priceLabel1.tag = 71;
            [view addSubview: priceLabel1];
            
            
            
            
            HJLabel *priceLabel = [[HJLabel alloc] initleftImage:[UIImage imageNamed:@"icon_time_big.png"]];
            priceLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            //priceLabel.backgroundColor = [UIColor redColor];
            priceLabel.numberOfLines = 1;
            [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            priceLabel.textAlignment = NSTextAlignmentLeft;
            priceLabel.font = [UIFont boldSystemFontOfSize:10];
            priceLabel.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
            priceLabel.tag = 7;
            [view addSubview: priceLabel];
            
            HJLabel *distanceLabel = [[HJLabel alloc] initleftImage:[UIImage imageNamed:@"icon_around.png"]];
            distanceLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            distanceLabel.numberOfLines = 1;
            [distanceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            distanceLabel.textAlignment = NSTextAlignmentRight;
            distanceLabel.font = [UIFont boldSystemFontOfSize:10];
            distanceLabel.textColor = [UIColor grayColor];
            distanceLabel.tag = 8;
            [view addSubview: distanceLabel];
            
            
            /*UIImageView *line1 = [[UIImageView alloc] init];
             [line1 setTranslatesAutoresizingMaskIntoConstraints:NO];
             line1.image = [UIImage imageNamed:@"search_shop_shop_list_right.png"];
             [view addSubview: line1];*/
            
            
            //3.去看看
            
            NSDictionary *dict1 = NSDictionaryOfVariableBindings(nameLabel, tagView, iZInfo, statusLabel, priceLabel,intr,priceLabel1, distanceLabel);
            NSDictionary *metrics = @{@"hPadding":@5, @"rightPadding":@2, @"linePadding":@0,@"nameTopPadding":@0,@"typeIcoWigth":@20,@"nameRightPadding":@-15};
            NSString *vfl = @"H:|-hPadding-[nameLabel(>=100)]-0-[tagView]-0-[statusLabel]-0-|";
            NSString *vfl0 = @"H:|-hPadding-[nameLabel(>=100)]-0-[tagView]-0-[iZInfo(statusLabel)]-0-|";
            NSString *vfl01 = @"V:|-nameTopPadding-[statusLabel(20)]";
            NSString *vfl02 = @"V:|-nameTopPadding-[iZInfo(statusLabel)]";
            NSString *vfl1 = @"H:|-hPadding-[priceLabel1]-rightPadding-|";
            NSString *vfl2 = @"H:|-hPadding-[intr]-rightPadding-|";
            //NSString *vfl10 = @"V:[nameLabel]-0-[intr]-hPadding-[priceLabel1]";
            
            NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-0-[priceLabel1]-0-[priceLabel]-0-[intr]";
            NSString *vfl31 = @"V:[priceLabel1]-0-[distanceLabel]";
            NSString *vfl4 = @"H:|-hPadding-[priceLabel]-60-|";
            NSString *vfl41 = @"H:[distanceLabel]-2-|";
            
            //NSString *vfl6 = @"V:[priceLabel]-5-|";
            // NSString *vfl7 = @"V:[priceLabel1(15)]-5-|";
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl01
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl02
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
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl31
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl41
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            /*[view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7
             options:0
             metrics:metrics
             views:dict1]];*/
            [cell.contentView addSubview:view];
            [nameLabel release];
            [intr release];
            [iZInfo release];
            [priceLabel1 release];
            [priceLabel release];
            [view release];
            
            
            UIColor *color = [UIColor colorWithRed:221/255.0 green:228/255.0 blue:224/255.0 alpha:1.0];
            
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 333, 320, 2)];
            imageView1.backgroundColor = color;
            /*UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
             [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
             CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
             
             
             float lengths[] = {10,0};//表示先绘制10个点，再跳过5个点 如果把lengths值改为｛10, 20, 10｝，则表示先绘制10个点，跳过20个点，绘制10个点，跳过10个点，再绘制20个点，如此反复
             CGContextRef line2 = UIGraphicsGetCurrentContext();
             CGContextSetStrokeColorWithColor(line2, color.CGColor);
             
             CGContextSetLineDash(line2, 0, lengths, 2);  //画虚线 设置虚线的样式
             CGContextMoveToPoint(line2, 0.0, 0);    //开始画线 将路径绘制的起点移动到一个位置，即设置线条的起点
             CGContextAddLineToPoint(line2, 320.0, 0);//在图形上下文移动你的笔画来指定线条的重点
             CGContextStrokePath(line2);//创建你已经设定好的路径。此过程将使用图形上下文已经设置好的颜色来绘制路径。
             
             
             imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
             CGContextClosePath(line2);*/
            [cell.contentView addSubview:imageView1];
            [imageView1 release];
                
                
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
            cell.backgroundColor = [UIColor clearColor];
            
            
            
            
        }
        FShop4ListModel *foodmodel = [self.shops objectAtIndex:indexPath.row];
        UIView *tagView = (UIView *)[cell.contentView viewWithTag:10];
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
        UIImageView *iZInfo = (UIImageView *)[cell.contentView viewWithTag:9];
        UIImageView *openStatus = (UIImageView *)[cell.contentView viewWithTag:2];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *statusLabel = (UILabel *)[cell.contentView viewWithTag:4];
        HJLabel *distanceLabel = (UILabel *)[cell.contentView viewWithTag:8];
        UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
        HJLabel * priceLabel = (HJLabel *)[cell.contentView viewWithTag:7];
        //[priceLabel setLeftImage:[UIImage imageNamed:@"icon_time_big.png"]];
        UILabel * priceLabel1 = (UILabel *)[cell.contentView viewWithTag:71];
        ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
        ico.image = foodmodel.image;
        if(foodmodel.status == 1)
        {
            [openStatus setHidden:NO];
           // statusLabel.text = @"营业中";
           // cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            [openStatus setHidden:YES];
           // cell.contentView.backgroundColor = [UIColor whiteColor];
           // statusLabel.text = @"休息中";
           // cell.contentView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        }
        if (foodmodel.shopDiscount != 0.0 && foodmodel.shopDiscount < 10.0) {
            statusLabel.text = [NSString stringWithFormat:@"%.1f%@", foodmodel.shopDiscount, CustomLocalizedString(@"public_zhe", @"折")];
            [statusLabel setHidden:NO];
            [iZInfo setHidden:NO];
        }else{
            [statusLabel setHidden:YES];
            [iZInfo setHidden:YES];
        }

        nameLabel.text = foodmodel.shopname;
        for(id cc in [tagView subviews])
        {
            UIImageView *imgView = (UIImageView *)cc;
            [imgView removeFromSuperview];
        }
        CGRect fram = tagView.frame;
        /*fram.size.height = 10;
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize size = CGSizeMake(320,2000);
        CGSize labelsize = [foodmodel.shopname sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, labelsize.width, labelsize.height)];*/
        fram.size.width = 0;
        fram.origin.x = nameLabel.frame.size.width + 5;
        
        tagView.frame = fram;
        NSString *value = [NSString stringWithFormat:@"<font color='red'><b>%@</b></font>%@", CustomLocalizedString(@"shop_detail_top", @"推荐理由"), foodmodel.des];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[value dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        priceLabel1.attributedText = attrStr;
        
       // priceLabel1.text = [NSString stringWithFormat:@"配送费:%.2f元 起送金额:%.2f元", foodmodel.Sendmoney, foodmodel.startMoney];
        priceLabel.text = foodmodel.OrderTime;
        intr.text = foodmodel.address;
        distanceLabel.text = [NSString stringWithFormat:@"<%.2f%@", foodmodel.distance, CustomLocalizedString(@"public_distance", @"<%.2f公里")];
        return cell;

        
        

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 335;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = self.dateTableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.dateTableView.bounds;          // UIScrollView 可+视高度
    CGSize size = self.dateTableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.dateTableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(twitterClient == nil && hasMoreShop){
            //读取更多数据
            //page++;
            [self GetShopListData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (indexPath.row < [self.shops count]) {
            [app setShopMode:(FShop4ListModel *)[self.shops objectAtIndex:indexPath.row]];
            FoodListViewController *controller = [[[FoodListViewController alloc] init] autorelease];
            UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:controller] autorelease];
            //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
            [self presentViewController:navController animated:YES completion:nil];
            
        }
    
}

#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[deleteDic removeObjectForKey:[self.activitys objectAtIndex:indexPath.row]];
    
}

#pragma mark searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    /*ShopListViewController *controller = [[[ShopListViewController alloc] initWithKeywords:searchBar.text] autorelease];
     
     [self.navigationController pushViewController:controller animated:true];
    
    [self.navigationController popViewControllerAnimated:YES];*/
    self.searchKey = searchBar.text;
    if (self.searchKey.length > 0) {
        shopPage = 1;
        [self GetShopListData:YES];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if (self.searchKey.length > 0) {
        self.searchKey = @"";
        shopPage = 1;
        [self GetShopListData:YES];
    }
}

-(void)handleSearchForTerm:(NSString *)searchterm{
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    //searchBar.showsScopeBar = YES;
    
    //[searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    for(id cc in [searchBar subviews])
    {
        if(cc)
        {
            for(id bb in [cc subviews])
            {
                if([bb isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)bb;
                    [btn setTitle:@"取消"  forState:UIControlStateNormal];
                }
            }
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