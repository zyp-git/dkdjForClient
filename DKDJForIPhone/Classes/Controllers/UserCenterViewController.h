//

//  EasyEat4iPhone
//
//  Created by OS Mac on 12-3-31.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFConnection.h"
#import "TwitterClient.h"
#import "HJViewController.h"
#import "HJScrollView.h"
#import "ImageDowloadTask.h"
#import "CachedDownloadManager.h"
#import "MBProgressHUD.h"
//#import <AssetsLibrary/AssetsLibrary.h>
@interface UserCenterViewController : HJViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate>{

    NSString            *uduserid;
    TwitterClient       *twitterClient;
    BOOL isShow;//是否显示过登陆界面
    //NSString *haveMoney;
    UILabel *userName;
    UILabel *userMoeny;
    UILabel *userPoint;//积分
    UILabel *userCoupon;//优惠券
    UILabel *userPhone;
    //UILabel *userOPoint;//历史积分
    //UILabel *userYPoint;//公益积分
    UIImageView *userICO;
    MBProgressHUD *_progressHUD;
    //UITapGestureRecognizer *rePassworeClick;
    //UITapGestureRecognizer *myOrderClick;
    UITapGestureRecognizer *userInfoClick;
    
    //UITapGestureRecognizer *MyFriendClick;
    
    HJScrollView *scrollView;
    float viewHeight;
    CachedDownloadManager *imageDowload;
    UIImage *viewroundImage;
    
    UIImagePickerController *imagePicker;
    UITapGestureRecognizer *backClick;

}

@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSString *myICONet;//我的头像网络地址
@property (nonatomic, retain) NSString *myICOPath;//我的头像本地地址
@property (nonatomic, retain) UIImage *myICO;//我的头像图片
@property(nonatomic, retain)NSString *haveMoney;

- (BOOL)IsLogin;
- (void)refreshFields;
@end
