//
//  UserInfoViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"

#define RegeditViewNumberOfEditableRows        6

#define TrueName             0
#define Phone                1
#define Email                2
#define QQ                   3

#define RegeditViewLabelTag  1024

@interface UserInfoViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate>
{
    NSArray *fieldLabels;
    NSMutableDictionary *tempValues;
    UITextField *textFieldBeingEdited;  
    
    NSString*           userid;
    TwitterClient*      twitterClient;
    
    UITableView         *orderTableView;
    
    MBProgressHUD       *_progressHUD;
    
    NSDictionary        *dic;
    int                 dis;
}

@property (nonatomic, retain) NSString              *userid;
@property (nonatomic, retain) NSDictionary          *dic;
@property (nonatomic, retain) NSArray               *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary   *tempValues;
@property (nonatomic, retain) UITextField           *textFieldBeingEdited;
@property (nonatomic, retain) UITableView           *orderTableView;

-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

-(id)initUserInfo;

//-(void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end