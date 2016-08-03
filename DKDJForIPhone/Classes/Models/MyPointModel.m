//
//  MyPointModel.m
//  HMBL
//
//  Created by ihangjing on 13-12-31.
//
//

#import "MyPointModel.h"

@implementation MyPointModel

@synthesize comment;//说明
@synthesize point;//积分值
@synthesize dataTime;//时间
@synthesize type;//类型

-(MyPointModel *)initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.comment = [dic objectForKey:@"Comment"];
        self.point = [dic objectForKey:@"Point"];
        self.dataTime = [dic objectForKey:@"PostTime"];
        self.type = [[dic objectForKey:@""] intValue];
    }
    return self;
}

-(void)dealloc
{
    [self.comment release];//说明
    [self.point release];//积分值
    [self.dataTime release];//时间
    [super dealloc];
}
@end
