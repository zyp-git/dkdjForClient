//
//  MyFriends.h
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import <Foundation/Foundation.h>

@interface MyFriends : NSObject
{
    
}
@property (nonatomic,)int dataID;//数据库编号
@property (nonatomic,)int friendID;//朋友编号
@property (nonatomic, retain)NSString* friendName;//朋友会员名
@property (nonatomic, retain)NSString* friendPhone;//好友手机号码，注意是手机号码，不含固话
@property (nonatomic, retain)NSString* friendICON;//好友头像
@property (nonatomic, retain)NSString* imageLocalPath;//好友头像本地缓存
@property (nonatomic, retain) UIImage *image;//头像
@property (nonatomic, assign) int isFriend;
-(MyFriends *) initWitchId:(int)dataid frinedId:(int)friendid name:(NSString *)name phone:(NSString *)phone icon:(NSString *)cion;
-(MyFriends *) initWitchDic:(NSDictionary *)dic;
-(void)setImg:(NSString *)imagePath  Default:(NSString *)name;
@end
