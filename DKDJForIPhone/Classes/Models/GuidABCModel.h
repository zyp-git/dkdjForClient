//
//  FoodModel.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuidABCAttrModel.h"
#import "CachedDownloadManager.h"

@interface GuidABCModel : NSObject
{
    
	
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *attr;//商家
- (GuidABCModel*)init;
- (GuidABCModel*)initWithJsonDic:(NSDictionary*)dic imageDowload:(CachedDownloadManager*)imgDown indexGroup:(int)goup;
- (void)updateWithJSonArry:(NSArray*)arry imageDowload:(CachedDownloadManager*)imgDown indexGroup:(int)goup;
@end