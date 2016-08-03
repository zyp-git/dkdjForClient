//
//  UserCommentTalbeViewController.h
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "HJTableViewController.h"
#import "TwitterClient.h"
#import "LoadCell.h"
#import "CachedDownloadManager.h"
@interface UserCommentTalbeViewController : HJTableViewController<MBProgressHUDDelegate>
{
    UITapGestureRecognizer *backClick;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    
    NSMutableArray *commentList;
    int page;
    BOOL hasMore;
    NSString *FoodID;
    CachedDownloadManager *imageDownload1;
}

-(UserCommentTalbeViewController *)initWithcFoodID:(int)foodid;
@property (nonatomic, strong)NSString *FoodID;
@end
