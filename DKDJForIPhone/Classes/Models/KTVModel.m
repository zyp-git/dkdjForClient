//
//  FoodAttrModel.m
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import "KTVModel.h"

@implementation KTVModel
@synthesize dataID;
@synthesize weekstart;//星期段
@synthesize TimeEnd;
@synthesize Sort;//优惠类型  0价格，1 活动，2优惠券
@synthesize TimeStart;
@synthesize Sortname;//包间
@synthesize Price;//价格
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    //[name release];
    
    
    self.weekstart = [dic objectForKey:@"weekstart"];
    self.Sort = [[dic objectForKey:@"Sort"] intValue];
    self.dataID = [[dic objectForKey:@"Id"] intValue];
    self.TimeEnd = [dic objectForKey:@"TimeEnd"];
    self.TimeStart = [dic objectForKey:@"TimeStart"];
    self.Price = [[dic objectForKey:@"Price"] floatValue];
    self.Sortname = [dic objectForKey:@"Sortname"];
    //[name retain];
    
}



- (KTVModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.weekstart release];
    [self.TimeEnd release];
    [self.TimeStart release];
    [self.Sortname release];
   	[super dealloc];
}
@end
