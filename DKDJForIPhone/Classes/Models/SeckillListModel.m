//
//  SeckillListModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import "SeckillListModel.h"

@implementation SeckillListModel

@synthesize shopid;
@synthesize dataid;
@synthesize togoname;
@synthesize title;
@synthesize nowdis;
@synthesize inve3;
@synthesize price;
@synthesize discount;
@synthesize inuser;
@synthesize inve4;
@synthesize sentmoney;
@synthesize status;
@synthesize desc;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [shopid release];
    [dataid release];
    [togoname release];
    [title release];
    [nowdis release];
    [inve3 release];
    [price release];
    [discount release];
    [inuser release];
    [inve4 release];
    [sentmoney release];
    [status release];
    [desc release];
    
    //{"fID":"21","foodname":"素三样","statestr":"立即秒杀","openstate":"1","timestr":"正在秒杀中...","togoname":"山东人家","oldprice":"8.0","newprice":"5.0","sqid":"2","cnum":"4"}
    
    dataid = [dic objectForKey:@"fID"];
    togoname = [dic objectForKey:@"togoname"];
    title = [dic objectForKey:@"foodname"];
    nowdis = [dic objectForKey:@"newprice"];//秒杀价
    inve3 = [dic objectForKey:@"timestr"];  //结束时间
    price = [dic objectForKey:@"oldprice"]; //原价
    discount = [dic objectForKey:@"statestr"];//开始时间
    inuser = [dic objectForKey:@"cnum"];//剩余数量
    inve4 = [dic objectForKey:@"Inve4"];
    shopid = [dic objectForKey:@"shopid"];
    sentmoney = [dic objectForKey:@"sqid"];//运费
    status = [dic objectForKey:@"status"];
    desc = [dic objectForKey:@"openstate"];
    
    NSLog(@"title: %@", title);
    
    [shopid retain];
    [shopid retain];
    [dataid retain];
    [togoname retain];
    [title retain];
    [nowdis retain];
    [inve3 retain];
    [price retain];
    [discount retain];
    [inuser retain];
    [inve4 retain];
    [sentmoney retain];
    [status retain];
    [desc retain];
}

- (SeckillListModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [shopid release];
    [dataid release];
    [togoname release];
    [title release];
    [nowdis release];
    [inve3 release];
    [price release];
    [discount release];
    [inuser release];
    [inve4 release];
    [sentmoney release];
    [status release];
    [desc release];
    
   	[super dealloc];
}

@end