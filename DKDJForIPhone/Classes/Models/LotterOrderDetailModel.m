//
//  Order4ListModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "LotterOrderDetailModel.h"

@implementation LotterOrderDetailModel


@synthesize Pname;//礼品名称
@synthesize ReveInt;//现金券金额
@synthesize addtime;//抽奖时间
@synthesize ReveVar;//兑换状态 0 未兑换 1 兑换
@synthesize state;//状态 0 未中奖 1中奖
@synthesize Rcver;//收件人
@synthesize tel;//电话
@synthesize Address;//地址
@synthesize Remark;//备注

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [Pname release];
    [addtime release];
    [ReveInt release];
    [Rcver release];
    [tel release];
    [Address release];
    [Remark release];
    //int a = [@"123" intValue];
    
    
    Pname = [dic objectForKey:@"Pname"];
    state = [[dic objectForKey:@"state"] intValue];
    ReveInt = [dic objectForKey:@"ReveInt"];
    addtime = [dic objectForKey:@"addtime"];
    ReveVar = [[dic objectForKey:@"ReveVar"] intValue];
    
    Rcver = [dic objectForKey:@"Rcver"];
    tel = [dic objectForKey:@"tel"];
    Address = [dic objectForKey:@"Address"];
    Remark = [dic objectForKey:@"Remark"];
    
    [Pname retain];
    [addtime retain];
    [ReveInt retain];
    [Rcver retain];
    [tel retain];
    [Address retain];
    [Remark retain];
}

- (LotterOrderDetailModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [Pname release];
    [addtime release];
    [ReveInt release];
    [Rcver release];
    [tel release];
    [Address release];
    [Remark release];
   	[super dealloc];
}

@end
