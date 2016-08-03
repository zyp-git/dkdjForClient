//
//  MyFriends.h
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import <Foundation/Foundation.h>

@interface MyFriendBuy : NSObject
{
    
}
@property (nonatomic, retain)NSString* friendID;//朋友编号
@property (nonatomic, retain)NSString* friendName;//朋友会员名
@property (nonatomic, retain)NSString* friendICON;//好友头像网络
@property (nonatomic, retain)NSString* frImageLocalPath;//好友头像本地缓存
@property (nonatomic, retain) UIImage *frImage;//好友头像
@property (nonatomic, retain)NSString* foodID;//食品名称
@property (nonatomic, retain)NSString* sendTime;//发布时间
@property (nonatomic, retain)NSString* foodName;//食品名称
@property (nonatomic, retain)NSString* foodICON;//食品图像网络
@property (nonatomic, retain)NSString* foImageLocalPath;//食品图像本地缓存
@property (nonatomic, retain) UIImage *foImage;//食品图像

-(MyFriendBuy *) initWitchDic:(NSDictionary *)dic;
-(void)setFrImg:(NSString *)imagePath Default:(NSString *)name;
-(void)setFoImg:(NSString *)imagePath Default:(NSString *)name;
@end
