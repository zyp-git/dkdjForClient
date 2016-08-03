//
//  ShopDetailModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ShopDetailModel.h"
/*
 {"id":"6092","name":"赛百味","area":"0","address":"香江北路28号赛奥特莱斯2022","icon":"","SendLimit":"0.00","SendFee":"0.00","senttime":"45","special":"","bisnessStart":"10:00","bisnessend":"20:30","start":"10:00","end":"14:30","foodupdatetime":"2012年3月23日","FlavorGrade":"1","ServiceGrade":"1","SpeedGrade":"1","Grade":"2","sentorg":"自送","lat":"","lng":"","Comm":"8435 7568","reviewtimes":"0","Time1Start":"10:00","Time1End":"14:30","Time2Start":"14:30","Time2End":"20:30","hasmenupic":"1","status":"1","buildingids":""}
 */
@implementation ShopDetailModel
@synthesize shopTagList;//商家图片标签
@synthesize shopid;
@synthesize shopname;
@synthesize icon;
@synthesize imgIcon;
@synthesize logo;
@synthesize localIcon;
@synthesize localLogo;
@synthesize tel;
@synthesize address;
@synthesize dis;//满10减2 满20-5；
@synthesize OrderTime;
@synthesize StartTime1;
@synthesize EndTime1;
@synthesize StartTime2;
@synthesize EndTime2;
@synthesize lat;
@synthesize lng;
@synthesize Introduction;//简介
@synthesize Explain;//人均消费说明
@synthesize FoodCount;//菜品总数
@synthesize sortId;//商家分类id，电影的为 35 KTV的为36
@synthesize Grade;//是否支持预约,0表示支持，1表示不支持
@synthesize Star;//商铺类型：0：统一商铺；1：独立商铺；2：同城商铺
@synthesize status;
@synthesize startsendtime;//点赞数量
@synthesize okCount;//一般数量
@synthesize badCount;//差评数量
@synthesize Sendtype;//是否支持送货，0表示支持，1表示不支持
@synthesize iscollect;//是否收藏，0表示没有收藏，或者没有传用户编号，1表示收藏了
@synthesize sendmoney;//配送费
@synthesize sendDistance;//配距离
@synthesize fullFreeMoney;//满多少免配送费 0.0表示不眠
@synthesize distance;//距离
@synthesize startMoney;//起送金额
@synthesize shopDiscount;//折扣
- (ShopDetailModel*)initWithJsonDictionary:(NSDictionary*)dic 
{
    self = [super init];
    if (self) {
        [self updateWithJSonDictionary:dic];
    }
    return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    if (self.shopTagList == nil) {
        self.shopTagList = [[NSMutableArray alloc] init];
    }
    NSArray *ary = nil;
    ary = [dic objectForKey:@"taglist"];

    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic1 = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic1 isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ShopTagMode *tagModel = [[ShopTagMode alloc] initWithJsonDictionary:dic1];
    
        [self.shopTagList addObject:tagModel];
    }
    //self.sortId = [[dic objectForKey:@"sortId"] intValue];
    self.shopid = [[dic objectForKey:@"DataID"] intValue];
    self.startsendtime = [[dic objectForKey:@"PType"] intValue];
    self.okCount = [[dic objectForKey:@"RcvType"] intValue];
    self.badCount = [[dic objectForKey:@"IsCallCenter"] intValue];
    self.shopname = [dic objectForKey:@"TogoName"];
    self.icon = [dic objectForKey:@"icon"];
    
//    self.logo = [dic objectForKey:@"logo"];
    self.dis = [dic objectForKey:@"desc"];
    self.Introduction = [dic objectForKey:@"desc"];
    //self.Explain = [dic objectForKey:@"Explain"];
    self.lat = [dic objectForKey:@"lat"];
    self.lng = [dic objectForKey:@"lng"];
    self.shopDiscount = [[dic objectForKey:@"shopdiscount"] floatValue] / 10.0;//折扣
    self.tel = [dic objectForKey:@"Comm"];
    //self.FoodCount = [dic objectForKey:@"FoodCount"];
    self.address = [dic objectForKey:@"address"];
    self.distance = [[dic objectForKey:@"distance"] floatValue];
    //self.Grade = [[dic objectForKey:@"Grade"] intValue];//是否支持预约
    //self.Star = [[dic objectForKey:@"Star"] intValue];//商铺类型：0：统一商铺；1：独立商铺；2：同城商铺
    self.status = [[dic objectForKey:@"status"] intValue];
    //self.startsendtime = [[dic objectForKey:@"startsendtime"] intValue];
    //self.Sendtype = [[dic objectForKey:@"Sendtype"] intValue];
    self.iscollect = [[dic objectForKey:@"iscollected"] intValue];
    self.StartTime1 = [dic objectForKey:@"Time1Start"];
    self.StartTime2 = [dic objectForKey:@"Time2Start"];
    self.EndTime1 = [dic objectForKey:@"Time1End"];
    self.EndTime2 = [dic objectForKey:@"Time2End"];
    if( [self.StartTime2 compare:@"" ] == NSOrderedSame){
        self.OrderTime = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@-%@",StartTime1,EndTime1]];
    }
    else{
        self.OrderTime = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@-%@ %@-%@",StartTime1,EndTime1,StartTime2,EndTime2]];
    }
    
    self.sendmoney = [[dic objectForKey:@"sendmoney"] floatValue];

    self.fullFreeMoney = [[dic objectForKey:@"sendfree"] floatValue];
   
    self.startMoney = [[dic objectForKey:@"minmoney"] floatValue];
}


@end
