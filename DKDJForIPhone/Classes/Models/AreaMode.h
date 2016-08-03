//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface AreaMode : NSObject
{
    NSString*   pID;//父id
    NSString*   aID;
	NSString*   name;
    NSString*   cID;//城市编号
}

@property (nonatomic, retain) NSString* aID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* cID;
@property (nonatomic, retain) NSString*   pID;//父id

- (AreaMode*)initWithJsonDictionary:(NSDictionary*)dic;
- (AreaMode*)initWithJsonDictionaryByArea:(NSDictionary*)dic;
- (AreaMode*)initWithJsonDictionaryByCity:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end