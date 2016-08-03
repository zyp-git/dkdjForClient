//
//  FShop4ListMode.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopTagMode.h"
#import "CachedDownloadManager.h"

@interface FShop4ListModel : NSObject


@property (nonatomic, assign) int shopid;
@property (nonatomic, strong) NSMutableArray* shopTagList;//商家图片标签
@property (nonatomic, strong) NSString* shopname;
@property (nonatomic, strong) NSString*   searchName;//搜索结果
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* tel;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* OrderTime;
@property (nonatomic, strong) NSString* StartTime1;
@property (nonatomic, strong) NSString* EndTime1;
@property (nonatomic, strong) NSString* StartTime2;
@property (nonatomic, strong) NSString* EndTime2;
@property (nonatomic, assign) int Grade;//是否支持预约,0表示支持，1表示不支持
@property (nonatomic, strong) NSString* Star;
@property (nonatomic, strong) NSString* Lat;
@property (nonatomic, strong) NSString* Lng;
@property (nonatomic, strong) NSString* des;//描述，间接；
@property (nonatomic, strong) NSString* Explain;//说明，包含商品数，或者包间数等


@property (nonatomic, strong) NSString* picPath;

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) int sortId;//商家分类id，电影的为 35 KTV的为36
@property (nonatomic, assign) int isFav;//是否收藏
@property (nonatomic, assign) int status;
@property (nonatomic, assign) float Sendmoney;//配送费
@property (nonatomic, assign) float startMoney;//起送价
@property (nonatomic, assign) float fullFreeMoney;// 满多少免配送费 0.0表示不眠

// 下面计算配送费相关
@property (nonatomic, assign) float startSendFee;// 起步价
@property (nonatomic, assign) float SendFeeOfKM;// 每公里加价
@property (nonatomic, assign) float minKM;// 超过多少公里开始加价
@property (nonatomic, assign) float maxKM;// 超过多少公里采用第二价格
@property (nonatomic, assign) float SendFeeAffKM;// 超过多少公里第二价格
@property (nonatomic, assign) float distance;//距离最后地址确定计算
@property (nonatomic, assign) float shopDiscount;//折扣
@property (nonatomic, assign)BOOL mBUpdate;
@property (nonatomic, assign) int shopType;//0：统一商铺；1：独立商铺；2：同城商铺 独立商铺不能购买物品
@property (nonatomic, strong) NSMutableArray *ConstraintsArry;
-(FShop4ListModel *)init;
- (FShop4ListModel*)initWithJsonDictionary:(NSDictionary*)dic imageDow:(CachedDownloadManager *)dow Group:(int)groupT;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end