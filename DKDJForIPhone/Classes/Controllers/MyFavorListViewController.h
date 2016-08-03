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
#import "LimitModel.h"
#import "MBProgressHUD.h"
#import "FoodTypeViewController.h"
#import "CachedDownloadManager.h"
#import "FoodTypeModel.h"
#import "HJViewController.h"
#import "ActivityModel.h"
#import "FShop4ListModel.h"
#import "FoodModel.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface MyFavorListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate, UISearchBarDelegate>
{
    int select;//1使用foods1的内容 2使用foods2的内容
    BOOL                isFollowers;
    BOOL                hasMoreFood;
    BOOL                hasMoreShop;
    
    NSString            *tid;
    NSString            *shopid;
    NSString            *foodtypeid;

    float            sentmoney;//配送费
    float startSend;//起送金额
    float fullFree;//满多少免费送
    float sumPrice;//总金额
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    //NSMutableDictionary *shopcartDict;//foodid FoodInOrderModel
    UILabel             *shopcartLabel;
    
    int viewHeight;
    BOOL isShowType;//是否显示过分类
    int shopTotalPage;
    int shopPage;
    
    int foodTotalPage;
    int foodPage;
    
    int optIndex;//操作的行数
    FoodModel *food;
    FShop4ListModel *shop;
    
    
    NSUInteger          row;
    NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    NSString            *uduserid;
    
    
    UITableView *typeTableView;
    
    //NSMutableArray      *foodtypes;
    NSInteger selectIndex;//当前选中的类型索引
    CachedDownloadManager *imageDownload;
    CachedDownloadManager *imageDownload1;
    UITapGestureRecognizer *gotoShopCartClick;
    UITapGestureRecognizer *showFoodTypeClick;
    
    
    int getType;//0商家 1商品
    
    BOOL isRemoveAllCell;
    
    NSMutableArray *shops;
    NSMutableArray *foods;
    
    UIButton *btnFavShop;
    UIButton *btnFavFood;
    
}

@property (nonatomic, retain) NSString *uduserid;

@property (nonatomic, retain) NSString *defaultPath;
//@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
@property (nonatomic, retain) UITableView *dateTableView;



- (id)initWithTypeId:(int)type;


-(void) updateTable;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;



@end