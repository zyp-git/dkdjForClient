//
//  FoodModel.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "SelfStateModel.h"

@implementation SelfStateModel

@synthesize stateID;
@synthesize stateName;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    self.stateID = [dic objectForKey:@"SortID"];
    self.stateName = [dic objectForKey:@"SortName"];
    
}

- (SelfStateModel*)init
{
    [super init];
    return self;
}

- (SelfStateModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	[self init];
    [self updateWithJSonDictionary:dic];
	return self;
}



- (void)dealloc
{
    
    [self.stateName release];
    [self.stateID release];
   	[super dealloc];
}


@end
