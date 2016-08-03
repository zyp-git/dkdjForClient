//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "TopFoodModel.h"

@implementation TopFoodModel

@synthesize foodid;
@synthesize foodname;
@synthesize count;//当前总价
@synthesize togoID;
@synthesize togoName;
@synthesize des;
@synthesize icon;
@synthesize localPath;

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
    self.icon = [dic objectForKey:@"Picture"];
    self.foodid = [dic objectForKey:@"FoodID"];
    self.foodname = [dic objectForKey:@"Name"];
    self.count = [dic objectForKey:@"salecount"];
    self.togoID = [dic objectForKey:@"TogoId"];
    self.togoName = [dic objectForKey:@"TogoName"];
    self.des = [dic objectForKey:@"Introduce"];
    
                    
    /*[self.foodid release];
    [self.foodname release];
    [self.count release];
    [self.togoName release];
    [self.togoID release];
    [self.icon release];
    [self.des release];
    [self.localPath release];*/
}

- (TopFoodModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.foodid release];
    [self.foodname release];
    [self.count release];
    [self.togoName release];
    [self.togoID release];
    [self.icon release];
    [self.des release];
    [self.localPath release];

   	[super dealloc];
}


@end
