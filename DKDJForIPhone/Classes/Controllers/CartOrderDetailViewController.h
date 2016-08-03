////
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "CartOrderDetailModel.h"
#import "HJTableViewController.h"

@interface CartOrderDetailViewController : HJTableViewController<MBProgressHUDDelegate>
{
    NSMutableArray      *foods;
    NSString            *orderid;

    TwitterClient       *twitterClient;

    
    NSMutableArray      *shopcartDict;
    
    NSString            *stateString;
    
    LoadCell            *loadCell;
    MBProgressHUD       *_progressHUD;
    CartOrderDetailModel *cartOrder;
    UITapGestureRecognizer *backClick;
}

@property (nonatomic, retain) NSMutableArray *foods;
@property (nonatomic, retain) NSString *orderid;
@property (nonatomic, retain) NSMutableArray *shopcartDict;
@property (nonatomic, retain) NSString *stateString;
@property(nonatomic, retain)CartOrderDetailModel *cartOrder;

- (id)initWithOrderid:(NSString*)OrderId;

@end