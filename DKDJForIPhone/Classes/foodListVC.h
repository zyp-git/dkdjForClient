//
//  foodListVC.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/19.
//
//

#import "HJViewController.h"

@interface foodListVC : HJViewController<UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate>
{
    NSMutableArray*     foods1;
    NSMutableArray*     foods2;
    NSMutableArray*     foods;
    int select;
    BOOL                isFollowers;
    BOOL                hasMore;
    int                 page;
    NSString            *tid;
    NSString            *shopid;
    NSString            *foodtypeid;
    
    float            sentmoney;//配送费
    float startSend;//起送金额
    float fullFree;//满多少免费送
    float sumPrice;//总金额
    LoadCell            *loadCell;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    TwitterClient       *twitterClient1;
    MBProgressHUD       *_progressHUD1;
    //NSMutableDictionary *shopcartDict;//foodid FoodInOrderModel
    UILabel             *shopcartLabel;
    
    int viewHeight;
    BOOL isShowType;//是否显示过分类
    
    
    
    NSUInteger          row;
    NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    NSString            *uduserid;
    
    UITableView *typeTableView;
    
    //NSMutableArray      *foodtypes;
    NSInteger selectIndex;//当前选中的类型索引
    CachedDownloadManager *imageDownload;
    UITapGestureRecognizer *gotoShopCartClick;
    UITapGestureRecognizer *showFoodTypeClick;
    NSMutableArray*     foodTypes;
    int isBespeak;//0不是预约 1支持预约
    int buyType;//购买类型，目前商铺线上活动回过来，3
    int shopType;//0：统一商铺；1：独立商铺；2：同城商铺 独立上铺和同城上铺不能下单
    
    UIView *bottomView;
    HJLabel *bottomLabel;
    UIButton *bottomButon;
    //ShopDetailModel *shopDetail;
    
    UILabel *lbTime;
    UILabel *lbSendMoney;
    UILabel *lbStartSend;
}

@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSString *activityID;//活动编号，活动过来购买物品的编号
@property (nonatomic, retain) NSMutableArray*     foods1;
@property (nonatomic, retain) NSMutableArray*     foods2;
@property (nonatomic, retain) NSString *shopid;
@property (nonatomic, retain) NSString *foodtypeid;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDict;//购物车
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车

@property (nonatomic, retain) UILabel *shopcartLabel;
@property (nonatomic, retain) NSString *defaultPath;
//@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *typeTableView;
@property (nonatomic, retain) FoodModel *foodModel;

-(void)startReadFood:(ShopDetailModel *)shop;
- (id)initWithShopid:(NSString*)shopid sentmoney:(NSString*)sentmoneyString  startSend:(NSString *)start fullFree:(float)full bspeak:(int)type   shopType:(int)shoptype;
- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full bspeak:(int)type  buytype:(int)buytype activityid:(NSString *)activityid shopType:(int)shoptype;
- (id)initWithTypeId:(NSString*)type;

//餐品数量增加1
-(void)plusFoodToOrder:(id)sender;

//餐品数量减少1
-(void)minusFoodToOrder:(id)sender;

-(void) updateTable;

-(void) UpdateShopCart:(FoodModel *) foodmodel;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AddtoCart;

-(void) doSum;

-(void) GetData;

@end
