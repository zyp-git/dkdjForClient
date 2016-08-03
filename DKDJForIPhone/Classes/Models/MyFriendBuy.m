//
//  MyFriends.m
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "MyFriendBuy.h"

@implementation MyFriendBuy
@synthesize friendID;//朋友编号
@synthesize friendName;//朋友会员名
@synthesize friendICON;//好友头像
@synthesize frImageLocalPath;//本地图片地址
@synthesize frImage;//头像
@synthesize foodID;//食品名称
@synthesize sendTime;//发布时间
@synthesize foodName;//食品名称
@synthesize foodICON;//食品图像网络
@synthesize foImageLocalPath;//食品图像本地缓存
@synthesize foImage;//食品图像
-(MyFriendBuy *) initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self != nil) {
        self.friendID = [dic objectForKey:@"userid"];
        self.friendICON = [dic objectForKey:@"userpic"];
        self.friendName = [dic objectForKey:@"username"];
        self.foodICON = [dic objectForKey:@"foodpic"];
        self.foodID = [dic objectForKey:@"foodid"];
        self.foodName = [dic objectForKey:@"foodname"];
        self.sendTime = [dic objectForKey:@"issuetime"];
       
        
    }
    return self;
}

-(void)setFrImg:(NSString *)imagePath Default:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.frImage = [[UIImage alloc] init];
        [self.frImage initWithContentsOfFile:imagePath];
    }else{
        self.frImage = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

-(void)setFoImg:(NSString *)imagePath Default:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.foImage = [[UIImage alloc] init];
        [self.foImage initWithContentsOfFile:imagePath];
    }else{
        self.foImage = [UIImage imageNamed:name];
    }
    [fileManager release];
    
}

-(void)dealloc
{
    
    [self.friendICON release];
    [self.friendName release];
    [self.foodICON release];
    [self.foodID release];
    [self.foodName release];
    [self.sendTime release];
    [self.friendID release];
    [super dealloc];
}

@end
