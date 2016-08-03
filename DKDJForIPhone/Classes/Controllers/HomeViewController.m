//
//  MainViewController.m
//  EasyEat4iPhone
//
//  Created by zheng jianfeng on 11-12-29.
//  Copyright 2011 ihangjing. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginNewViewController.h"
#import "ShopListViewController.h"
#import "MapSearchViewController.h"
#import "ShopTypeViewController.h"
#import "ShopDetailViewController.h"
#import "MJRefresh.h"
#import "SettingViewController.h"
#import "GpsAddressViewController.h"
#import "SearchShopViewController.h"
#import "CityListViewController.h"
#import "GiftListViewController.h"
#import "SectionListViewController.h"
#import "tooles.h"
#import "GrouplistViewController.h"
#import "SeckillListViewController.h"
#import "TopFoodListViewController.h"
#import "AreaListViewController.h"
#import "RegeditViewController.h"
#import "CityListViewController.h"
#import "ShakeViewController.h"
#import "FoodTypeModel.h"
#import "PopAdvModel.h"
#import "PopAdvViewController.h"
#import "NewsViewController.h"
#import "AGJFoodListViewController.h"
#import "ActivityListViewController.h"
#import "CouponListViewController.h"
#import "KTVListViewController.h"
#import "LimitListViewController.h"
#import "SearchShopListViewController.h"
#import "HJPopViewBase.h"
#import "FoodDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "ShopNewListViewController.h"
#import "FoodListViewController.h"
#import "ShopNewTopListViewController.h"
#import "ShopNewViewController.h"
#import "SearchShopViewController.h"
#import "AFNetworking.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+WebCache.h"
#define NAVBAR_CHANGE_POINT 60

@implementation HomeViewController{
    SDCycleScrollView *cycleScrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    
    return self;
}

