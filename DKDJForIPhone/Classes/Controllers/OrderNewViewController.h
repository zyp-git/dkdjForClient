//
//  OrderNewViewController.h
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
#import "OrderDetailNewViewController.h"
#import "OrderStateListViewController.h"
@interface OrderNewViewController : HJViewController<MBProgressHUDDelegate>
{
    UITapGestureRecognizer *backClick;
    UIButton *btnShopFav;
    MBProgressHUD *_progressHUD;
    TwitterClient *twitterClient;
    FShop4ListModel *shop;//收藏夹过来的商家
    OrderDetailNewViewController *shopDetailViewController;
    OrderStateListViewController *foodListViewController;
    NSString *ulat;
    NSString *ulng;
    //FShop4ListModel *shop;
}
@property(nonatomic, retain) NSDictionary *dic;
@property(nonatomic, retain) ShopDetailModel *shopDetail;
@property(nonatomic, retain) NSString *uduserid;
@property(nonatomic, retain) NSString *ShopId;
@property(nonatomic, retain) NSString *orderId;

- (id)initWithOrderId:(NSString*)odid;
@end
