#import <UIKit/UIKit.h>
#import "TFConnection.h"

//#define DOMAIN @"dianyifen.com:88"
//#define HOST @"dkdj." DOMAIN http://122.114.94.150:
#define DOMAIN @""
#define HOST @"122.114.94.150:" DOMAIN
#define APP_PATH @"http://" HOST @"/App/Android/"
#define APP_API_PATH @"http://" HOST @"/Api/"
#define WEIXIN_PAY @"http://weixin." DOMAIN @"/weixinpay/payNotifyUrl.aspx"

#define APP_URL_COMBACK @"HangJingAPPComBackURL"
#define APP_URL_COMBACK_CANCEL @"HangJingAPPComBackURLC"
#define APP_URL_COMBACK_FAILD  @"HangJingAPPComBackURLF"
#define APP_WX_PAY_COMBACK     @"HangJingWXComBackURL"
typedef enum {
    TWITTER_REQUEST_TIMELINE,
    TWITTER_REQUEST_REPLIES,
    TWITTER_REQUEST_MESSAGES,
    TWITTER_REQUEST_SENT,
    TWITTER_REQUEST_FAVORITE,
    TWITTER_REQUEST_DESTROY_FAVORITE,
    TWITTER_REQUEST_CREATE_FRIENDSHIP,
    TWITTER_REQUEST_DESTROY_FRIENDSHIP,
    TWITTER_REQUEST_FRIENDSHIP_EXISTS,
} RequestType;

@interface TwitterClient : TFConnection
{
    RequestType request;
    id          context;
    SEL         action;
    BOOL        hasError;
    NSString*   errorMessage;
    NSString*   errorDetail;
}

@property(nonatomic, readonly) RequestType request;
@property(nonatomic, assign) id context;
@property(nonatomic, assign) BOOL hasError;
@property(nonatomic, copy) NSString* errorMessage;
@property(nonatomic, copy) NSString* errorDetail;



- (id)initWithTarget:(id)delegate action:(SEL)action;
//获取首页广告
-(void) getAdvList;
//获取商家首页广告
-(void) getShopAdvList:(NSDictionary*)params;
// get shoplist by keywords
- (void) getAllShopListByKeywors:(NSString*)keywords;
//点赞等
-(void) praiseShop:(NSDictionary*)params;
//获取充值编号
- (void) getRechID:(NSDictionary*)params;
// get shoplist by location, get all shoplist for test
- (void) getShopListByLocation:(NSDictionary*)params;
//获取订单状态
- (void) getOrderStateList:(NSDictionary*)params;
//获取导航 字母
- (void) getGuidABCList:(NSDictionary*)params;
// 菜品收藏
-(void) favorFood:(NSDictionary*)params;
//获取商家分类，传参数
- (void) getShopTypeWithParams:(NSDictionary*)params;
//获取限时购商品
- (void) getLimitListByLocation:(NSDictionary*)params;
//获取收藏商家
- (void) getFavorShopListByLocation:(NSDictionary*)params;
//获取收藏商品
- (void) getFavorFoodListByLocation:(NSDictionary*)params;
//搜索
- (void) getShopListBySearch:(NSDictionary*)params;

-(void) getShopType;

- (void) getGiftList:(NSDictionary*)params;
//获取取货站点
- (void) getSelfStateList;
//获取用户在商家优惠券
- (void) getUserInShopCardList:(NSDictionary*)params;
//获取支付编号
- (void) getPayID:(NSDictionary*)params;
//获取商家支付方式
- (void) getPayMode:(NSDictionary*)params;
- (void) getUserAddressList:(NSDictionary*)params;

- (void) getCityList:(NSDictionary*)params;

- (void) getAreaList:(NSDictionary*)params;

//获取商圈列表
- (void) getByAreaList:(NSDictionary*)params;

- (void) saveUserAddressList:(NSDictionary*)params;

// get shopdetail by shopid
-(void) getShopDetailByShopId:(NSDictionary*)params;

-(void) getGiftDetailByGiftId:(NSDictionary*)params;

// get orderlist by userid
-(void) getOrderList:(NSDictionary*)params;
// 获取预约列表
-(void) getAppointmentOrderList:(NSDictionary*)params;
-(void) getCartOrderList:(NSDictionary*)params;
-(void) getLotterOrderList:(NSDictionary*)params;
// 确认收货操作
-(void) setOrderState:(NSDictionary*)params;
// get orderlist by userid
-(void) getOrderByOrderId:(NSString*)orderId;
-(void) getCartOrderByOrderId:(NSString*)orderId;
-(void) getLotterOrderByOrderId:(NSString*)orderId;

// get all foodlist
-(void)getFoodListByShopId:(NSDictionary*)params;

