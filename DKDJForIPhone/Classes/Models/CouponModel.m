//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

@synthesize dataID;
@synthesize name;
@synthesize tid;//商家编号
@synthesize tName;//商家名称
@synthesize quota;//已经售出的分数
@synthesize starttime;//有效期开始时间
@synthesize endtime;//有效期结束时间
@synthesize ico;
@synthesize picPath;
@synthesize Disc;//
@synthesize needpoint;//表示代金券的售价或者多少积分可以兑换一张代金券
@synthesize atype;//代金券类型：0表示现金线上券，1表示积分线上券，2表示现金线下券，3表示折扣线下券
@synthesize reveint2;//有效期类型：0表示根据时间，1表示无过期
@synthesize point;//代金券额度或折扣
@synthesize userType;//0.有效 1.过期 2.已使用
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    self.ico = [dic objectForKey:@"pic"];
    self.dataID = [[dic objectForKey:@"aId"] intValue];
    self.name = [dic objectForKey:@"title"];
    self.tid = [[dic objectForKey:@"shopid"] intValue];
    self.tName = [dic objectForKey:@"TogoName"];
    self.quota = [[dic objectForKey:@"reveint3"] intValue];
    self.Disc = [dic objectForKey:@"introduction"];
    self.starttime= [dic objectForKey:@"starttime"];
    self.endtime= [dic objectForKey:@"endtime"];
    self.needpoint = [[dic objectForKey:@"needpoint"] intValue];//
    self.atype = [[dic objectForKey:@"atype"] intValue];//
    self.point = [[dic objectForKey:@"quota"] floatValue];
    self.reveint2 = [[dic objectForKey:@"reveint2"] intValue];
    self.userType = [[dic objectForKey:@"IsUse"] intValue];
}

- (void)updateWithJSonDictionaryOnShopCart:(NSDictionary*)dic
{
    
    self.dataID = [[dic objectForKey:@"ID"] intValue];
    self.name = [dic objectForKey:@"VoucherName"];
    
    self.atype = [[dic objectForKey:@"VoucherType"] intValue];//
    self.point = [[dic objectForKey:@"VoucherValue"] floatValue];
    self.reveint2 = [[dic objectForKey:@"reveint2"] intValue];
}

- (CouponModel*)init
{
    [super init];
    return self;
}

- (CouponModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	[self init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (CouponModel*)initWithJsonDictionaryOnShopCart:(NSDictionary*)dic
{
    [self init];
    
    [self updateWithJSonDictionaryOnShopCart:dic];
    
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
    [self.ico release];
    [self.name release];
    [self.Disc release];
    [self.picPath release];
    [self.tName release];
    [self.image release];
    [self.starttime release];
    [self.endtime release];
   	[super dealloc];
}


@end
