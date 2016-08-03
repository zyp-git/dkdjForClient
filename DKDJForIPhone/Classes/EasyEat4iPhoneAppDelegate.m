//
//  EasyEat4iPhoneAppDelegate.m
//  EasyEat4iPhone
//
//  Created by zheng jianfeng on 11-12-29.
//  Copyright ihangjing 2011. All rights reserved.
//

#import "EasyEat4iPhoneAppDelegate.h"

#import "NavigationRotateController.h"

#import "HomeViewController.h"
#import "ShopNewListViewController.h"
#import "SearchShopViewController.h"
#import "MapSearchViewController.h"

#import "SettingViewController.h"
#import "ShopDetailViewController.h"

#import "ShopCartViewController.h"
#import "GrouplistViewController.h"

#import "FileController.h"
#import "OrderListNewViewController.h"
#import "GiftListViewController.h"
#import "FoodListViewController.h"
#import "PopAdvModel.h"
#import "PopAdvViewController.h"
#import <sys/utsname.h>
#import "HJNavigationController.h"
#import "GuidShopListViewController.h"
#import "ShopNewTopListViewController.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"
@implementation EasyEat4iPhoneAppDelegate

@synthesize window;
@synthesize myLocation;//我的地址信息
@synthesize searchLocation;//搜索的地址信息
@synthesize useLocation;//要使用的地址信息
@synthesize tabBarController;
@synthesize imageStore;
@synthesize selectedTab;
@synthesize shopCart;
@synthesize shopType;
@synthesize viewController;
@synthesize isDine;
@synthesize mShopModel;
@synthesize SendMoney;
@synthesize startMoney;
@synthesize fullFree;
@synthesize sysTitleColor;//系统标题栏颜色
@synthesize reciverAddress;
@synthesize orderId;
@synthesize buildID;
@synthesize shopListType;
@synthesize Area;
@synthesize arryFoodType;//食品分类
@synthesize foodID;//从首页跳转到列表页面所传商品编号，可能是广告里面的foodid也可能是热门商品的food id
@synthesize commentSucess;//0未评论，1评论成功
@synthesize geverCoupon;//转赠优惠券 0失败，1成功；
@synthesize couponPage;//提交订单时，使用优惠券当前读取的券的页数
@synthesize couponTotal;//提交订单时，使用优惠券时，券的总页数
@synthesize payOK;//在线支付是否成功
@synthesize appName;
@synthesize newsOrderID;
@synthesize language;//语言
@synthesize shopTypeArry;//商家分类
@synthesize bomttomTabH;//下部tabbar的高度


