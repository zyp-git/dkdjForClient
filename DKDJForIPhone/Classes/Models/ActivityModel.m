//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

@synthesize dataID;
@synthesize name;
@synthesize tid;//商家编号
@synthesize tName;//商家名称
@synthesize quota;//参与名额
@synthesize starttime;
@synthesize endtime;//结束时间
@synthesize ico;
@synthesize picPath;
@synthesize Disc;//菜品介绍
@synthesize needpoint;//参与活动所需积分，只对全场积分活动有效
@synthesize atype;//类型：0表示全场线下活动，1表示全场积分活动，2表示商铺线下活动，3表示商铺线上活动@synthesize isJoin;//是否促销
@synthesize peoplecount;//已经参与人数
@synthesize disCount;//折扣 85折保存85，只有商铺线上活动有效
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    self.ico = [dic objectForKey:@"pic"];
    self.dataID = [[dic objectForKey:@"aId"] intValue];
    self.name = [dic objectForKey:@"title"];
    self.tid = [[dic objectForKey:@"shopid"] intValue];
    self.tName = [dic objectForKey:@"TogoName"];
    self.quota = [[dic objectForKey:@"quota"] intValue];
    self.Disc = [dic objectForKey:@"introduction"];
    self.starttime= [dic objectForKey:@"starttime"];
    self.endtime= [dic objectForKey:@"endtime"];
    self.needpoint = [[dic objectForKey:@"needpoint"] intValue];//
    self.atype = [[dic objectForKey:@"atype"] intValue];//
    self.peoplecount = [[dic objectForKey:@"peoplecount"] intValue];
    self.disCount = [[dic objectForKey:@"discount"] intValue] / 100.0;//折扣
    }

- (ActivityModel*)init
{
    [super init];
    return self;
}

- (ActivityModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	[self init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)iname{
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath] == YES) {
      
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:iname];
    }
//    [fileManager release];
    
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
