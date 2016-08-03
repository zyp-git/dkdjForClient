//
//  ShopCardListViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 13-2-26.
//
//

#import <UIKit/UIKit.h>
#import "ShopCardModel.h"
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "HJTableViewController.h"

@interface ShopCardListViewController : HJTableViewController<UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate>
{
    NSMutableArray      *orders;
    BOOL                hasMore;
    int                 page;
    NSString            *userid;
    LoadCell            *loadCell;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
}

@property (nonatomic, retain) NSMutableArray *orders;
@property (nonatomic, retain) NSString *userid;

- (id)initWithUserid;

@end