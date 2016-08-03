//
//  PointTopModel.m
//  HMBL
//
//  Created by ihangjing on 13-12-31.
//
//

#import "PointTopModel.h"

@implementation PointTopModel
@synthesize userID;//用户编号
@synthesize userName;//用户名称
@synthesize historyPoint;//历史积分
@synthesize publicPoint;//公益积分;
@synthesize friendICON;//好友头像网络
@synthesize frImageLocalPath;//好友头像本地缓存
@synthesize frImage;//好友头像
-(PointTopModel *)initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.userID = [dic objectForKey:@"userid"];
        
        self.userName = [dic objectForKey:@"username"];//用户名称
        self.historyPoint = [dic objectForKey:@"historypoint"];//历史积分
        self.publicPoint = [dic objectForKey:@"publicgood"];//公益积分;
        self.friendICON = [dic objectForKey:@"picture"];//好友头像网络
    }
    return self;
}
-(void)setFrImg:(NSString *)imagePath Default:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.frImage = [[UIImage alloc] init];
        [self.frImage initWithContentsOfFile:imagePath];
    }else{
        self.frImage = [UIImage imageNamed:name];
    }
    [fileManager release];
}

-(void)dealloc
{
    [self.userID release];
    [self.userName release];//用户名称
    [self.historyPoint release];//历史积分
    [self.publicPoint release];//公益积分;
    [self.friendICON release];//好友头像网络
    [self.frImageLocalPath release];//好友头像本地缓存
    [self.frImage release];//好友头像
    [super dealloc];
}
@end
