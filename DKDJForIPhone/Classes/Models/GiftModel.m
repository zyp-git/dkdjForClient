//
//  FShop4ListMode.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "GiftModel.h"

@implementation GiftModel

@synthesize giftID;//编号
@synthesize giftName;//名称，物品名称
@synthesize oPrice;//原价
@synthesize cNum;//剩余数量，库存
@synthesize icon;//网络图片地址
@synthesize NeedIntegral;//积分
@synthesize des;//描述，间接；
@synthesize image;

@synthesize GiftsPrice;//销量
@synthesize picPath;//商家本地图片地址


-(GiftModel *)init
{
    [super init];
    if(self != nil)
    {
    }
    return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    
    
    
    
    //int a = [@"123" intValue];
    
    //{"DataID":"84", "TogoName":"池上便当", "Grade":"0","sortname":"商务简餐","address":"联庄四区","Time1Start":"10:00","Time1End":"14:00","Time2Start":"16:00","Time2End":"21:00","distance":"0.0公里","Star":"0","lng":"120.163655","lat":"30.189053","sendmoney":"￥8","status":"1"}
    self.giftID = [[dic objectForKey:@"GiftsId"] intValue];
    self.giftName = [dic objectForKey:@"Gname"];
    self.cNum = [[dic objectForKey:@"Stocks"] intValue];
    /*if (self.cNum > 9999) {
        self.cNum >
    }*/
    
    self.icon = [dic objectForKey:@"bigpicture"];
    self.des = [dic objectForKey:@"ReveVar1"];

    self.NeedIntegral = [[dic objectForKey:@"NeedIntegral"] intValue];//需要积分
    self.oPrice = [[dic objectForKey:@"GiftsPrice"] intValue];
    
    
    
    
}

- (GiftModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)iname{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:iname];
    }
    [fileManager release];
    
}

- (void)dealloc
{
    [self.giftName release];
    [self.icon release];
    [self.image release];
    [self.des release];
    
   	[super dealloc];
}

@end
