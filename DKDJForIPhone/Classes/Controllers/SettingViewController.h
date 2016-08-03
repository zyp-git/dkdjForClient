//
//  SettingViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "HJViewController.h"
#import "HJScrollView.h"
#import "HJView.h"
#import "TwitterClient.h"
#import "HJLabel.h"
#import "UserInfoNewViewController.h"
#import "CartOrderListViewController.h"
#import "OrderListNewViewController.h"
#import "MyPointListViewController.h"
#import "ChangePasswordViewController.h"
#import "ShopNewListViewController.h"
#import "UserAddressListViewController.h"
#import "CachedDownloadManager.h"
#import "MBProgressHUD.h"
@interface SettingViewController : HJViewController<UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>
{
    //UITapGestureRecognizer *viewClick;
    UIImage *viewroundImage;
    HJScrollView *scrollView;
    float viewHeight;
    
    HJView *noLoginView;
    
    UIButton *userinfoView;
    
    UILabel *userName;
    HJLabel *point;
    TwitterClient *twitterClient;
    
    UIImageView *userImagView;
    UIButton *logout;
    BOOL isGotoPay;
    MBProgressHUD *_progressHUD;
    float payMoeny;
}
@property (nonatomic, retain)NSString *uduserid;
@property (nonatomic, retain)NSString *payId;
@property (nonatomic, retain)NSString *uduserName;
@property (nonatomic, retain)NSString *uduserPoint;
@property (nonatomic, retain)NSString *myICONet;
@property (nonatomic, retain)NSString *myICOPath;
@property (nonatomic, retain)UIImage *myICO;


@end
