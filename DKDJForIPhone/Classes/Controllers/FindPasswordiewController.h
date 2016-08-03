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

@interface FindPasswordiewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{

    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;  
    UITextField *tfEmail;
    UITextField *tfUserName;
    UITextField *tfPasswordR;
    UITextField *tfPasswordR1;
    UITextField *tfPhone;
    UITextField *tfSMSCode;
    BOOL isPayPassword;//是否为支付密码
    
    UITapGestureRecognizer *backClick;
    
    
    UIImageView *ivRegBG;
    
    UIButton *btnTLogin;
    UIButton *btnTReg;
    
    NSTimer *timer;
    int nTimer;
    BOOL isGetCode;//是否获取过验证码
    
    UIButton *btnSendSMS;
    UIImage *backgroundImage;
    
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
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

-(void)cancel:(id)sender;
-(void)save:(id)sender;

-(id)initUserInfo:(BOOL)isPay;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end