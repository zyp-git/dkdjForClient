//
//  MyShopCart.h
//  GZGJ
//
//  Created by ihangjing on 14-9-19.
//
//

#import <Foundation/Foundation.h>
#import "OrderDetailModel.h"
#import "FShop4ListModel.h"
#import "FoodModel.h"
@interface OrderDetailList : NSObject
{
    
}
@property(nonatomic, retain)NSMutableArray *OrderDetailArry;//ShopCardModel 列表


@property (nonatomic, retain) NSString* payPassword;//在线支付余额支付的支付密码

@property (nonatomic,) int senType;//配送方式 1送货上门;2上门自提;3到店消费
@property (nonatomic,) int payType;//支付方法:0线上支付,1线下支付
@property (nonatomic,) int payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@property (nonatomic,) float sendMoney;//配送费
@property (nonatomic,) float packageFee;//打包费
@property (nonatomic,) float allPrice;//总价
@property (nonatomic,) float togoPrice;//不包含水吧饮品的价格

@property (nonatomic,) int cFoodCount;//勾选支付订单的总个数

@property (nonatomic,) float cSendMoney;//购物车选中配送费
@property (nonatomic,) float cPackageFee;//购物车选中打包费
@property (nonatomic,) float cAllPrice;//购物车选中总价
@property (nonatomic,) float cTogoPrice;//购物车选中不包含水吧饮品的价格


-(void)checkAll:(BOOL)check;
-(void)checkOrder:(NSString *)orderID check:(BOOL)isCheck;

@end
