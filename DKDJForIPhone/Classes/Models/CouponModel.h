//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CouponModel : NSObject
{
    
	
    
}

@property (nonatomic, assign) int dataID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) int tid;//商家编号
@property (nonatomic, retain) NSString* tName;//商家名称
@property (nonatomic, assign) int quota;//已经售出的分数
@property (nonatomic, retain) NSString* starttime;//有效期开始时间
@property (nonatomic, retain) NSString* endtime;//有效期结束时间
@property (nonatomic, retain) NSString *ico;
@property (nonatomic, retain) NSString *picPath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *Disc;//活动介绍
@property (nonatomic, assign) int needpoint;//表示代金券的售价或者多少积分可以兑换一张代金券
@property (nonatomic,) int atype;//代金券类型：0表示现金线上券，1表示积分线上券，2表示现金线下券，3表示折扣线下券
@property (nonatomic,) float point;//代金券额度
@property (nonatomic,) int reveint2;//有效期类型：0表示根据时间，1表示无过期
@property (nonatomic,) int userType;//0.有效 1.过期 2.已使用

- (CouponModel*)init;
- (CouponModel*)initWithJsonDictionary:(NSDictionary*)dic;
//购物车专用
- (CouponModel*)initWithJsonDictionaryOnShopCart:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;
@end