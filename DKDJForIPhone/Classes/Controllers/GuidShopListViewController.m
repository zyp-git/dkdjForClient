//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GuidShopListViewController.h"
#import "LoadCell.h"
#import "FoodListCell.h"
#import "FoodModel.h"
#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "FileController.h"
#import "UIAlertTableView.h"
#import "HJAppConfig.h"
#import "FoodAttrModel.h"
#import "KTVListViewController.h"
#import "ShopDetailViewController.h"
#import "ShopNewListViewController.h"
#import "LoginNewViewController.h"

@implementation GuidShopListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70
//@synthesize shopcartDict;

//@synthesize shopcartDictForSaveFile;
@synthesize labABCIndexTitle;
@synthesize foodtypeid;
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize dateTableView;
@synthesize couponModel;
static NSString *CellTableIdentifier = @"CellTableIdentifier";
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    page = 1;
    Mark = 0;
    pageFloor = 1;
    pageShopType = 1;
    BoolMark = YES;
    if (is_iPhone5) {
        viewHeight = 440;
    }else{
        viewHeight = 350;
    }
    self.foodtypeid = @"35";
    
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    imageDownload1 = [[CachedDownloadManager alloc] initWitchReadDic:12 Delegate:self];
    
    
    guids1 = [[NSMutableArray array] retain];
    guids2 = [[NSMutableArray array] retain];
    guids3 = [[NSMutableArray array] retain];
    ABCNames = [[NSMutableArray array] retain];
    
    
   
    
    btn1 = [[UIButton alloc] initWithFrame:
                           CGRectMake(0, 0, 107, 60)];
    btn1.selected = YES;
    btn1.tag = 1;
    [btn1 setImage:[UIImage imageNamed:@"guid_list_one.png"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"guid_list_one_sel.png"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(guidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    
    
    btn2 = [[UIButton alloc] initWithFrame:
                          CGRectMake(107,0, 107, 60)];
    btn2.tag = 2;
    [btn2 setImage:[UIImage imageNamed:@"guid_list_two.png"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"guid_list_two_sel.png"] forState:UIControlStateSelected];

    [btn2 addTarget:self action:@selector(guidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn2];
    
    btn3 = [[UIButton alloc] initWithFrame:
            CGRectMake(214,0, 107, 60)];
    btn3.tag = 3;
    [btn3 setImage:[UIImage imageNamed:@"guid_list_three.png"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"guid_list_three_sel.png"] forState:UIControlStateSelected];

    
    [btn3 addTarget:self action:@selector(guidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn3];
    
    
    
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, viewHeight - 5)];
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
    
    [self GetGuidABCListData:YES];
    
    
}
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
    isRemoveAllCell = NO;
}
-(void)guidBtnClick:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        getType = (int)btn.tag - 1;;
        switch (btn.tag) {
            case 1:
                btn2.selected = NO;
                btn3.selected = NO;
                [self removeAllTableView];
                if ([guids1 count] == 0) {
                    [self GetGuidABCListData:YES];
                }
                else
                {
                    [self.dateTableView reloadData];
                }
                break;
            case 2:
                btn1.selected = NO;
                btn3.selected = NO;
                [self removeAllTableView];
                if ([guids2 count] == 0) {
                    [self GetGuidFloorListData:YES];
                }
                else
                {
                    [self.dateTableView reloadData];
                }
                break;
            case 3:
                btn2.selected = NO;
                btn1.selected = NO;
                [self removeAllTableView];
                if ([guids3 count] == 0) {
                    [self GetGuidShopTypeListData:YES];
                }
                else
                {
                    [self.dateTableView reloadData];
                }
                break;
            default:
                break;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



-(void)ShowFoodType:(id)senser
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
    

    
    
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

#pragma mark GetDataABC
-(void) GetGuidABCListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", page];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", self.foodtypeid, @"shopTypeID", pageindex, @"pageindex", @"1", @"isplay",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(guidABCDidReceive:obj:)];
    
    [twitterClient getGuidABCList:param];
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

- (void)guidABCDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    
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
    
    NSInteger prevCount = [guids1 count];//已经存在列表中的数量
    
    
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
    ary = [dic objectForKey:@"datalist"];
    
    if ([ary count] == 0) {
        hasMore = false;
        [self.dateTableView reloadData];
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
        hasMore = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错 
    // 将获取到的数据进行处理 形成列表
    //int index = [guids1 count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        GuidABCModel *model = [[GuidABCModel alloc] initWithJsonDic:dic imageDowload:imageDownload indexGroup:i];
        [guids1 addObject:model];
        [ABCNames addObject:model.name];
        [model release];
    }
    
    [imageDownload startTask];
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
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}
#pragma mark GetDataFloor
-(void) GetGuidFloorListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", pageFloor];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"2", @"pid",pageindex, @"indexpage", @"20", @"pagesize",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(guidFloorDidReceive:obj:)];
    
    [twitterClient getShopTypeWithParams:param];
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

