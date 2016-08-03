//
//  ShopListViewController.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-29.
//  Copyright 2011 ihangjing.com. All rights reserved.
//

#import "ShopListViewController.h"
#import "LoadCell.h"
#import "ShopListCell.h"
#import "ShopDetailViewController.h"
#import "FShop4ListModel.h"


@implementation ShopListViewController

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

@synthesize shops1;
@synthesize shops2;
@synthesize aid;
@synthesize gettype;
@synthesize imageDownload;
@synthesize defaultPath;

@synthesize shopTypeNameArray;
@synthesize shopTypeIDArray;
@synthesize nearButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

/*
-(id)init
{
    NSLog(@"ShopListViewController init");

	return [self initWithNibName:@"ShopListView" bundle:nil];
}
 
 -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {   
 [cell setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255
 alpha:1]];
 cell.textLabel.backgroundColor = [UIColor clearColor];  
 cell.detailTextLabel.backgroundColor = [UIColor clearColor];  
 } 
 
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
 }
 
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 self.navigationController.navigationBar.tintColor = nil;
 }
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //select 是表示什么?
    select = 1;
    
    //希望说明一下为什么用shops1 shops2
    
    self.shops1 = [[NSMutableArray array] retain];
    self.shops2 = [[NSMutableArray array] retain];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    self.imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    NSBundle *myBundle = [NSBundle mainBundle];
    
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    [myBundle release];
        
    if (shopname == nil && bID == nil) {
        UIImage *normalImage = [UIImage imageNamed:@"droplist.png"];
        
        self.nearButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
        [self.nearButton  setBackgroundImage:normalImage forState:UIControlStateNormal];
        self.nearButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self.nearButton setTitle:@"附近1500迷        " forState:nil];
        [self.nearButton setBackgroundColor:[UIColor clearColor]];
        
        [self.nearButton addTarget:self action:@selector(showNear:) forControlEvents:UIControlEventTouchUpInside];
        
        //[button ]
        self.navigationItem.titleView = self.nearButton;
    }
    

    if (userID == nil) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"商家分类"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(showType)];
        
        self.navigationItem.rightBarButtonItem = saveButton;
        
        [saveButton release];
    }
    
    [self getShopList];
    
    
    
    	
}

-(void)showType
{
    if (self.shopTypeNameArray == nil) {
        [self getShopType];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请分类"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
        for (int i = 0; i < [self.shopTypeNameArray count]; i++) {
            [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@", [self.shopTypeNameArray objectAtIndex:i]]];
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 2;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];//IActionSheet的最后一项点击失效，点最后一项的上半区域时有效，这是在特定情况下才会发生，这个场景就是试用了UITabBar的时候才有。平时可以这样使用showInView:self.view
    }
}

-(void)showNear:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
    initWithTitle:@"请选择距离"
    delegate:self
    cancelButtonTitle:nil
    destructiveButtonTitle:nil
    otherButtonTitles:@"附近500米", @"附近1000米", @"附近1500米", @"附近2000米", @"附近3000米", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];//IActionSheet的最后一项点击失效，点最后一项的上半区域时有效，这是在特定情况下才会发生，这个场景就是试用了UITabBar的时候才有。平时可以这样使用showInView:self.view
    
}

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    for (int i = index; i < [arry count]; i++) {
        ImageDowloadTask *task = [arry objectAtIndex:i];
        FShop4ListModel *model = [shops objectAtIndex:i];
        model.picPath = task.locURL;
    }
    
}

-(void)updataUI:(int)type{//下载完成，更新界面
    [self.tableView reloadData];
}

-(void)initPara
{
    //如果没有坐标 处理
    hasMore = false;
    
    uaddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"uaddress"];
    ulat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"ulat"];
	ulng = [[NSUserDefaults standardUserDefaults] doubleForKey:@"ulng"];
}

//建筑物选择
-(id)initWithAid:(NSString*)_aid areaname:areaName
{
    
    istuan = @"0";
    shopname = nil;
    brandid = @"";
    isbrand = @"0";
    page = 1;
    nearFilter = @"1500";
    //gettype = @"1";
    //aid = @"0";
    //[self initPara];
    
    self.aid = _aid;
    self.gettype = @"1";
    
    self.navigationItem.title = areaName;
    
    return self;
}

//商家分类列表中点击进入商家列表时调用此函数进行获取数据
- (id)initWithShopType:(NSString*)ashoptype shoptypename:(NSString*)shoptypename
{
    //shoptype = @"";
    istuan = @"0";
    shopname = nil;
    brandid = @"";
    isbrand = @"0";
    self.gettype = @"1";
    self.aid = @"0";
    page = 1;
    nearFilter = @"1500";
    //[self initPara];
    
    shopType = ashoptype;
    
    self.navigationItem.title = shoptypename;

    return self;
}

// 经纬度 半径范围
- (id)initWithLocation
{
    istuan = @"0";
    shopname = nil;
    bID = nil;
    brandid = @"";
    isbrand = @"0";
    self.gettype = @"0";
    shopType = @"";
    self.aid = @"0";
    page = 1;
    nearFilter = @"1500";


    return self;
}

// 建筑物
- (id)initWithBid:(NSString *)bid
{
    bID = bid;
    userID = nil;
    istuan = @"0";
    shopname = nil;
    brandid = @"";
    isbrand = @"0";
    self.gettype = @"0";
    shopType = @"";
    self.aid = @"0";
    page = 1;
    nearFilter = @"1500";
    
    
    return self;
}

// 收藏
- (id)initWithFavor:(NSString *)userid
{
    userID = userid;
    bID = @"";
    istuan = @"0";
    shopname = nil;
    brandid = @"";
    isbrand = @"0";
    self.gettype = @"0";
    shopType = @"";
    self.aid = @"0";
    page = 1;
    nearFilter = @"1500";
    
    
    return self;
}

//搜索
- (id)initWithKeywords:(NSString*)akeywords
{
    
    istuan = @"0";
    //shopname = @"";
    bID = nil;
    brandid = @"";
    isbrand = @"0";
    self.gettype = @"0";
    shopType = @"";
    self.aid = @"0";
    page = 1;
    nearFilter = @"1500";

    shopname = akeywords;
    
    self.navigationItem.title = @"搜索商家";
    
    return self;
}

-(id)initWithIsTuan
{
    
    //istuan = @"0";
    shopname = nil;
    brandid = @"";
    isbrand = @"0";
    self.gettype = @"1";
    self.aid = @"0";
    istuan = @"1";
    nearFilter = @"1500";
    
    self.title = @"推荐商家";
    
    return self;
}

-(void)initWithBrandId:(NSString*)abrandid shopname:(NSString*)ashopname
{
    
    istuan = @"0";
    shopname = nil;
    //brandid = @"";
    isbrand = @"0";
    self.gettype = @"1";
    self.aid = @"0";
    nearFilter = @"1500";
    
    brandid = abrandid;
    
    self.navigationItem.title = ashopname;
    
    page = 1;
    
    [self getShopListFix];
    
}

-(void)getShopType
{
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsTypeDidReceive:obj:)];
    
    [twitterClient getShopType];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
 
}

-(void)getShopList
{
    [self initPara];
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.189053";
    //lng = @"120.163655";
    NSString *latx = [[NSString alloc] initWithFormat:@"%f",ulat];
    NSString *lngx = [[NSString alloc] initWithFormat:@"%f",ulng];
    
    NSDictionary* param;
    if (shopname != nil) {
        
        param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex", shopType, @"shoptype", self.gettype,@"gettype",latx,@"lat",lngx,@"lng",shopname,@"shopname",@"10",@"pagesize", nil];
        [twitterClient getShopListBySearch:param];
        
    }else{
        if (userID != nil) {
            param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",shopType, @"shoptype", self.gettype,@"gettype",latx,@"lat",lngx,@"lng",@"10",@"pagesize", userID, @"Usrid", nil];
        }
        else if (bID != nil) {
            param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",shopType, @"shoptype", self.gettype,@"gettype",latx,@"lat",lngx,@"lng",@"10",@"pagesize", bID, @"bid", nil];
        }else{
            param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",shopType, @"shoptype", self.gettype,@"gettype",latx,@"lat",lngx,@"lng",@"10",@"pagesize", nearFilter, @"nearFilter", nil];
        }
        [twitterClient getShopListByLocation:param];
    }
    
    
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_SHOPS];
    
    [pageindex release];
}

-(void)getShopListFix
{
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.284243";
    //lng = @"120.153432";
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",lat,@"lat",lng,@"lng",brandid,@"brandid", nil];
    
    [twitterClient getShopListByLocation:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_SHOPS];
    
    [pageindex release];
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}

- (void)shopsTypeDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    if (obj == nil)
    {
        return;
    }
    
    NSDictionary* dic = (NSDictionary*)obj;
    
    self.shopTypeNameArray = [[NSMutableArray alloc] init];
    [self.shopTypeNameArray addObject:@"全部分类"];
    self.shopTypeIDArray = [[NSMutableArray alloc] init];
    
    NSArray *ary = [dic objectForKey:@"datalist"];
    
    [self.shopTypeIDArray addObject:@""];
    
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        NSString *value = [dic objectForKey:@"SortName"];
        [self.shopTypeNameArray addObject:value];
        
        value = [dic objectForKey:@"SortID"];
        [self.shopTypeIDArray addObject:value];
    }
    [self showType];
}

/*
{"cachekey":"xxx","desc":"xxx","page":"1","status":"1","total":"3", "list":[{"DataID":"140", "TogoName":"老娘舅", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"120.176888","lat":"30.303508","sendmoney":"0"},{"DataID":"119", "TogoName":"弁当屋", "Grade":"0","sortname":"商务简餐","address":"庆春路118号嘉德广场一楼","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"120.180555","lat":"30.266256","sendmoney":"0"},{"DataID":"128", "TogoName":"家乐送", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"126", "TogoName":"味捷", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"127", "TogoName":"永和大王", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"85", "TogoName":"真功夫", "Grade":"0","sortname":"商务简餐","address":"文三路477号","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"120.131079","lat":"30.285177","sendmoney":"0"},{"DataID":"133", "TogoName":"粤之林", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"131", "TogoName":"台奇香", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"120.178998","lat":"30.256732","sendmoney":"0"}]}
 */
