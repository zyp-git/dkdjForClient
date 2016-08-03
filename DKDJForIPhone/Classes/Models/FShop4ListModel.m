//
//  FShop4ListMode.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "FShop4ListModel.h"

@implementation FShop4ListModel


-(FShop4ListModel *)init
{
    
    if(self= [super init])
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
        self.shopTagList = [[NSMutableArray alloc] init];
        _status = 1;
    }
    return self;
}

- (void)updateWithJSonDictionary:(NSDictionary*)dic imageDow:(CachedDownloadManager *)dow Group:(int)goupT
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
    
    self.status = [[dic objectForKey:@"status"] intValue];
    if (self.status == -1) {
        self.searchName = [dic objectForKey:@"name"];
    }
    //self.sortId = [[dic objectForKey:@"sortId"] intValue];
    self.shopid = [[dic objectForKey:@"DataID"] intValue];
    self.shopDiscount = [[dic objectForKey:@"shopdiscount"] floatValue] / 10.0;//折扣
    self.shopname = [dic objectForKey:@"TogoName"];
    self.icon = [dic objectForKey:@"icon"];
    //self.tel = [dic objectForKey:@""];
    self.address = [dic objectForKey:@"address"];
    //self.distance = [[dic objectForKey:@"distance"] floatValue];
    self.des = [dic objectForKey:@"desc"];//推荐理由
    //self.Explain = [dic objectForKey:@"Explain"];
    self.StartTime1 = [dic objectForKey:@"Time1Start"];
    self.EndTime1 = [dic objectForKey:@"Time1End"];
    self.StartTime2 = [dic objectForKey:@"Time2Start"];
    self.EndTime2 = [dic objectForKey:@"Time2End"];

    NSString *orderTimeString;
    
    if( [self.StartTime2 compare:@"" ] == NSOrderedSame)
    {
        orderTimeString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@-%@",_StartTime1,_EndTime1]];
    }
    else
    {
        orderTimeString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@-%@ %@-%@",_StartTime1,_EndTime1,_StartTime2,_EndTime2]];
    }
    
    self.OrderTime = orderTimeString;
    
    //self.Grade = [[dic objectForKey:@"Grade"] intValue];//是否支持预约,0表示支持，1表示不支持
    self.Lat = [dic objectForKey:@"lat"];
    self.Lng = [dic objectForKey:@"lng"];
    //self.Star = [dic objectForKey:@"Star"];
    //self.startMoney = [[dic objectForKey:@"Remark"] floatValue];//起送价
    self.Sendmoney = [[dic objectForKey:@"sendmoney"] floatValue];
    self.startMoney = [[dic objectForKey:@"minmoney"] floatValue];
    _distance = [[dic objectForKey:@"distance"] floatValue];
}

- (FShop4ListModel*)initWithJsonDictionary:(NSDictionary*)dic imageDow:(CachedDownloadManager *)dow Group:(int)goupT
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic imageDow:dow Group:goupT];
	
	return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)iname{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        
        self.image=[UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:iname];
    }

    
}


@end
