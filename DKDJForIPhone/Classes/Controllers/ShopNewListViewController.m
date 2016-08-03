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

#import "ShopNewListViewController.h"
#import "ShopDetailViewController.h"
#import "AreaListViewController.h"
#import "SearchOnMapViewController.h"
#import "HJButton.h"
#import "FoodListViewController.h"
#import "ShopNewViewController.h"
#import "HomeCell.h"


@implementation ShopNewListViewController


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
//@synthesize dateTableView;
@synthesize searchKey;



-(id)init
{
    self = [super init];
    if (self) {
        isShowLocationLabel = YES;
         OpenType = 2;
        isFavor = NO;
    }
    return self;
}

- (id)initWithFavor:(NSString *)userID
{
    self = [super init];
    if (self) {
        isShowLocationLabel = NO;
        isFavor = YES;
        self.uduserid = userID;
    }
    return self;
}

- (id)initWithKeywords:(NSString *)key
{
    self = [super init];
    if (self) {
        isShowLocationLabel = NO;
       
        self.searchKey = key;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isShowLocationLabel = YES;
        OpenType = 2;
        isFavor = NO;
    }
    return self;
}

- (id)initWithOpenType:(int)oType  shopType:(NSString *)typeID
{
    self = [super init];
    if (self) {
        isShowLocationLabel = NO;
        OpenType = oType;
        self.getShopTypeID = typeID;
    }
    return self;
}


