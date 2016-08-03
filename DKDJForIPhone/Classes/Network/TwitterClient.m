//
//  TwitterClient.m
//  TwitterFon
//
//  Created by kaz on 7/13/08.
//  Copyright naan studio 2008. All rights reserved.
//

#import "EasyEat4iPhoneAppDelegate.h"
#import "TwitterClient.h"
#import "StringUtil.h"
#import "JSON.h"

@implementation TwitterClient

@synthesize request;
@synthesize context;
@synthesize hasError;
@synthesize errorMessage;
@synthesize errorDetail;


- (id)initWithTarget:(id)aDelegate action:(SEL)anAction
{
    [super initWithDelegate:aDelegate];
    action = anAction;
    hasError = false;
    return self;
}

/*-(oneway void)release
{
    if(self.retainCount != 0)
    {
        [super release];
    }
}
*/
- (void)dealloc
{
    [errorMessage release];
    [errorDetail release];
    [super dealloc];
}

// get shoplist by keywords
- (void) getAllShopListByKeywors:(NSString*)keywords
{
	
}

-(void) getAdvList{
    needAuth = false;
    NSString *url = APP_PATH  @"specialad.aspx";
    [super get:url];
}

-(void) getShopAdvList:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"shoppics.aspx";
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    [super get:url];
}

-(void) praiseShop:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"shopPraise.aspx";
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    [super get:url];
}
//获取充值编号
- (void) getRechID:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"recharege.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

- (void) getShopListByLocation:(NSDictionary*)params
{

    needAuth = false;
    NSString *url = APP_PATH  @"GetShopListByLocation.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    [super get:url];
}
//获取订单状态
- (void) getOrderStateList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_API_PATH  @"/OrderStep";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取导航 字母
- (void) getGuidABCList:(NSDictionary*)params{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetShopByLetter.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

// 菜品收藏
-(void) favorFood:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"SaveFavorFood.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
    
}
//获取商家分类，传参数
- (void) getShopTypeWithParams:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetShopTypeList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

//获取限时购商品
- (void) getLimitListByLocation:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetLimitList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取收藏商家
- (void) getFavorShopListByLocation:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetCollectionListByUserId.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

//获取收藏商品
- (void) getFavorFoodListByLocation:(NSDictionary*)params{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetFoodCollect.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//搜索
- (void) getShopListBySearch:(NSDictionary*)params{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetShopandFoodListByKeyword.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

- (void) getShopType
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetShopTypeList.aspx";
    
  
    
    
    [super get:url];
}

//获取礼品
- (void) getGiftList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetGiftList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取取货站点
- (void) getSelfStateList
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetDeliverySiteListByShopId.aspx";
    
   
    
    [super get:url];
}
//获取用户在商家优惠券
- (void) getUserInShopCardList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"VoucherIsNull.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取支付编号
- (void) getPayID:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"buildpaynum.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取商家支付方式
- (void) getPayMode:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"paymodel.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取用户地址
- (void) getUserAddressList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetUserAddressList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取城市列表
- (void) getCityList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetCityList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//获取区域列表
- (void) getAreaList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetSectionList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

//获取商圈列表
- (void) getByAreaList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"GetBuildingBysid.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
//保存用户地址
- (void) saveUserAddressList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"SaveUserAddress.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

// get shopdetail by shopid
-(void) getShopDetailByShopId:(NSDictionary*)params
{
	NSString *url = APP_PATH  @"GetShopDetailByShopId.aspx";
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    [super get:url];
    
}

-(void) getGiftDetailByGiftId:(NSDictionary*)params
{
	NSString *url = APP_PATH  @"GetGiftDetail.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
    
}


// get all foodlist
-(void)getFoodListByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"getfoodlistbyshopid.aspx";

    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

// 获取活动商品列表
-(void)getActivityFoodListByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"activeifyFoods.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//获取商家电影列表
-(void)getMovieListByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"GetMoviceList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//获取商家KTV列表
-(void)getKTVListByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"GetktvPriceList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

// 获取活动列表
-(void)getActivityListByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"activitylist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

// 获取我的优惠券列表
-(void)getMyCouponList:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"UserVoucherlist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

