//
//  FoodAttrModel.m
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import "MovieModel.h"

@implementation MovieModel
@synthesize dataID;
@synthesize name;
@synthesize ico;
@synthesize Sort;//0热映 1 近期上映 2 优惠活动
@synthesize TimeStart;
@synthesize image;//原价
@synthesize picPath;
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    //[name release];
    
    
    self.name = [dic objectForKey:@"Mname"];
    self.Sort = [[dic objectForKey:@"Sort"] intValue];
    self.dataID = [[dic objectForKey:@"MoviceId"] intValue];
    self.ico = [dic objectForKey:@"Picture"];
    self.TimeStart = [dic objectForKey:@"TimeStart"];
    self.Star = [[dic objectForKey:@"Star"] intValue];
    
    //[name retain];
    
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)imname{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:imname];
    }
    [fileManager release];
    
}

- (MovieModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    
    [self updateWithJSonDictionary:dic];
	
	return self;
}

- (void)dealloc
{
    [self.name release];
    [self.image release];
    [self.ico release];
    [self.TimeStart release];
    [self.picPath release];
   	[super dealloc];
}
@end
