//
//  ShopCartViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-16.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "FoodInOrderModel.h"
#import "HJViewController.h"
#import "HJEditShopCartNumberPopView.h"
#import "OrderListCell.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface OrderListNewViewController :  HJViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate,UIScrollViewDelegate,OrderListCellDelegate>{
    NSString*           shopidSC;
    int sumCountSC;
    UILabel             *shopcartLabelSC;
    float sumPriceSC ;
    int viewHeight;
    NSUInteger selectIntex;
    int colorIndex;
    UIButton *btnCur;//当前编辑菜品勾选的
    UITapGestureRecognizer *backClick;
    
    TwitterClient       *twitterClient;
    MBProgressHUD       *_progressHUD;

    NSString *uduserid;
    NSString *today;
    NSString *state;
    int pageindex;
    BOOL hasMore;
    UIButton *btnProcess;
    UIButton *btnFinish;
    int select;
}

@property (nonatomic, retain) NSString *shopidSC;
@property (nonatomic, retain) UILabel *shopcartLabelSC;
@property (nonatomic, weak) UITableView * orderTableView;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;
@property(nonatomic, retain) NSArray *colorArry;

////餐品数量增加1
//-(void)plusFoodToOrderSC:(id)sender;
//
////餐品数量减少1
//-(void)minusFoodToOrderSC:(id)sender;
//
////-(void) updateTableSC;
//
//-(void) UpdateShopCartSC:(FoodInOrderModel *)foodmodel;
//
//-(void) doSum;

-(void)getShopCart;

@end
