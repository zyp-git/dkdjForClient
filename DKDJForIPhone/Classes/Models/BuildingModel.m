//
//  BuildingModel.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import "BuildingModel.h"

@implementation BuildingModel

@synthesize ID;
@synthesize Name;
//{"dataid":"2619","Name":"肯德基餐厅"}
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    [ID release];
    [Name release];
    
    ID = [dic objectForKey:@"dataid"];
    Name = [dic objectForKey:@"Name"];
    
    NSLog(@"name: %@", Name);
    
    [ID retain];
    [Name retain];
}

-(BuildingModel*)initWithJsonDictionary:(NSDictionary*)dic
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
