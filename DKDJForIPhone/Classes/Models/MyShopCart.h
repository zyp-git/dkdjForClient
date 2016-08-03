//
//  MyShopCart.h
//  GZGJ
//
//  Created by ihangjing on 14-9-19.
//
//

#import <Foundation/Foundation.h>
#import "ShopCardModel.h"
#import "FShop4ListModel.h"
#import "FoodModel.h"
@interface MyShopCart : NSObject
{
    //NSString *strJSON;
}
@property(nonatomic, retain)NSMutableArray <ShopCardModel*> *shopCartArry;//ShopCardModel 列表

@property (nonatomic, retain) NSString* custName;//收货人
@property (nonatomic, retain) NSString* phone;//收货电话
@property (nonatomic, retain) NSString* Address;//收货地址
@property (nonatomic, retain) NSString* sendTime;//配送时间
@property (nonatomic, retain) NSString* email;//邮箱
@property (nonatomic, retain) NSString* userID;//会员编号
@property (nonatomic, retain) NSString* areaID;//区域编号
@property (nonatomic, retain) NSString* userName;//会员名称
@property (nonatomic, retain) NSString* people;//就餐人数
@property (nonatomic, retain) NSString* payPassword;//在线支付余额支付的支付密码
@property (nonatomic, retain) NSString* note;//订单备注
@property (nonatomic, retain) NSString* uLat;//用户纬度
@property (nonatomic, retain) NSString* uLng;//用户经度

@property (nonatomic, retain) NSString* activityID;//参加活动编号
@property (nonatomic, retain) NSString* activityName;//参加活动名称
@property (nonatomic, retain) NSString* addTime;//提交时间
@property (nonatomic,) int canJoinPeople;//能参加活动的人数限制

@property (nonatomic,) int canBuyType;//能支持0 普通订单 1预约订单
@property (nonatomic,) int buyType;//0 普通订单 1预约订单 2 参与线下活动 3参与线上活动 4购买或兑换优惠券 5积分兑换

@property (nonatomic,) int senType;//配送方式 1送货上门;2上门自提;3到店消费
@property (nonatomic,) int payType;//支付方法:0线上支付,1线下支付
@property (nonatomic,) int payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@property (nonatomic,) int foodCount;//菜品总数
@property (nonatomic,) int foodAttrLine;//菜品规格总数（不包含规格里面的个数）

@property (nonatomic,) float sendMoney;//配送费
@property (nonatomic,) float packageFee;//打包费
@property (nonatomic,) float allPrice;//总价
@property (nonatomic,) float togoPrice;//不包含水吧饮品的价格

@property (nonatomic,) int cFoodCount;//购物车选中菜品总数
@property (nonatomic,) int cFoodAttrLine;//购物车选中菜品规格总数（不包含规格里面的个数）

@property (nonatomic,) float cSendMoney;//购物车选中配送费
@property (nonatomic,) float cPackageFee;//购物车选中打包费
@property (nonatomic,) float cAllPrice;//购物车选中总价
@property (nonatomic,) float cTogoPrice;//购物车选中不包含水吧饮品的价格

-(int) addFoodAttr:(FShop4ListModel *)mShop food:(FoodModel *)food attrIndex:(int)attrIndex;
-(int) delFoodAttr:(FShop4ListModel *)mShop food:(FoodModel *)food attrIndex:(int)attrIndex;
-(float) getFoodPriceWithShop:(FShop4ListModel *)mShop foodID:(int)foodId;
-(float) getFoodPrice:(FoodModel *)food;
-(int) getFoodCountInAttr:(FShop4ListModel *)mShop foodID:(int)foodId attrId:(int)cId;
-(int)getFoodCountInAttrWitchShopID:(int)shopID foodID:(int)foodId attrId:(int)cId;
-(ShopCardModel*) getShopCardInOrderModel:(int)index;//根据index返回shopCart;
-(FoodModel*) getFoodInOrderModel:(int *)index;//根据index返回食品
-(int) addFoodAttr:(FoodModel *)food attrIndex:(int)attrIndex;
-(int) delFoodAttr:(FoodModel *)food attrIndex:(int)attrIndex;
-(void) removeFood:(FoodModel *)food attrIndex:(int)attrIndex;
-(int) setFoodAttr:(FoodModel *)food attrIndex:(int)attrIndex foodCount:(int)ncount shop:(FShop4ListModel *)mShop;
-(void)checkAll:(BOOL)check;
-(void)checkFood:(FoodModel *)food attrIndex:(int)attrIndex check:(BOOL)isCheck;
//通过ary检查购物车中的商家是否含有代金券
-(void)checkShopCard:(NSArray *)ary;
-(NSString *)getJSONString;
//获取商家id json
-(NSString *)getTogoIDJSONString;
-(NSString *)getGiftJSONString;
-(void)Clean;
@end