// 获取活动商品列表
-(void)getActivityFoodListByShopId:(NSDictionary*)params;
//获取商家电影列表
-(void)getMovieListByShopId:(NSDictionary*)params;
// 获取活动列表
-(void)getActivityListByShopId:(NSDictionary*)params;
//获取商家KTV列表
-(void)getKTVListByShopId:(NSDictionary*)params;
// 获取我的优惠券列表
-(void)getMyCouponList:(NSDictionary*)params;
// 获取优惠券列表
-(void)getCouponListByShopId:(NSDictionary*)params;
//获取好友
-(void)getFriendsListByUserId:(NSDictionary*)params;
//发送消息
-(void)sendMyMessageListByUserId:(NSDictionary*)params;
//获消息列表
-(void)getMyMessageListByUserId:(NSDictionary*)params;
//获取券列表
-(void)getCouponListByUserId:(NSDictionary*)params;
//绑定优惠券
-(void)bindCouponListByUserId:(NSDictionary*)params;
//获取积分列表
-(void)getPointListByUserId:(NSDictionary*)params;
//搜索好友
-(void)findFriendsListByUserId:(NSDictionary*)params;
//通讯录匹配好友
-(void)checkFriendsListByUserId:(NSDictionary*)params;
//获取所有好友的购买记录
-(void)getFrinedsBuyListByUserId:(NSDictionary*)params;
//获取积分排行榜
-(void)getPointTopListByUserId:(NSDictionary*)params;
//加好友
-(void)addFriendsByUserId:(NSDictionary*)params;
//删好友
-(void)delFriendsByUserId:(NSDictionary*)params;
//赠优惠券给好友
-(void)geverCouponFriendsByUserId:(NSDictionary*)params;
//加载食品评论
-(void)getFoodCommentListByFoodId:(NSDictionary*)params;
//根据食品编号获取食品详情
-(void)getFoodDetailByShopId:(NSDictionary*)params;
//对菜品评论
-(void)updataCommentFood:(NSDictionary*)params;
// 商家收藏
-(void) favorShop:(NSDictionary*)params;
//获取摇一摇的提示信息
-(void)getShakeInitData;

//获摇一摇
-(void)getShakeData:(NSDictionary*)params;
//获弹出广告
-(void)getPopAdv;
//获取排行榜
-(void)getTopFoodListByShopId;

// get all foottypelist
-(void)getFoodTypeListByShopId:(NSString*)shopid;

// get foodlist by typeid
-(void)getFoodListByTypeId:(NSString*)type;
//获取弹出广告
-(void)getPopAdvListByShopId:(NSString*)shopid;
-(void)getHotAreaList;

-(void)getHotAreaSubList:(NSDictionary*)params;

//-(void)doLoginByUserNameAndPassword:(NSString*)UserName Password:(NSString*)Password;
//使用上面的形式会报错  可能是Password会出现问题
-(void)doLoginByUserNameAndPassword:(NSString*)un pw:(NSString*)pw;

//发送验证码
-(void)sendSMSCode:(NSString*)phone;
//验证手机是否注册，注册发送验证码
-(void)checkPhone:(NSString*)phone;
-(void)doRegedit:(NSString*)un pw:(NSString*)pw email:(NSString*)email phone:(NSString*)phone cityid:(NSString*)cityid rname:(NSString*)rname;

-(void)getUserInfoByUserId:(NSString*)userId;
//上传图片
- (void)Upload:(UIImage *)image type:(NSString *)type dataID:(NSString *)dataid imageExtName:(NSString *)extName;

//抽奖
-(void)getPrizeRecord:(NSString*)userId pID:(NSString *)pid;

-(void)SaveUserInfo:(NSDictionary*)params;

-(void)ResetPassword:(NSDictionary*)params isPay:(BOOL)ispay;
//礼品兑换
-(void)SubmitGiftCart:(NSDictionary*)order;
//提交中奖订单
-(void)SubmitLotter:(NSDictionary*)params;

-(void)ResetPayPassword:(NSDictionary*)params;
//参加活动
-(void)JoinActivity:(NSDictionary*)params;
//购买或兑换优惠券
-(void)buyCoupon:(NSDictionary*)params;
-(void)getAddressListByUserId:(NSString*)userId;

-(void)getShopListByLocationForMap:(NSDictionary*)params;

-(void)SubmitOrder:(NSString*)order orderType:(int)type;

-(void)getMyCardListByUserId:(NSDictionary*)params;

-(void)getGroupListByBid:(NSDictionary*)params;

-(void)getGroupDetailById:(NSString*)Id;

-(void)getSeckillListByBid:(NSDictionary*)params;

-(void)getSeckillDetailById:(NSString*)Id;

-(void)setNewPasswordWithPhone:(NSString *)phoneNum pw:(NSString *)password;

//- (void)getTimeline:(TweetType)type params:(NSDictionary*)params;
//- (void)getUserTimeline:(NSString*)screen_name params:(NSDictionary*)params;
//- (void)getUser:(NSString*)screen_name;
//- (void)getMessage:(sqlite_int64)statusId;
//- (void)post:(NSString*)tweet inReplyTo:(sqlite_int64)statusId;
//- (void)send:(NSString*)text to:(NSString*)screen_name;
//- (void)getFriends:(NSString*)screen_name page:(int)page isFollowers:(BOOL)isFollowers;
//- (void)destroy:(Tweet*)tweet;
//- (void)favorites:(NSString*)screenName page:(int)page;
//- (void)toggleFavorite:(Status*)status;
//- (void)friendship:(NSString*)screen_name create:(BOOL)create;
//- (void)search:(NSString*)query;
//- (void)existFriendship:(NSString*)screen_name;
//- (void)updateLocation:(float)latitude longitude:(float)longitude;
//- (void)trends;
//- (void)verify;

- (void)alert;

-(void) getShopCardListByUserId:(NSDictionary*)params;

@end
