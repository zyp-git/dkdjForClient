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

@interface UserInfoNewViewController : HJViewController<UITextFieldDelegate, MBProgressHUDDelegate>
{
    
    
    
   
    TwitterClient*      twitterClient;

    MBProgressHUD       *_progressHUD;

    NSDictionary        *dic;
    BOOL isPayPassword;//是否为支付密码
    
    UITapGestureRecognizer *backClick;
    int startTag;
    int LineCount;
}

@property (nonatomic, strong) NSString              *userid;
@property (nonatomic, strong) NSString              *userName;
@property (nonatomic, strong) NSArray   *  textArr;

-(void)cancel:(id)sender;
-(void)save:(id)sender;
//-(void)textFieldDone:(id)sender;

-(id)initUserInfo:(BOOL)isPay;

@end