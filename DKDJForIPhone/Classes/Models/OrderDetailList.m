//
//  MyShopCart.m
//  GZGJ
//
//  Created by ihangjing on 14-9-19.
//
//

#import "OrderDetailList.h"

@implementation OrderDetailList
@synthesize OrderDetailArry;//OrderDetailModel 列表

@synthesize payPassword;//在线支付余额支付的支付密码

@synthesize senType;//配送方式 1送货上门;2上门自提;3到店消费
@synthesize payType;//支付方法:0线上支付,1线下支付
@synthesize payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@synthesize sendMoney;//配送费
@synthesize packageFee;//打包费
@synthesize allPrice;//总价
@synthesize togoPrice;//不包含水吧饮品的价格

@synthesize cFoodCount;//勾选支付订单的总个数

@synthesize cSendMoney;//购物车选中配送费
@synthesize cPackageFee;//购物车选中打包费
@synthesize cAllPrice;//购物车选中总价
@synthesize cTogoPrice;//购物车选中不包含水吧饮品的价格

-(id)init{
    [super init];
    if (self != nil) {
        OrderDetailArry = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)checkAll:(BOOL)check{
    int length = (int)[self.OrderDetailArry count];
    OrderDetailModel *shopCart;
    for (int i = 0; i < length; i++) {
        shopCart = [self.OrderDetailArry objectAtIndex:i];
        if (shopCart.checked) {
            cAllPrice -= shopCart.allPrice;
            cTogoPrice -= shopCart.togoPrice;
            cPackageFee -= shopCart.packageFee;
            cSendMoney -= shopCart.sendMoney;
            cFoodCount--;
        }
        
        shopCart.checked = check;
        if (shopCart.checked) {
            cAllPrice += shopCart.allPrice;
            cTogoPrice += shopCart.togoPrice;
            cPackageFee += shopCart.packageFee;
            cSendMoney += shopCart.sendMoney;
            cFoodCount++;
        }
        
    }
}
-(void)checkOrder:(NSString *)orderID check:(BOOL)isCheck
{
    NSInteger length = [self.OrderDetailArry count];
    OrderDetailModel *shopCart;
    for (int i = 0; i < length; i++) {
        shopCart = [self.OrderDetailArry objectAtIndex:i];
        if ([orderID compare:shopCart.OrderId] == NSOrderedSame) {
            if (shopCart.checked) {
                cAllPrice -= shopCart.allPrice;
                cTogoPrice -= shopCart.togoPrice;
                cPackageFee -= shopCart.packageFee;
                cSendMoney -= shopCart.sendMoney;
                cFoodCount--;
            }
            
            shopCart.checked = isCheck;
            if (shopCart.checked) {
                cAllPrice += shopCart.allPrice;
                cTogoPrice += shopCart.togoPrice;
                cPackageFee += shopCart.packageFee;
                cSendMoney += shopCart.sendMoney;
                cFoodCount++;
            }
            break;

        }
    }
}

-(void)dealloc{
    [self.OrderDetailArry removeAllObjects];
    [self.OrderDetailArry release];//OrderDetailModel 列表
    [self.payPassword release];//在线支付余额支付的支付密码
    [super dealloc];
}
@end
