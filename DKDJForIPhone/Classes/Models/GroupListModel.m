//
//  GroupListModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import "GroupListModel.h"

@implementation GroupListModel

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
    
    //{"gId":"10","Title":"团购测试项目","nowdis":"5.0","Inve3":"0天-21时-23分-56秒","price":"100.0","Discount":"50.0","InUser":"5","togoname":"山东人家","Inve4":"测试一下而已木有地址"}
    
    dataid = [dic objectForKey:@"gId"];
    togoname = [dic objectForKey:@"togoname"];
    title = [dic objectForKey:@"Title"];
    nowdis = [dic objectForKey:@"nowdis"];//折扣
    inve3 = [dic objectForKey:@"Inve3"];
    price = [dic objectForKey:@"price"];//原价
    discount = [dic objectForKey:@"Discount"];//现价
    inuser = [dic objectForKey:@"InUser"];//参团人数
    inve4 = [dic objectForKey:@"Inve4"];
    shopid = [dic objectForKey:@"SupplyerId"];
    sentmoney = [dic objectForKey:@"Inve2"];
    status = [dic objectForKey:@"status"];
    desc = [dic objectForKey:@"Introduce"];
    
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

- (GroupListModel*)initWithJsonDictionary:(NSDictionary*)dic
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
