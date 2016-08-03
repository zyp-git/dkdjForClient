//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface ActivityModel : NSObject
{
    
	
    
}

@property (nonatomic, assign) int dataID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) int tid;//商家编号
@property (nonatomic, retain) NSString* tName;//商家名称
@property (nonatomic, assign) int quota;//参与名额
@property (nonatomic, retain) NSString* starttime;//开始时间
@property (nonatomic, retain) NSString* endtime;//结束时间
@property (nonatomic, retain) NSString *ico;
@property (nonatomic, retain) NSString *picPath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *Disc;//活动介绍
@property (nonatomic, assign) int needpoint;//参与活动所需积分，只对全场积分活动有效
@property (nonatomic,) int atype;//类型：0表示全场线下活动，1表示全场积分活动，2表示商铺线下活动，3表示商铺线上活动
@property (nonatomic,) int peoplecount;//参加人数限制
@property (nonatomic,) float disCount;//折扣85折保存85，只有商铺线上活动有效

- (ActivityModel*)init;
- (ActivityModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;
@end