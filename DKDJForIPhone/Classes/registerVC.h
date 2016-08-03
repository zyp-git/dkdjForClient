//
//  registerVC.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/13.
//
//
#import <Foundation/Foundation.h>
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"
#import "HJViewController.h"

@interface registerVC : HJViewController<UITextFieldDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{
    
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    UITextField *tfPassword;
    UITextField *tfPhone;
    UITextField *tfEmail;
    UITextField *tfUserName;
    UITextField *tfPasswordR;
    UITextField *tfSMSCode;
    BOOL isPayPassword;//是否为支付密码
    UITapGestureRecognizer *backClick;
    
    UIButton *btnTLogin;
    
    
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
-(void)textFieldDone:(id)sender;

-(id)initUserInfo:(BOOL)isPay;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;


@end
