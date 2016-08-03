//
//  UserAddressDetail.h
//  SYW
//
//  Created by wulin on 13-8-29.
//
//

#import <UIKit/UIKit.h>

@interface UserAddressDetail : UIAlertView<UITextInputDelegate>

@property(nonatomic, retain) UITextField* name;    // 旧密码输入框
@property(nonatomic, retain) UITextField* phone;    // 新密码输入框
@property(nonatomic, retain) UITextField* address;    // 新密码确认框@end

-(id)initWithUserName:(NSString *)name UserAddress:(NSString *)address UserPhone:(NSString *)phone Title:(NSString *)title delegate:(id)delegate;
-(id)initDefault:(id)delegate;

@end
