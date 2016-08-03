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
#import "GuidABCModel.h"
#import "ShopTypeModel.h"
#import "HJViewController.h"
#import "ShopTyePopView.h"
#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface GuidShopListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate, HJPopViewBaseDelegate>
{
    NSMutableArray*     guids1;
    NSMutableArray*     ABCNames;
    NSMutableArray*     guids2;
    NSMutableArray*     guids3;
    int select;//1使用foods1的内容 2使用foods2的内容
    BOOL                isFollowers;
    BOOL                hasMore;
    int                 page;
    int totalPage;
    
    BOOL                hasMoreFloor;
    int                 pageFloor;
    int totalPageFloor;
    
    
    BOOL                hasMoreShopType;
    int                 pageShopType;
    int totalPageShopType;
    
    
    
    BOOL isRemoveAllCell;
    NSString            *tid;
    NSString            *shopid;
    NSString            *foodtypeid;

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
    
    
    int Mark;
    BOOL BoolMark;
    
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
    
    int getType;//0字母 1楼层 2分类
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    ShopTypeModel *typeModel;
    
}

@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSString *shopid;
@property (nonatomic, retain) NSString *foodtypeid;
@property (nonatomic, retain)UILabel *labABCIndexTitle;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDict;//购物车
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车

@property (nonatomic, retain) NSString *defaultPath;
//@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
@property (nonatomic, retain) UITableView *dateTableView;
@property (nonatomic, retain) FShop4ListModel *couponModel;


- (id)initWithShopid:(NSString*)shopid sentmoney:(NSString*)sentmoneyString  startSend:(NSString *)start fullFree:(float)full;

- (id)initWithTypeId:(NSString*)type;

//餐品数量增加1
-(void)plusFoodToOrder:(UIButton *)sender;

//餐品数量减少1
-(void)minusFoodToOrder:(id)sender;

-(void) updateTable;

-(void) UpdateShopCart:(FShop4ListModel *) model;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AddtoCart;

-(void) doSum;

-(void) GetData;

@end