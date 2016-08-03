//
//  MyFriendsBuyListViewController.h
//  HMBL
//
//  Created by ihangjing on 13-12-20.
//
//

#import "HJTableViewController.h"
#import "CachedDownloadManager.h"
#import "TwitterClient.h"
#import "LoadCell.h"
#import "FoodModel.h"
@interface MyFriendsBuyListViewController : HJTableViewController<MBProgressHUDDelegate>
{
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSString *userID;
    NSMutableArray *dataList;
    CachedDownloadManager *frImageDowload;
    CachedDownloadManager *foImageDowload;
    UITapGestureRecognizer *backClick;
    int pageIndex;
    LoadCell *loadCell;
    int selectRow;
    
}
@property (nonatomic, retain)FoodModel *food;
-(MyFriendsBuyListViewController *)initWithcUserID:(NSString *)userid;
@end
