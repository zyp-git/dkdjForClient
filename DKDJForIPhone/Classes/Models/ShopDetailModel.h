//
//  ShopDetailModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopTagMode.h"
#import "CachedDownloadManager.h"
/*
{"id":"6092","name":"赛百味","area":"0","address":"香江北路28号赛奥特莱斯2022","icon":"","SendLimit":"0.00","SendFee":"0.00","senttime":"45","special":"","bisnessStart":"10:00","bisnessend":"20:30","start":"10:00","end":"14:30","foodupdatetime":"2012年3月23日","FlavorGrade":"1","ServiceGrade":"1","SpeedGrade":"1","Grade":"2","sentorg":"自送","lat":"","lng":"","Comm":"8435 7568","reviewtimes":"0","Time1Start":"10:00","Time1End":"14:30","Time2Start":"14:30","Time2End":"20:30","hasmenupic":"1","status":"1","buildingids":""}
*/
@interface ShopDetailModel : NSObject
{
    
}
@property (nonatomic, retain) NSMutableArray <ShopTagMode *>* shopTagList;//商家图片标签
@property (nonatomic, assign) int shopid;
@property (nonatomic, retain) NSString* shopname;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) UIImage* imgIcon;
@property (nonatomic, retain) NSString* logo;
@property (nonatomic, retain) NSString* localIcon;
@property (nonatomic, retain) NSString* localLogo;
@property (nonatomic, retain) NSString* tel;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* dis;
@property (nonatomic, retain) NSString* OrderTime;
@property (nonatomic, retain) NSString* StartTime1;
@property (nonatomic, retain) NSString* EndTime1;
@property (nonatomic, retain) NSString* StartTime2;
@property (nonatomic, retain) NSString* EndTime2;
@property (nonatomic, retain) NSString* lat;
@property (nonatomic, retain) NSString* lng;
@property (nonatomic, retain) NSString* Introduction;//简介
@property (nonatomic, retain) NSString* Explain;//人均消费说明
@property (nonatomic, retain) NSString* FoodCount;//菜品总数
@property (nonatomic, assign) int sortId;//商家分类id，电影的为 35 KTV的为36
@property (nonatomic, assign) int Grade;//是否支持预约,0表示支持，1表示不支持
@property (nonatomic, assign) int Star;//商铺类型：0：统一商铺；1：独立商铺；2：同城商铺
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int startsendtime;//点赞数量
@property (nonatomic, assign) int okCount;//一般数量
@property (nonatomic, assign) int badCount;//差评数量
@property (nonatomic, assign) int Sendtype;//是否支持送货，0表示支持，1表示不支持
@property (nonatomic, assign) int iscollect;//是否收藏，0表示没有收藏，或者没有传用户编号，1表示收藏了
@property (nonatomic, assign) float sendmoney;//配送费
@property (nonatomic, assign) float sendDistance;//配距离
@property (nonatomic, assign) float fullFreeMoney;//满多少免配送费 0.0表示不眠
@property (nonatomic, assign) float distance;//距离
@property (nonatomic, assign) float startMoney;//起送金额
@property (nonatomic, assign) float shopDiscount;//折扣


- (ShopDetailModel*)initWithJsonDictionary:(NSDictionary*)dic;
-(void)setImageDow:(CachedDownloadManager *)dow ;

@end