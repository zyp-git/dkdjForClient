//
//  Shop4ListModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "Shop4ListModel.h"

@implementation Shop4ListModel

@synthesize shopid;
@synthesize shopname;
@synthesize icon;
@synthesize tel;
@synthesize address;
@synthesize dis;
@synthesize OrderTime;
@synthesize StartTime1;
@synthesize EndTime1;
@synthesize StartTime2;
@synthesize EndTime2;
@synthesize Grade;
@synthesize Lat;
@synthesize Lng;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [shopid release];
    [shopname release];
    [icon release];
    [tel release];
    [address release];
    [dis release];
    [OrderTime release];
    [StartTime1 release];
    [EndTime1 release];
    [StartTime2 release];
    [EndTime2 release];
    [Grade release];
    [Lat release];
    [Lng release];
    
    //int a = [@"123" intValue];
    
    //{"id":"6", "icon":"http:\/\/fsg.ihangjing.com\/upload\/togopicture\/s0002.jpg","name":"四季明湖东城店","tel":"4008-181-182","address":"","dis":"2000","ordertime":"07:15-17:30", "latitude":"30.29153373149921","longtude":"120.1739501953125"}
    shopid = [dic objectForKey:@"id"];
    shopname = [dic objectForKey:@"name"];
    icon = [dic objectForKey:@"icon"];
    tel = [dic objectForKey:@"tel"];
    address = [dic objectForKey:@"address"];
    dis = [dic objectForKey:@"dis"];
    OrderTime = [dic objectForKey:@"ordertime"];
    StartTime1 = [dic objectForKey:@"StartTime1"];
    EndTime1 = [dic objectForKey:@"EndTime1"];
    StartTime2 = [dic objectForKey:@"StartTime2"];
    EndTime2 = [dic objectForKey:@"EndTime2"];
    Grade = [dic objectForKey:@"Grade"];
    Lat = [dic objectForKey:@"latitude"];
    Lng = [dic objectForKey:@"longtude"];
    
    NSLog(@"shopname: %@", shopname);
    
    if ((id)StartTime1 == [NSNull null]) StartTime1 = @"";
    if ((id)EndTime1 == [NSNull null]) EndTime1 = @"";
    if ((id)StartTime2 == [NSNull null]) StartTime2 = @"";
    if ((id)EndTime2 == [NSNull null]) EndTime2 = @"";
    
    [shopid retain];
    [shopname retain];
    [icon retain];
    [tel retain];
    [address retain];
    [dis retain];
    [OrderTime retain];
    [StartTime1 retain];
    [EndTime1 retain];
    [StartTime2 retain];
    [EndTime2 retain];
    [Grade retain];
    [Lat retain];
    [Lng retain];
}

- (Shop4ListModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [shopid release];
    [shopname release];
    [icon release];
    [tel release];
    [address release];
    [dis release];
    [OrderTime release];
    [StartTime1 release];
    [EndTime1 release];
    [StartTime2 release];
    [EndTime2 release];
    [Grade release];
    [Lat release];
    [Lng release];
    
   	[super dealloc];
}


@end
