//
//  EasyEat4iPhoneAppDelegate.h
//  EasyEat4iPhone
//
//  Created by zheng jianfeng on 11-12-29.
//  Copyright ihangjing 2011. All rights reserved.
//
//${PRODUCT_NAME}
#import <UIKit/UIKit.h>
#import "ImageStore.h"
#import "BMapKit.h"
#import "FShop4ListModel.h"
#import "UserAddressMode.h"
#import "AreaMode.h"
#import "MyShopCart.h"
#import "HJTabBarController.h"
#import "ShopDetailModel.h"
#import "MyLocationModel.h"
#import "WXApi.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import <ShareSDK/ShareSDK.h>
//#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCedy37bnjfmCyUmx4UX+I/I8GOS8m57QEvKdG6RyyXH91xCe+hoS9U1Hb5kwRRvjeuXuc45u6/Rm6DUex5fTzcR7x9kAExOqeE+QWd8wRjhU2AvCelCvlxP9phRVN0fo3RPLxitA4opTW66UWD1Q0tuQp09/XqysKuz5Xl89BHzwIDAQAB"
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
#define AliPartner @"2088421279495661"
#define AliSeller @"dakedaojia@126.com"
//注意，下面的是pkcs8 key
#define AliPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMhPaTDenPqCgHX30X3krf5ltMDivslscEAX36ocanbVjw9BIEPXqLW4ub4MI8lRRRoFQ+n7rSyjKbiK0rH42JN2XrEgXWdke3M3aMqkm72e+KJOLimJSLcd5GBw5lm1AZU9g2KUdUtYJrAwWut9ILftrjzuSxBOd4Z681ODtNJfAgMBAAECgYEAg3B4WfT5lPglS0N+V9nCwngCj7856foZ/jSsM3fJ9IhWA3B8t4e/0N6SIz7cDLIjYduqoNLg47V9HvcZImdj1NV0R7GvTgFmNoCWtGDPnD7tLTlHmTyaEDVNEaazkhDfDUmXHmPTPWM3rrfrsKdWU151fWMUjBPid+CX3ddmMAECQQD0zhsBisMYMa+3snvJJL7Sx7HcLUZ1mHN32ZV51mgJnXVDvBVxwdQwvlopoRld7tvm7lTogz4n9WK4o6jj0gYBAkEA0XhpINpPnohXbK3rqRRKE0K/4Onkykf2ycCN13sLbmD4CiKAGVVUlqZOdN1YMA8+spHtQf0qCXd5M31rDTSYXwJAVafkFScLWmTQOfNOkrOzvSa4WfTRiYX9KPtN7OKTZoHcrQWbb0FF0IRaIeTHbnGMKgJMXUrGrc6Ta02AY65yAQJAay6PrG3Im7fr9AIyOXvWQ3C+Odm0ZgTYtHdAnOeq+7nGcXkhztSoycUjFA1GWKEUVc7xdfiSj/GAJOah5knpRQJBAOcQs86ivkcNhA1UaF+aKCN9w9hgN8k6zjpD/+dRX/RU5qq/6lZz2X+uN8SOfqfwt5aUrDolBivcgM43RyJDJ7U="
typedef enum {
    TAB_SHOPLIST,
    TAB_ORDERLIST,
    TAB_SEARCHSHOP,
    TAB_MAPSEARCH,
    TAB_MORE,
} TAB_ITEM;

@interface EasyEat4iPhoneAppDelegate : NSObject <UIApplicationDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, WXApiDelegate> {
    IBOutlet UIWindow *window;
	//根视图控制器
	HJTabBarController *tabBarController;
	enum WXScene wx_scene;
    int selectedTab;
    
    ImageStore* imageStore;
    
    BMKMapManager* _mapManager;
    
    
    NSString *shopType;//商店类型
    BOOL isDine;//是否现场点菜
    
    
    float SendMoney;//配送费
    float startMoney;//起送金额
    float fullFree;//满多少送
    UIColor *sysTitleColor;//系统标题栏颜色
    UserAddressMode *reciverAddress;//用户收获地址
    int pushViewType;//编辑地址的时候选择区域使用 0 没有选择城市 1选择了城市
    NSString *newID;//编辑地址的时候记忆
    NSString *orderId;
    
