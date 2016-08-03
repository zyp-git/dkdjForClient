//
//  MyFriends.m
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "MyFriends.h"

@implementation MyFriends
@synthesize dataID;//数据库编号
@synthesize friendID;//朋友编号
@synthesize friendName;//朋友会员名
@synthesize friendPhone;//好友手机号码，注意是手机号码，不含固话
@synthesize friendICON;//好友头像
@synthesize imageLocalPath;//本地图片地址
@synthesize image;//头像
@synthesize isFriend;//1表示好友，0表示不是
-(MyFriends *) initWitchId:(int)dataid frinedId:(int)friendid name:(NSString *)name phone:(NSString *)phone icon:(NSString *)cion
{
    self = [super init];
    if (self != nil) {
        self.dataID = dataid;
        self.friendID = friendid;
        self.friendName = name;
        self.friendPhone = phone;
        self.friendICON = cion;
        self.isFriend = 1;
    }
    return self;
}
-(MyFriends *) initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self != nil) {
        self.friendICON = [dic objectForKey:@"friendpicture"];
        self.friendName = [dic objectForKey:@"friendname"];
        self.friendPhone = [dic objectForKey:@"friendtell"];
        self.friendID = [[dic objectForKey:@"friendid"] intValue];
        NSString *value = [dic objectForKey:@"isfriend"];
        if (value && value.length > 0) {
            self.isFriend = [value intValue];
        }
    }
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

-(void)dealloc
{
    
    [self.friendName release];
    [self.friendPhone release];
    [self.friendICON release];
    [super dealloc];
}

@end
