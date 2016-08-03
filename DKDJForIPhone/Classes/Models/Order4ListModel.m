//
//  Order4ListModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "Order4ListModel.h"

@implementation Order4ListModel

@synthesize OrderId;
@synthesize ShopName;
@synthesize State;
@synthesize Sendtate;
@synthesize ShopState;
@synthesize Address;
@synthesize TotalMoney;
@synthesize OrderTime;
@synthesize SentMoney;
@synthesize Packagefree;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
   
    
    self.OrderId = [dic objectForKey:@"OrderID"];
    self.ShopName = [dic objectForKey:@"TogoName"];
    self.State = [[dic objectForKey:@"State"] intValue];
    self.Sendtate = [[dic objectForKey:@"sendstate"] intValue];
    self.ShopState = [[dic objectForKey:@"IsShopSet"] intValue];
    self.Address = @"";
    self.TotalMoney = [dic objectForKey:@"TotalPrice"];
    self.OrderTime = [dic objectForKey:@"orderTime"];
    self.SentMoney = [dic objectForKey:@"sendmoney"];
    self.Packagefree  = [dic objectForKey:@"Packagefree"];
    self.foodsArr=[dic objectForKey:@"foodlist"];
    self.TogoPic=[dic objectForKey:@"TogoPic"];
    self.isShopSet=[[dic objectForKey:@"IsShopSet"] intValue];
    self.payState=[[dic objectForKey:@"paystate"] intValue];
    NSMutableArray * arr=[NSMutableArray array];
    for (NSDictionary * dic in self.foodsArr) {
        FoodInOrderModelFix * model=[[FoodInOrderModelFix alloc]initWithDictionaryFix:dic];
        [arr addObject:model];
    }
    self.foodsArr=arr;
}
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:iname];
    }


}
- (Order4ListModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}



@end