- (id)init
{
    if(self = [super init])
    {
        wx_scene = WXSceneSession;
    }
    return self;
}
- (BOOL)checkMobilePhone:(NSString *)phone
{

    
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|4[0-9]|5[017-9]|8[0-9]|7[0-9])\\d|705)\\d{7}$";
    
    /**
     
     15         * 中国联通：China Unicom
     
     16         * 130,131,132,152,155,156,185,186,1709
     
     17         */
    
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    
    
    if (([regextestcm evaluateWithObject:phone] == YES)
        
        || ([regextestct evaluateWithObject:phone] == YES)
        
        || ([regextestcu evaluateWithObject:phone] == YES)
        
        || ([regextestphs evaluateWithObject:phone] == YES))
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:APP_ID withDescription:@"demo 2.0"];
    
    self.sysTitleColor = [UIColor colorWithRed:0/255.0 green:216/255.0 blue:226/255.0 alpha:1.0];
    self.reciverAddress = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value = [defaults objectForKey:AppLanguage];
    if (value == nil || value.length == 0) {
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage compare:@"zh-Hans-US"] == NSOrderedSame) {
            self.language = @"1";
            [defaults setValue:@"zh-Hans" forKey:AppLanguage];
        }else if([currentLanguage compare:@"zh-Hans-CN"] == NSOrderedSame){
            self.language = @"1";
            [defaults setValue:@"zh-Hans" forKey:AppLanguage];
        }else{
            self.language = @"2";
            [defaults setValue:@"ug-Arab-CN" forKey:AppLanguage];
        }
        [defaults synchronize];
    }else{
        [self setAppLanguage:value reStart:NO];
    }
    
    
    self.shopType = @"1";
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"ZxfkNFub13feMuCS1reVjtAAZHTOGf5t" generalDelegate:nil];
    if (!ret) {
        NSLog(@"BMKMapManager start failed!");
        [self alert:@"百度定位启动失败" message:@"百度定位启动失败"];
    }
    
    self.appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    NSDictionary *appDefaults = [[NSDictionary alloc] initWithContentsOfFile:
                                 [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    

    
    
    //加载主页面的方法
    [self setupPortraitUserInterface];
    
    [self.window makeKeyAndVisible];
    self.window.rootViewController = tabBarController;//这里必须的，否则sharesdk会有些问题
    
    //在显示窗口子视图加入ViewController视图
    //[window addSubview:tabBarController.view];
    
    imageStore = [[ImageStore alloc] init];
    
    //[[LocationManager locationManager] startUpdates];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    
    [self initLocation];
    
    CGRect frame = tabBarController.tabBar.frame;
    bomttomTabH = frame.size.height;
    
    [self getCurrentAppStoreVersion];
    
    //3D touch
    // 创建标签的ICON图标。
    //图标应该是正方形、唯一颜色和35x35像素点
//    UIApplicationShortcutIcon *icon =[UIApplicationShortcutIcon iconWithTemplateImageName:@"btn0Icon"];
    // 创建一个标签，并配置相关属性。
    UIApplicationShortcutItem *item =[[UIApplicationShortcutItem alloc]initWithType:@"favoriteShop" localizedTitle:@"我的收藏" localizedSubtitle:nil icon:nil userInfo:nil];
    
//    UIApplicationShortcutIcon *icon2 =[UIApplicationShortcutIcon iconWithTemplateImageName:@"btn0Icon"];
    UIApplicationShortcutItem *item2 =[[UIApplicationShortcutItem alloc]initWithType:@"order" localizedTitle:@"我的订单" localizedSubtitle:nil icon:nil userInfo:nil];
    // 将标签添加进Application的shortcutItems中。
    [[UIApplication sharedApplication] setShortcutItems:@[item,item2]];
    
    
    return YES;
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    UIViewController * viewControl =(UIViewController *)self.window.rootViewController;
    if ([shortcutItem.type isEqualToString:@"favoriteShop"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * uduserid = [defaults objectForKey:@"userid"];
        
        UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:[[ShopNewListViewController alloc] initWithFavor:uduserid]];
        [viewControl presentViewController:navi animated:YES completion:nil];
    }
    if ([shortcutItem.type isEqualToString:@"order"]) {
        [self SetTab:1];
    }
}
#pragma mark-获取当前app版本
- (NSString *)getCurrentLocalVersion
{//CFBundleVersion
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"检查当前版本%@",appVersion);
    return appVersion;
}
#pragma mark-获取appstore最新app版本
- (void )getCurrentAppStoreVersion
{
    
    [MHNetworkManager postReqeustWithURL:@"http://itunes.apple.com/lookup" params:@{@"id":@"1131141247"} successBlock:^(NSDictionary *returnData) {
        NSArray *configData = [returnData valueForKey:@"results"];
        for (id config in configData)
        {
            //Check your version with the version in app store
            if (![[config valueForKey:@"version"] isEqualToString:[self getCurrentLocalVersion]])
            {
                
                UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"发现新版本，请及时更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/da-ke-dao-jia1.0/id1131141247?mt=8"];
                    [[UIApplication sharedApplication]openURL:url];
                }];
                UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [ac addAction:aa1];
                [ac addAction:aa2];
                
                [tabBarController presentViewController:ac animated:YES completion:nil];
            }
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

    
}

-(void)initLocation
{
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    self.useLocation = [[MyLocationModel alloc] init];
}
#pragma mark 百度地图定位
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    if (self.myLocation == nil) {
        self.myLocation = [[MyLocationModel alloc] initWithUserLocation:userLocation];
    }else{
        [self.myLocation setUserLocation:userLocation];
    }
    if (self.useLocation == nil) {
        self.useLocation = [[MyLocationModel alloc] initCopy:self.myLocation];
    }
    [self startGeoCode];
}

#pragma mark 百度地图搜索
//接收正向编码结果

-(void)startGeoCode
{
    CLLocationCoordinate2D pt= (CLLocationCoordinate2D){self.myLocation.lat, self.myLocation.lon};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }
    else{
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        if (self.myLocation == nil) {
            self.myLocation = [[MyLocationModel alloc] initWithSearch:result];
        }else{
            [self.myLocation setSearch:result];
        }
        if (self.useLocation == nil) {
            self.useLocation = [[MyLocationModel alloc] initCopy:self.myLocation];
        }else if(self.useLocation.addressDetail == nil || self.useLocation.addressDetail.length == 0){
            [self.useLocation setSearch:result];
        }
        NSNotification* notification = [NSNotification notificationWithName:@"MyLocationUpdate" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark 微信支付

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = CustomLocalizedString(@"pay_mode_3", @"微信支付");
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = CustomLocalizedString(@"pay_mode_3", @"微信支付");
        NSNotification* notification;
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = CustomLocalizedString(@"pay_sucess", @"支付成功！");
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                notification = [NSNotification notificationWithName:APP_WX_PAY_COMBACK object:[NSString stringWithFormat:@"%d", resp.errCode]];
                break;
            case WXErrCodeUserCancel:
                strMsg = CustomLocalizedString(@"pay_cancel", @"取消支付！");
                notification = [NSNotification notificationWithName:APP_WX_PAY_COMBACK object:[NSString stringWithFormat:@"%d", resp.errCode]];
                break;
            default:
                strMsg = CustomLocalizedString(@"pay_error", @"微信支付异常！请稍后再试！");
                notification = [NSNotification notificationWithName:APP_WX_PAY_COMBACK object:[NSString stringWithFormat:@"%d", resp.errCode]];
                break;
        }
        [self.shopCart Clean];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

- (void)WXsendPay:(NSString *)odid payid:(NSString *)pid price:(float)moeny
{

    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    NSMutableDictionary *dict = [req sendPay:self.appName odid:pid payid:odid moeny:moeny];
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }
    }else{
        [self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
    }
    
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
    
    [alter show];
}
/*- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
 return  [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
 //return [WXApi handleOpenURL:url delegate:self];
 }*/
