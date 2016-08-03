//
//  SeckillDetailViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import <UIKit/UIKit.h>

#import "LoadCell.h"
#import "ProgressWindow.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJTableViewController.h"

@interface SeckillDetailViewController :  HJTableViewController<MBProgressHUDDelegate>
{
    TFConnection        *connection;
    TwitterClient       *twitterClient;
    
    NSString            *GroupId;
    NSString            *shopid;
    NSString            *title;
    NSString            *price;
    NSString            *uduserid;
    NSString            *state;
    
    NSDictionary        *dic;
    
    //UITableView         *shopdetailTableView;
    MBProgressHUD       *_progressHUD;
    
    NSString            *ulat;
    NSString            *ulng;
    
    NSMutableDictionary *shopcartDict;//foodid FoodInOrderModel
    NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
}

@property (nonatomic, retain) NSMutableDictionary *shopcartDict;//购物车
@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车

- (id)initWithGroupId:(NSString*)GroupId;

- (void) cancel:  (id) sender;

- (void)gotoOrder;

@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSString *GroupId;
@property (nonatomic, retain) NSDictionary *dic;
@property (nonatomic, retain) NSString *shopid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *price;

@end