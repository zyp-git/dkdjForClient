//
//  FoodAttrModel.m
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import "GuidABCAttrModel.h"

@implementation GuidABCAttrModel
@synthesize shopID;
@synthesize shopName;
@synthesize ico;
@synthesize image;
@synthesize picPath;
- (void)updateWithJSonDictionary:(NSDictionary*)dic
{
    
    
    self.shopName = [dic objectForKey:@"TogoName"];
    self.ico = [dic objectForKey:@"icon"];
    self.shopID = [[dic objectForKey:@"DataID"] intValue];
    
    
}

- (GuidABCAttrModel*)initWithJsonDictionary:(NSDictionary*)dic
{
	self = [super init];
    [self updateWithJSonDictionary:dic];
	
	return self;
}
-(void)setImg:(NSString *)imagePath Default:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

- (void)dealloc
{
    [self.shopName release];
    [self.ico release];
    [self.picPath release];
    [self.image release];
        
   	[super dealloc];
}
@end
