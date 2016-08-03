//
//  FoodInOrderModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-15.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodModel.h"
#import "FoodAttrModel.h"

@interface FoodInOrderModel : NSObject
{
    NSString*   foodid;
	NSString*   foodname;
    float       price;
    int         foodCount; 
}

@property (nonatomic, retain) NSString* foodid;
@property (nonatomic, retain) NSString* foodname;
@property (nonatomic, assign) float     price;
@property (nonatomic, assign) int       foodCount;
@property (nonatomic, retain) NSMutableArray *attr;

-(FoodInOrderModel*)initWithFoodModel:(FoodModel*)model;
- (FoodInOrderModel*)initWithDictionary:(NSDictionary*)dic;
- (void)updateWithDictionary:(NSDictionary*)dic;

- (FoodInOrderModel*)initWithDictionaryFix:(NSDictionary*)dic;
- (void)updateWithDictionaryFix:(NSDictionary*)dic;

@end