#pragma mark GetShopList
-(void) GetShopListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    if (!isReadData) {
        isReadData = YES;
        NSString *pageindex = [NSString stringWithFormat:@"%d", shopPage];
        NSMutableDictionary* param;
        NSString *lat;
        NSString *lon;
        if (app.useLocation != nil) {
            lat = [NSString stringWithFormat:@"%f", app.useLocation.lat ];
            lon = [NSString stringWithFormat:@"%f", app.useLocation.lon ];
        }else{
            lat  = @"0.0";
            lon = @"0.0";
        }
        
        if (OpenType != 2) {//传营业状态
            if (self.searchKey != nil && self.searchKey.length > 0) {
                param  = [[NSMutableDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize", pageindex, @"pageindex", [NSString stringWithFormat:@"%d", OpenType], @"isonline", sortFlag, @"sortflag", sortname, @"sortname", self.getShopTypeID, @"shoptype", self.searchKey, @"shopname", lat, @"lat", lon, @"lng", nil];//isbuy 0表示线上商品，1表示线下商品 type
            }else{
                param  = [[NSMutableDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize",  pageindex, @"pageindex", [NSString stringWithFormat:@"%d", OpenType], @"isonline", sortFlag, @"sortflag", sortname, @"sortname", self.getShopTypeID, @"shoptype", lat, @"lat", lon, @"lng", nil];//isbuy 0表示线上商品，1表示线下商品 type
            }
            
        }else{//不传营业状态
            if (isFavor) {
                param  = [[NSMutableDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize",  pageindex, @"pageindex", sortFlag, @"sortflag", sortname, @"sortname", self.getShopTypeID, @"shoptype", @"1", @"iscollected", self.uduserid, @"userid", lat, @"lat", lon, @"lng", nil];//isbuy 0表示线上商品，1表示线下商品 type
            }else{
                if (self.searchKey != nil && self.searchKey.length > 0) {
                    param  = [[NSMutableDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize",  pageindex, @"pageindex", sortFlag, @"sortflag", sortname, @"sortname", self.getShopTypeID, @"shoptype", self.searchKey, @"shopname", lat, @"lat", lon, @"lng", nil];//isbuy 0表示线上商品，1表示线下商品 type
                }else{
                    param  = [[NSMutableDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize",  pageindex, @"pageindex", sortFlag, @"sortflag", sortname, @"sortname", self.getShopTypeID, @"shoptype", lat, @"lat", lon, @"lng", nil];//isbuy 0表示线上商品，1表示线下商品 type
                }
            }
            
            
        }
        if (isPromotion > -1) {
            [param setValue:[NSString stringWithFormat:@"%d", isPromotion] forKey:@"ispromotion"];
            //param se
        }
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
        
        [twitterClient getShopListByLocation:param];
        
        if (shopPage == 1) {
            [processView setHidden:NO];
            [noDataView setHidden:YES];
        }

    }
    
    
    
}

- (void)shopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj{

    twitterClient = nil;
    [processView setHidden:YES];
    
    if (client.hasError) {
        
        
        [client alert];
        [noDataView setHidden:NO];
        processInfo.text = CustomLocalizedString(@"public_net_or_data_failed", @"获取数据失败");
        processInfo1.text = CustomLocalizedString(@"public_net_or_data_error", @"请检查网络后点击重新加载");
        isReadData = NO;
        return;
    }
    
    NSInteger prevCount = (int)[self.shops count];//已经存在列表中的数量
    if (obj == nil){
        [noDataView setHidden:NO];
        processInfo.text = CustomLocalizedString(@"public_net_or_data_failed", @"获取数据失败");
        processInfo1.text = CustomLocalizedString(@"public_net_or_data_error", @"请检查网络后点击重新加载");
        isReadData = NO;
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
        if (isFavor) {
            processInfo.text = CustomLocalizedString(@"fav_no_shop", @"您没有关注任何商家！");
            processInfo1.text = @"";
        }else{
            if (isShowLocationLabel) {
                processInfo.text = CustomLocalizedString(@"shop_list_no_shop",@"对不起！该区域暂未开通服务！");
                processInfo1.text = @"";
                
            }else{
                processInfo.text = CustomLocalizedString(@"search_no_shop", @"未搜索到任何商家！");
                processInfo1.text = @"";
            }
        }
    }
    if ([ary count] == 0) {
        hasMoreShop = false;
        shops = activity;
        activity = nil;
        [dateTableView reloadData];
        isReadData = NO;
        return;
    }
    
    //判断是否有下一页
    
    
    if( shopTotalPage > shopPage ){
        ++shopPage;
        hasMoreShop = true;
    }else{
        hasMoreShop = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = (int)[activity count];
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
    }
    
    [imageDownload1 startTask];
    [imageDownload startTask];
    isRemoveAllCell = NO;
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        shops = activity;
        activity = nil;
        [dateTableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count] ;
        /*if([ary count] % 2 != 0){
            count++;
        }*/
        activity = nil;
        NSMutableArray *newPath = [[NSMutableArray alloc] init];
        
        //刷新表格数据
        [dateTableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            
        }
        
        [dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [dateTableView endUpdates];
    }
    isReadData = NO;
}




- (void)gotoShopCart:(id)senser
{
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice",@"提醒") message:@"购物车为空" delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok",@"确定") otherButtonTitles:nil];
        [alert show];
    }else{
        [app SetTab:2];
        
    }
}

- (void)goToActivityDetail:(id)senser
{
    NSUInteger row1;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        row1 = [dateTableView indexPathForCell:(UITableViewCell *)[[[[senser superview] superview] superview] superview]].row;
    }else{
        row1 = [dateTableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    if (row1 == 0) {
        row1 = [dateTableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    row1 *= 2;
    
}
#pragma mark 显示商家分类
-(void)ShowShopType:(id)senser
{
    
    if (popView) {
        [popView closeDialog];
    }else{
        if (popView1) {
            [popView1 closeDialog];
        }
        if (popView2) {
            [popView2 closeDialog];
        }
        if (btnOrder1.selected) {
            [btnOrder1 setRightImage:[UIImage imageNamed:@"ic_arrow_up.png"]];
            
            
        }else{
            [btnOrder1 setRightImage:[UIImage imageNamed:@"ic_arrow_down.png"]];
            
        }
        btnOrder1.selected = !btnOrder1.selected;
        popView = nil;
        popView = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 95) aryValue:app.shopTypeArry showType:0 popType:0];
        popView.delegate = self;
        
        [popView showDialog];
    }
    //[self.navigationController popViewControllerAnimated:YES];
    /*if (!hasShowMenu) {
        hasShowMenu = YES;
        [popView release];
        popView = nil;
        popView = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 30) aryValue:app.shopTypeArry showType:0 popType:0];
        popView.delegate = self;
        
        [popView showDialog];
    }*/
    
}

#pragma mark 显示排序
-(void)ShowOrderBy:(id)senser
{
    if (popView1) {
        [popView1 closeDialog];
    }else{
        if (popView) {
            [popView closeDialog];
        }
        if (popView2) {
            [popView2 closeDialog];
        }
        popView1 = nil;
        popView1 = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 95) aryValue:orderByArry showType:0 popType:1];
        popView1.delegate = self;
        
        [popView1 showDialog];
    }
    
    
}

#pragma mark 显示是否有活动
-(void)ShowActivis:(id)senser
{
    if (popView2) {
        [popView2 closeDialog];
    }else{
        if (popView1) {
            [popView1 closeDialog];
        }
        if (popView) {
            [popView closeDialog];
        }
        popView2 = nil;
        popView2 = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 95) aryValue:activsArry showType:0 popType:2];
        popView2.delegate = self;
        
        [popView2 showDialog];
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
    isPromotion = -1;
    if (is_iPhone5) {
        viewHeight = 440;
    }else{
        viewHeight = 350;
    }
    [self IsLogin];
    if(getType == nil || getType.length < 1)
    {
        getType = @"2";
        self.title = @"同城";
        
        if (isShowLocationLabel) {
            self.lbTitle = [[HJLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 30.0) leftImage:[UIImage imageNamed:@"icon_my_address.png"]];
            gotoCityClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoCity:)];
            self.lbTitle.textAlignment = NSTextAlignmentCenter;
            self.lbTitle.lineBreakMode =NSLineBreakByTruncatingHead;//
            self.lbTitle.font = [UIFont boldSystemFontOfSize:12];
            [self.lbTitle setUserInteractionEnabled:YES];
            [self.lbTitle addGestureRecognizer:gotoCityClick];
            self.lbTitle.textColor = [UIColor whiteColor];
            [self setTitle:CustomLocalizedString(@"search_gps", @"定位中...")];
            self.navigationItem.titleView = self.lbTitle;
        }else{
            UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
            backBtn.tintColor=[UIColor whiteColor];
            self.navigationItem.leftBarButtonItem = backBtn;
            if (isFavor) {
                self.title = CustomLocalizedString(@"user_center_shop",@"关注店家");
            }else{
                self.title = CustomLocalizedString(@"search_title",@"搜索商家");
            }
        }
        
        
        
    }
    else
    {
        self.title = @"商家列表";
        UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        backBtn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
    if (self.getShopTypeID == nil || self.getShopTypeID.length < 1) {
        self.getShopTypeID = @"0";
    }
    
    if (self.searchKey == nil) {
        self.searchKey = @"";
    }
    
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload1 = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:15 Delegate:self];
    
    dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [dateTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //dateTableView.style = 1;//UITableViewStyleGrouped;
    //下面两行设置行高自适应计算
    dateTableView.rowHeight = UITableViewAutomaticDimension;
    dateTableView.estimatedRowHeight = 65;//// 设置为一个接近“平均”行高的值
    [self.view addSubview:dateTableView];
    NSArray* hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dateTableView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(dateTableView)];
    [self.view addConstraints:hConstraintArray];
    
    
    NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dateTableView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(dateTableView)];
    [self.view addConstraints:vConstraintArray];
    
    
    
    
    if (!isFavor) {
        orderByArry = [[NSMutableArray alloc] init];
        [orderByArry addObject:CustomLocalizedString(@"shop_list_default",@"默认排序")];
        [orderByArry addObject:CustomLocalizedString(@"shop_list_distance",@"距离")];
        [orderByArry addObject:CustomLocalizedString(@"shop_list_show",@"销量")];
        [orderByArry addObject:CustomLocalizedString(@"shop_list_com",@"评价")];
        [orderByArry addObject:CustomLocalizedString(@"shop_list_new",@"入住时间")];
        activsArry  = [[NSMutableArray alloc] init];
        [activsArry addObject:CustomLocalizedString(@"shop_list_all",@"所有商家")];
        [activsArry addObject:CustomLocalizedString(@"shop_list_activity",@"有活动商家")];
        [activsArry addObject:CustomLocalizedString(@"shop_list_n_activity",@"无活动商家")];
        
        heardView =[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 30)];
        dateTableView.tableHeaderView = heardView;
        
        btnOrder1 = [[HJButton alloc] initWithFrame:RectMake_LFL(0, 2.0,375.0/3.0,30) leftImage:nil rightImage:[UIImage imageNamed:@"tagClose"]];
        [btnOrder1 setTitle:CustomLocalizedString(@"public_all_type",@"全部分类") forState:UIControlStateNormal];
        btnOrder1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnOrder1 addTarget:self action:@selector(btnClickOrder:) forControlEvents:UIControlEventTouchDown];
        [btnOrder1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [heardView addSubview:btnOrder1];

        
        btnOrder2 = [[HJButton alloc]initWithFrame:RectMake_LFL(375.0/3.0, 2.0, 375.0/3.0, 30) leftImage:nil rightImage:nil];
        [btnOrder2 setTitle:CustomLocalizedString(@"shop_list_default",@"默认排序") forState:UIControlStateNormal];
        btnOrder2.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnOrder2 addTarget:self action:@selector(btnClickOrder:) forControlEvents:UIControlEventTouchDown];
        [btnOrder2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [heardView addSubview:btnOrder2];

        
        btnOrder3 = [[HJButton alloc]initWithFrame:RectMake_LFL(375.0/3.0*2, 2.0,375.0/3.0, 30) leftImage:nil rightImage:nil];
        [btnOrder3 setTitle:CustomLocalizedString(@"shop_list_all",@"所有商家") forState:UIControlStateNormal];
        btnOrder3.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnOrder3 addTarget:self action:@selector(btnClickOrder:) forControlEvents:UIControlEventTouchDown];
        [btnOrder3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [heardView addSubview:btnOrder3];

    }
    
    
    
    self.shops1 = [NSMutableArray array];
    self.shops2 = [NSMutableArray array];

    
    //下面两行设置行高自适应计算
    dateTableView.rowHeight = UITableViewAutomaticDimension;
    dateTableView.estimatedRowHeight = 80;//// 设置为一个接近“平均”行高的值
    dateTableView.delegate = self;
    dateTableView.dataSource = self;
    dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    /*dateTableView.tableHeaderView = headerView;
     [dateTableView addSubview:headerView];*/
    dateTableView.tag = 1;
    dateTableView.backgroundColor = [UIColor clearColor];
    dateTableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    
    processView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 40.0, self.view.frame.size.width, self.view.frame.size.height - 40)];
    processView.backgroundColor = [UIColor colorWithRed:231/255.0 green:236/255.0 blue:232/255.0 alpha:1.0];
    UIActivityIndicatorView *processIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35, self.view.frame.size.height / 2 - 10, 20, 20)];
    [processIndicator startAnimating];
    [processView addSubview:processIndicator];
    //[processIndicator release];
    
    UILabel *lbProcessInfo = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 15, self.view.frame.size.height / 2 - 10, 50, 20)];
    lbProcessInfo.text = CustomLocalizedString(@"loading",@"加载中");
    lbProcessInfo.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:98/255.0 alpha:1.0];
    lbProcessInfo.font = [UIFont boldSystemFontOfSize:13];
    [processView addSubview:lbProcessInfo];
    
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
    
   // [self initBaiduMap];
    if (isShowLocationLabel) {
        if (app.useLocation.addressDetail.length > 0) {
            [self GetShopListData:YES];
        }

    }
    
}