- (BOOL)AreLogin{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    
    NSLog(@"islogin userid:%@", self.uduserid);
    
    if([self.uduserid intValue]  > 0 ) {
        return YES;
    }
    else{
        return NO;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //导航栏透明度设置
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    //导航栏透明度设置
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}
-(void)SearchOnMapViewController:(SearchOnMapViewController *)vc withLocation:(NSString *)locat{
    app.useLocation.addressDetail=locat;
    [self locationUpdate:nil];
}
#pragma mark GPS信息更新
-(void)locationUpdate:(id)sender{
    
    if (app.useLocation.addressDetail.length > 0) {
        if (_progressHUD)
        {
            [_progressHUD removeFromSuperview];
            _progressHUD = nil;
        }
        //zyp  地理位置结果
        [self setTitle:app.useLocation.addressDetail];
        
        shopPage = 1;
        [self GetNearShopListData:YES];
    }
    
}
-(void)getAppUserLoaction{
    
    if (app.useLocation.addressDetail.length > 0) {
        if (_progressHUD){
            [_progressHUD removeFromSuperview];
            _progressHUD = nil;
        }
        [self setTitle:app.useLocation.addressDetail];
    }else{
        
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"search_gps_notice", @"定位中...，请稍后！");
        [_progressHUD show:YES];
        [self setTitle:CustomLocalizedString(@"search_gps", @"定位中...")];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (app.useLocation.addressDetail.length <1){
            if (_progressHUD){
                [_progressHUD removeFromSuperview];
                _progressHUD = nil;
            }
            [self setTitle:@"未定位"];
            [self GetNearShopListData:YES];
        }
        
    });
    
}
-(void)SearchBtnClicked{
    UIViewController* viewController1 = [[SearchShopViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:viewController1];
    [self presentViewController:navi animated:YES completion:nil];
}
- (void) advDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    NSDictionary* dic = (NSDictionary*)obj;
    
    [self getAdvModelFromDic:dic type:1];
    
}
-(void)getAdvModelFromDic:(NSDictionary *)dic type:(int)cacheType{
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodtypelist"];
    if ([ary count] == 0) {
        return;
    }
    AdvModel *model1;
    
    NSMutableArray *imagePathArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dict = (NSDictionary*)[ary objectAtIndex:i];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        model1 = [[AdvModel alloc] initWithDic:dict];
        [imagePathArr addObject:model1.imageNetPath];
        cycleScrollView.imageURLStringsGroup = imagePathArr;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置当有导航栏自动添加64的高度的属性为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem * barBtnItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStylePlain target:self action:@selector(SearchBtnClicked)];
    barBtnItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=barBtnItem;
    
    sortname = @"SortNum";
    sortFlag = @"1";
    isPromotion = -1;
    self.getShopTypeID = @"0";
    self.lbTitle = [[HJLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 30.0) leftImage:[UIImage imageNamed:@"icon_my_address.png"]];
    gotoCityClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GotoMapView:)];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    self.lbTitle.lineBreakMode = NSLineBreakByTruncatingHead;
    self.lbTitle.font = [UIFont boldSystemFontOfSize:12];
    [self.lbTitle setUserInteractionEnabled:YES];
    [self.lbTitle addGestureRecognizer:gotoCityClick];
    self.lbTitle.textColor = [UIColor whiteColor];
    [self setTitle:CustomLocalizedString(@"search_gps", @"定位中...")];
    
    
    self.navigationItem.titleView = self.lbTitle;
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    self.tableView=tbView;
    tbView.dataSource = self;
    tbView.delegate = self;
    //下拉刷新
    tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        foods=nil;
        shopPage=1;
        [self GetNearShopListData:YES];
    }];
    //上拉刷新
    tbView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (hasMoreShop ) {
//            shopPage++;
            [self GetNearShopListData:NO];
        }else{
            [tbView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
//    tbView.mj_h = 30;
    //zyp-mark 主页tableView
    //下面两行设置行高自适应计算
    
    tbView.rowHeight = UITableViewAutomaticDimension;
    tbView.estimatedRowHeight = 90;//// 设置为一个接近“平均”行高的值
    tbView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [tbView setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:tbView];
    
    
    UIView *backView = [[UIView alloc] init];//WithFrame:CGRectMake(0.0, 0.0, 375, 430)];
    backView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    
    backView.userInteractionEnabled = YES;
    
    tbView.tableHeaderView = backView;
    
    
    self.navigationItem.title = app.appName;
    app.shopListType = 2;
    
    int height1 = 0;
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(advDidReceive:obj:)];
    [twitterClient getAdvList];
    
    //广告滚动条
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:RectMake_LFL(0, 0, 375, 200) delegate:self placeholderImage:nil];
    cycleScrollView.autoScrollTimeInterval=4;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.backgroundColor=[UIColor whiteColor];
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [backView addSubview:cycleScrollView];

    
    height1 += 200;
    shopTypeView = [[HJScrollView alloc] initWithFrame:RectMake_LFL(0, height1, 375, 132)];
    shopTypeView.backgroundColor = [UIColor whiteColor];
    shopTypeView.pagingEnabled = YES;
    shopTypeView.bounces=NO;
    shopTypeView.showsHorizontalScrollIndicator = NO;
    shopTypeView.showsVerticalScrollIndicator = NO;
    [backView addSubview:shopTypeView];
    
    
    height1 += 132;
    
    height1 += 5.0 ;

    
    
    UILabel* label=[[UILabel alloc]init];
    
    label.text=@"附近商家";
    label.font=[UIFont systemFontOfSize:13];
    label.frame=RectMake_LFL(6, height1, 100, 12.0);
    
    [backView addSubview:label];
    
    UIView * blockColorView=[[UIView alloc]init];
    blockColorView.backgroundColor=[UIColor colorWithRed:99.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    blockColorView.frame=RectMake_LFL(0, height1, 4, 12.0);
    [backView addSubview:blockColorView];
    height1+=17;
    backView.frame=RectMake_LFL(0, 0, 375, height1);

    imageDownload2 = [[CachedDownloadManager alloc] initWitchReadDic:15 Delegate:self];
    select = 1;
    shops1 = [[NSMutableArray alloc] init];
    shops2 = [[NSMutableArray alloc] init];
    
    app.shopTypeArry = [[NSMutableArray alloc] init];
    [self GetGuidShopTypeListData];
    shopPage = 1;
    if (app.useLocation.addressDetail.length > 0) {
//        shopPage++;
        [self GetNearShopListData:YES];
    }
    
    
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
    
    
    btnOrder1 = [[HJButton alloc] initWithFrame:CGRectMake(0, 2.0, 107, 20) leftImage:nil rightImage:[UIImage imageNamed:@"ic_arrow_up.png"]];//[[[HJButton alloc] initWithFrame:CGRectMake(0.0, 2.0, 107, 20) leftImage:[UIImage imageNamed:@"icon_around.png"] rightImage:nil];
    [btnOrder1 setTitle:CustomLocalizedString(@"public_all_type",@"全部分类") forState:UIControlStateNormal];
    btnOrder1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btnOrder1 addTarget:self action:@selector(btnClickOrder:) forControlEvents:UIControlEventTouchDown];
    [btnOrder1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];


    
    btnOrder2 = [[HJButton alloc] initWithFrame:CGRectMake(109.0, 2.0, 107, 20) leftImage:nil rightImage:nil];
    [btnOrder2 setTitle:CustomLocalizedString(@"shop_list_default",@"默认排序") forState:UIControlStateNormal];
    btnOrder2.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btnOrder2 addTarget:self action:@selector(btnClickOrder:) forControlEvents:UIControlEventTouchDown];
    [btnOrder2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    
    btnOrder3 = [[HJButton alloc] initWithFrame:CGRectMake(218.0, 2.0, 107, 20) leftImage:nil rightImage:nil];
    [btnOrder3 setTitle:CustomLocalizedString(@"shop_list_all",@"所有商家") forState:UIControlStateNormal];
    btnOrder3.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btnOrder3 addTarget:self action:@selector(btnClickOrder:) forControlEvents:UIControlEventTouchDown];
    [btnOrder3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];


    
    [self getAppUserLoaction];
}


