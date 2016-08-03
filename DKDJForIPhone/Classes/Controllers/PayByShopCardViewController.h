//
//  PayByShopCardViewController.h
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

@protocol SelectShopCardViewControllerDelegate <NSObject>

- (void)SelectShopCardViewControllerChanged:(NSString *)usedshopcardid;

@end

@interface PayByShopCardViewController : HJTableViewController<UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate, SelectShopCardViewControllerDelegate>
{
    NSMutableArray      *orders;
    BOOL                hasMore;
    int                 page;
    NSString            *userid;
    LoadCell            *loadCell;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSIndexPath         *lastIndexPath;
    NSString            *shopcardid;
    
}

@property (nonatomic, retain) NSMutableArray *orders;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (nonatomic, retain) NSString *shopcardid;

- (id)initWithUserid;

@property (nonatomic,retain) id<SelectShopCardViewControllerDelegate> delegate;
@end