// 获取优惠券列表
-(void)getCouponListByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"Voucherlist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}
//加载好友
-(void)getFriendsListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"friendlist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}
//发送消息
-(void)sendMyMessageListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"addmessage.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}
//获消息列表
-(void)getMyMessageListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"Messagelist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}
//获取券列表
-(void)getCouponListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"GetMyCardList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}


//绑定优惠券
-(void)bindCouponListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"bindcard.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//获取积分列表
-(void)getPointListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"pointrecordlist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//搜索好友
-(void)findFriendsListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"searchfriend.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//通讯录匹配好友
-(void)checkFriendsListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"matefriend.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//获取所有好友的购买记录
-(void)getFrinedsBuyListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"mycircle.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//获取积分排行榜
-(void)getPointTopListByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"Gethistorypoinpoint.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//加好友
-(void)addFriendsByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"addfriend.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}
//删好友
-(void)delFriendsByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"deletefriend.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//赠优惠券给好友
-(void)geverCouponFriendsByUserId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"GiveCardToPerson.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//加载食品评论
-(void)getFoodCommentListByFoodId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"reviewlist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

-(void)getFoodDetailByShopId:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"Fooddetail.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;

    [super get:url];
    
}
//对菜品评论
-(void)updataCommentFood:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"Submitreview.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

// 商家收藏
-(void) favorShop:(NSDictionary*)params
{
	NSString *url = APP_PATH  @"SaveCollection.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
    
}
//获取摇一摇的提示信息
-(void)getShakeInitData
{
    NSString *url = APP_PATH  @"getwebset.aspx?id=31";
    
    
    
    needAuth = false;
    
    [super get:url];
    
}

//获摇一摇
-(void)getShakeData:(NSDictionary*)params
{
    NSString *url = APP_PATH  @"selectonefood.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    needAuth = false;
    
    [super get:url];
    
}

//获弹出广告
-(void)getPopAdv
{
    NSString *url = APP_PATH  @"GetAdList.aspx";
    
       
    needAuth = false;
    
    [super get:url];
    
}

-(void)getTopFoodListByShopId
{
    NSString *url = APP_PATH  @"GetFoodCharts.aspx";
    
    
    needAuth = false;
    
    [super get:url];
    
}

// get foodlist by typeid
-(void)getFoodListByTypeId:(NSString*)type
{
    NSString *url = [NSString stringWithFormat:APP_PATH  @"getfoodlistbytypeid.aspx?typeid=%@", type];
    
    needAuth = false;
    
    [super get:url];
    
}

// get orderlist by userid
-(void) getOrderList:(NSDictionary*)params
{
    
    needAuth = false;
    NSString *url = APP_PATH  @"getorderlistbyuserid.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

// 获取预约列表
-(void) getAppointmentOrderList:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"Getbooklist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

-(void) getCartOrderList:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetIntegralList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

-(void) getLotterOrderList:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetPrizeList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
// 确认收货操作
-(void) setOrderState:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"UpdateOrderStatus.aspx";
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

// get orderlist by orderId
-(void) getOrderByOrderId:(NSString*)orderId
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetOrderDetailByOrderId.aspx";
    url = [NSString stringWithFormat:@"%@?orderid=%@&isios=0", url, orderId];
    
    [super get:url];
}

-(void) getCartOrderByOrderId:(NSString*)orderId
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetIntegralDetail.aspx";
    url = [NSString stringWithFormat:@"%@?id=%@&isios=1", url, orderId];
    
    [super get:url];
}

-(void) getLotterOrderByOrderId:(NSString*)orderId
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetPrizeDetail.aspx";
    url = [NSString stringWithFormat:@"%@?id=%@&isios=1", url, orderId];
    
    [super get:url];
}

// get all foottypelist
-(void)getFoodTypeListByShopId:(NSString*)shopid
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetFoodTypeListByShopId.aspx";
    url = [NSString stringWithFormat:@"%@?shopid=%@", url, shopid];
    
    [super get:url];
}

//获取弹出广告
-(void)getPopAdvListByShopId:(NSString*)shopid
{
    needAuth = false;
    NSString *url = APP_PATH  @"Specialad.aspx";
    url = [NSString stringWithFormat:@"%@?size=%@", url, shopid];
    
    [super get:url];
}

//获取热点区域一级
-(void)getHotAreaList
{
    needAuth = false;
    NSString *url = APP_PATH  @"getarealist.aspx";
    
    [super get:url];
}

