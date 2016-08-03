//
//  MyPointListViewController.h
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "HJTableViewController.h"
#import "DBHelper.h"
#import "CachedDownloadManager.h"
#import "TwitterClient.h"
#import "LoadCell.h"
@interface MyPointListViewController : HJTableViewController<UITextFieldDelegate, MBProgressHUDDelegate,  UISearchBarDelegate>
{
    
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSString *userID;
    int indexPage;
    LoadCell            *loadCell;
    
    UITapGestureRecognizer *backClick;
    
}
@property (nonatomic, retain)NSMutableArray *dataList;
-(MyPointListViewController *)initWithcUserID:(NSString *)userid;
@end