-(void)setTitle:(NSString *)title
{

    title = [NSString stringWithFormat:@"%@>", title];
    //    CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary * attr = @{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12]};
    CGSize labelsize=[ title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:NSLineBreakByWordWrapping].size;
    
    if (labelsize.width + 20 > 320) {
        labelsize.width = 290;
    }
    [self.lbTitle setFrame:CGRectMake(0,0, labelsize.width + 20, 30)];
    [self.lbTitle setText:title];
    
}
#pragma mark 去地图界面
-(void)GotoMapView:(id)sender{
    SearchOnMapViewController *viewController = [[SearchOnMapViewController alloc] init];
    viewController.isOrderAddress=YES;
    viewController.delegate=self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

#pragma mark 广告点击代理
-(void)clickViewGetModel:(NSObject *)model Type:(int)type{
    if(model == nil)
        return;
    AdvModel *adv = (AdvModel *)model;
    if (adv.advType == 2) {//点评
        FShop4ListModel *shop = [[FShop4ListModel alloc] init];
        shop.shopid = adv.dataID;
        shop.shopname = @"";
        [app setShopMode:shop];
        ShopNewViewController *controller = [[ShopNewViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
        
        [self presentViewController:navController animated:YES completion:^{
        }];

    }else if (adv.advType == 3) {//菜单
        FShop4ListModel *shop = [[FShop4ListModel alloc] init];
        shop.shopid = adv.dataID;
        shop.shopname = @"";
        [app setShopMode:shop];

        ShopNewViewController *controller = [[ShopNewViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];

        [self presentViewController:navController animated:YES completion:^{
            
        }];
    }

}
#pragma mark 分类，帅选 要滚动
-(void)btnClickOrder1:(HJButton *)btn{
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tbView scrollToRowAtIndexPath:scrollIndexPath
                  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (btn == btnOrder4) {

        
        [self ShowShopType:nil];
    }else if(btn == btnOrder5){
        [self ShowOrderBy:nil];
        
        //[btnOrder1 setRightImage:nil];
        //[btnOrder3 setRightImage:nil];
        
    }else{
        [self ShowActivis:nil];
        
    }
    //shopPage = 1;
    // [self GetShopListData:YES];
}
#pragma mark 分类，帅选
-(void)btnClickOrder:(HJButton *)btn
{
    if (btn == btnOrder1) {
        [self ShowShopType:nil];
    }else if(btn == btnOrder2){
     
    }else{
        [self ShowActivis:nil];
        
    }

}
#pragma mark 点击分类
-(void)ShopTypebtnClick:(UIButton *)btn
{
    NSInteger index = btn.tag;
    //index--;
    ShopTypeModel *model1 = (ShopTypeModel *)[app.shopTypeArry objectAtIndex:index];
    ShopNewListViewController *controller = [[ShopNewListViewController alloc] initWithOpenType:2 shopType:[NSString stringWithFormat:@"%d", model1.typeID]];
    UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:nil];
    
}

#pragma mark 获取商家分类
-(void) GetGuidShopTypeListData
{
    NSString *url = APP_PATH  @"GetShopTypeList.aspx";
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"1", @"pid",@"1", @"indexpage", @"100", @"pagesize",nil];
    twitterClient1 = [[TwitterClient alloc] initWithTarget:self action:@selector(guidShopTypeDidReceive:obj:)];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [self guidShopTypeDidReceive:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}

- (void)guidShopTypeDidReceive:(NSDictionary *)dic{
 

    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];

    ShopTypeModel *model = [[ShopTypeModel alloc] init];
    model.typeName = CustomLocalizedString(@"public_all_type", @"全部分类");
    model.typeID = 0;
    [app.shopTypeArry addObject:model];
    shopTypeViewList = [[NSMutableArray alloc] init];
    CGRect frame = shopTypeView.frame;
    UIImageView *img;
    UILabel *lb;
    int x = 5;
    int with = 365/4;
    CGFloat imgWith = 40;
    CGFloat height= imgWith + 10 + 12;
    BOOL isAdd = NO;
    UIView *view = [[UIView alloc] initWithFrame:RectMake_LFL(0.0, 0.0, 375*2,2*height)];

    for (int i = 0, j = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        //zyp滚动的商店分类按钮  
        UIView *subView = [[UIView alloc] init];//WithFrame:RectMake_LFL(x+with*(i%4), y*(i/4), with, imgWith + 10 + 12)];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=RectMake_LFL((with - imgWith) / 2, 5, imgWith, imgWith);
        [btn addTarget:self action:@selector(ShopTypebtnClick:) forControlEvents:UIControlEventTouchDown];
        btn.tag = i + 1;
        img = [[UIImageView alloc] initWithFrame:RectMake_LFL((with - imgWith) / 2, 5, imgWith, imgWith)];
        
        model = [[ShopTypeModel alloc] initWithChildJsonDictionary:dic];
        [img sd_setImageWithURL:[NSURL URLWithString:model.ico] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        [app.shopTypeArry addObject:model];
        
        
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(0,imgWith +x*2, with, 12)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont boldSystemFontOfSize:12.0];
        lb.text = model.typeName;
        //        lb.text =[NSString stringWithFormat:@"%lu%@",(long)btn.tag,model.typeName];
        [subView addSubview:btn];
        [subView addSubview:img];
        [subView addSubview:lb];
        [view addSubview:subView];
        
        if (i<8) {
            subView.frame=RectMake_LFL(x+with*(i%4), height*(i/4), with, height);
        }else{
            subView.frame=RectMake_LFL(375+x+with*(j%4), height*(j/4), with, height);
            j++;
        }
    }
    if (!isAdd) {
        [shopTypeView addSubview:view];
        frame = view.frame;
        shopTypeView.contentSize = SizeMake_LFL(375, frame.size.height);
    }

}
#pragma mark 获取商家列表
-(void) GetNearShopListData:(BOOL)isShowProcess{
    
    if (!isReadData) {
        isReadData = YES;
        NSString *pageindex = [NSString stringWithFormat:@"%d", shopPage];
        NSMutableDictionary* param;
        NSString *lat;
        NSString *lon;
        if (app.useLocation.addressDetail.length>0) {
            lat = [NSString stringWithFormat:@"%f", app.useLocation.lat ];
            lon = [NSString stringWithFormat:@"%f", app.useLocation.lon ];
        }else{
            lat  = @"38.894431";
            lon  = @"115.504949";
        }
        param  = [[NSMutableDictionary alloc] initWithObjectsAndKeys:app.language, @"languageType", @"20", @"pagesize",  pageindex, @"pageindex", sortFlag, @"sortflag", sortname, @"sortname", self.getShopTypeID, @"shoptype", lat, @"lat", lon, @"lng", nil];
        NSLog(@"%@",param);
        if (isPromotion > -1) {
            [param setValue:[NSString stringWithFormat:@"%d", isPromotion] forKey:@"ispromotion"];
        }
        NSString *url = APP_PATH  @"GetShopListByLocation.aspx";
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self shopsDidReceive:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败：%@",error);
        }];
    }
    
}

