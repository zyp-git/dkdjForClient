//
//  UserCommentModel.h
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import <Foundation/Foundation.h>

@interface UserCommentModel : NSObject
@property(nonatomic,) int dataID;
@property(nonatomic,retain)  NSString *userID;//用户编号
@property(nonatomic,retain)  NSString *foodID;//食品编号
@property(nonatomic,)int point;//星级
@property(nonatomic,retain)  NSString *odid;//订单编号提交评论时用
@property(nonatomic,retain)  NSString *userName;
@property(nonatomic,retain)  NSString *foodName;//餐品名称提交评论时用
@property(nonatomic,)  int ServerG;//服务评分
@property(nonatomic,)  int FlavorG;//口感评分
@property(nonatomic,)  int OutG;//外观评分
@property(nonatomic,retain)  NSString *time;//评价时间
@property(nonatomic,retain)  NSString *value;//评价内容
@property(nonatomic,retain)  NSString *togoID;//商家编号
@property(nonatomic, retain) NSString *icon;//评论上传的图片
@property(nonatomic, retain) NSString *iconPath;//图片本地地址
@property (nonatomic, retain) UIImage* image;
-(UserCommentModel *)initWitchDic:(NSDictionary *)dic;
-(void)setImg:(NSString *)imagePath Default:(NSString *)iname;

@end
