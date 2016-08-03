//
//  Order4ListModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "LotterOrder4ListModel.h"

@implementation LotterOrder4ListModel

@synthesize RID;//中奖编号
@synthesize Pname;//礼品名称
@synthesize ReveInt;//现金券金额
@synthesize addtime;//抽奖时间
@synthesize ReveVar;//兑换状态 0 未兑换 1 兑换
@synthesize state;//状态 0 未中奖 1中奖

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [RID release];
    [Pname release];
    [addtime release];
    [ReveInt release];
    //int a = [@"123" intValue];
    
    //{"OrderID":"1206291202476671","TogoName":"老娘舅/西湖","orderTime":"2012-06-29 12:02:29","TotalPrice":"51.5","State":"5","sendmoney":"8","Packagefree":"0.0"}
    RID = [dic objectForKey:@"RID"];
    Pname = [dic objectForKey:@"Pname"];
    state = [[dic objectForKey:@"state"] intValue];
    ReveInt = [dic objectForKey:@"ReveInt"];
    addtime = [dic objectForKey:@"addtime"];
    ReveVar = [[dic objectForKey:@"ReveVar"] intValue];
    
    
    [RID retain];
    [Pname retain];
    [addtime retain];
    [ReveInt retain];
}

- (LotterOrder4ListModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [RID release];
    [Pname release];
    [addtime release];
    [ReveInt release];
    
   	[super dealloc];
}

@end
