//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface TopFoodModel : NSObject
{
    NSString*   foodid;
	NSString*   foodname;
    NSString*   count;
	NSString*   togoName;
    NSString*   des;
    NSString*   icon;
    NSString *togoID;
    NSString *localPath;
}

@property (nonatomic, retain) NSString* foodid;
@property (nonatomic, retain) NSString* foodname;
@property (nonatomic, retain) NSString* count;
@property (nonatomic, retain) NSString* togoName;
@property (nonatomic, retain) NSString* des;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString *togoID;//菜品规格
@property(nonatomic, retain)NSString *localPath;

- (TopFoodModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end