//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ShopTagMode.h"

@implementation ShopTagMode
@synthesize picPath;
@synthesize aID;
@synthesize Title;
@synthesize Picture;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{

    self.Title = [dic objectForKey:@"Title"];
    self.Picture = [dic objectForKey:@"Picture"];

}


- (ShopTagMode*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionary:dic];
	
	return self;
}


- (void)dealloc
{
    [self.aID release];
    [self.picPath release];
    [self.Picture release];
    [self.Title release];
   	[super dealloc];
}


@end
