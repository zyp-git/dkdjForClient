//
//  OrderList.h
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "HJTableViewController.h"


@interface LotterOrderListViewController : HJTableViewController<UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate>
{
    NSMutableArray      *orders;
    BOOL                hasMore;
    int                 page;
    NSString            *userid;
    LoadCell            *loadCell;
    TwitterClient       *twitterClient;
    UITableView         *ordersTableView;
    MBProgressHUD       *_progressHUD;
    
}
//Today 1表示获取今天的订单
//Ordertype 表示订单类型订单类型：：0普通订单1：团购订单2:秒杀订单3:积分兑换订单
@property (nonatomic, retain) NSMutableArray *orders;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) UITableView *ordersTableView;

- (id)initWithUserid:(NSString*)stateString;

@end