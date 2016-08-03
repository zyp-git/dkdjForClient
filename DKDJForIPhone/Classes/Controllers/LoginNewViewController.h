//
//  ChangePasswordViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"

#define RegeditViewNumberOfEditableRows        3

#define RegeditViewLabelTag  1024

@interface LoginNewViewController : HJViewController<UITextFieldDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{
    
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    UITextField *tfPassword;
    UITextField *tfPhone;
    UITextField *tfEmail;
    UITextField *tfUserName;
    UITextField *tfPasswordR;
    UITextField *tfPasswordR1;
    UITextField *tfPhoneR;
    UITextField *tfSMSCode;
    BOOL isPayPassword;//是否为支付密码
    UITapGestureRecognizer *backClick;

    UIButton *btnTLogin;

    
    NSTimer *timer;
    int nTimer;
    BOOL isGetCode;//是否获取过验证码
    
    UIButton *btnSendSMS;
    
    int startTag;
    int LineCount;
    BOOL isRegSuccess;
    
    
}

@property (nonatomic, retain) NSString              *userid;
@property (nonatomic, retain) NSString              *userName;
@property (nonatomic, retain) NSString              *email;
@property (nonatomic, retain) NSString              *phone;
@property (nonatomic, retain) NSString              *password;
@property (nonatomic, retain) NSString              *SMSCode;


-(void)cancel:(id)sender;

-(id)initUserInfo:(BOOL)isPay;


@end