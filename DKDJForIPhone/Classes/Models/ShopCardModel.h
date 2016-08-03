//
//  ShopCardModel.h
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-4.
//
//

#import <Foundation/Foundation.h>
#import "FoodModel.h"
#import "FShop4ListModel.h"

@interface ShopCardModel : NSObject
{
    NSString*   cardnum;
	NSString*   point;
    NSString*   ckey;
    NSString*   cmoney;
    NSString*   CID;
    
    NSString*   reveint;
    NSString*   timelimity;
    NSString*   moneylimity;
    NSString*   moneyline;
    NSString*   starttime;
    NSString*   endtime;
    
    BOOL			m_checked;
}

@property (nonatomic, retain) NSString* cardnum;
@property (nonatomic, retain) NSString* point;
@property (nonatomic, retain) NSString* ckey;
@property (nonatomic, retain) NSString* cmoney;
@property (nonatomic, retain) NSString* CID;
@property (nonatomic, retain) NSString* reveint;
@property (nonatomic, retain) NSString* timelimity;
@property (nonatomic, retain) NSString* moneylimity;
@property (nonatomic, retain) NSString* moneyline;
@property (nonatomic, retain) NSString* starttime;
@property (nonatomic, retain) NSString* endtime;
@property (nonatomic, retain) NSString* Lat;
@property (nonatomic, retain) NSString* Lng;

@property(nonatomic, assign) BOOL checked;
@property(nonatomic, retain) NSMutableArray *foodArry;//菜品
@property (nonatomic,) int shopID;//商家编号
@property (nonatomic, retain) NSString* shopName;//商家名称
@property(nonatomic,)float allPrice;//总价
@property (nonatomic,)float togoPrice;//不包含水吧饮品的价格
@property(nonatomic,)int foodCount;//菜品总数
@property(nonatomic,)int foodAttrLine;//菜品规格总数（不包含规格里面的个数）

@property (nonatomic,) int senType;//配送方式 1送货上门;2上门自提;3到店消费
@property (nonatomic,) int payType;//支付方法:0线上支付,1线下支付
@property (nonatomic,) int payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@property (nonatomic,) float sendMoney;//配送费（网站固定的）
@property (nonatomic,) float sendFee;//配送费   计算出来的
@property (nonatomic,) float packageFee;//打包费

@property (nonatomic, assign) float startMoney;//起送价
@property (nonatomic, assign) float fullFreeMoney;// 满多少免配送费 0.0表示不眠

// 下面计算配送费相关
@property (nonatomic, assign) float startSendFee;// 起步价
@property (nonatomic, assign) float SendFeeOfKM;// 每公里加价
@property (nonatomic, assign) float minKM;// 超过多少公里开始加价
@property (nonatomic, assign) float maxKM;// 超过多少公里采用第二价格
@property (nonatomic, assign) float SendFeeAffKM;// 超过多少公里第二价格
@property (nonatomic, assign) float distance;//距离最后地址确定计算

@property(nonatomic,)float cAllPrice;//购物车选中总价
@property (nonatomic,)float cTogoPrice;//购物车选中不包含水吧饮品的价格
@property(nonatomic,)int cFoodCount;//购物车选中菜品总数
@property(nonatomic,)int cFoodAttrLine;//购物车选中菜品规格总数（不包含规格里面的个数)//暂时不用
@property (nonatomic,) float cPackageFee;//购物车选中打包费
@property (nonatomic, retain) NSMutableArray *activity;//优惠券列表
@property (nonatomic, retain)NSMutableArray *userActivity;//使用优惠券

-(ShopCardModel*)init;
- (ShopCardModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void) CalculationSendFee;//计算配送费
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)Clean;
-(FoodModel*) getFoodInOrderModel:(int *)index ;
-(int)setFoodWithAttrLine:(int)index Count:(int)Count;
-(int)addFoodWithAttrLine:(int)index;

-(int)delFoodWithAttrLine:(int)index;

-(int)removeFoodWithAttrLine:(int)index;
//获取对应商家的代金券
-(void)checkCardList:(NSDictionary *)dic;


// 返回相应食品某一属性是否已经存在，并返回相应的个数
-(int) getFoodCountInAttr:(int)foodId attId:(int)attrId ;

-(float) getFoodPrice:(int)foodId ;

//
-(int) addFoodAttrFoodId:(int)foodid index:(int)attrIndex ;
-(int) setFoodAttr:(FoodModel *)food index:(int)attrIndex Count:(int)count;
//添加代金券
-(void) addFoodAttr:(FoodModel *)food index:(int)attrIndex cardAry:(NSMutableArray *)cardAry cardIndex:(int)index;
//去除代金券
-(void) removeFoodAttr:(FoodModel *)food index:(int)attrIndex cardAry:(NSMutableArray *)cardAry;
-(int) addFoodAttr:(FoodModel *)food index:(int)attrIndex;

-(void) removeFood:(int)foodid index:(int)attrIndex ;

-(int) delFoodAttrFoodId:(int)foodid index:(int)attrIndex;



-(int) delFoodAttr:(FoodModel*)food index:(int)attrIndex ;

-(void)checkAll:(BOOL)check;
-(void)checkFoodId:(int)foodID attrIndex:(int)attrIndex check:(BOOL)isCheck;
-(NSString *)getJSONString;
@end