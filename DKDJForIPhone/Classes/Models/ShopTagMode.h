//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface ShopTagMode : NSObject
{
    
}

@property (nonatomic, retain) NSString* aID;
@property (nonatomic, retain) NSString* Title;
@property (nonatomic, retain) NSString* Picture;
@property (nonatomic, retain) NSString*   picPath;//图片本地地址


- (ShopTagMode*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end