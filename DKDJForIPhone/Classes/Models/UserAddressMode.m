//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "UserAddressMode.h"

@implementation UserAddressMode

@synthesize aID;
@synthesize address;
@synthesize receiverName;
@synthesize tel;//
@synthesize buildingid;
@synthesize buildingName;
@synthesize phone;
@synthesize sortPhone;//校园短号
@synthesize lat;//菜品规格
@synthesize lon;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    /*[self.foodid release];
    [self.foodname release];
    [self.count release];
    [self.togoName release];
    [self.togoID release];
    [self.icon release];
    [self.des release];
    [self.localPath release];*/

    //int a = [@"123" intValue];
    
    //{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"}
    self.aID = [dic objectForKey:@"dataid"];
    self.address = [dic objectForKey:@"address"];
    self.receiverName = [dic objectForKey:@"receiver"];
    self.sortPhone = [dic objectForKey:@"phone"];
    self.buildingid = [dic objectForKey:@"bID"];
    self.phone = [dic objectForKey:@"mobilephone"];
    
    self.buildingName = [dic objectForKey:@"bName"];
    self.lat = [dic objectForKey:@"lat"];
    self.lon = [dic objectForKey:@"lng"];
    
                    
    /*[self.foodid release];
    [self.foodname release];
    [self.count release];
    [self.togoName release];
    [self.togoID release];
    [self.icon release];
    [self.des release];
    [self.localPath release];*/
}

- (UserAddressMode*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.aID release];
    [self.address release];
    [self.receiverName release];
    [self.tel release];
    [self.sortPhone release];
    [self.buildingid release];
    [self.phone release];
    [self.lat release];
    [self.lon release];
    [self.buildingName release];
   	[super dealloc];
}


@end
