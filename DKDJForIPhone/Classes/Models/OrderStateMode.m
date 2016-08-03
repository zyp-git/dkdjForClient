//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "OrderStateMode.h"

@implementation OrderStateMode
@synthesize addtime;
@synthesize aID;
@synthesize name;
@synthesize subtitle;
@synthesize isEnd;
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
    self.subtitle = [dic objectForKey:@"subtitle"];
    self.aID = [dic objectForKey:@"sId"];
    self.addtime = [dic objectForKey:@"addtime"];
    self.addtime = [self.addtime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    self.addtime = [self.addtime substringWithRange:NSMakeRange(0,19)];
    self.name = [dic objectForKey:@"title"];

}

- (void)updateWithJSonDictionaryByArea:(NSDictionary*)dic
{

    
    //{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"}
    self.subtitle = [dic objectForKey:@"subtitle"];
    self.aID = [dic objectForKey:@"sId"];
    self.addtime = [dic objectForKey:@"addtime"];
    self.addtime = [self.addtime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    self.name = [dic objectForKey:@"title"];
    

}

- (void)updateWithJSonDictionaryByCity:(NSDictionary*)dic
{

    self.addtime = [dic objectForKey:@"addtime"];
    self.addtime = [self.addtime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    self.aID = [dic objectForKey:@"sId"];
    self.subtitle = [dic objectForKey:@"subtitle"];
    self.name = [dic objectForKey:@"title"];
    
    /*[self.foodid release];
     [self.foodname release];
     [self.count release];
     [self.togoName release];
     [self.togoID release];
     [self.icon release];
     [self.des release];
     [self.localPath release];*/
}

- (OrderStateMode*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (OrderStateMode*)initWithJsonDictionaryByArea:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionaryByArea:dic];
	
	return self;
}

- (OrderStateMode*)initWithJsonDictionaryByCity:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionaryByCity:dic];
	
	return self;
}

- (void)dealloc
{
    [self.aID release];
    [self.addtime release];
    [self.subtitle release];
    [self.name release];

   	[super dealloc];
}


@end