- (void)shopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [shops count];//已经存在列表中的数量
    
    if (obj == nil)
    {
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
    /*if (hasMore) {
        [self.tableView deleteRowsAtIndexPaths:[shops count] withRowAnimation:YES];
    }*/
    
    NSMutableArray *shop;
    
    if (page == 1) {
        prevCount = 0;
        [self.imageDownload cleanAllTask];
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([self.shops2 count] != 0) {
                //[self.shops2 release];
                //self.shops2 = [[NSMutableArray array] retain];
                
                //zjf@ihangjing.com 这里是点击第二次分类报错的语句  貌似没有地方给他赋值  debug有数据.所以发现内存地址shops shops1 shops2 有两个总会变成是一样的
                [self.shops2 removeAllObjects];
                
            }

            shop = self.shops2;

            //zjf@ihangjing.com debug 发现 shops有值时 shops2也有值了 而且内存地址是一样的，是这个语句导致的,可能是内存地址 shop  shops1 shops2有些混乱了  下面又有不同的情况出现 shop = self.shops1; 估计就导致 removeAllObjects报错了
            //没看明白这里的shops2是什么用途
            
            
            select = 2;
        }else{
            if ([self.shops1 count] != 0) {
                [self.shops1 removeAllObjects];
            }
            shop = self.shops1;
            select = 1;
        }
    }else{
        shop = shops;
    }
    
    if ([ary count] == 0) {
        hasMore = false;
        
        [loadCell setType:MSG_TYPE_NO_MORE];
        shops = shop;
        [self.tableView reloadData];
        return;
    }
    //判断是否有下一页
    int totalpage = [totalString intValue];
    if( totalpage > page )
    {
        ++page;
        hasMore = true;
    }
    else
    {
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMore = false;
    }
    //特别注意：此处如果设置未false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错 
    // 将获取到的数据进行处理 形成列表
    
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FShop4ListModel *model = [[FShop4ListModel alloc] initWithJsonDictionary:dic];
        [self.imageDownload addTask:model.shopid url:model.icon showImage:nil defaultImg:self.defaultPath];
        NSLog(@"ShopListViewController shopname:%@", model.shopname);
        [shop addObject:model];
        [model release];
    }
    [self.imageDownload startTask];
    if (prevCount == 0) {
        //如果是第一页则直接加载表格 刚进来没有数据，获取后有数据时reload 显示数据
        
        shops = shop;
        
        [self.tableView reloadData];
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //重新刷新表格显示数据
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
//            NSLog(@"ShopListViewController->shopsDidReceive %ld",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];    
    }
    
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [self.aid release];
    [self.shopTypeNameArray release];
    [self.shopTypeIDArray release];
    [self.nearButton release];
    [self.shops1 release];
    [self.shops2 release];
    [self.gettype release];
    [self.defaultPath release];
    
    if (self.imageDownload != nil) {
        [self.imageDownload stopTask];
        [self.imageDownload release];
    }
    
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

