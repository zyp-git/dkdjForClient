//
//  Order4ListModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "CartOrderDetailModel.h"

@implementation CartOrderDetailModel

@synthesize OrderId;//兑换编号
@synthesize GiftName;//礼品名字
@synthesize PayIntegral;//所需积分
@synthesize State;//状态 0 为审核 1 审核通过 2 审核未通过
@synthesize sendtype;//配送方式 1 自提 2 送货
@synthesize OrderTime; //兑换时间
@synthesize ReveInt1;//礼品类型 0普通礼品 1 现金券
@synthesize Person;//联系人
@synthesize Address;//送货地址
@synthesize Phone;//手机
@synthesize Date;//送货时间
@synthesize remark;//自提地址

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    /*[self.OrderId release];
    [self.GiftName release];
    
    [self.PayIntegral release];
    [self.sendtype release];
    [self.OrderTime release];
    [self.ReveInt1 release];
    [self.Person release];//联系人
    [self.Address release];//送货地址
    [self.Phone release];//手机
    [self.Date release];//送货时间
    [self.remark release];//自提地址*/
    
    self.OrderId = [dic objectForKey:@"IntegralId"];
    self.GiftName = [dic objectForKey:@"GiftName"];
    self.State = [[dic objectForKey:@"State"] intValue];
    self.sendtype = [dic objectForKey:@"sendtype"];
    self.PayIntegral = [dic objectForKey:@"PayIntegral"];
    self.OrderTime = [dic objectForKey:@"Cdate"];
    self.ReveInt1 = [dic objectForKey:@"ReveInt1"];
    self.Person = [dic objectForKey:@"Person"];
    self.Address = [dic objectForKey:@"Address"];
    self.Phone = [dic objectForKey:@"Phone"];
    self.Date = [dic objectForKey:@"Date"];
    self.remark = [dic objectForKey:@"remark"];
    
   /* [self.OrderId retain];
    [self.GiftName retain];
    
    [self.PayIntegral retain];
    [self.sendtype retain];
    [self.OrderTime retain];
    [self.ReveInt1 retain];
    [self.Person retain];//联系人
    [self.Address retain];//送货地址
    [self.Phone retain];//手机
    [self.Date retain];//送货时间
    [self.remark retain];//自提地址*/
    NSLog(@"OrderId: %@", OrderId);
}

- (CartOrderDetailModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.OrderId release];
    [self.GiftName release];
    
    [self.PayIntegral release];
    [self.sendtype release];
    [self.OrderTime release];
    [self.ReveInt1 release];
    [self.Person release];//联系人
    [self.Address release];//送货地址
    [self.Phone release];//手机
    [self.Date release];//送货时间
    [self.remark release];//自提地址
   	[super dealloc];
}

@end