- (void)guidFloorDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    
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
    
    NSInteger prevCount = [guids2 count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    totalPageFloor = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",pageFloor);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    
    if ([ary count] == 0) {
        hasMoreFloor = false;
        [self.dateTableView reloadData];
        return;
    }
    //判断是否有下一页
    if( totalPageFloor > pageFloor )
    {
        ++pageFloor;
        hasMoreFloor = true;
    }
    else
    {
        hasMoreFloor = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    //int index = [guids1 count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ShopTypeModel *model = [[ShopTypeModel alloc] initWithFloorJsonDictionary:dic];
        [guids2 addObject:model];
        [model release];
    }
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
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}
#pragma mark GetDataShopType
-(void) GetGuidShopTypeListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", pageShopType];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"pid",pageindex, @"indexpage", @"20", @"pagesize",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(guidShopTypeDidReceive:obj:)];
    
    [twitterClient getShopTypeWithParams:param];
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

- (void)guidShopTypeDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    
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
    
    NSInteger prevCount = [guids3 count];//已经存在列表中的数量
    
    
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
    int index = (int)[guids3 count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ShopTypeModel *model = [[ShopTypeModel alloc] initWithJsonDictionary:dic imageDow:imageDownload1 GoupId:index];
        model.picPath = [imageDownload1 addTask:[NSString stringWithFormat:@"%d", model.typeID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:-1];
        [model setImg:model.picPath Default:@"暂无图片"];
        [guids3 addObject:model];
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
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
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
            GuidABCModel *model = [guids1 objectAtIndex:task.groupType];
            GuidABCAttrModel *attrModel = [model.attr objectAtIndex:task.index];
            if (attrModel) {
                
                attrModel.picPath = task.locURL;
                
                [attrModel setImg:attrModel.picPath  Default:@"暂无图片"];
            }
        }else if(type == 12){
            ShopTypeModel *model;
            if (task.groupType == -1) {
                model = [guids3 objectAtIndex:task.index];
                model.picPath = task.locURL;
                [model setImg:model.picPath  Default:@"暂无图片"];
            }else{
                model = [guids3 objectAtIndex:task.groupType];
                ShopTypeModel *attrModel = [model.attr objectAtIndex:task.index];
                attrModel.picPath = task.locURL;
                [attrModel setImg:attrModel.picPath  Default:@"暂无图片"];
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
    [self.labABCIndexTitle release];
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [self.dateTableView release];
    //[self.foodtypes release];
    [self.foodtypeid release];
    [guids1 release];
    [guids2 release];
    [guids3 release];
    [self.uduserid release];
    [self.shopid release];
    [self.defaultPath release];
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

-(void) updateShopCart:(FShop4ListModel *)model{
    [self UpdateShopCart:model];
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCart:(FShop4ListModel *) model
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
    ShopTypeModel *model = [typeModel.attr objectAtIndex:type];
    ShopNewListViewController *viewController = [[[ShopNewListViewController alloc] initWithTypeId:[NSString stringWithFormat:@"%d", model.typeID]] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark UITable
//右边索引选中
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (Mark > 100) {
        BoolMark = NO;
    }
    else if(Mark <  -100)
    {
        BoolMark = YES;
    }
    
    if(BoolMark)
    {
        Mark++;
    }
    else
    {
        Mark--;
    }
    
    if(!self.labABCIndexTitle)
    {
        self.labABCIndexTitle = [self CreatLabelIndexTitle];
    }
    self.labABCIndexTitle.text = title;
    self.labABCIndexTitle.hidden = NO;
    [self performSelector:@selector(LableABC:) withObject:[NSNumber numberWithInt:Mark] afterDelay:0.7];
    
    
    
    return index;
}
-(void)LableABC:(NSNumber*)num
{
    
    if ([num intValue] == Mark ) {
        self.labABCIndexTitle.hidden = YES;
    }
    
}

-(UILabel*)CreatLabelIndexTitle
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:60];
    label.backgroundColor = [UIColor colorWithRed:201/255.0 green:185/255.0 blue:156/255.0 alpha:0.5];//UIColor co(201, 185, 156, 0.5);
    [self.view addSubview:label];
    label.hidden = YES;
    return label;
}
//右边的导航索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if (getType == 0) {
        if ([ABCNames count] == 0) {
            return nil;
        }
        return ABCNames;
    }
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (getType == 0) {
        return ((GuidABCModel *)[guids1 objectAtIndex:section]).name;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isRemoveAllCell) {
        return 1;
    }
    if (getType == 0) {
        return [guids1 count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isRemoveAllCell) {
        return 0;
    }
    GuidABCModel *model;
    switch (getType) {
        case 0:
            model = (GuidABCModel *)[guids1 objectAtIndex:section];
            return [model.attr count];
            //return [guids1 count];
            break;
        case 1:
            return [guids2 count];
            break;
        case 2:
            return [guids3 count];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
            
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        if (getType == 0) {
            UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
            UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 290, 2)];
            line1.image = hImage;
            line1.tag = 4;
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
            
            
            
            
            
            
            
            
            
            
            //3.去看看
            
            NSDictionary *dict1 = NSDictionaryOfVariableBindings(typeIco, nameLabel);
            NSDictionary *metrics = @{@"hPadding":@5, @"vPadding":@5, @"linePadding":@0,@"nameTopPadding":@0,@"typeIcoWigth":@15,@"nameRightPadding":@-0};
            NSString *vfl = @"H:|-hPadding-[nameLabel]-nameRightPadding-[typeIco(typeIcoWigth)]";
            NSString *vfl1 = @"H:|-205-[typeIco]-15-|";
            
            NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-10-|";
            
            
            NSString *vfl4 = @"V:|-25-[typeIco(typeIcoWigth)]";
            
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
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
            [view release];

        }
        else if(getType == 1)
        {
            
            
            UIImageView *typeIco = [[UIImageView alloc] init];
            typeIco.tag = 2;
            [typeIco setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView addSubview:typeIco];
            
            //1. 名称
            UIView *view = [[UIView alloc] init];
            [view setTranslatesAutoresizingMaskIntoConstraints:NO];
            view.tag = 1;
            
            
            
            
            UILabel *nameLabel = [[UILabel alloc] init];
            [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            nameLabel.textColor = [UIColor blackColor];
            
            nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            nameLabel.numberOfLines = 2;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:12];
            nameLabel.tag = 3;
            
            UIImageView *line = [[UIImageView alloc] init];
            line.image = [UIImage imageNamed:@"horizontal_line.png"];
            [line setTranslatesAutoresizingMaskIntoConstraints:NO];
            line.tag = 6;
            [nameLabel addSubview:line];
            
            [view addSubview: nameLabel];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            titleLabel.textColor = [UIColor blackColor];
            
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            titleLabel.numberOfLines = 2;
            //nameLabel.text = shopmodel.shopname;
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            titleLabel.tag = 4;
            
            [view addSubview: titleLabel];
            
            UILabel *enNameLabel = [[UILabel alloc] init];
            [enNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            enNameLabel.textColor = [UIColor blackColor];
            
            enNameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            enNameLabel.numberOfLines = 2;
            //nameLabel.text = shopmodel.shopname;
            enNameLabel.font = [UIFont boldSystemFontOfSize:12];
            enNameLabel.tag = 5;
            
            [view addSubview: enNameLabel];
            
            [cell.contentView addSubview:view];
            
            //NSArray *ary = [cell.contentView constraints];
            
            [line release];
            [typeIco release];
            [nameLabel release];
            [titleLabel release];
            [enNameLabel release];
            [view release];
        }
        else
        {
            UIImage *hImage = [UIImage imageNamed:@"horizontal_line.png"];
            UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 290, 2)];
            line1.image = hImage;
            line1.tag = 4;
            [cell.contentView addSubview:line1];
            [line1 release];
            
            
            
            
            
            UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(30.0, 10.0, 60.0, 60.0)];
            ico.tag = 1;
            [cell.contentView addSubview:ico];
            [ico release];
            
            //1. 名称
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100.0, 10.0, 235, 60)];
            
            
            
            
            UILabel *nameLabel = [[UILabel alloc] init];
            [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            nameLabel.numberOfLines = 1;
            nameLabel.font = [UIFont boldSystemFontOfSize:18];
            nameLabel.tag = 3;
            
            [view addSubview: nameLabel];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            [infoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            infoLabel.textColor = [UIColor grayColor];
            infoLabel.textAlignment = NSTextAlignmentLeft;
            infoLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            infoLabel.numberOfLines = 1;
            infoLabel.font = [UIFont boldSystemFontOfSize:16];
            infoLabel.tag = 2;
            
            [view addSubview: infoLabel];
            
            NSDictionary *dict1 = NSDictionaryOfVariableBindings(nameLabel, infoLabel);
            NSDictionary *metrics = @{@"hPadding":@15, @"vPadding":@5, @"linePadding":@0,@"nameTopPadding":@10,@"typeIcoWigth":@15,@"nameRightPadding":@-0};
            NSString *vfl = @"H:|-hPadding-[nameLabel]";
            NSString *vfl1 = @"H:|-hPadding-[infoLabel]";
            
            NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-0-[infoLabel]";
            
            
            
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [cell.contentView addSubview:view];
            [infoLabel release];
            [nameLabel release];
            [view release];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        
    }
    if (getType == 0) {
        GuidABCModel *foodmodel = (GuidABCModel *)[guids1 objectAtIndex:indexPath.section];
        
        GuidABCAttrModel *attrModel = (GuidABCAttrModel *)[foodmodel.attr objectAtIndex:indexPath.row];
        
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
        ico.image = attrModel.image;
        UIImageView *line1 = (UIImageView *)[cell.contentView viewWithTag:4];
        if (indexPath.row == 0) {
            [line1 setHidden:YES];
        }else{
            [line1 setHidden:NO];
        }
        nameLabel.text = attrModel.shopName;
    }
    else if(getType == 1)
    {
        UIView *view = (UIView *)[cell.contentView viewWithTag:1];
        UIImageView *typeIco = (UIImageView *)[cell.contentView viewWithTag:2];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *enNameLabel = (UILabel *)[cell.contentView viewWithTag:5];
        UIImageView *line = (UIImageView *)[cell.contentView viewWithTag:6];
        NSDictionary *dict1 = NSDictionaryOfVariableBindings(view, typeIco, nameLabel, titleLabel, enNameLabel, line);
        NSDictionary *metrics = @{@"hPadding":@0, @"vPadding":@5, @"lablePadding":@0,@"nameTopPadding":@20,@"lineLength":@25,@"nameRightPadding":@-0};
        if (indexPath.row % 2 == 0) {
            nameLabel.textAlignment = NSTextAlignmentRight;
            titleLabel.textAlignment = NSTextAlignmentRight;
            enNameLabel.textAlignment = NSTextAlignmentRight;
            NSArray *arry = [cell.contentView constraints];
            if (arry != nil && [arry count] > 0) {
                [view retain];
                [typeIco retain];
                [nameLabel retain];
                [titleLabel retain];
                [enNameLabel retain];
                
                [typeIco removeFromSuperview];
                
                [nameLabel removeFromSuperview];
                [titleLabel removeFromSuperview];
                [enNameLabel removeFromSuperview];
                [view removeFromSuperview];
                
                
                
                [view addSubview:nameLabel];
                [view addSubview:titleLabel];
                [view addSubview:enNameLabel];
                
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:typeIco];
                
                [view release];
                [typeIco release];
                [nameLabel release];
                [titleLabel release];
                [enNameLabel release];
                
            }
            NSString *vfl = @"H:|-hPadding-[view(160)]-0-[typeIco(160)]-hPadding-|";
            NSString *vfl5 = @"H:[titleLabel(nameLabel)]-hPadding-|";
            NSString *vfl6 = @"H:[enNameLabel(nameLabel)]-hPadding-|";
            NSString *vfl8 = @"H:[nameLabel(nameLabel)]-hPadding-|";
            NSString *vfl1 = @"H:[line(lineLength)]-0-|";
            NSString *vfl7 = @"V:[line(2)]-0-|";
            
            NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-lablePadding-[titleLabel]-lablePadding-[enNameLabel]";
            
            
            NSString *vfl4 = @"V:|-nameTopPadding-[typeIco(100)]-nameTopPadding-|";
            NSString *vfl2 = @"V:|-nameTopPadding-[view(100)]-nameTopPadding-|";
            
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl8
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:dict1]];

            //view removeConstraints:
        }else{
            nameLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            enNameLabel.textAlignment = NSTextAlignmentLeft;
            NSArray *arry = [cell.contentView constraints];
            if (arry != nil && [arry count] > 0) {//已经有了，去掉，重新布局，这样可以保证不会布局错乱
                [view retain];
                [typeIco retain];
                [nameLabel retain];
                [titleLabel retain];
                [enNameLabel retain];
                
                [typeIco removeFromSuperview];
                
                [nameLabel removeFromSuperview];
                [titleLabel removeFromSuperview];
                [enNameLabel removeFromSuperview];
                [view removeFromSuperview];
                
                
                
                [view addSubview:nameLabel];
                [view addSubview:titleLabel];
                [view addSubview:enNameLabel];
                
                [cell.contentView addSubview:view];
                [cell.contentView addSubview:typeIco];
                
                [view release];
                [typeIco release];
                [nameLabel release];
                [titleLabel release];
                [enNameLabel release];
                
            }
            NSString *vfl = @"H:|-hPadding-[typeIco(160)]-0-[view(160)]-hPadding-|";
            NSString *vfl5 = @"H:|-0-[titleLabel(nameLabel)]";
            NSString *vfl6 = @"H:|-0-[enNameLabel(nameLabel)]";
            NSString *vfl8 = @"H:|-0-[nameLabel(nameLabel)]";
            NSString *vfl1 = @"H:|-0-[line(lineLength)]";
            NSString *vfl7 = @"V:[line(2)]-0-|";
            
            NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-lablePadding-[titleLabel]-lablePadding-[enNameLabel]";
            
            
            NSString *vfl4 = @"V:|-nameTopPadding-[typeIco(100)]-nameTopPadding-|";
            NSString *vfl2 = @"V:|-nameTopPadding-[view(100)]-nameTopPadding-|";
            
            
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl8
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:dict1]];
        }
        
        
        NSString *imageName = [NSString stringWithFormat:@"guid_floor_%ld.png", indexPath.row % 4];
        ShopTypeModel *model = [guids2 objectAtIndex:indexPath.row];
        nameLabel.text = model.typeName;
        titleLabel.text = model.notice;
        enNameLabel.text = model.typeEnName;
        typeIco.image = [UIImage imageNamed:imageName];
    }else
    {
        ShopTypeModel *foodmodel = (ShopTypeModel *)[guids3 objectAtIndex:indexPath.row];
        
        
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *infoLabel = (UILabel *)[cell.contentView viewWithTag:2];
        ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
        ico.image = foodmodel.image;
        
        nameLabel.text = foodmodel.typeName;
        infoLabel.text = foodmodel.notice;
    }
    
    return cell;
    

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (getType == 0) {
        return 97;
    }else if(getType == 1){
        return 110;//(indexPath.row == [foods count]) ? 60 : 40;
    }
    else
    {
        return 80;
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
        if(getType == 0 && twitterClient == nil && hasMore){
            //读取更多数据
            //page++;
            [self GetGuidABCListData:NO];
        }else if(getType == 1 && twitterClient == nil && hasMoreFloor){
            //读取更多数据
            //page++;
            [self GetGuidFloorListData:NO];
        }else if(getType == 2 && twitterClient == nil && hasMoreShopType){
            //读取更多数据
            //page++;
            [self GetGuidShopTypeListData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(getType == 0){
        GuidABCModel *foodmodel = (GuidABCModel *)[guids1 objectAtIndex:indexPath.section];
        
        GuidABCAttrModel *attrModel = (GuidABCAttrModel *)[foodmodel.attr objectAtIndex:indexPath.row];
        if(attrModel != nil)
        {
            ShopDetailViewController *controller = [[[ShopDetailViewController alloc] initWithShopId:[NSString stringWithFormat:@"%d", attrModel.shopID] shopType:0]autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }
    else if(getType == 1)
    {
        ShopTypeModel *model = [guids2 objectAtIndex:indexPath.row];
        ShopNewListViewController *viewController = [[[ShopNewListViewController alloc] initWithTypeId:[NSString stringWithFormat:@"%d", model.typeID]] autorelease];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        typeModel = (ShopTypeModel *)[guids3 objectAtIndex:indexPath.row];
        if ([typeModel.attr count] > 0) {
            ShopTyePopView *popView = [[ShopTyePopView alloc] initinitWithView:self.view WithArry:typeModel.attr];
            popView.delegate = self;
            [popView showDialog];
            [popView release];
        }
        
    }
}

@end