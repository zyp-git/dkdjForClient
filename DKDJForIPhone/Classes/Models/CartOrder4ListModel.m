//
//  Order4ListModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "CartOrder4ListModel.h"

@implementation CartOrder4ListModel

@synthesize OrderId;//兑换编号
@synthesize GiftName;//礼品名字
@synthesize PayIntegral;//所需积分
@synthesize State;//状态 0 为审核 1 审核通过 2 审核未通过
@synthesize sendtype;//配送方式 1 自提 2 送货
@synthesize OrderTime; //兑换时间
@synthesize ReveInt1;//礼品类型 0普通礼品 1 现金券
@synthesize validcode;//验证码
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    
    self.OrderId = [dic objectForKey:@"IntegralId"];
    self.GiftName = [dic objectForKey:@"GiftName"];
    self.State = [[dic objectForKey:@"State"] intValue];
    self.sendtype = [dic objectForKey:@"sendtype"];
    self.PayIntegral = [dic objectForKey:@"PayIntegral"];
    self.OrderTime = [dic objectForKey:@"Cdate"];
    self.ReveInt1 = [dic objectForKey:@"ReveInt1"];
    self.validcode = [dic objectForKey:@"validcode"];
    
    
    
}

- (CartOrder4ListModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.OrderId release];
    [self.GiftName release];
    [self.validcode release];
    [self.PayIntegral release];
    [self.sendtype release];
    [self.OrderTime release];
    [self.ReveInt1 release];
    
   	[super dealloc];
}

@end
