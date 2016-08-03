//
//  SectionModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import "GiftInfoModel.h"

@implementation GiftInfoModel

@synthesize gID;
@synthesize gName;
@synthesize needPoint;
@synthesize price;
@synthesize stocks;
@synthesize pic;
@synthesize type;
@synthesize hasMoney;
@synthesize lotterPoint;
@synthesize pkAddress;
@synthesize locaPath;

//{"SectionID":"69","SectionName":"开发区","cityid":"1","Parentid":"0"}
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [gID release];
	[gName release];
    [price release];//礼品价格
    [pic release];
    [hasMoney release];//当type = 1时，代表多少金额
    [pkAddress release];//礼品自取地址
    
    
    gID = [dic objectForKey:@"GiftsId"];
    gName = [dic objectForKey:@"Gname"];
    needPoint = [[dic objectForKey:@"NeedIntegral"] intValue];
    price = [dic objectForKey:@"GiftsPrice"];
    type = [[dic objectForKey:@"gifttype"] intValue];
    pic = [dic objectForKey:@"Picture"];
    stocks = [[dic objectForKey:@"Stocks"] intValue];
    hasMoney = [dic objectForKey:@"hasmoney"];
    lotterPoint = [[dic objectForKey:@"lotterypoint"] intValue];
    pkAddress = [dic objectForKey:@"ReveVar2"];
    
    [gID retain];
	[gName retain];
    [price retain];//礼品价格
    [pic retain];
    [hasMoney retain];//当type = 1时，代表多少金额
    [pkAddress retain];//礼品自取地址
    
}

-(GiftInfoModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [gID release];
	[gName release];
    [price release];//礼品价格
    [pic release];
    [hasMoney release];//当type = 1时，代表多少金额
    [pkAddress release];//礼品自取地址
    
    
    gID = [dic objectForKey:@"GiftsId"];
    gName = [dic objectForKey:@"Gname"];
    needPoint = [[dic objectForKey:@"NeedIntegral"] intValue];
    price = [dic objectForKey:@"GiftsPrice"];
    //type = [[dic objectForKey:@"gifttype"] intValue];
    type = 0;
    pic = [dic objectForKey:@"Picture"];
    stocks = [[dic objectForKey:@"Stocks"] intValue];
    //hasMoney = [dic objectForKey:@"hasmoney"];
    hasMoney = @"0.0";
    //lotterPoint = [[dic objectForKey:@"lotterypoint"] intValue];
    lotterPoint = 0;
    //pkAddress = [dic objectForKey:@"ReveVar2"];
    pkAddress = @"";
    
    [gID retain];
	[gName retain];
    [price retain];//礼品价格
    [pic retain];
    [hasMoney retain];//当type = 1时，代表多少金额
    [pkAddress retain];//礼品自取地址
    
	return self;
}

-(GiftInfoModel*)initWithJsonDictionaryOfDetail:(NSDictionary*)dic{
    self = [super init];
    [gID release];
	[gName release];
    [price release];//礼品价格
    [pic release];
    [hasMoney release];//当type = 1时，代表多少金额
    [pkAddress release];//礼品自取地址
    
    
    gID = [dic objectForKey:@"GiftsId"];
    gName = [dic objectForKey:@"Gname"];
    needPoint = [[dic objectForKey:@"NeedIntegral"] intValue];
    price = [dic objectForKey:@"GiftsPrice"];
    type = [[dic objectForKey:@"gifttype"] intValue];
    pic = [dic objectForKey:@"Picture"];
    stocks = [[dic objectForKey:@"stocks"] intValue];
    hasMoney = [dic objectForKey:@"hasmoney"];
    lotterPoint = [[dic objectForKey:@"lotterypoint"] intValue];
    pkAddress = [dic objectForKey:@"ReveVar2"];
    
    [gID retain];
	[gName retain];
    [price retain];//礼品价格
    [pic retain];
    [hasMoney retain];//当type = 1时，代表多少金额
    [pkAddress retain];//礼品自取地址
    
	return self;
}

-(void)dealloc
{
    [gID release];
	[gName release];
    [price release];//礼品价格
    [pic release];
    [hasMoney release];//当type = 1时，代表多少金额
    [pkAddress release];//礼品自取地址
    [locaPath release];
    
   	[super dealloc];
}

@end

