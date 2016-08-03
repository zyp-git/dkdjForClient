//
//  MyCouponListViewController.h
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
@interface MyCouponListViewController : HJViewController<UITextFieldDelegate, MBProgressHUDDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    MBProgressHUD   *HUD;
    NSString *userID;
    int indexPage;
    int viewHeight;
    int tableViewType;
    
    LoadCell            *gLoadCell;
    
    BOOL isShowGiverTable;
    NSUInteger row1;//当前操作的行
    UITapGestureRecognizer *backClick;
    UITextField *couponKey;
    MyCouponModel *newCoupon;
    
    float minMoney;
    NSMutableArray *couponKeyList;
    
}
@property (nonatomic, retain)NSMutableArray *dataList;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *giverTableView;
@property (nonatomic, retain)NSString *searchValue;
@property (nonatomic, retain)LoadCell            *loadCell;
-(MyCouponListViewController *)initWithcUserID:(NSString *)userid;

-(MyCouponListViewController *)initWithcHasMoney:(float)money arry:(NSMutableArray *)arry keyArry:(NSMutableArray *)keyArry UserID:(NSString *)userid  LoadCell:(LoadCell *)cell;
@end
