//
//  MyFriendsListViewController.h
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "HJViewController.h"
#import "DBHelper.h"
#import "CachedDownloadManager.h"
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MyCouponModel.h"
@interface MyFriendsListViewController : HJViewController<MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    DBHelper *db;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSString *userID;
    int indexPage;
    NSMutableArray *searchList;
    int viewHeight;
    int tableViewType;
    LoadCell            *loadCell;
    UISearchBar* searchbar;
    
    BOOL isShowDeleteTable;
    NSUInteger row1;//当前操作的行
    UITapGestureRecognizer *backClick;
    MyCouponModel *couponModel;
    int optIndex;
    
}
@property (nonatomic, retain)NSMutableArray *myFriendsList;
@property (nonatomic, retain) CachedDownloadManager *imageDowload;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *deleteTableView;
@property (nonatomic, retain)NSString *searchValue;
-(MyFriendsListViewController *)initWithcUserID:(NSString *)userid;
-(MyFriendsListViewController *)initWithcCoupon:(MyCouponModel *)model userid:(NSString *)userid;
@end
