//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodAttrModel.h"

@interface OrderStateMode : NSObject
{
   
}

@property (nonatomic, retain) NSString* aID;//编号
@property (nonatomic, retain) NSString* name;//名称
@property (nonatomic, retain) NSString* subtitle;//副标题
@property (nonatomic, retain) NSString*   addtime;//添加时间
@property (nonatomic) BOOL isEnd;
- (OrderStateMode*)initWithJsonDictionary:(NSDictionary*)dic;
- (OrderStateMode*)initWithJsonDictionaryByArea:(NSDictionary*)dic;
- (OrderStateMode*)initWithJsonDictionaryByCity:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end