-(void)GetShopListDataAgain
{
    shopPage = 1;
    [self GetShopListData:YES];
}

-(void)btnClickOrder:(HJButton *)btn
{
    if (btn == btnOrder1) {
        /*[btnOrder2 setRightImage:nil];
        [btnOrder3 setRightImage:nil];
        sortname = @"Distance";
        
        if (btn.selected) {
            [btn setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
            sortFlag = @"1";
            
        }else{
            [btn setRightImage:[UIImage imageNamed:@"arrow_asc.png"]];
            sortFlag = @"0";
        }
        btn.selected = !btn.selected;*/
        
        [self ShowShopType:nil];
    }else if(btn == btnOrder2){
        [self ShowOrderBy:nil];
        
    }else{
        [self ShowActivis:nil];
        
    }
    //shopPage = 1;
   // [self GetShopListData:YES];
}

-(void)setTitle:(NSString *)title
{
    if(isShowLocationLabel){
        UIFont *font = [UIFont fontWithName:@"Arial" size:12];
        CGSize size = CGSizeMake(320,2000);
        title = [NSString stringWithFormat:@"%@>", title];
        CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        if (labelsize.width + 20 > 320) {
            labelsize.width = 290;
        }
        
        [self.lbTitle setFrame:CGRectMake(0,0, labelsize.width + 20, 30)];
        
        [self.lbTitle setText:title];
    }else{
        [super setTitle:title];
    }
}



