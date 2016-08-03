//
//  ShopNewViewController.h
//  HangJingForiphone
//
//  Created by ihangjing on 16/2/24.
//
//

#import "HJViewController.h"
#import "TwitterClient.h"
#import "FShop4ListModel.h"
#import "ShopDetailModel.h"
#import "FoodListViewController.h"
#import "ShopDetailViewController.h"
#import "FShop4ListModel.h"
@interface ShopNewViewController : HJViewController<MBProgressHUDDelegate,UIScrollViewDelegate>
{
    UITapGestureRecognizer *backClick;
    UIButton *btnShopFav;
    MBProgressHUD *_progressHUD;
    TwitterClient *twitterClient;
    FShop4ListModel *shop;//收藏夹过来的商家
    ShopDetailViewController *shopDetailViewController;
    FoodListViewController *foodListViewController;
    NSString *ulat;
    NSString *ulng;
    //FShop4ListModel *shop;
}

@property(nonatomic, retain) ShopDetailModel *shopDetail;
@property(nonatomic, retain) NSString *uduserid;
@property(nonatomic, retain) NSString *ShopId;

- (id)initWithShop:(FShop4ListModel*)_shop;
@end
