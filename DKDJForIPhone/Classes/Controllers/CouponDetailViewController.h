//
//  FoodDetailViewController.h
//  HMBL
//
//  Created by ihangjing on 13-11-24.
//
//

#import "HJViewController.h"
#import "CouponModel.h"
#import "ImageDownloader.h"
#import "CachedDownloadManager.h"
#import "TwitterClient.h"
#define startNumberTag 1000//数字显示界面起始tag
#define startPlushTag 2000//增加按钮起始tag
#define startMinTag 3000//减少按钮起始tag
@interface CouponDetailViewController : HJViewController<MBProgressHUDDelegate>
{
    
    UITapGestureRecognizer *backClick;
    
    UILabel *price;
    NSMutableArray *numViewList;
    CachedDownloadManager *imageDowloader;
    UIImageView *img;
    
    float viewHeight;
    int AttrCount;
    UIScrollView *myscroll;
    BOOL isShowGoToShop;
    int buyCount;
    UITextField *numValue;
    
}
-(CouponDetailViewController *)initWithFood:(CouponModel *)Food ShowGoToShop:(BOOL)ShowGoToShop;
@property (nonatomic, retain)CouponModel *food;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@end