#pragma mark 支付宝回调
/*
 - (void)parseURL:(NSURL *)url application:(UIApplication *)application {
 
 AlixPayResult *result = [self handleOpenURL:url];
 if (result) {
 //是否支付成功
 if (9000 == result.statusCode) {
 
 //用公钥验证签名
 
 //id<DataVerifier> verifier = CreateRSADataVerifier([[NSBundle mainBundle] objectForInfoDictionaryKey:AlipayPubKey]);
 //if ([verifier verifyString:result.resultString withSign:result.signString]) {
 UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
 message:result.statusMessage
 delegate:nil
 cancelButtonTitle:@"确定"
 otherButtonTitles:nil];
 alertView.tag = 1;
 [alertView show];
 [alertView release];
 if ([result.statusMessage compare:@"支付结束"] == NSOrderedSame) {
 self.payOK = YES;
 }else{
 self.payOK = NO;
 }
 }
 //如果支付失败,可以通过result.statusCode查询错误码
 else {
 UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
 message:result.statusMessage
 delegate:nil
 cancelButtonTitle:@"确定"
 otherButtonTitles:nil];
 alertView.tag = 1;
 [alertView show];
 [alertView release];
 }
 
 }
 }
 
 - (AlixPayResult *)resultFromURL:(NSURL *)url {
 NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 #if ! __has_feature(objc_arc)
 return [[[AlixPayResult alloc] initWithString:query] autorelease];
 #else
 return [[AlixPayResult alloc] initWithString:query];
 #endif
 }
 
 - (AlixPayResult *)handleOpenURL:(NSURL *)url {
 AlixPayResult * result = nil;
 
 if (url != nil && [[url host] compare:@"safepay"] == 0) {
 result = [self resultFromURL:url];
 }
 
 return result;
 }*/
