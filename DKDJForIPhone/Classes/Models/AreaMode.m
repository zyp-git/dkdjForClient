//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "AreaMode.h"

@implementation AreaMode
@synthesize pID;
@synthesize aID;
@synthesize name;
@synthesize cID;

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
    self.pID = [dic objectForKey:@"cid"];
    self.aID = [dic objectForKey:@"cid"];
    self.cID = [dic objectForKey:@"cid"];
    self.name = [dic objectForKey:@"cname"];
                        
    /*[self.foodid release];
    [self.foodname release];
    [self.count release];
    [self.togoName release];
    [self.togoID release];
    [self.icon release];
    [self.des release];
    [self.localPath release];*/
}

- (void)updateWithJSonDictionaryByArea:(NSDictionary*)dic
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
    self.pID = [dic objectForKey:@"dataid"];
    self.aID = [dic objectForKey:@"dataid"];
    self.cID = [dic objectForKey:@"dataid"];
    self.name = [dic objectForKey:@"Name"];
    
    /*[self.foodid release];
     [self.foodname release];
     [self.count release];
     [self.togoName release];
     [self.togoID release];
     [self.icon release];
     [self.des release];
     [self.localPath release];*/
}

- (void)updateWithJSonDictionaryByCity:(NSDictionary*)dic
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
    self.pID = [dic objectForKey:@"cid"];
    self.aID = [dic objectForKey:@"cid"];
    self.cID = [dic objectForKey:@"cid"];
    self.name = [dic objectForKey:@"cname"];
    
    /*[self.foodid release];
     [self.foodname release];
     [self.count release];
     [self.togoName release];
     [self.togoID release];
     [self.icon release];
     [self.des release];
     [self.localPath release];*/
}

- (AreaMode*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (AreaMode*)initWithJsonDictionaryByArea:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionaryByArea:dic];
	
	return self;
}

- (AreaMode*)initWithJsonDictionaryByCity:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionaryByCity:dic];
	
	return self;
}

- (void)dealloc
{
    [self.aID release];
    [self.pID release];
    [self.cID release];
    [self.name release];

   	[super dealloc];
}


@end
