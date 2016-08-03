//
//  ShopDetailViewController.h
//  EasyEat4iPhone
//
//  Created by dev on 12-1-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadCell.h"
#import "ProgressWindow.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"
#import "ShopDetailModel.h"
#import "CachedDownloadManager.h"
#import "ActivityModel.h"
#import "CouponModel.h"
#import "FShop4ListModel.h"
#import "ImageScrollViewControl.h"
#import "HJLabel.h"
#import "HJButton.h"
#import "UserCommentModel.h"
#import "HJScrollView.h"
@interface ShopDetailViewController :  HJViewController<MBProgressHUDDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    //TFConnection        *connection;
    TwitterClient       *twitterClient;
    NSString            *telString;
    MBProgressHUD       *_progressHUD;
    
    NSString            *ulat;
    NSString            *ulng;

    NSString *uduserid;//用户编号
    
    UITapGestureRecognizer *backClick;
    
    HJLabel *lOtherInfo;
    
    UITableView *tvListView;
    
    UIButton *btnShopFav;//收藏
    
    BOOL hasMore;
    BOOL hasMoreCoupon;
    BOOL hasMoreActivity;
    
    int foodPage;
    
    int activityPage;
    
    int nShopType;//0 外卖商家 1电影 2 KTV
    
    int couponPage;
    int isBespeak;//0不是预约 1支持预约
    BOOL isDowLog;
    
    BOOL isRemoveAllCell;
    
    //FShop4ListModel *shop;
    int buyType;//活动传过来专用
    ImageScrollViewControl *advView;

    UIView *tagView;

    
    UITapGestureRecognizer *foodClick;
    UITapGestureRecognizer *telClick;
    UITapGestureRecognizer *commandClick;
    
    int viewHeight;
    BOOL isCommand;

    UIView *addressView;
    UIView *secondView;
    UIView *fourthView;
    HJLabel *viewCommand;
    
    //评论
    NSMutableArray *commentList;
    int page;
    NSString *FoodID;
    
    
}
#pragma mark 获取评论列表
-(void)getCommentList;
-(id)initWithShopDetail:(ShopDetailModel *)model;
- (id)initWithShopId:(NSString*)ShopId  shopType:(int)shoptype;
- (id)initWithShop:(FShop4ListModel*)_shop;
- (id)initWithShop:(FShop4ListModel*)_shop buytype:(int)buytype activityid:(NSString *)activityid;
- (void) cancel:  (id) sender;

- (void)GetShopDetail;

- (void)gotoOrder;
-(ShopDetailModel *)loadView:(NSDictionary *)json;

@property(nonatomic, retain) ShopDetailModel *shopDetail;
@property (nonatomic, retain) NSString *ShopId;
@property (nonatomic, retain) NSString *activityID;

@property (nonatomic, retain) NSString *uduserid;//用户编号


@end
