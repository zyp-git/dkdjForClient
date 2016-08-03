//
//  HotAreaModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-3-31.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "HotAreaModel.h"
#import "StringUtil.h"

@implementation HotAreaModel

@synthesize unid;
@synthesize aid;
@synthesize areaName;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [unid release];
    [aid release];
    [areaName release];
    
    unid = [dic objectForKey:@"unid"];
    
    aid = [dic objectForKey:@"aid"];
	areaName = [dic objectForKey:@"areaname"];

    NSLog(@"areaname: %@", areaName);
    
    if ((id)unid == [NSNull null]) unid = @"";
    if ((id)aid == [NSNull null]) aid = @"";
    if ((id)areaName == [NSNull null]) areaName = @"";
    
    [unid retain];
    [aid retain];
    [areaName retain];
}

- (HotAreaModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [unid release];
    [aid release];
    [areaName release];

   	[super dealloc];
}

@end
