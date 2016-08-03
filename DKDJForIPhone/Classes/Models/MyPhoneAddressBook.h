//
//  MyFriends.h
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import <Foundation/Foundation.h>

@interface MyPhoneAddressBook : NSObject
{
    
}
@property (nonatomic,)int dataID;//数据库编号
@property (nonatomic, retain)NSString* friendName;//朋友会员名
@property (nonatomic, retain)NSString* friendPhone;//好友手机号码，注意是手机号码，不含固话
@property (nonatomic, assign) int friendTye;//-1表示不能加自己为好友,-2表示已经是好友,-3用户未注册,1表示添加成好友
-(MyPhoneAddressBook *) initWitchId:(int)dataid name:(NSString *)name phone:(NSString *)phone;
-(MyPhoneAddressBook *) initWitchDic:(NSDictionary *)dic;
@end
