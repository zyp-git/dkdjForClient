//
//  FoodAttrModel.m
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import "FoodAttrModel.h"

@implementation FoodAttrModel
@synthesize name;
@synthesize price;
@synthesize count;
@synthesize cid;
@synthesize foodId;
@synthesize pactFee;
@synthesize oldPrice;//原价
@synthesize isSelect;//是否在购物车中选中结算，选中了才会最总提交；
@synthesize card;//代金券
@synthesize cardIndex;//代金券所在位置
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    //[name release];
    
    
    self.name = [dic objectForKey:@"Title"];
    self.price = [[dic objectForKey:@"Price"] floatValue];
    self.cid = [[dic objectForKey:@"DataId"] intValue];
    self.foodId = [[dic objectForKey:@"FoodtId"] intValue];
    self.oldPrice = self.price;//[[dic objectForKey:@"Foodcurrentprice"] floatValue];
    
    
    //[name retain];
    
}

- (FoodAttrModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    self.isSelect = NO;
    self.count = 0;
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.name release];
    [self.card release];
        
   	[super dealloc];
}
@end
