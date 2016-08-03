//
//  FoodTypeModel.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-17.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "FoodTypeModel.h"
//{"SortID":"6220","SortName":"便当类","JOrder":"1"}
@implementation FoodTypeModel

@synthesize SortID;
@synthesize SortName;
@synthesize JOrder;
@synthesize icon;
@synthesize picPath;
@synthesize image;

- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    self.SortID = [dic objectForKey:@"SortID"];
    self.SortName = [dic objectForKey:@"SortName"];
}

- (FoodTypeModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:name];
    }

}


@end
