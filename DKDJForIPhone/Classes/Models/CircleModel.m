//
//  CircleModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import "CircleModel.h"

@implementation CircleModel

@synthesize ID;
@synthesize Name;
@synthesize CityId;

//{"SectionID":"69","SectionName":"开发区","cityid":"1","Parentid":"0"}
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [ID release];
    [Name release];
    [CityId release];
    
    ID = [dic objectForKey:@"SectionID"];
    Name = [dic objectForKey:@"SectionName"];
    CityId = [dic objectForKey:@"CityId"];
    
    NSLog(@"name: %@", Name);
    
    [ID retain];
    [Name retain];
    [CityId retain];
}

-(CircleModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)dealloc
{
    [ID release];
    [Name release];
    [CityId release];
    
   	[super dealloc];
}

@end