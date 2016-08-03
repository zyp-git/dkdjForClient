//
//  FoodTypeViewController.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "HJViewController.h"
@protocol FoodTypeViewControllerDelegate <NSObject>

- (void) FoodTypeViewControllerValueChanged:(NSString *)typevalue;

@end

@interface FoodTypeViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate>
{
    NSMutableArray      *shoptypes;
    BOOL                hasMore;
    int                 page;
    NSString            *shopid;
    LoadCell            *loadCell;
    TwitterClient       *twitterClient;
    UITableView         *shoptyTableView;
    MBProgressHUD       *_progressHUD;
}

@property (nonatomic, retain) NSMutableArray *shoptypes;
@property (nonatomic, retain) NSString *shopid;
@property (nonatomic, retain) UITableView *shoptyTableView;

- (id)initWithShopid:(NSString*)Shopid;

@property (nonatomic, retain) id<FoodTypeViewControllerDelegate> delegate;
@end