//返回有多少类型的表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个分类中包括多少行，由于只有一类，直接返回数组长度，如果对于多类别的，如年级的话，则可以返回每个年级中的班级数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([shops count] == 0) {
        return 0;
    }
    return [shops count] + 1;
}

//本函数用于显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//show load more cell
    if (indexPath.row == [shops count]) {
        //[self.imageDownload startTask];
        
            return loadCell;
        //}
        
    }
    else {
        
		static NSString *CellTableIdentifier = @"CellTableIdentifier";
		//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; 
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
		
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            /*
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];// 套用自己的圖片做為背景
            */
            //自定义布局 分别显示以下几项
            //名称
            //电话
            //营业时间
            //地址
            UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 50)];
            ico.image = [[UIImage alloc] initWithContentsOfFile:self.defaultPath];
            ico.tag = 5;//不能使用0
            [ico setDoubleTap:self.parentViewController.view];
            [cell.contentView addSubview:ico];
            [ico release];
            //1. 名称
            CGRect nameLabelRect = CGRectMake(60, 5, 205, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            CGRect stateLabelRect = CGRectMake(275, 5, 40, 15);
            UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
            
            stateLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            stateLabel.font = [UIFont boldSystemFontOfSize:10];
            stateLabel.textColor = [UIColor colorWithRed:246.0f green:0.0f blue:0.0f alpha:1.0f];
            stateLabel.tag = 6;
            
            [cell.contentView addSubview: stateLabel];
            [stateLabel release];
            
            //2. 送餐费
            /*CGRect telLabelRect = CGRectMake(60,25, 205, 12);
            UILabel *telLabel = [[UILabel alloc] initWithFrame:
                                 telLabelRect];
            
            telLabel.textAlignment = NSTextAlignmentLeft;
            //telLabel.text = shopmodel.tel;
            telLabel.font = [UIFont boldSystemFontOfSize:12];
            telLabel.textColor = [UIColor grayColor];
            telLabel.tag = 2;
            
            [cell.contentView addSubview: telLabel];
            [telLabel release];*/
            
            //3. 营业时间
            CGRect timeValueRect = CGRectMake(60, 25, 205, 12);
            UILabel *timeValue = [[UILabel alloc] initWithFrame:
                                  timeValueRect];
            
            timeValue.textAlignment = NSTextAlignmentLeft;
            //timeValue.text = shopmodel.OrderTime;
            timeValue.font = [UIFont boldSystemFontOfSize:12];
            timeValue.textColor = [UIColor grayColor];
            timeValue.tag = 3;
            
            [cell.contentView addSubview:timeValue];
            [timeValue release];
            
            //4.地址
            CGRect addressValueRect = CGRectMake(60, 40, 205, 12);
            UILabel *addressValue = [[UILabel alloc] initWithFrame:
                                     addressValueRect];
            
            addressValue.textAlignment = NSTextAlignmentLeft;
            //addressValue.text = shopmodel.address;
            addressValue.font = [UIFont boldSystemFontOfSize:12];
            addressValue.textColor = [UIColor grayColor];
            addressValue.tag = 4;
            
            [cell.contentView addSubview:addressValue];
            [addressValue release];
            

           
		}else{
            /*while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }*/
        }
        
        //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
        
        FShop4ListModel *shopmodel = [shops objectAtIndex:indexPath.row];
        
        if( shopmodel == nil)
        {
            return nil;
        }
        
        
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:5];
        UIImage *image = [[UIImage alloc] init];
        if (shopmodel.picPath == nil || shopmodel.picPath.length == 0) {
            image = [image initWithContentsOfFile:self.defaultPath];
        }else{
            image = [image initWithContentsOfFile:shopmodel.picPath];
        }
        [ico setImage:image];
        [image release];
        //[ico1 ]
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = shopmodel.shopname;
        
        /*NSString *aString = [[NSString alloc] initWithFormat:@"起送价:%@元", shopmodel.startMoney];
        
        UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
        telLabel.text = aString;*/
        UILabel *timeValue = (UILabel *)[cell.contentView viewWithTag:3];
        if (shopname == nil) {
            timeValue.text = shopmodel.OrderTime;
            
        }else{
            timeValue.text = @"";
        }
        
        UILabel *addressValue = (UILabel *)[cell.contentView viewWithTag:4];
		addressValue.text = [NSString stringWithFormat:@"地址：%@", shopmodel.address];
        
        UILabel *stateLabel = (UILabel *)[cell.contentView viewWithTag:6];
        switch (shopmodel.status) {
            case 0:
                stateLabel.text = @"休息";
                break;
            case 1:
                stateLabel.text = @"营业";
                break;
            case -1:
                stateLabel.text = @"";
                nameLabel.text = shopmodel.searchName;
                timeValue.text = [NSString stringWithFormat:@"所属商家：%@", shopmodel.shopname];
                break;
            default:
                break;
        }
        
        //[shopmodel release]; //此处不能做release操作，会导致程序报错
        
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //设置UItableCelView背景 
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = backgrdView;
        
        [backgrdView release];
        //[aString release];
        
        return cell;
    }
}

