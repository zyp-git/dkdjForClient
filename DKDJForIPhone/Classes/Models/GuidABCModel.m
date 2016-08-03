//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "GuidABCModel.h"

@implementation GuidABCModel

@synthesize name;
@synthesize attr;//商家
- (void)updateWithJSonArry:(NSArray*)arry imageDowload:(CachedDownloadManager*)imgDown indexGroup:(int)goup
{
    
    NSInteger index = [self.attr count];
    for (int i = 0; i < [arry count]; i++) {
        NSDictionary *dic1 = (NSDictionary*)[arry objectAtIndex:i];
        if (![dic1 isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        GuidABCAttrModel *model = [[GuidABCAttrModel alloc] initWithJsonDictionary:dic1];
        model.picPath = [imgDown addTask:[NSString stringWithFormat:@"%d", model.shopID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:(int)index++ Goup:goup];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.shopName);
        [self.attr addObject:model];
        
        [model release];
        
    }
    
}

- (GuidABCModel*)init
{
    [super init];
    self.attr = [[NSMutableArray alloc] init];
    return self;
}

- (GuidABCModel*)initWithJsonDic:(NSDictionary*)dic imageDowload:(CachedDownloadManager*)imgDown indexGroup:(int)goup
{
	[self init];
    self.name = [dic objectForKey:@"Letter"];
    NSArray *arry = [dic objectForKey:@"sublist"];
    [self updateWithJSonArry:arry imageDowload:imgDown indexGroup:goup];
	
	return self;
}



- (void)dealloc
{
    
    
    [self.name release];
    [self.attr release];
   	[super dealloc];
}


@end
