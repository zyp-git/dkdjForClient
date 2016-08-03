//
//  FoodInOrderModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-15.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "FoodInOrderModel.h"
#import "StringUtil.h"

@implementation FoodInOrderModel

@synthesize foodid;
@synthesize foodname;
@synthesize price;
@synthesize foodCount;
@synthesize attr;

- (void)updateWithDictionary:(NSDictionary*)dic
{
    [foodid release];
    [foodname release];
    
    //int a = [@"123" intValue];
    
    foodid = [dic objectForKey:@"foodid"];
    foodname = [dic objectForKey:@"foodname"];
    price = [[dic objectForKey:@"price"] floatValue];
    foodCount = [[dic objectForKey:@"foodCount"] intValue];
    
    NSLog(@"FoodInOrderModel foodname: %@", foodname);
    
    [foodid retain];
    [foodname retain];
}


- (FoodInOrderModel*)initWithDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithDictionary:dic];
	
	return self;
}

-(FoodInOrderModel*)initWithFoodModel:(FoodModel*)model{
    [foodid release];
    [foodname release];
    
    //int a = [@"123" intValue];
    
    self.foodid = [model foodid];
    self.foodname = [model foodname];
    self.attr = [[NSMutableArray alloc] init];
    self.price = model.price;
    self.foodCount = model.count;
    for(int i = 0; i < [[model attr] count]; i++){
        FoodAttrModel *attrModel = [[model attr] objectAtIndex:i];
        if (attrModel.count > 0) {
            [attr addObject:attrModel];
        }
    }
    
    NSLog(@"FoodInOrderModel foodname: %@", foodname);
    
    //[foodid retain];
    //[foodname retain];
    return self;
    
}

- (FoodInOrderModel*)initWithDictionaryFix:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithDictionaryFix:dic];
	
	return self;
}

//{"count":2,"id":"309","price":25.0,"name":"香辣鸡腿堡+薯条+可乐"}
- (void)updateWithDictionaryFix:(NSDictionary*)dic
{
    [foodid release];
    [foodname release];
    
    //int a = [@"123" intValue];
    
    foodid = [dic objectForKey:@"id"];
    foodname = [dic objectForKey:@"name"];
    price = [[dic objectForKey:@"price"] floatValue];
    foodCount = [[dic objectForKey:@"count"] intValue];
    
    NSLog(@"foodname: %@", foodname);
    
    [foodid retain];
    [foodname retain];
}

- (void)dealloc
{
    [foodid release];
    [foodname release];
    [self.attr release];
   
   	[super dealloc];
}

@end
