//
//  MyCardModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-6.
//
//

#import "MyCardModel.h"
//{"cardnum":"111128","point":"100","ckey":"1111-1111-1111-1128","cmoney":"100.0","CID":"18"}
@implementation MyCardModel

@synthesize cardnum;
@synthesize point;
@synthesize ckey;
@synthesize cmoney;
@synthesize CID;
@synthesize checked = m_checked;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [cardnum release];
    [point release];
    [ckey release];
    [cmoney release];
    [CID release];
    
    cardnum = [dic objectForKey:@"cardnum"];
    ckey = [dic objectForKey:@"ckey"];
    point = [dic objectForKey:@"point"];
    cmoney = [dic objectForKey:@"cmoney"];
    CID = [dic objectForKey:@"CID"];
    self.checked = NO;
    
    NSLog(@"ckey: %@", ckey);
    
    [cardnum retain];
    [point retain];
    [ckey retain];
    [cmoney retain];
    [CID retain];
}

-(MyCardModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)dealloc
{
    [cardnum release];
    [point release];
    [ckey release];
    [cmoney release];
    [CID release];
    
   	[super dealloc];
}

@end
