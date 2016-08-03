//
//  FoodDetailViewController.h
//  HMBL
//
//  Created by ihangjing on 13-11-24.
//
//

#import "HJViewController.h"
#import "ActivityModel.h"
#import "ImageDownloader.h"
#import "CachedDownloadManager.h"
#import "TwitterClient.h"
#define startNumberTag 1000//数字显示界面起始tag
#define startPlushTag 2000//增加按钮起始tag
#define startMinTag 3000//减少按钮起始tag
@interface ActivityDetailViewController : HJViewController<MBProgressHUDDelegate>
{
    
    UITapGestureRecognizer *backClick;
    UITapGestureRecognizer *gotoShopCartClick;
    
    UILabel *price;
    NSMutableArray *numViewList;
    CachedDownloadManager *imageDowloader;
    UIImageView *img;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    
    UITapGestureRecognizer *DiscClick;//产品描述单击
    UITapGestureRecognizer *noticeClick;//产品提示单击
    UITapGestureRecognizer *userCommentClick;//用户评论
    float viewHeight;
    int AttrCount;
    UIScrollView *myscroll;
    
    
}
-(ActivityDetailViewController *)initWithFood:(ActivityModel *)Food;

@property (nonatomic, retain)ActivityModel *food;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@end
