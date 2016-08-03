//
//  FShop4ListMode.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

//{"DataID":"140", "TogoName":"老娘舅", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"120.176888","lat":"30.303508","sendmoney":"0"}
@interface LimitModel : NSObject
{
       //NSString*   picPath;
}
@property (nonatomic,) int limitID;//限时购编号，活动编号
@property (nonatomic, retain) NSString *limitName;//活动名称，物品名称
@property (nonatomic,) int Foodid;//商品编号，物品编号
@property (nonatomic,) float oPrice;//原价
@property (nonatomic,) float nPrice;//新价
@property (nonatomic,) int cNum;//剩余数量，库存
@property (nonatomic, assign) int shopid;
@property (nonatomic, retain) NSString* shopname;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString* tel;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* StartTime1;//活动开始时间
@property (nonatomic, retain) NSString* EndTime1;//活动结束时间
@property (nonatomic, assign) int Grade;//是否支持预约,0表示支持，1表示不支持
@property (nonatomic, retain) NSString* Star;
@property (nonatomic, retain) NSString* Lat;
@property (nonatomic, retain) NSString* Lng;
@property (nonatomic, retain) NSString* des;//描述，间接；



@property (nonatomic, retain) NSString* picPath;

@property (nonatomic, retain) UIImage* image;

@property (nonatomic, assign) int status;
@property (nonatomic, assign) float Sendmoney;//配送费
@property (nonatomic, assign) float startMoney;//起送价
@property (nonatomic, assign) float fullFreeMoney;// 满多少免配送费 0.0表示不眠
@property (nonatomic, assign) float sendDistance;// 配送距离

// 下面计算配送费相关
@property (nonatomic, assign) float startSendFee;// 起步价
@property (nonatomic, assign) float SendFeeOfKM;// 每公里加价
@property (nonatomic, assign) float minKM;// 超过多少公里开始加价
@property (nonatomic, assign) float maxKM;// 超过多少公里采用第二价格
@property (nonatomic, assign) float SendFeeAffKM;// 超过多少公里第二价格
@property (nonatomic, assign) float distance;//距离最后地址确定计算
@property (nonatomic, assign)BOOL mBUpdate;
-(LimitModel *)init;
- (LimitModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end