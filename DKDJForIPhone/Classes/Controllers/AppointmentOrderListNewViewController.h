//
//  ShopCartViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-16.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "AppointmentOrderDetailModel.h"
#import "HJViewController.h"
#import "HJEditShopCartNumberPopView.h"
#import "CachedDownloadManager.h"
#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface AppointmentOrderListNewViewController :  HJViewController<UITableViewDelegate, UITableViewDataSource, HJPopViewBaseDelegate, MBProgressHUDDelegate>{
    NSString*           shopidSC;
    int sumCountSC;
    //NSMutableDictionary *shopcartDictSCTemp;//foodid FoodInOrderModel
    //NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    //NSMutableArray      *shopcartDictSC;//foodid FoodInOrderModel
    UILabel             *shopcartLabelSC;
    UITableView *tableView;
    float sumPriceSC ;
    int viewHeight;
    NSUInteger selectIntex;
    int colorIndex;
    UIButton *btnCur;//当前编辑菜品勾选的
    UITapGestureRecognizer *backClick;
    CachedDownloadManager *imageDownload;
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;
    NSMutableArray      *orders;
    NSMutableArray      *orders1;
    NSMutableArray      *orders2;
    NSString *uduserid;
    NSString *today;
    NSString *state;
    int pageindex;
    BOOL hasMore;
    int select;
}

@property (nonatomic, retain) NSString *shopidSC;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictSCTemp;//购物车
//@property (nonatomic, retain) NSMutableArray *shopcartDictSC;//购物车
@property (nonatomic, retain) UILabel *shopcartLabelSC;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车
@property (nonatomic, retain) UITableView *tableView;
//- (id)initWithShopCartDict:(NSMutableDictionary*)shopcartDictSC ShopId:(NSString*)ShopId;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;


-(void) doSum;

-(void)getShopCart;

@end
