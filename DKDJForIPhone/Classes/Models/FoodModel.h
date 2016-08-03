//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface FoodModel : NSObject

@property (nonatomic, retain) NSString* FoodType;
@property (nonatomic, assign) int foodid;
@property (nonatomic, retain) NSString* foodname;
@property (nonatomic,) float price;
@property (nonatomic, assign) int tid;//商家编号
@property (nonatomic, retain) NSString* tName;//商家名称
@property (nonatomic, assign) int count;
@property (nonatomic, assign) float packagefree;
@property (nonatomic, retain) NSMutableArray *attr;//菜品规格
@property (nonatomic, retain) NSString *ico;
@property (nonatomic, retain) NSString *picPath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *Disc;//菜品介绍
@property (nonatomic, retain) NSString *notice;//菜品提示
@property (nonatomic, retain) NSString *publicPoint;//公益积分
@property (nonatomic, assign) int isNew;//是否新品推荐 0不是 1是
@property (nonatomic,) int isHot;//是否热卖
@property (nonatomic,) int isJoin;//是否促销
@property (nonatomic,) int isFav;//是否收藏
@property (nonatomic,) float disCount;//折扣
@property (nonatomic,) int big;//赞的数量
@property (nonatomic,) int sale;//已售数量
@property (nonatomic,) int canBuy;//是否能购买 0表示可以购买，1表示只可浏览(只对活动商品列表有效)
- (FoodModel*)init;
- (FoodModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)name;
@end