- (void)shopsDidReceive:(NSDictionary *)dic{
    
    [tbView.mj_header endRefreshing];
    [tbView.mj_footer endRefreshing];
    NSInteger prevCount = [shops count];//已经存在列表中的数量
    shopTotalPage = [[dic objectForKey:@"total"] intValue];
    
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];
    NSMutableArray *activity;
    if (shopPage == 1) {
        prevCount = 0;
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([shops2 count] != 0) {
                [shops2 removeAllObjects];
            }
            
            activity = shops2;
            select = 2;
        }else{
            if ([shops1 count] != 0) {
                [shops1 removeAllObjects];
            }
            
            activity = shops1;
            select = 1;
        }
    }else{
        activity = shops;
    }
    
    if ([ary count] == 0) {
        hasMoreShop = false;
        shops = activity;
        activity = nil;
        [tbView reloadData];
        isReadData = NO;
        return;
    }
    
    //判断是否有下一页
    
    if (shopPage == 1) {
        //[shops removeAllObjects];
    }
    if( shopTotalPage > shopPage )
    {
        ++shopPage;
        hasMoreShop = true;
    }
    else
    {
        hasMoreShop = false;
    }

    int index = (int)[shops count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FShop4ListModel *model = [[FShop4ListModel alloc] initWithJsonDictionary:dic imageDow:imageDownload2 Group:index];

        [activity addObject:model];
    }

    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        shops = activity;
        activity = nil;
        [tbView reloadData];
    }
    else {
        
        NSInteger count = [ary count] ;
    
        NSMutableArray *newPath = [[NSMutableArray alloc] init];
        
        //刷新表格数据
        [tbView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            
        }
        
        [tbView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [tbView endUpdates];
    }
    isReadData = NO;
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
            [btnOrder1 setRightImage:[UIImage imageNamed:@"tagOpen"]];
        }else{
            [btnOrder1 setRightImage:[UIImage imageNamed:@"tagClose"]];
            
        }
        btnOrder1.selected = !btnOrder1.selected;
        popView = nil;
        popView = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 94) aryValue:app.shopTypeArry showType:0 popType:0];
        popView.delegate = self;
        
        [popView showDialog];
    }

    
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
        popView1 = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 94) aryValue:orderByArry showType:0 popType:1];
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
        popView2 = [[HJListViewPop alloc] initWithView:self.view  childViewPosition:CGPointMake(0, 94) aryValue:activsArry showType:0 popType:2];
        popView2.delegate = self;
        
        [popView2 showDialog];
    }
    
    
}
#pragma mark HJPopViewDelete 选择商家类别后
- (BOOL) HJPopViewBaseClose:(int)type index:(int)index popType:(int)pType
{
    if (pType == 0) {
        if (type >= 0) {
            
            
            if (index == 0) {
                self.getShopTypeID = @"0";
                [btnOrder1 setTitle:CustomLocalizedString(@"public_all_type", @"全部分类") forState:UIControlStateNormal];
                [btnOrder4 setTitle:CustomLocalizedString(@"public_all_type", @"全部分类") forState:UIControlStateNormal];
            }else{
                ShopTypeModel *model = [app.shopTypeArry objectAtIndex:index];
                self.getShopTypeID = [NSString stringWithFormat:@"%d", model.typeID];
                [btnOrder1 setTitle:model.typeName forState:UIControlStateNormal];
                [btnOrder4 setTitle:model.typeName forState:UIControlStateNormal];
            }
            shopPage = 1;
            [self GetNearShopListData:YES];
        }
        if (btnOrder1.selected) {
            [btnOrder1 setRightImage:[UIImage imageNamed:@"ic_arrow_up.png"]];
            [btnOrder4 setRightImage:[UIImage imageNamed:@"ic_arrow_up.png"]];
            
            
        }else{
            [btnOrder1 setRightImage:[UIImage imageNamed:@"ic_arrow_down.png"]];
            [btnOrder4 setRightImage:[UIImage imageNamed:@"ic_arrow_down.png"]];
            
        }
        btnOrder1.selected = !btnOrder1.selected;
        btnOrder4.selected = !btnOrder1.selected;

        popView = nil;
    }else if(pType == 1){//排序
        if (type >= 0) {
            [btnOrder2 setTitle:[orderByArry objectAtIndex:index] forState:UIControlStateNormal];
            [btnOrder5 setTitle:[orderByArry objectAtIndex:index] forState:UIControlStateNormal];
            
            if (index == 0 || userOrderByIndex != index) {
                
                sortFlag = @"1";
                if (index == 0) {
                    userOrderByIndex = index;
                    sortname = @"SortNum";
                    [btnOrder2 setRightImage:nil];
                    [btnOrder5 setRightImage:nil];
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
                    btnOrder5.selected = YES;
                    [btnOrder2 setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
                    [btnOrder5 setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
                }
                
            }else{
                btnOrder2.selected = !btnOrder2.selected;
                btnOrder5.selected = !btnOrder2.selected;
                if (btnOrder2.selected) {
                    [btnOrder2 setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
                    [btnOrder5 setRightImage:[UIImage imageNamed:@"arrow_desc.png"]];
                    sortFlag = @"1";
                    
                }else{
                    [btnOrder2 setRightImage:[UIImage imageNamed:@"arrow_asc.png"]];
                    [btnOrder5 setRightImage:[UIImage imageNamed:@"arrow_asc.png"]];
                    sortFlag = @"0";
                }
            }
            shopPage = 1;
            [self GetNearShopListData:YES];
        }
        popView1 = nil;
    }else{//是否参加活动
        if (type >= 0) {
            [btnOrder3 setTitle:[activsArry objectAtIndex:index] forState:UIControlStateNormal];
            [btnOrder6 setTitle:[activsArry objectAtIndex:index] forState:UIControlStateNormal];
            if (isPromotion == index - 1) {
                popView2 = nil;
                return YES;
            }
            isPromotion = index - 1;
            shopPage = 1;
            [self GetNearShopListData:YES];
        }
        popView2 = nil;
    }
    
    return YES;
}

#pragma mark 下载图片完成一批任务

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    
    ImageDowloadTask *task;
    
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        if(type == 1){
            FShop4ListModel *model1;
            if (task.index >= 0 && task.index < [shops count]) {
                model1 = (FShop4ListModel *)[shops objectAtIndex:task.index];
                
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }else if (type == 12) {
            if (task.locURL.length == 0) {
                task.locURL = @"mindex.png";
            }
            if (task.index < [app.shopTypeArry count]) {
                ShopTypeModel *model1 = (ShopTypeModel *)[app.shopTypeArry objectAtIndex:task.index];
                model1.picPath = task.locURL;
                [model1 setImg:model1.picPath Default:@"暂无图片"];
                //[model1 setImgView:model1.picPath Default:@"暂无图片"];
            }
        }
    }
}

-(void)updataUI:(int)type{
    if (type == 12) {//食品
        for (int i = 0; i < [app.shopTypeArry count]; i++) {
            ShopTypeModel *model1 = (ShopTypeModel *)[app.shopTypeArry objectAtIndex:i];
            model1.imageView.image = model1.image;
        }
        
    }else if(type == 1){
        [tbView reloadData];
    }else if(type == 15){
        [tbView reloadData];
    }
}



#pragma mark MyLabel Delegate Methods
// myLabel是你的MyLabel委托的实例
- (void)myLabel:(MyAddressLabel *)myLabel touchesWtihTag:(NSInteger)tag {
    
    //delegate datasoure view
    
    GpsAddressViewController* controller = [[GpsAddressViewController alloc] initWithNibName:@"GpsAddressView" bundle:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
    //[self.navigationController pushViewController:shoplistviewController animated:YES];
}


- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    if (userLocation != nil) {
        NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        
        //保存当前定位坐标
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:userLocation.location.coordinate.latitude forKey:@"ulat"];
        [defaults setFloat:userLocation.location.coordinate.longitude forKey:@"ulng"];
        
        //测试 lat=30.189053&lng=120.163655
        //[defaults setFloat:30.189053 forKey:@"ulat"];
        //[defaults setFloat:120.163655 forKey:@"ulng"];
        
        [defaults synchronize];
        
        //得到坐标后进行地址查询
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        
        if (userLocation.location.coordinate.latitude > 0 && userLocation.location.coordinate.longitude > 0) {
            
            //纬度latitude 经度longitude
            //coors[0].latitude = 39.315;
            //coors[0].longitude = 116.304;
            pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude };
            
            //测试
            //pt = (CLLocationCoordinate2D){30.189053, 120.163655};
        }
        
        
    }
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (error != nil)
    {
        NSLog(@"locate failed: %@", [error localizedDescription]);
    }
    else {
        NSLog(@"locate failed");
    }
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
//    NSLog(@"start locate");
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    
}

