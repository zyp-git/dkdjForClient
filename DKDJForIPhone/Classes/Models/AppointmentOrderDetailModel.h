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

@interface AppointmentOrderDetailModel : NSObject
{
    
}

@property (nonatomic, retain) NSString* OrderId;
@property (nonatomic, retain) NSString* ShopName;
@property (nonatomic, retain) NSString* ShopTel;
@property (nonatomic, retain) NSString* ShopAddress;
@property (nonatomic, retain) NSString* ShopIcon;
@property (nonatomic, retain) NSString* picPath;
@property (nonatomic, retain) UIImage* shopImage;
@property (nonatomic, assign) int State;
@property (nonatomic, retain) NSString* OrderTime;
@property (nonatomic, retain) NSString* Reciver;//联系人
@property (nonatomic, retain) NSString* phone;//联系电话

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
@property(nonatomic,)float allPrice;//总价
@property (nonatomic,)float togoPrice;//不包含水吧饮品的价格
@property(nonatomic,)int foodCount;//菜品总数

@property (nonatomic,) int senType;//配送方式 1送货上门;2上门自提;3到店消费
@property (nonatomic,) int payType;//支付方法:0线上支付,1线下支付
@property (nonatomic,) int payMode;//支付方式：1,支付宝支付;2,礼品卡支付;3,货到付款;4,到店自提;5,到店消费;

@property (nonatomic,) float sendMoney;//配送费
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


-(AppointmentOrderDetailModel*)init;
- (AppointmentOrderDetailModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)Clean;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;

@end