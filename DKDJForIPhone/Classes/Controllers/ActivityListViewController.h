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
#import "ActivityModel.h"
#import "MBProgressHUD.h"
#import "FoodTypeViewController.h"
#import "CachedDownloadManager.h"
#import "FoodTypeModel.h"
#import "HJViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface ActivityListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate>
{
    NSMutableArray*     activitys1;
    NSMutableArray*     activitys2;
    NSMutableArray*     activitys;
    int select;//1使用foods1的内容 2使用foods2的内容
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
    int totalPage;
    
    
    
    NSUInteger          row;
    NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    NSString            *uduserid;
    
    
    UITableView *typeTableView;
    
    //NSMutableArray      *foodtypes;
    NSInteger selectIndex;//当前选中的类型索引
    CachedDownloadManager *imageDownload;
    UITapGestureRecognizer *gotoShopCartClick;
    UITapGestureRecognizer *showFoodTypeClick;
    
    UITapGestureRecognizer *imgTapRecognize;
    
    UITapGestureRecognizer *imgTapRecognize1;
    
}

@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSMutableArray*     activitys1;
@property (nonatomic, retain) NSMutableArray*     activitys2;
@property (nonatomic, retain) NSString *shopid;
@property (nonatomic, retain) NSString *foodtypeid;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDict;//购物车
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车

@property (nonatomic, retain) UIImageView *imLeft;
@property (nonatomic, retain) NSString *defaultPath;
//@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
@property (nonatomic, retain) UITableView *dateTableView;
@property (nonatomic, retain) UIImageView *imRight;
@property (nonatomic, retain) ActivityModel *activityModel;


- (id)initWithShopid:(NSString*)shopid sentmoney:(NSString*)sentmoneyString  startSend:(NSString *)start fullFree:(float)full;

- (id)initWithTypeId:(NSString*)type;

//餐品数量增加1
//-(void)plusFoodToOrder:(id)sender;

//餐品数量减少1
//-(void)minusFoodToOrder:(id)sender;

-(void) updateTable;

-(void) UpdateShopCart:(ActivityModel *) model;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

//-(void)AddtoCart;

-(void) doSum;

//-(void) GetData;

@end