//禁止横屏
- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UITabBarItem *) createTabBarItem:(NSString *)strTitle normalImage:(NSString *)strNormalImg selectedImage:(NSString *)strSelectedImg itemTag:(NSInteger)intTag
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:strTitle image:nil tag:intTag];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]
                        forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:53/255.0 green:0.0 blue:0.0 alpha:1.0], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item setTitlePositionAdjustment:UIOffsetMake(item.titlePositionAdjustment.horizontal,item.titlePositionAdjustment.vertical-5.0)];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [item initWithTitle:@"test" image:[UIImage imageNamed:strNormalImg] selectedImage:[UIImage imageNamed:strSelectedImg]];
    }else{
        [item setImage:[[UIImage imageNamed:strNormalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:strSelectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return item;
}

#pragma mark 语言切换
-(void)setAppLanguage:(NSString *)value reStart:(BOOL)restart
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([value compare:@"zh-Hans"] == NSOrderedSame) {
        //简体中文
        
        [def setValue:@"zh-Hans" forKey:AppLanguage];
        //def.setValue(["zh-Hans"], forKey:"AppleLanguages");
        //def.synchronize();
        self.language = @"1";
    }else{
        [def setValue:@"ug-Arab-CN" forKey:AppLanguage];
        self.language = @"2";
    }
    [def synchronize];
    if (restart) {
        //self.window.rootViewController = [[[SettingViewController alloc] init] autorelease];
        [self setupPortraitUserInterface];
        self.window.rootViewController = tabBarController;
        //tabBarController set
        //[tabBarController release];
        //[localViewControllersArray release];
        //[self setupPortraitUserInterface];
        //self.window.rootViewController = tabBarController;//这里必须的，否则sharesdk会有些问题
    }
}

- (HJNavigationController *)createNavControllerWrappingViewControllerOfClass:(Class)cntrloller nibName:(NSString*)nibName tabSelectIconName:(NSString*)uiconName tabUnSelectIconName:(NSString*)siconName tabTitle:(NSString*)tabTitle
{
    UIViewController* viewController1 = [[cntrloller alloc] initWithNibName:nibName bundle:nil];
    //
    UIImage * normalImage = [[UIImage imageNamed:uiconName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage = [[UIImage imageNamed:siconName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [viewController1.tabBarItem initWithTitle:tabTitle image:normalImage selectedImage:selectImage];
    /*[viewController1.tabBarItem setTitleTextAttributes:@{
     NSForegroundColorAttributeName :[UIColor clearColor]
     } forState:UIControlStateNormal];//去除可能有显示文字*/
    
    [viewController1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor  colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                        nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:0/255.0 green:216/255.0 blue:226/255.0 alpha:1.0];
    [viewController1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        titleHighlightedColor, NSForegroundColorAttributeName,
                                                        nil] forState:UIControlStateHighlighted];

    [viewController1.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    
    
    HJNavigationController *theNavigationController;
    theNavigationController = [[HJNavigationController alloc] initWithRootViewController:viewController1];
    
    return theNavigationController;
}

//zyp-mark-tabBar
- (void)setupPortraitUserInterface
{
    HJNavigationController *localNavigationController;
    
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[HomeViewController class] nibName:nil tabSelectIconName:@"home_icon_gray" tabUnSelectIconName:@"home_icon" tabTitle:CustomLocalizedString(@"nav_2", @"首页")];
    [localViewControllersArray addObject:localNavigationController];
    
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[OrderListNewViewController class] nibName:nil tabSelectIconName:@"订单" tabUnSelectIconName:@"订单_选择" tabTitle:@"订单"];
    [localViewControllersArray addObject:localNavigationController];
    
    localNavigationController = [self createNavControllerWrappingViewControllerOfClass:[SettingViewController class] nibName:nil tabSelectIconName:@"me_icon" tabUnSelectIconName:@"me_icon_select" tabTitle:CustomLocalizedString(@"nav_3", @"我的")];
    [localViewControllersArray addObject:localNavigationController];
    
    tabBarController = [[HJTabBarController alloc] init];
    tabBarController.viewControllers = localViewControllersArray;
    UIView *bgView = [[UIView alloc] initWithFrame:tabBarController.tabBar.bounds];//下面修改背景色
    bgView.backgroundColor = [UIColor whiteColor];
    [tabBarController.tabBar insertSubview:bgView atIndex:0];
    tabBarController.tabBar.opaque = YES;

}
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [BMKMapView willBackGround];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [BMKMapView didForeGround];
}

-(void)SetTab:(int)index{
    tabBarController.selectedIndex = index;
}



-(void)setShopMode:(FShop4ListModel *)model
{

    mShopModel = model;
    mShopModel.mBUpdate = NO;

}
-(void)setShopDetailMode:(ShopDetailModel *)model
{
    if (self.mShopModel == nil) {
        self.mShopModel = [[FShop4ListModel alloc] init];
    }
    self.mShopModel.mBUpdate = NO;
    self.mShopModel.shopid = model.shopid;
    self.mShopModel.shopname = model.shopname;
    self.mShopModel.Sendmoney = model.sendmoney;
    self.mShopModel.startMoney = model.startMoney;
    self.mShopModel.startSendFee = model.fullFreeMoney;
    self.mShopModel.status = model.status;
    self.mShopModel.Lat = model.lat;
    self.mShopModel.Lng = model.lng;
    
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [imageStore didReceiveMemoryWarning];
}

//
// Common utilities
//

static UIAlertView *sAlert = nil;

- (void)alert:(NSString*)title message:(NSString*)message
{
    if (sAlert) return;
    
    sAlert = [[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:self
                              cancelButtonTitle:@"关闭"
                              otherButtonTitles:nil];
    [sAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde
{
    sAlert = nil;
}

+(EasyEat4iPhoneAppDelegate*)getAppDelegate
{
    return (EasyEat4iPhoneAppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)applicationWillTerminate:(UIApplication *)application {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:[FileController fullpathOfFilename:kOrderListFile] error:&error];
}
#pragma mark 微信支付打开

//被废弃的方法. 但是在低版本中会用到.建议写上
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSNotification* notification = [NSNotification notificationWithName:APP_URL_COMBACK object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return [WXApi handleOpenURL:url delegate:self];
}
//被废弃的方法. 但是在低版本中会用到.建议写上

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSNotification* notification = [NSNotification notificationWithName:APP_URL_COMBACK object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return [WXApi handleOpenURL:url delegate:self];
}

//新的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSNotification* notification = [NSNotification notificationWithName:APP_URL_COMBACK object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return [WXApi handleOpenURL:url delegate:self];
}

@end
