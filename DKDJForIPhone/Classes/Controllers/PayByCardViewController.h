//
//  PayByCardViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-11.
//
//

#import <UIKit/UIKit.h>

#import "MyCardModel.h"
#import "TwitterClient.h"
#import "LoadCell.h"
#import "MBProgressHUD.h"
#import "HJTableViewController.h"

@protocol SelectCardViewControllerDelegate <NSObject>

- (void)SelectCardViewControllerChanged:(NSString *)usedcardid;

@end

@interface PayByCardViewController : HJTableViewController<UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate, SelectCardViewControllerDelegate>
{
    NSMutableArray      *orders;
    BOOL                hasMore;
    int                 page;
    NSString            *userid;
    LoadCell            *loadCell;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSIndexPath         *lastIndexPath;
    NSString            *cardid;
    
}

@property (nonatomic, retain) NSMutableArray *orders;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (nonatomic, retain) NSString *cardid;

- (id)initWithUserid;

@property (nonatomic,retain) id<SelectCardViewControllerDelegate> delegate;
@end
