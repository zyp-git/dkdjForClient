//
//  Shop4ListModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//  商家列表中使用到的商家信息model 简化版的商家model

#import <Foundation/Foundation.h>

@interface Shop4ListModel : NSObject
{
    NSString*   shopid;
	NSString*   shopname;
    NSString*   icon;
	NSString*   tel;
    NSString*   address;
    NSString*   dis;
    NSString*   OrderTime;  
    NSString*   StartTime1;//暂未使用
    NSString*   EndTime1;//暂未使用
    NSString*   StartTime2;//暂未使用
    NSString*   EndTime2;//暂未使用
    NSString*   Grade;
    NSString*   Stat;
    NSString*   Lat;
    NSString*   Lng;
}

@property (nonatomic, retain) NSString* shopid;
@property (nonatomic, retain) NSString* shopname;
@property (nonatomic, retain) NSString* icon;
@property (nonatomic, retain) NSString* tel;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* dis;
@property (nonatomic, retain) NSString* OrderTime;
@property (nonatomic, retain) NSString* StartTime1;
@property (nonatomic, retain) NSString* EndTime1;
@property (nonatomic, retain) NSString* StartTime2;
@property (nonatomic, retain) NSString* EndTime2;
@property (nonatomic, retain) NSString* Grade;
@property (nonatomic, retain) NSString* Lat;
@property (nonatomic, retain) NSString* Lng;

- (Shop4ListModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end