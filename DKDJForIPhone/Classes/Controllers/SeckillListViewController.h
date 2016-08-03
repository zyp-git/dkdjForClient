//
//  SeckillListViewController.h
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import <UIKit/UIKit.h>

#import "LoadCell.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "HJTableViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface SeckillListViewController :  HJTableViewController<MBProgressHUDDelegate>
{
    NSMutableArray*     shops;
    BOOL                isFollowers;
    BOOL                hasMore;
    
    int                 page;
    NSString*           buildingid;
    
    LoadCell*           loadCell;
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    
    UIActivityIndicatorView *indicatorView;
}

@property (nonatomic, retain) NSMutableArray *shops;
@property (nonatomic, retain) NSString *buildingid;

-(void)getShopList;

@end
