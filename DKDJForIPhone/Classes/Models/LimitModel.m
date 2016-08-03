//
//  FShop4ListMode.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "LimitModel.h"

@implementation LimitModel

@synthesize limitID;//限时购编号，活动编号
@synthesize limitName;//活动名称，物品名称
@synthesize Foodid;//商品编号，物品编号
@synthesize oPrice;//原价
@synthesize nPrice;//新价
@synthesize cNum;//剩余数量，库存
@synthesize shopid;
@synthesize shopname;
@synthesize icon;//商家网络图片地址
@synthesize tel;
@synthesize address;
@synthesize StartTime1;
@synthesize EndTime1;
@synthesize Grade;//是否支持预约,0表示支持，1表示不支持
@synthesize Lat;
@synthesize Lng;
@synthesize des;//描述，间接；
@synthesize Star;
@synthesize image;

@synthesize status;
@synthesize picPath;//商家本地图片地址
@synthesize Sendmoney;
@synthesize startMoney;
@synthesize sendDistance;// 配送距离
@synthesize fullFreeMoney;// 满多少免配送费 0.0表示不眠

// 下面计算配送费相关
@synthesize startSendFee;// 起步价
@synthesize SendFeeOfKM;// 每公里加价
@synthesize minKM;// 超过多少公里开始加价
@synthesize maxKM;// 超过多少公里采用第二价格
@synthesize SendFeeAffKM;// 超过多少公里第二价格
@synthesize distance;//距离最后地址确定计算
@synthesize mBUpdate;

-(LimitModel *)init
{
    [super init];
    if(self != nil)
    {
        self.Sendmoney = 0.0;//配送费
        self.startMoney = 0.0;//起送价
        self.fullFreeMoney = 0.0;// 满多少免配送费 0.0表示不眠
        
        // 下面计算配送费相关
        self.startSendFee = 0.0;// 起步价
        self.SendFeeOfKM = 0.0;// 每公里加价
        self.minKM = 0.0;// 超过多少公里开始加价
        self.maxKM = 0.0;// 超过多少公里采用第二价格
        self.SendFeeAffKM = 0.0;// 超过多少公里第二价格
        status = 1;
    }
    return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    
    
    
    
    //int a = [@"123" intValue];
    
    //{"DataID":"84", "TogoName":"池上便当", "Grade":"0","sortname":"商务简餐","address":"联庄四区","Time1Start":"10:00","Time1End":"14:00","Time2Start":"16:00","Time2End":"21:00","distance":"0.0公里","Star":"0","lng":"120.163655","lat":"30.189053","sendmoney":"￥8","status":"1"}
    self.limitID = [[dic objectForKey:@"fID"] intValue];
    self.limitName = [dic objectForKey:@"foodname"];
    self.Foodid = [[dic objectForKey:@"Foodid"] intValue];
    self.oPrice = [[dic objectForKey:@"oldprice"] floatValue];
    self.nPrice = [[dic objectForKey:@"newprice"] floatValue];
    self.cNum = [[dic objectForKey:@"cnum"] intValue];
    self.status = 1;//[[dic objectForKey:@"status"] intValue];
    
    self.shopid = [[dic objectForKey:@"shopid"] intValue];
    self.shopname = [dic objectForKey:@"togoname"];
    self.icon = [dic objectForKey:@"pic"];
    //self.tel = [dic objectForKey:@""];
    //self.address = [dic objectForKey:@"address"];
    self.distance = [[dic objectForKey:@"distance"] floatValue];
    self.des = [dic objectForKey:@"ReveVar1"];
    self.StartTime1 = [dic objectForKey:@"stardate"];
    self.EndTime1 = [dic objectForKey:@"enddate"];
    //picPath = [dic objectForKey:@"icon"];


    
    
    //self.Grade = [[dic objectForKey:@"Grade"] intValue];//是否支持预约,0表示支持，1表示不支持
    self.Lat = [dic objectForKey:@"shoplat"];
    self.Lng = [dic objectForKey:@"shoplng"];
    self.Star = [dic objectForKey:@"Star"];
    self.fullFreeMoney = [[dic objectForKey:@"freefee"] floatValue];//起送价
    self.sendDistance = [[dic objectForKey:@"limitdistance"] floatValue];
    
    
    
    NSLog(@"shopname: %@", shopname);
    
    
}

- (LimitModel*)initWithJsonDictionary:(NSDictionary*)dic
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
    [self.shopname release];
    [self.limitName release];
    [self.icon release];
    [self.tel release];
    [self.address release];
    [self.StartTime1 release];
    [self.EndTime1 release];
    [self.Lat release];
    [self.Lng release];
    [self.Star release];
    [self.image release];
    [self.des release];
    
   	[super dealloc];
}

@end
