//
//  OrderDetailViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "HJTableViewController.h"

@interface OrderDetailViewController : HJTableViewController<MBProgressHUDDelegate,UIActionSheetDelegate>
{
    NSMutableArray      *foods;
    NSString            *orderid;

    TwitterClient       *twitterClient;
    //UITableView         *ordersTableView;
    NSDictionary        *dic;
    
    NSMutableArray      *shopcartDict;
    
    NSString            *stateString;
    
    LoadCell            *loadCell;
    MBProgressHUD       *_progressHUD;
    NSString *shopTel;
    UITapGestureRecognizer *backClick;
}

@property (nonatomic, retain) NSMutableArray *foods;
@property (nonatomic, retain) NSString *orderid;
//@property (nonatomic, retain) UITableView *ordersTableView;
@property (nonatomic, retain) NSDictionary *dic;
@property (nonatomic, retain) NSMutableArray *shopcartDict;
@property (nonatomic, retain) NSString *stateString;

- (id)initWithOrderid:(NSString*)OrderId;

@end