//获取热点区域二级
-(void)getHotAreaSubList:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"getareasublist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

// {"userid":"1","state":"1"} 1 成功 0 账号不存在 -1 失败
-(void)doLoginByUserNameAndPassword:(NSString*)un pw:(NSString*)pw
{
    needAuth = false;
    NSString *url = APP_PATH  @"login.aspx";
    url = [NSString stringWithFormat:@"%@?username=%@&password=%@", url, un, pw];
    
    [super get:url];
}
//发送验证码
-(void)sendSMSCode:(NSString*)phone
{
    needAuth = false;
    NSString *url = APP_PATH  @"sendcode.aspx";
    url = [NSString stringWithFormat:@"%@?tel=%@&type=0", url, phone];
    
    [super get:url];
}
//验证手机是否注册，注册发送验证码
-(void)checkPhone:(NSString*)phone
{
    needAuth = false;
    NSString *url = APP_PATH  @"sendcode.aspx";
    url = [NSString stringWithFormat:@"%@?tel=%@&type=1", url, phone];
    
    [super get:url];
}

//app/android/regedit.aspx?email=&username=&password=
// {"userid":"1","state":"1"}
-(void)doRegedit:(NSString*)un pw:(NSString*)pw email:(NSString*)email phone:(NSString*)phone cityid:(NSString*)cityid rname:(NSString*)rname
{
    needAuth = false;
    NSString *url = APP_PATH  @"NewRegedit.aspx";
    url = [NSString stringWithFormat:@"%@?email=%@&username=%@&password=%@&tel=%@&Sid=%@&rname=%@", url,email, un, pw, phone,cityid,rname];
    
    [super get:url];
}

//app/android/getuserinfo.aspx?userid=6023
-(void)getUserInfoByUserId:(NSString*)userId
{
    needAuth = false;
    NSString *url = APP_PATH  @"getuserinfo.aspx";
    url = [NSString stringWithFormat:@"%@?userid=%@",url, userId];
    
    [super get:url];
}
//zyp上传图片
- (void)Upload:(UIImage *)image type:(NSString *)type dataID:(NSString *)dataid imageExtName:(NSString *)extName{
    NSString *url = APP_PATH  @"androidupload.ashx";
    [super Upload:image type:type dataID:dataid imageExtName:extName url:url];
}
//抽奖
-(void)getPrizeRecord:(NSString*)userId pID:(NSString *)pid
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetPrizeRecord.aspx";
    url = [NSString stringWithFormat:@"%@?userid=%@&pid=%@",url, userId, pid];
    
    [super get:url];
}

-(void)SaveUserInfo:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"saveuserinfo.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}
-(void)setNewPasswordWithPhone:(NSString *)phoneNum pw:(NSString *)password{
    NSString * url = APP_PATH  @"setpassword.aspx";
    NSString * url1 = [NSString stringWithFormat:@"%@?tel=%@&newpassword=%@", url, phoneNum,password];
//    NSLog(@"%@",url1);
    [super get:url1];
}
-(void)ResetPassword:(NSDictionary*)params isPay:(BOOL)ispay
{
    needAuth = false;
    NSString *url;
    if (ispay) {
        url = APP_PATH  @"setpaypwd.aspx";
    }else{
        url = APP_PATH  @"ResetPassword.aspx";
    }
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    [super get:url];
}

-(void)SubmitGiftCart:(NSDictionary*)params
{
    needAuth = false;
    
    NSString *url = APP_PATH  @"changegift.aspx";
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    
    NSLog(@"%@", url);
    
    [super get:url];
}

-(void)SubmitLotter:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"luckgift.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    NSLog(@"%@", url);
    
    [super get:url];
    
}
//参加活动
-(void)JoinActivity:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"activitysignup.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    NSLog(@"%@", url);
    
    [super get:url];
}

//购买或兑换优惠券
-(void)buyCoupon:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"VoucherSubmit.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    NSLog(@"%@", url);
    
    [super get:url];
}

-(void)getAddressListByUserId:(NSString*)userId
{

}

