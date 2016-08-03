//
//  FoodListViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoadCell.h"
#import "TwitterClient.h"
#import "FShop4ListModel.h"
#import "MBProgressHUD.h"
#import "FoodTypeViewController.h"
#import "CachedDownloadManager.h"
#import "FoodTypeModel.h"
#import "HJViewController.h"
#import "ActivityModel.h"
#import "ShopTypeModel.h"
#import "ShopTyePopView.h"
#import "MyLocationModel.h"
#import "HJButton.h"
#import "HJListViewPop.h"
#import "HJLabel.h"
#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface ShopNewListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate, UISearchBarDelegate, HJPopViewBaseDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    int select;//1使用foods1的内容 2使用foods2的内容
    BOOL                isFollowers;
    BOOL                hasMoreActivity;
    BOOL                hasMoreShop;
    
    NSString            *tid;
    NSString            *shopid;

    float            sentmoney;//配送费
    float startSend;//起送金额
    float fullFree;//满多少免费送
    float sumPrice;//总金额
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    TwitterClient       *twitterClient1;
    MBProgressHUD       *_progressHUD1;
    //NSMutableDictionary *shopcartDict;//foodid FoodInOrderModel
    UILabel             *shopcartLabel;
    
    int viewHeight;
    BOOL isShowType;//是否显示过分类
    int shopTotalPage;
    int shopPage;
    
    int activityTotalPage;
    int activityPage;
    
    BOOL                hasMoreShopType;
    int                 pageShopType;
    int totalPageShopType;
    
    BOOL hasShowMenu;
    HJListViewPop *popView;
    HJListViewPop *popView1;
    HJListViewPop *popView2;
    NSUInteger          row;
    
    NSString            *uduserid;
    
    
    UITableView *typeTableView;
    
    //NSMutableArray      *foodtypes;
    NSInteger selectIndex;//当前选中的类型索引
    CachedDownloadManager *imageDownload1;
    CachedDownloadManager *imageDownload;
    UITapGestureRecognizer *gotoCityClick;
    UITapGestureRecognizer *showFoodTypeClick;
    NSString *getType;//2同城
    NSString *getShopTypeID;//商家分类
    BOOL isRemoveAllCell;
    BOOL isChangeCity;
    UITapGestureRecognizer *backClick;
    
    NSString *sortFlag;//0降序排序，1升序排序
    NSString *sortname;//排序字段
    
    HJButton *btnOrder1;
    HJButton *btnOrder2;
    HJButton *btnOrder3;
    
    UIView *processView;
    UIView *noDataView;
    UIImageView *noDateImag;
    UIView *noDataViewInfo;
    UITapGestureRecognizer *errViewClick;
    
    int OpenType; //0 关闭 1营业 2所有
    BOOL isShowLocationLabel;
    BOOL isFavor;
    
    UILabel *processInfo;
    UILabel *processInfo1;
    UITableView *dateTableView;
    
    NSMutableArray *orderByArry;
    NSMutableArray *activsArry;
    int userOrderByIndex;//当前使用的排序索引
    int isPromotion;//是否有活动 0没有 1 有 -1所有
    UIView* heardView;
    BOOL isReadData;
    
}
@property(nonatomic, retain)HJLabel *lbTitle;

@property(nonatomic, retain)UIButton *foodType;
@property (nonatomic, retain) NSString *getShopTypeID;//获取商家分类id
@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSMutableArray*     shops;
@property (nonatomic, retain) NSMutableArray*     shops1;
@property (nonatomic, retain) NSMutableArray*     shops2;
@property (nonatomic, retain)NSString *searchKey;
@property (nonatomic, retain) NSString *defaultPath;
//@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
//@property (nonatomic, retain) UITableView *dateTableView;

- (id)initWithOpenType:(int)oType  shopType:(NSString *)typeID;
- (id)initWithTypeId:(NSString*)type;
- (id)initWithKeywords:(NSString *)key;
//收藏
- (id)initWithFavor:(NSString *)userID;
//餐品数量增加1
-(void)plusFoodToOrder:(UIButton *)sender;

//餐品数量减少1
-(void)minusFoodToOrder:(UIButton *)sender;

-(void) updateTable;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AddtoCart;

-(void) doSum;

-(void) GetData;

@end