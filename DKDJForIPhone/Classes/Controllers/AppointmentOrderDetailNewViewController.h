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
#import "CachedDownloadManager.h"
#import "AppointmentOrderDetailModel.h"
#define RegeditViewNumberOfEditableRows        3

#define RegeditViewLabelTag  1024

@interface AppointmentOrderDetailNewViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, MBProgressHUDDelegate>
{
    
    
    
   
    TwitterClient*      twitterClient;
    
   
    
    MBProgressHUD       *_progressHUD;
    
    
    UITapGestureRecognizer *backClick;
    NSMutableArray *foods;
    int startTag;
    int LineCount;
    CachedDownloadManager *imageDownload;
    
}

@property (nonatomic, retain) NSString              *orderID;
@property (nonatomic, retain) NSString              *userName;
@property (nonatomic, retain) AppointmentOrderDetailModel              *OrderDetailModel;

@property (nonatomic, retain) NSString              *userid;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) NSDictionary *dic;


-(void)cancel:(id)sender;
-(void)save:(id)sender;
-(void)textFieldDone:(id)sender;

- (id)initOrderID:(NSString *)orderid;
- (id)initOrderModel:(AppointmentOrderDetailModel *)orderModel;

-(void)animateTextField:(UITextField *)textField up:(BOOL)up;

@end