- (BOOL)IsLogin
{
    //NSLog(@"setting userid:%@", uduserid);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController * LoginController = [[LoginNewViewController alloc ]init];
        
        LoginController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        
        [self presentViewController:navController animated:YES completion:^{
        }];
        //[self.navigationController pushViewController:LoginNewViewController animated:YES];

        
        return NO;
    }
}


/*
 -(IBAction)showNewShop:(id)sender
 {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"饭易得" message:@"最新商家视图" delegate:self cancelButtonTitle:@"取消." otherButtonTitles:@"确定.",nil];
	alert.tag = 0;//当有多个alert时使用这个作为标记
	[alert show];
	[alert release];
 }
 
 -(IBAction)showHotShop:(id)sender
 {
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"点一份演示系统" message:@"热门商家视图" delegate:nil cancelButtonTitle:@"取消." otherButtonTitles:@"确定.",nil];
	//[alert show];
	//[alert release];
 FoodListViewController *foodlistView = [[[FoodListViewController alloc] initWithShopid:@"106" ] autorelease];
 
 [self.navigationController pushViewController:foodlistView animated:YES];
 
	//[foodlistView setUser:_username];
	//[foodlistView release];
 }
 */
/*
 -(IBAction)doSearch:(id)sender
 {
	NSLog(@"Cancle Button clicked");
 
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"点一份演示系统" message:@"搜索商家" delegate:nil cancelButtonTitle:@"取消." otherButtonTitles:@"确定.",nil];
	[alert show];
	[alert release];
 }
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
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
    
    self.cell =[HomeCell HomeCellWithTableView:tableView];
    self.cell.delegate=self;
    self.cell.indexPath=indexPath;
    return self.cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGRectGetMaxY( RectMake_LFL(0, 0, 375, 100));
}


//cell中活动按钮传来的代理
-(void)HomeCell:(HomeCell *)cell withBtnOpenState:(BOOL)isOpen{
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    CGPoint offset = tbView.contentOffset;  // 当前滚动位移
//    //    NSLog(@"lddfdsfsdf %f",offset.y);
//    
//    CGRect bounds = tbView.bounds;          // UIScrollView 可+视高度
//    CGSize size = tbView.contentSize;         // 滚动区域
//    UIEdgeInsets inset = tbView.contentInset;
//    //    CGPoint fram = self.view.center;
////    float hd = tbView.tableHeaderView.frame.origin.y + tbView.tableHeaderView.frame.size.height - 85;//bounds.origin.y;//减去分类栏的高度
//    float y = offset.y;// + bounds.size.height - inset.bottom;
//    float b = y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    float reload_distance = 10;
//    if (b > (h + reload_distance)) {
//        // 滚动到底部
//        if(twitterClient == nil && hasMoreShop){
//            //读取更多数据
////            page++;
//            [tbView.mj_footer beginRefreshing];
//        }
//    }
//     y += bounds.origin.y;
    
    
    UIColor * color = [UIColor colorWithRed:0/255.0 green:216/255.0 blue:226/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < [shops count]) {
        [app setShopMode:(FShop4ListModel *)[shops objectAtIndex:indexPath.row]];
        ShopNewViewController *controller = [[ShopNewViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navController animated:YES completion:^{
            
        }];
        
    }
    
}

#pragma mark -UIViewDelegate-
//对视图中的弹出窗按钮事件进行处理 按钮的index值从0开始记数，依次累积1
//在类中使用UIAlertDelegate protocol后直接加入该方法即可实现按钮事件
-(void)alertView:(UIAlertView *)alertView clickButtonAtIndex:(NSInteger) buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancle Button clicked");
            break;
        case 1:
            NSLog(@"OK Button clicked");
            break;
        default:
            break;
    }
}




#pragma searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    ShopListViewController *controller = [[ShopListViewController alloc] initWithKeywords:searchBar.text];
    
    [self.navigationController pushViewController:controller animated:true];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)handleSearchForTerm:(NSString *)searchterm{
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
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

    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;  
    
}

@end
