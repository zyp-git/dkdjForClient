//
//  HotAreaModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-3-31.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotAreaModel : NSObject
{
    NSString*   unid;
	NSString*   aid;
	NSString*   areaName;
}

@property (nonatomic, retain) NSString* unid;
@property (nonatomic, retain) NSString* aid;
@property (nonatomic, retain) NSString* areaName;

- (HotAreaModel*)initWithJsonDictionary:(NSDictionary*)dic;
- (void)updateWithJSonDictionary:(NSDictionary*)dic;

@end