//每个行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger a = indexPath.row;
    return (indexPath.row == [shops count]) ? 60 : 76;
}

 //本函数用户处理用户点击列表行后的处理
//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
	//加载更多数据的行被点击了，则加载下一页数据
    if (indexPath.row == [shops count]) 
    {
        if (hasMore) {
            
        
        if (twitterClient) 
        {
            return;
        }
        
        [loadCell.spinner startAnimating];
        
        if([isbrand compare:@"1" ] == NSOrderedSame)
        {
            [self getShopListFix];
        }
        else
        {
            [self getShopList];
        }
        }
    }
    else 
    {
        [app setShopMode:[shops objectAtIndex:indexPath.row]];
        [app  SetTab:1];
        [self.navigationController popViewControllerAnimated:YES];
        /*FShop4ListModel *model = [shops objectAtIndex:indexPath.row];
        
        ShopDetailViewController *shopdetail = [[[ShopDetailViewController alloc] initWithShopId:model.shopid] autorelease];
        
        [self.navigationController pushViewController:shopdetail animated:true];*/
        
    }
}

#pragma mark - UIPickerViewDataSource

/*- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( pickerView.tag == 1)
    {
        return nearArray.count;
    }
        
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( pickerView.tag == 1)
    {
        return [nearArray objectAtIndex:row];
    }
    
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if( pickerView.tag == 1)
    {//外卖和现场点菜
        

    }
   
    
}*/

