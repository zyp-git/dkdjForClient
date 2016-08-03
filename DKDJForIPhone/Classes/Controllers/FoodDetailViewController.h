//
//  FoodDetailViewController.h
//  HMBL
//
//  Created by ihangjing on 13-11-24.
//
//

#import "HJViewController.h"
#import "FoodModel.h"
#import "ImageDownloader.h"
#import "CachedDownloadManager.h"
#import "TwitterClient.h"

@interface FoodDetailViewController : HJViewController<MBProgressHUDDelegate>
{
    
    UITapGestureRecognizer *backClick;
    UITapGestureRecognizer *gotoShopCartClick;
    
    UILabel *price;
    NSMutableArray *numViewList;
    CachedDownloadManager *imageDowloader;
    UIImageView *img;
    UIImageView *TImg;//一些特殊标签的图标
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    
    float viewHeight;
    int AttrCount;
    UIScrollView *myscroll;
    BOOL isShowGoToShop;
    int buyType;

}
-(FoodDetailViewController *)initWithFood:(FoodModel *)Food ShowGoToShop:(BOOL)ShowGoToShop shopType:(int)shoptype;

@property (nonatomic, retain)FoodModel *food;

@property(nonatomic, retain) NSString *uduserid;
@end
