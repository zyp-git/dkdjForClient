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
#import "OrderStateMode.h"
#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface OrderStateListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate, UISearchBarDelegate, HJPopViewBaseDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
{
    int select;//1使用foods1的内容 2使用foods2的内容
    
    
    NSString            *tid;
    NSString            *shopid;

    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    TwitterClient       *twitterClient1;
    MBProgressHUD       *_progressHUD1;
    //NSMutableDictionary *shopcartDict;//foodid FoodInOrderModel
    UILabel             *shopcartLabel;
    
    
    
    
    
    BOOL                hasMoreShopType;
    int                 pageShopType;
    int totalPageShopType;
    
    BOOL hasShowMenu;
    
    NSUInteger          row;
    
    NSString            *uduserid;
    
    
    UITableView *typeTableView;
    
    //NSMutableArray      *foodtypes;
    NSInteger selectIndex;//当前选中的类型索引
    CachedDownloadManager *imageDownload1;
    CachedDownloadManager *imageDownload;
    
    NSString *getType;//2同城
    NSString *getShopTypeID;//商家分类
    BOOL isRemoveAllCell;
    BOOL isChangeCity;
    UITapGestureRecognizer *backClick;
    
    NSString *sortFlag;//0降序排序，1升序排序
    NSString *sortname;//排序字段
    
    
    
   
    
    int OpenType; //0 关闭 1营业 2所有
    BOOL isShowLocationLabel;
    BOOL isFavor;
    
    UITableView *dateTableView;
    int userOrderByIndex;//当前使用的排序索引
    int isPromotion;//是否有活动 0没有 1 有 -1所有
    UIView* heardView;
    int orderState;
    
}
#pragma mark GetShopList
-(void) GetOrderStateListData:(BOOL)isShowProcess orderState:(int)state;

@property (nonatomic, retain) NSString *getShopTypeID;//获取商家分类id
@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSMutableArray*     orderStates;

- (id)initOrderID:(NSString *)orderid;

@end