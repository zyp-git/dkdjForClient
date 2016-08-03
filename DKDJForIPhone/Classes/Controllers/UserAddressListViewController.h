//
//  ShopListViewController.h
//  EasyEat4iPhone
//
//  Created by dev on 11-12-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadCell.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "CachedDownloadManager.h"
#import "HJViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2
@class UserAddressListViewController;
@protocol UserAddressListViewControllerDelegate <NSObject>

-(void)UserAddressListViewController:(UserAddressListViewController *) VC withModel:(UserAddressMode*)UserAddressMode;

@end

@interface UserAddressListViewController :  HJViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, UIAlertViewDelegate>
{

    BOOL isOutAddr;//标志地址是从外部传入，不需要release
    BOOL                isFollowers;
    BOOL                hasMore;
    
    int                 page;
    NSString*           shopname;
    NSString*           shoptype;
    NSString*           istuan;
    NSString*           brandid;
    
    NSString*           uaddress;
    NSString*           isbrand;
    
    LoadCell*           loadCell;
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    UITapGestureRecognizer *backClick;

    NSString* addressID;//当前编辑的地址编号
    int editType;
    NSInteger row;
    BOOL isShowDeleteTable;
    NSString *sexs;
    UIView *editView;
}

@property (nonatomic, strong) NSMutableArray *address;
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *gTypeID;
@property (nonatomic, strong) NSString *cTypeID;
@property (nonatomic, strong) NSString *defaultPath;
@property (nonatomic, strong) NSString *uduserid;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* userPhone;
@property (nonatomic, strong) NSString* userAddr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isFromOrder;
@property (weak,nonatomic) id<UserAddressListViewControllerDelegate> delegate;

//商家分类
- (id)initWithGiftType:(NSString*)giftType giftCType:(NSString*)giftCType;

//附近商家
- (id)initWithDefault;

- (id)initWithArry:(NSMutableArray*)ary;

//搜索
- (id)initWithKeywords:(NSString*)keywords;


-(void)getGiftList;

-(void)getShopListFix;

-(void)initPara;

@end

