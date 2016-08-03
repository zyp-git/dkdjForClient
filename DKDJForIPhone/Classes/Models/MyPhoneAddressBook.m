//
//  MyFriends.m
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "MyPhoneAddressBook.h"

@implementation MyPhoneAddressBook
@synthesize dataID;//数据库编号
@synthesize friendName;//朋友会员名
@synthesize friendPhone;//好友手机号码，注意是手机号码，不含固话
@synthesize friendTye;//-1表示不能加自己为好友,-2表示已经是好友,-3用户未注册,1表示添加成好友
-(MyPhoneAddressBook *) initWitchId:(int)dataid name:(NSString *)name phone:(NSString *)phone
{
    self = [super init];
    if (self != nil) {
        self.dataID = dataid;
        self.friendName = name;
        self.friendPhone = phone;
        self.friendTye = -3;
    }
    return self;
}
-(MyPhoneAddressBook *) initWitchDic:(NSDictionary *)dic
{
    self = [super init];
    if (self != nil) {
        self.friendPhone = [dic objectForKey:@"phone"];
        NSString *value = [dic objectForKey:@"state"];
        if (value && value.length > 0) {
            self.friendTye = [value intValue];
        }
    }
    return self;
}



-(void)dealloc
{
    
    [self.friendName release];
    [self.friendPhone release];
    [super dealloc];
}

@end
