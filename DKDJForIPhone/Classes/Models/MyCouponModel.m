//
//  MyCouponModel.m
//  HMBL
//
//  Created by ihangjing on 13-12-28.
//
//

#import "MyCouponModel.h"

@implementation MyCouponModel
@synthesize CKey;//券号
@synthesize CType;//券类型，1 现金券， 2折扣
@synthesize CValue;//券值
@synthesize GeivePerson;//赠送人
@synthesize CTimeLimity;//是否时间限制 0 有时间限制，1无时间限制
@synthesize StartTime;//时间限制的开始时间;
@synthesize EndTime;//时间限制的结束时间
@synthesize CMoneyLine;//金额限制 0有金额限制，1无金额限制
@synthesize MoneyLine;//金额限制量
@synthesize CMoney;//剩余金额;
@synthesize CActivity;//是否激活 0没有激活，1激活
@synthesize dataID;//编号
@synthesize isUser;//是否使用 0未用，1使用过
@synthesize isSelect;//是否选中，0未选中，1选择中
@synthesize indexSelect;//选中队列中的位置
-(MyCouponModel *)initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dataID = [[dic objectForKey:@"CID"] intValue];
        self.CValue = [dic objectForKey:@"point"];
        self.CType = [[dic objectForKey:@"ReveInt"] intValue];
        self.GeivePerson = [dic objectForKey:@"geivecardperson"];
        self.CTimeLimity = [[dic objectForKey:@"timelimity"] intValue];
        self.StartTime = [dic objectForKey:@"starttime"];
        self.EndTime = [dic objectForKey:@"endtime"];
        self.CMoneyLine = [[dic objectForKey:@"moneylimity"] intValue];
        self.MoneyLine = [[dic objectForKey:@"moneyline"] floatValue];
        self.CMoney = [[dic objectForKey:@"cmoney"] floatValue];
        self.CActivity = [[dic objectForKey:@"Inve2"] intValue];
        self.isUser = [[dic objectForKey:@"isused"] intValue];
        self.CKey = [dic objectForKey:@"ckey"];
    }
    return self;
}

-(void)dealloc
{
    [self.CKey release];//券号
    
    [self.CValue release];//券值
    [self.GeivePerson release];//赠送人
    
    [self.StartTime release];//时间限制的开始时间;
    [self.EndTime release];//时间限制的结束时间
    
    [super dealloc];
}


@end