-(void)GotoCity:(id)sel
{
    /*AreaListViewController *viewController = [[[AreaListViewController alloc] initWithModelShow] autorelease];
    
    //LoginController.title =@"会员登录";
    
    //注意：此处这样实现可以显示有顶部navigationbar的试图
    UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:viewController] autorelease];
    //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
    [self presentViewController:navController animated:YES completion:nil];
    isChangeCity = YES;*/
    
    SearchOnMapViewController *viewController = [[SearchOnMapViewController alloc] init];
    
    //LoginController.title =@"会员登录";
    
    //注意：此处这样实现可以显示有顶部navigationbar的试图
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
    [self presentViewController:navController animated:YES completion:nil];
    
    
}

-(void)goBack
{
    
    if (self.searchKey) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil]; 
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    //[self locationUpdate:nil];
    if (!isShowLocationLabel) {
        [self GetShopListData:YES];
    }
    else if (app.useLocation.addressDetail.length > 0) {
        if (_progressHUD)
        {
            [_progressHUD removeFromSuperview];
            _progressHUD = nil;
        }
        [self setTitle:app.useLocation.addressDetail];
    }else{
        
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"search_gps_notice", @"定位中...，请稍后！");
        [_progressHUD show:YES];
        [self setTitle:CustomLocalizedString(@"search_gps", @"定位中...")];
    }
    
    
    
    
        
    
}

