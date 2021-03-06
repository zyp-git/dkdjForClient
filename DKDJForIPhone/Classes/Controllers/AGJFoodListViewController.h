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
#import "FoodModel.h"
#import "MBProgressHUD.h"
#import "FoodTypeViewController.h"
#import "CachedDownloadManager.h"
#import "FoodTypeModel.h"
#import "HJViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface AGJFoodListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate>
{
    NSMutableArray*     foods1;
    NSMutableArray*     foods2;
    NSMutableArray*     foods;
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
    
    
    UITableView *tableView;
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
@property (nonatomic, retain) NSMutableArray*     foods1;
@property (nonatomic, retain) NSMutableArray*     foods2;
@property (nonatomic, retain) NSString *shopid;
@property (nonatomic, retain) NSString *foodtypeid;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDict;//购物车
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车

@property (nonatomic, retain) UIImageView *imLeft;
@property (nonatomic, retain) NSString *defaultPath;
//@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *imRight;
@property (nonatomic, retain) FoodModel *foodModel;

- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full;


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