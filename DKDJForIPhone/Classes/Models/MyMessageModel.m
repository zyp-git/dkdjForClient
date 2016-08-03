//
//  MyMessageModel.m
//  HMBL
//
//  Created by ihangjing on 14-1-9.
//
//

#import "MyMessageModel.h"

@implementation MyMessageModel
@synthesize dataID;//消息编号
@synthesize userName;//会员名
@synthesize userID;//会员编号
@synthesize comment;//消息内容
@synthesize userICO;//用户头像
@synthesize dataTiem;//发布时间
@synthesize rrmark;//回复
@synthesize pic;//消息中的图片地址
@synthesize Speech;//消息中的语音地址
@synthesize video;//消息中的食品地址
@synthesize rDataTime;//消息回复时间
@synthesize userImage;//会员头像
@synthesize msgImage;//消息图片
@synthesize msgImageLocalPath;//消息中的图片本地地址
@synthesize frImageLocalPath;//好友的图片本地地址
-(MyMessageModel *)initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dataID = [dic objectForKey:@"dataid"];
        self.userID = [dic objectForKey:@"userid"];
        self.userICO = [dic objectForKey:@"userpic"];
        self.userName = [dic objectForKey:@"username"];
        self.comment = [dic objectForKey:@"word"];
        self.dataTiem = [dic objectForKey:@"time"];
        NSString *value = [dic objectForKey:@"rremark"];
        self.rDataTime = [dic objectForKey:@"rtime"];
        if (value == nil || value.length < 1) {
            self.rrmark = @"[暂未回复]";
            self.rDataTime = @"";
        }else{
            self.rrmark = value;
        }
        
        self.pic = [dic objectForKey:@"picture"];
        self.Speech = [dic objectForKey:@"Speech"];
        self.video = [dic objectForKey:@"Video"];
        
    }
    return self;
}

-(void)setUserImageWithPath:(NSString *)imagePath Default:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.userImage = [[UIImage alloc] init];
        [self.userImage initWithContentsOfFile:imagePath];
    }else{
        self.userImage = [UIImage imageNamed:name];
    }
    [fileManager release];
}

-(void)setMsgImageWithPath:(NSString *)imagePath Default:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.msgImage = [[UIImage alloc] init];
        [self.msgImage initWithContentsOfFile:imagePath];
    }else{
        self.msgImage = [UIImage imageNamed:name];
    }
    [fileManager release];
}

-(void)dealloc
{
    [self.dataID release];
    [self.userID release];
    [self.userICO release];
    [self.userName release];
    [self.comment release];
    [self.dataTiem release];
    [self.rrmark release];
    [self.pic release];
    [self.Speech release];
    [self.video release];
    [self.rDataTime release];
    [self.userImage release];
    [self.msgImage release];
    [self.frImageLocalPath release];
    [self.msgImageLocalPath release];
    [super dealloc];
}
@end
