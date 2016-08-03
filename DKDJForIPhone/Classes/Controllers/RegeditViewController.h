//
//  RegeditViewController.h
//  EasyEat4iPhone
//
//  Created by zjf@ihangjing.com on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "ASIHttpHeaders.h"
#import "CJSONDeserializer.h"
#import "HJTableViewController.h"

#define RegeditViewNumberOfEditableRows        4
#define UserName                1
#define Password                2
#define Email                   0
#define Phone                   3
#define RegeditViewLabelTag                    1024

@interface RegeditViewController : HJTableViewController <UITextFieldDelegate,MBProgressHUDDelegate> {
    NSArray             *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField         *textFieldBeingEdited;    
    TwitterClient       *twitterClient;
    NSString            *_userName;
    NSString            *_password;
    MBProgressHUD       *_progressHUD;
    NSString            *servercode;//服务器生成接口返回的验证码
    NSString            *phone;
    //http 请求
    ASIHTTPRequest      *asiRequest;
    NSTimer *timer;
    int nTimer;
    BOOL isGetCode;//是否获取过验证码
    BOOL isShowArea;//是否显示过选择区域界面
    UITapGestureRecognizer *backClick;
}
@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) NSArray               *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary   *tempValues;
@property (nonatomic, retain) UITextField           *textFieldBeingEdited;
@property (nonatomic, retain) NSString              *_userName;
@property (nonatomic, retain) NSString              *_password;
@property(nonatomic,retain) ASIHTTPRequest *asiRequest;
@property (nonatomic, retain) NSString              *phone;
@property (nonatomic, retain) NSString              *servercode;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (BOOL)validateEmail:(NSString*)email;

- (void)resignKeyboard:(id)sender;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (id)getFirstResponder;
- (void)animateView:(NSUInteger)tag;
- (void)checkBarButton:(NSUInteger)tag;
- (void)checkSpecialFields:(NSUInteger)tag;
@end
