//
//  PopAdvModel.m
//  HMBL
//
//  Created by ihangjing on 14-1-8.
//
//

#import "PopAdvModel.h"

@implementation PopAdvModel
@synthesize icon;
@synthesize dataID;//编号
@synthesize image;
@synthesize picPath;//本地图片地址
-(PopAdvModel *)initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
       // NSString *value = [dic objectForKey:@"SortName"];
        self.icon = [dic objectForKey:@"SortName"];//[value stringByReplacingOccurrencesOfString:@"hmbl.cn" withString:@"192.168.100.100"];
    }
    return self;
}

-(void)setImageWitchPath:(NSString *)path Default:(NSString *)def
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path] == YES) {
        self.image = [[UIImage alloc] init];
        [self.image initWithContentsOfFile:path];
    }else{
        self.image = [UIImage imageNamed:def];
    }
    [fileManager release];
}

-(void)dealloc
{
    [self.icon release];
    [self.dataID release];
    [self.image release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
