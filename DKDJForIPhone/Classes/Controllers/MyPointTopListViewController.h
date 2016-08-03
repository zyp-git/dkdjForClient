//
//  MyPointTopListViewController.h
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
@interface MyPointTopListViewController : HJTableViewController<MBProgressHUDDelegate>
{
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSString *userID;
    NSMutableArray *dataList;
    CachedDownloadManager *frImageDowload;
    UITapGestureRecognizer *backClick;
    int pageIndex;
    LoadCell *loadCell;
    int topType; //0普通积分排行版，1公益积分排行榜
    
}
-(MyPointTopListViewController *)initWithcUserID:(NSString *)userid type:(int)type;
@end
