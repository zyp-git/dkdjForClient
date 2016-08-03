//
//  CityModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import "CityModel.h"

@implementation CityModel

@synthesize ID;
@synthesize Name;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [ID release];
    [Name release];
    
    ID = [dic objectForKey:@"cid"];
    Name = [dic objectForKey:@"cname"];
    
    NSLog(@"name: %@", Name);
    
    [ID retain];
    [Name retain];
}

-(CityModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)dealloc
{
    [ID release];
    [Name release];
    
   	[super dealloc];
}

@end
