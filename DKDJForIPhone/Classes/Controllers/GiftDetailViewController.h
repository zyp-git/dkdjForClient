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
#import "GiftInfoModel.h"
#import "HJTableViewController.h"

@interface GiftDetailViewController :  HJTableViewController<MBProgressHUDDelegate>
{
    TFConnection        *connection;
    TwitterClient       *twitterClient;
    
    NSString            *GiftId;
    
    NSString            *telString;
    
    NSDictionary        *dic;
    
    //UITableView         *shopdetailTableView;
    MBProgressHUD       *_progressHUD;
    
    NSString            *ulat;
    NSString            *ulng;
    NSInteger userPoint;//用户积分
    NSInteger selectType;//用户选中操作
    UITapGestureRecognizer *backClick;
}

- (id)initWithGiftId:(NSString*)giftId;

- (void) cancel:  (id) sender;

- (void)GetGiftDetail:(NSString*)giftId;

- (void)gotoOrder;

//@property (nonatomic, retain) UITableView *shopdetailTableView;
@property (nonatomic, retain) NSString *GiftId;
@property (nonatomic, retain) GiftInfoModel *GiftModel;
@property (nonatomic, retain) NSString *telString;
@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain)NSString *lotterID;//中奖编号

@end
