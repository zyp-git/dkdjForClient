//
//  FoodInOrderModelFix.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-7.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "FoodInOrderModelFix.h"
#import "StringUtil.h"

@implementation FoodInOrderModelFix

@synthesize foodid;
@synthesize foodname;
@synthesize price;
@synthesize foodCount;
@synthesize package;
@synthesize isComment;//0没有评论，1评论了
@synthesize picPath;
@synthesize image;

//{"Num":1,"FoodID":"7655","FoodPrice":8.5,"foodname":"香辣鸡翅一对","package":"0.00"}
- (void)updateWithDictionary:(NSDictionary*)dic
{
    [foodid release];
    [foodname release];
    
    //int a = [@"123" intValue];
    
    foodid = [dic objectForKey:@"FoodID"];
    foodname = [dic objectForKey:@"foodname"];
    price = [[dic objectForKey:@"FoodPrice"] floatValue];
    foodCount = [[dic objectForKey:@"Num"] intValue];
    package = [[dic objectForKey:@"package"] floatValue];
    isComment = [[dic objectForKey:@"isreview"] intValue];
    [foodid retain];
    [foodname retain];
}
-(void)setImg:(NSString *)imagePath Default:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

- (FoodInOrderModelFix*)initWithDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithDictionary:dic];
	
	return self;
}

- (FoodInOrderModelFix*)initWithDictionaryFix:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithDictionaryFix:dic];
	
	return self;
}

- (void)updateWithDictionaryFix:(NSDictionary*)dic
{
    [foodid release];
    [foodname release];
    
    //int a = [@"123" intValue];
    //{\"Num\":1,\"FoodID\":\"74513\",\"FoodPrice\":15.0,\"foodname\":\"红烧鸡翅1\",\"package\":\"0\"}
    foodid = [dic objectForKey:@"FoodID"];
    foodname = [dic objectForKey:@"foodname"];
    price = [[dic objectForKey:@"FoodPrice"] floatValue];
    foodCount = [[dic objectForKey:@"Num"] intValue];
    isComment = [[dic objectForKey:@"isreview"] intValue];
    //package = [[dic objectForKey:@"package"] floatValue];
    package = 0.0f;
    [foodid retain];
    [foodname retain];
}

- (void)dealloc
{
    [foodid release];
    [foodname release];
    
   	[super dealloc];
}

@end
