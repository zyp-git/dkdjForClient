//
//  ShopCardModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-4.
//
//

#import "OrderDetailModel.h"
#import "FoodModel.h"

@implementation OrderDetailModel

@synthesize OrderId;
@synthesize ShopName;
@synthesize State;
@synthesize OrderTime;

@synthesize cardnum;
@synthesize point;
@synthesize ckey;
@synthesize cmoney;
@synthesize CID;
@synthesize reveint;
@synthesize timelimity;
@synthesize moneylimity;
@synthesize moneyline;
@synthesize starttime;
@synthesize endtime;
@synthesize Lat;
@synthesize Lng;
@synthesize checked;
@synthesize foodArry;//菜品
@synthesize shopID;//商家编号
@synthesize allPrice;//总价
@synthesize foodCount;//菜品总数

@synthesize senType;//配送方式 1送货上门;2上门自提;3到店消费
@synthesize payType;//支付方法:0线上支付,1线下支付
@synthesize payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@synthesize sendMoney;//配送费
@synthesize packageFee;//打包费
@synthesize startMoney;//起送金额

@synthesize fullFreeMoney;// 满多少免配送费 0.0表示不眠

// 下面计算配送费相关
@synthesize startSendFee;// 起步价
@synthesize SendFeeOfKM;// 每公里加价
@synthesize minKM;// 超过多少公里开始加价
@synthesize maxKM;// 超过多少公里采用第二价格
@synthesize SendFeeAffKM;// 超过多少公里第二价格
@synthesize distance;//距离最后地址确定计算


- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    self.OrderId = [dic objectForKey:@"OrderID"];
    self.ShopName = [dic objectForKey:@"TogoName"];
    self.State = [[dic objectForKey:@"State"] intValue];
    self.togoPrice = [[dic objectForKey:@"TotalPrice"] floatValue];
    self.allPrice = self.togoPrice;
    self.sendMoney = [[dic objectForKey:@"sendmoney"] floatValue];
    self.OrderTime = [dic objectForKey:@"orderTime"];
    self.packageFee = [[dic objectForKey:@"Packagefree"] floatValue];
    
    self.checked = NO;
    
    NSLog(@"ckey: %@", ckey);
    
    
}

-(void)Clean{
    [self.foodArry removeAllObjects];
    self.allPrice = 0.0f;
    self.foodCount = 0;
}

-(OrderDetailModel*)init
{
    self = [super init];
    self.foodArry = [[NSMutableArray alloc] init];
    return self;
}

-(OrderDetailModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)dealloc
{
    [self.cardnum release];
    [self.point release];
    [self.ckey release];
    [self.cmoney release];
    [self.CID release];
    [self.reveint release];
    [self.timelimity release];
    [self.moneylimity release];
    [self.moneyline release];
    [self.starttime release];
    [self.endtime release];
    [self.Lat release];
    [self.Lng release];
    [self.ShopName release];
    [self.OrderId release];
    [self.OrderTime release];
    
    [self.foodArry release];
    
   	[super dealloc];
}

@end