-(void)locationUpdate:(id)sender
{
    
    if (app.useLocation.addressDetail.length > 0) {
        if (_progressHUD)
        {
            [_progressHUD removeFromSuperview];
            _progressHUD = nil;
        }
        [self setTitle:app.useLocation.addressDetail];
        shopPage = 1;
        
        [self GetShopListData:YES];
    }
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
        }else{
            ShopTypeModel *model1;
            if (task.index >= 0 && task.index < [app.shopTypeArry count]) {
                model1 = (ShopTypeModel *)[app.shopTypeArry objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }
    }
}

-(void)updataUI:(int)type{
   
    [dateTableView reloadData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (twitterClient) {
        [twitterClient cancel];
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

    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =CustomLocalizedString(@"login", @"会员登录");
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];

        [self presentViewController:navController animated:YES completion:nil];

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
    [dateTableView reloadData];
}
#pragma mark HJPopViewDelete 选择商家类别后
- (BOOL) HJPopViewBaseClose:(int)type index:(int)index popType:(int)pType
{
    hasShowMenu = NO;
    if (pType == 0) {
        if (type >= 0) {
            
            
            if (index == 0) {
                self.getShopTypeID = @"0";
                [btnOrder1 setTitle:CustomLocalizedString(@"public_all_type", @"全部分类") forState:UIControlStateNormal];
            }else{
                ShopTypeModel *model = [app.shopTypeArry objectAtIndex:index];
                self.getShopTypeID = [NSString stringWithFormat:@"%d", model.typeID];
                [btnOrder1 setTitle:model.typeName forState:UIControlStateNormal];
            }
            shopPage = 1;
            [self GetShopListData:YES];
        }
        if (btnOrder1.selected) {
            [btnOrder1 setRightImage:[UIImage imageNamed:@"ic_arrow_up.png"]];
            
            
        }else{
            [btnOrder1 setRightImage:[UIImage imageNamed:@"ic_arrow_down.png"]];
            
        }
        btnOrder1.selected = !btnOrder1.selected;
        popView = nil;
    }else if(pType == 1){//排序
        if (type >= 0) {
            [btnOrder2 setTitle:[orderByArry objectAtIndex:index] forState:UIControlStateNormal];
            
            if (index == 0 || userOrderByIndex != index) {
                
                sortFlag = @"1";
                if (index == 0) {
                    userOrderByIndex = index;
                    sortname = @"SortNum";
                    [btnOrder2 setRightImage:nil];
                    /*if (userOrderByIndex == index) {
                        [popView1 release];
                        popView1 = nil;
                        return YES;
                    }*/
                }else{
                    userOrderByIndex = index;
                    if(index == 1){
                        sortname = @"Distance";
                    }else if(index == 2){
                        sortname = @"pop";
                    }else if(index == 3){
                        sortname = @"grade";
                    }else if(index == 4){
                        sortname = @"InTime";
                    }
                    btnOrder2.selected = YES;
                    [btnOrder2 setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
                }
                
                
                
            }else{
                btnOrder2.selected = !btnOrder2.selected;
                if (btnOrder2.selected) {
                    [btnOrder2 setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
                    sortFlag = @"1";
                    
                }else{
                    [btnOrder2 setRightImage:[UIImage imageNamed:@"arrow_asc.png"]];
                    sortFlag = @"0";
                }
            }
            
            shopPage = 1;
            [self GetShopListData:YES];
        }
        popView1 = nil;
    }else{//是否参加活动
        if (type >= 0) {
            [btnOrder3 setTitle:[activsArry objectAtIndex:index] forState:UIControlStateNormal];
            if (isPromotion == index - 1) {
                popView2 = nil;
                return YES;
            }
            isPromotion = index - 1;
            shopPage = 1;
            [self GetShopListData:YES];
        }
        popView2 = nil;
    }
        
    return YES;
}
#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [shops count];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ((HomeCell *)cell).FShop4ListModel=shops[indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[HomeCell HomeCellWithTableView:tableView];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

        return CGRectGetMaxY( RectMake_LFL(0, 0, 375, 100));

}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = dateTableView.contentOffset;  // 当前滚动位移
    CGRect bounds = dateTableView.bounds;          // UIScrollView 可+视高度
    CGSize size = dateTableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = dateTableView.contentInset;
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
    
    if (indexPath.row < [shops count]) {
        [app setShopMode:(FShop4ListModel *)[shops objectAtIndex:indexPath.row]];
        ShopNewViewController *controller = [[ShopNewViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
        [self presentViewController:navController animated:YES completion:^{
            
        }];
        
        
    }
    
}

#pragma mark searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithKeywords:searchBar.text];
     
     [self.navigationController pushViewController:controller animated:true];
    
    
    
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
                    [btn setTitle:CustomLocalizedString(@"public_cancel", @"取消")  forState:UIControlStateNormal];
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