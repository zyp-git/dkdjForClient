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
#import "HJTableViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2
//UIViewController <UITableViewDelegate, UITableViewDataSource>
@interface AreaListViewController :  HJTableViewController<MBProgressHUDDelegate, UIAlertViewDelegate>
{
    NSMutableArray*     area;
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
    
    
    
    NSString*           aid;
    NSString*           gTypeID;
    NSString*           cTypeID;
 
    int areaType;//1 1级区域 2 二级区域。。。
    BOOL isReturn;
    BOOL Return;
    BOOL isModelShow;
    
    UITapGestureRecognizer *backClick;
 
}

@property (nonatomic, retain) NSMutableArray *area;
@property (nonatomic, retain) NSString *aid;
@property (nonatomic, retain) NSString *gTypeID;
@property (nonatomic, retain) NSString *cTypeID;


//商家分类
- (id)initWithGiftType:(NSString*)giftType giftCType:(NSString*)giftCType;

//附近商家
- (id)initWithDefault;

- (id)initWithModelShow;
//城市编号
- (id)initWithCityID:(NSString *)cid;

- (id)initWithCityIDReturn:(NSString *)cid;

//搜索
- (id)initWithKeywords:(NSString*)keywords;


-(void)getGiftList;

-(void)getShopListFix;

-(void)initPara;

@end