//app/android/submitorder.aspx?ordermodel
//{"orderid":"","orderstate":""}
-(void)SubmitOrder:(NSString*)order orderType:(int)type
{
    needAuth = false;
    
    NSString *url;// = APP_PATH  @"SubmitOrder.aspx";
    if (type == 0) {
        url = APP_PATH  @"SubmitOrder.aspx";
    }else if(type == 1){
        url = APP_PATH  @"submitbook.aspx";
    }

    NSLog(@"%@?ordermodel=%@", url, order);
    
    [super post:url body:[NSString stringWithFormat:@"ordermodel=%@", order]];
}



// get orderlist by orderId
-(void) getMyCardListByUserId:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetMyCardList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

-(void) getShopCardListByUserId:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"GetMyShopCardList.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

// get orderlist by userid
-(void) getGroupListByBid:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"gettuanllist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

-(void)getGroupDetailById:(NSString*)Id
{
    needAuth = false;

    NSString *url = APP_PATH  @"gettuandetail.aspx";
    url = [NSString stringWithFormat:@"%@?Id=%@",url, Id];
    
    NSLog(@"%@", url);
    
    [super get:url];
}

-(void) getSeckillListByBid:(NSDictionary*)params
{
    needAuth = false;
    NSString *url = APP_PATH  @"getseckilllist.aspx";
    
    int i = 0;
    for (id key in params) {
        NSString *value = [params objectForKey:key];
        NSLog(@"---%@", key);
        NSLog(@"---%@", value);
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@", url, key, value];
        }
        else {
            url = [NSString stringWithFormat:@"%@&%@=%@", url, key, value];
        }
        ++i;
    }
    
    [super get:url];
}

-(void)getSeckillDetailById:(NSString*)Id
{
    needAuth = false;
    
    NSString *url = APP_PATH  @"GETSeckilldetail.aspx";
    url = [NSString stringWithFormat:@"%@?Id=%@",url, Id];
    
    NSLog(@"%@", url);
    
    [super get:url];
}

- (void)authError
{
    self.errorMessage = @"认证失败";
    self.errorDetail  = @"错误的用户名或者密码.";    
    [delegate performSelector:action withObject:self withObject:nil];    
}

- (void)TFConnectionDidFailWithError:(NSError*)error
{
    hasError = true;
    if (error.code ==  NSURLErrorUserCancelledAuthentication) {
        statusCode = 401;
        [self authError];
    }
    else {
        self.errorMessage = @"网络连接错误";
        self.errorDetail  = [error localizedDescription];
        [delegate performSelector:action withObject:self withObject:nil];
    }
    //[self autorelease];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"Authentication Challenge");
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        NSURLCredential* cred = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    } else {
        NSLog(@"Failed auth (%ld times)", (long)[challenge previousFailureCount]);
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    hasError = true;
    [self authError];
    //[self autorelease];
}

- (void)TFConnectionDidFinishLoading:(NSString*)content
{
    switch (statusCode) {
        case 401: // Not Authorized: either you need to provide authentication credentials, or the credentials provided aren't valid.
            hasError = true;
            [self authError];
            //[self autorelease];
        case 304: // Not Modified: there was no new data to return.
            [delegate performSelector:action withObject:self withObject:nil];
            //[self autorelease];
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 200: // OK: everything went awesome.
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
            break;
                
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user). 
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Twitter team will investigate.
        case 502: // Bad Gateway: returned if Twitter is down or being upgraded.
        case 503: // Service Unavailable: the Twitter servers are up, but are overloaded with requests.  Try again later.
        default:
        {
            hasError = true;
            self.errorMessage = @"服务器错误";//Server responded with an error
            self.errorDetail  = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            [delegate performSelector:action withObject:self withObject:nil];
            return;
           // [self autorelease];
        }
    }

    //返回的结果json解析 使用json-framework json解析工具解析
    content = [content stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    content = [content stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
    content = [content stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
    NSObject *obj = [content JSONValue];
        
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)obj;
        NSString *msg = [dic objectForKey:@"error"];//如果访问的数据有错误则需要返回类似{"error":"error msg"}
        if (msg) {
            NSLog(@"服务器返回错误: %@", msg);
            hasError = true;
            self.errorMessage = @"服务器错误";
            self.errorDetail  = msg;
        }
    }
    
    //具体调用远程数据的controller进行解析工作
    [delegate performSelector:action withObject:self withObject:obj];
    
}

- (void)alert
{
    [[EasyEat4iPhoneAppDelegate getAppDelegate] alert:errorMessage message:errorDetail];
    
}


@end
