//

//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "LotterOrderDetailModel.h"
#import "HJTableViewController.h"

@interface LotterOrderDetailViewController : HJTableViewController<MBProgressHUDDelegate>
{
    NSMutableArray      *foods;
    NSString            *orderid;

    TwitterClient       *twitterClient;

    
    NSMutableArray      *shopcartDict;
    
    NSString            *stateString;
    
    LoadCell            *loadCell;
    MBProgressHUD       *_progressHUD;
    LotterOrderDetailModel *cartOrder;
}

@property (nonatomic, retain) NSMutableArray *foods;
@property (nonatomic, retain) NSString *orderid;
@property (nonatomic, retain) NSMutableArray *shopcartDict;
@property (nonatomic, retain) NSString *stateString;
@property(nonatomic, retain)LotterOrderDetailModel *cartOrder;

- (id)initWithOrderid:(NSString*)OrderId;

@end