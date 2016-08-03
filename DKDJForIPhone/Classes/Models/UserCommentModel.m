//
//  UserCommentModel.m
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "UserCommentModel.h"

@implementation UserCommentModel
@synthesize dataID;
@synthesize userID;//用户编号
@synthesize foodID;//食品编号
@synthesize point;//星级
@synthesize odid;//订单编号提交评论时用
@synthesize userName;
@synthesize foodName;//餐品名称提交评论时用
@synthesize ServerG;//服务评分
@synthesize FlavorG;//口感评分
@synthesize OutG;//外观评分
@synthesize time;//评价时间
@synthesize value;//评价内容
@synthesize togoID;//商家编号
@synthesize icon;//评论上传的图片
@synthesize iconPath;//图片本地地址
@synthesize image;//图片
-(UserCommentModel *)initWitchDic:(NSDictionary *)dic
{
    [super init];
    if (self != nil) {
        self.userID = [dic objectForKey:@"UserID"];
        self.foodID = [dic objectForKey:@"TogoID"];
        self.userName = [dic objectForKey:@"UserName"];
        self.point = [[dic objectForKey:@"Point"] intValue];
        self.ServerG = [[dic objectForKey:@"ServiceGrade"] intValue];
        self.FlavorG = [[dic objectForKey:@"FlavorGrade"] intValue];
        self.OutG = [[dic objectForKey:@"SpeedGrade"] intValue];
        self.time = [dic objectForKey:@"PostTime"];
        self.value = [dic objectForKey:@"Comment"];
        self.icon = [dic objectForKey:@"userpic"];
        self.dataID = [[dic objectForKey:@"DataID"] intValue];
    }
    return self;
}

-(void)dealloc
{
    
    [self.userID release];//用户编号
    [self.foodID release];//食品编号
    [self.odid release];//订单编号提交评论时用
    [self.userName release];
    [self.foodName release];//餐品名称提交评论时用
    
    [self.time release];//评价时间
    [self.value release];//评价内容
    [self.togoID release];//商家编号
    [self.image release];
    
    [super dealloc];
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)iname
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.image = [[UIImage alloc] init];
        self.image = [UIImage imageWithContentsOfFile:imagePath];
    }else{
        self.image = [UIImage imageNamed:iname];
    }
    [fileManager release];
}

@end
