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
#import "FoodTypeViewController.h"
#import "FoodTypeModel.h"
#import "HJViewController.h"
#import "HJLabel.h"
#import "ShopDetailModel.h"
#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2
@class FoodListViewController;
@protocol FoodListViewControllerDelegate <NSObject>

-(void)FoodListViewControllerLetShopPushController:(UIViewController *) controller isPush:(BOOL)isPush;

@end

@interface FoodListViewController :  HJViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate>
{
    
    int select;
    BOOL                isFollowers;
    BOOL                hasMore;
    int                 page;
    NSString            *tid;
    float            sentmoney;//配送费
    float startSend;//起送金额
    float fullFree;//满多少免费送
    float sumPrice;//总金额
    LoadCell            *loadCell;
    
    TwitterClient       *twitterClient1;
    MBProgressHUD       *_progressHUD1;
    
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    
    int viewHeight;
    BOOL isShowType;//是否显示过分类
    
    NSUInteger          row;
    NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    
    NSInteger selectIndex;//当前选中的类型索引
    UITapGestureRecognizer *gotoShopCartClick;
    UITapGestureRecognizer *showFoodTypeClick;
    NSMutableArray <FoodTypeModel *>*     foodTypes;
    int isBespeak;//0不是预约 1支持预约
    int buyType;//购买类型，目前商铺线上活动回过来，3
    int shopType;//0：统一商铺；1：独立商铺；2：同城商铺 独立上铺和同城上铺不能下单
    
    UIView *bottomView;
    HJLabel *bottomLabel;
    UIButton *bottomButon;
    
    UILabel *lbTime;
    UILabel *lbSendMoney;
    UILabel *lbStartSend;
}

@property (nonatomic, strong) NSString *uduserid;
@property (nonatomic, strong) NSString *activityID;//活动编号，活动过来购买物品的编号
@property (nonatomic, strong) NSMutableArray <FoodModel *>*     foods;
@property (nonatomic, strong) NSString *shopid;
@property (nonatomic, strong) NSString *foodtypeid;
@property (nonatomic, assign) NSInteger  indexSelected;
@property (nonatomic, strong) UILabel *shopcartLabel;
@property (nonatomic, strong) NSString *defaultPath;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *typeTableView;
@property (nonatomic, weak) UIView * cartView;
@property (nonatomic, strong) FoodModel *foodModel;
@property (nonatomic, weak) id<FoodListViewControllerDelegate> delegate;

-(void)startReadFood:(ShopDetailModel *)shop;
- (id)initWithShopid:(NSString*)shopid sentmoney:(NSString*)sentmoneyString  startSend:(NSString *)start fullFree:(float)full bspeak:(int)type   shopType:(int)shoptype;
- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full bspeak:(int)type  buytype:(int)buytype activityid:(NSString *)activityid shopType:(int)shoptype;
- (id)initWithTypeId:(NSString*)type;

//餐品数量增加1
-(void)plusFoodToOrder:(UIButton *)sender;

//餐品数量减少1
-(void)minusFoodToOrder:(UIButton *)sender;

-(void) updateTable;

-(void) UpdateShopCart:(FoodModel *) foodmodel;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AddtoCart;

//-(void) doSum;

-(void) GetData;

@end