//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface UserAddressMode : NSObject
{
    NSString*   aID;
	NSString*   address;
    NSString*   receiverName;
	NSString*   tel;
    NSString*   buildingid;
    NSString*   buildingName;
    NSString*   phone;
    NSString*   sortPhone;//校园短号
    NSString *lat;
    NSString *lon;
}

@property (nonatomic, retain) NSString* aID;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* receiverName;
@property (nonatomic, retain) NSString* tel;
@property (nonatomic, retain) NSString* buildingid;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSString*   sortPhone;//校园短号
@property (nonatomic, retain) NSString *lat;//菜品规格
@property(nonatomic, retain)NSString *lon;
@property(nonatomic, retain)NSString*   buildingName;;

- (UserAddressMode*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end