    int shopListType;//0：gps附近外卖 1:商圈 2：未进过商家列表
    NSString *buildID;//当前建筑物编号
    //UIImageView *splashView;

    UIImageView *splashScreen;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    
    
}


@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic ,strong) MyLocationModel *myLocation;//zyp我的地址信息
@property (nonatomic ,strong) MyLocationModel *searchLocation;//搜索的地址信息
@property (nonatomic ,strong) MyLocationModel *useLocation;//要使用的地址信息
@property (nonatomic, strong) IBOutlet HJTabBarController *tabBarController;
@property (nonatomic, readonly) ImageStore* imageStore;

@property (nonatomic, assign) int selectedTab;
@property (nonatomic, strong) NSString *shopType;//商店类型
@property(nonatomic, strong)UINavigationController *viewController;
@property(nonatomic, assign)BOOL isDine;
@property(nonatomic, strong) FShop4ListModel* mShopModel;

@property (nonatomic, assign)float SendMoney;
@property (nonatomic, assign)float startMoney;//起送金额
@property (nonatomic, assign)float fullFree;//满多少送
@property (nonatomic, strong) UIColor *sysTitleColor;//系统标题栏颜色
@property (atomic, strong) UserAddressMode *reciverAddress;//用户收获地址
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic,assign) int shopListType;//0：gps附近外卖 1:商圈 2：未进过商家列表 3 收藏
@property (nonatomic, strong)NSString *buildID;//当前建筑物编号
@property (nonatomic, strong)AreaMode *Area;
@property (nonatomic, strong)NSMutableArray *arryFoodType;//食品分类
@property (nonatomic, strong)MyShopCart *shopCart;//购物车
@property (nonatomic, assign)int foodID;//从首页跳转到列表页面所传商品编号，可能是广告里面的foodid也可能是热门商品的food id
@property (nonatomic,assign)int commentSucess;//0未评论，1评论成功
@property (nonatomic,assign) int geverCoupon;//转赠优惠券 0失败，1成功；
@property (nonatomic,assign) int couponPage;//提交订单时，使用优惠券当前读取的券的页数
@property (nonatomic,assign) int couponTotal;//提交订单时，使用优惠券时，券的总页数
@property (nonatomic,assign) BOOL payOK;//在线支付是否成功
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString * newsOrderID;
@property (nonatomic, strong) NSString *language;//语言
@property (nonatomic, strong) NSMutableArray *shopTypeArry;//商家分类
@property (nonatomic, assign) int bomttomTabH;//下部tabbar的高度
+ (EasyEat4iPhoneAppDelegate*)getAppDelegate;
-(void)setAppLanguage:(NSString *)value reStart:(BOOL)restart;
- (void)WXsendPay:(NSString *)odid payid:(NSString *)pid price:(float)moeny;
-(void)SetTab:(int)index;

- (void)alert:(NSString*)title message:(NSString*)detail;

- (void)setupPortraitUserInterface;

- (void)initializeUserDefaults;

- (BOOL)checkMobilePhone:(NSString *)phone;//判断是否为手机号码

- (BOOL)isSingleTask;
//- (void)parseURL:(NSURL *)url application:(UIApplication *)application;

-(void)setShopMode:(FShop4ListModel *)model;
-(void)setShopDetailMode:(ShopDetailModel *)model;

@end

/*
 在Build Phases中添加一个Phase，右下角的Add Build Phase，然后单击Add Run Script，输入以下脚本
 export CODESIGN_ALLOCATE=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/codesign_allocate
 if [ "${PLATFORM_NAME}" == "iphoneos" ]; then
 /Developer/iphoneentitlements401/gen_entitlements.py "my.company.${PROJECT_NAME}" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PROJECT_NAME}.xcent";
 codesign -f -s "iPhone Developer" --entitlements "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/${PROJECT_NAME}.xcent" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}/"
 fi
*/