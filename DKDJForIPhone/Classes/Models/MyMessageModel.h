//
//  MyMessageModel.h
//  HMBL
//
//  Created by ihangjing on 14-1-9.
//
//

#import <Foundation/Foundation.h>

@interface MyMessageModel : NSObject
@property(nonatomic, retain)NSString *dataID;//消息编号
@property(nonatomic, retain)NSString *userName;//会员名
@property(nonatomic, retain)NSString *userID;//会员编号
@property(nonatomic, retain)NSString *comment;//消息内容
@property(nonatomic, retain)NSString *userICO;//用户头像网络地址
@property(nonatomic, retain)NSString *dataTiem;//发布时间
@property(nonatomic, retain)NSString *rrmark;//回复
@property(nonatomic, retain)NSString *pic;//消息中的图片网络地址
@property(nonatomic, retain)NSString *Speech;//消息中的语音地址
@property(nonatomic, retain)NSString *video;//消息中的食品地址
@property(nonatomic, retain)NSString *rDataTime;//消息回复时间
@property(nonatomic, retain)UIImage *userImage;//会员头像
@property(nonatomic, retain)UIImage *msgImage;//消息图片
@property(nonatomic, retain)NSString *msgImageLocalPath;//消息中的图片本地地址
@property(nonatomic, retain)NSString *frImageLocalPath;//好友的图片本地地址
-(MyMessageModel *)initWitchDic:(NSDictionary *)dic;
-(void)setUserImageWithPath:(NSString *)imagePath Default:(NSString *)name;

-(void)setMsgImageWithPath:(NSString *)imagePath Default:(NSString *)name;
@end