#pragma mark -UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self.nearButton setTitle:@"附近500米         " forState:UIControlStateNormal];
                nearFilter = @"500";
                page = 1;
                [self getShopList];
                break;
            case 1:
                [self.nearButton setTitle:@"附近1000米        " forState:UIControlStateNormal];
                nearFilter = @"1000";
                page = 1;
                [self getShopList];
                break;
            case 2:
                [self.nearButton setTitle:@"附近1500米        " forState:UIControlStateNormal];
                nearFilter = @"1500";
                page = 1;
                [self getShopList];
                break;
            case 3:
                [self.nearButton setTitle:@"附近2000米        " forState:UIControlStateNormal];
                nearFilter = @"2000";
                page = 1;
                [self getShopList];
                break;
            case 4:
                [self.nearButton setTitle:@"附近3000米        " forState:UIControlStateNormal];
                nearFilter = @"3000";
                page = 1;
                [self getShopList];
                break;
            case 5:
                [self.nearButton setTitle:@"附近4000米        " forState:UIControlStateNormal];
                nearFilter = @"4000";
                page = 1;
                [self getShopList];
                break;
            case 6:
                [self.nearButton setTitle:@"附近5000米        " forState:UIControlStateNormal];
                nearFilter = @"5000";
                page = 1;
                [self getShopList];
                break;
            default:
                break;
        }
    }else{
        shopType = [self.shopTypeIDArray objectAtIndex:buttonIndex];
        page = 1;
        [self getShopList];
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
}

@end
