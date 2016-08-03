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

@interface ChangePasswordViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate>{

    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    UITextField *tfOPassword;
    UITextField *tfNPassword;
    UITextField *tfNPassword1;
    NSDictionary        *dic;
    
    UITapGestureRecognizer *backClick;
    int startTag;
    int LineCount;
}
@property (nonatomic, assign) BOOL isPayPassword;//是否为支付密码
@property (nonatomic, retain) NSString              *userid;
@property (nonatomic, retain) NSString              *userName;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;

-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

-(id)initUserInfo:(BOOL)isPay;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end