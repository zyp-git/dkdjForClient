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
#import "OrderDetailList.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface UnPayOrderListViewController :  HJViewController<UITableViewDelegate, UITableViewDataSource, HJPopViewBaseDelegate, MBProgressHUDDelegate>{
    NSString*           shopidSC;
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    int sumCountSC;
    //NSMutableDictionary *shopcartDictSCTemp;//foodid FoodInOrderModel
    //NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    //NSMutableArray      *shopcartDictSC;//foodid FoodInOrderModel
    UILabel             *shopcartLabelSC;
    UITableView *tableView;
    UIView *bottomView;//下面的显示
    UILabel *price;
    float sumPriceSC ;
    int viewHeight;
    NSUInteger selectIntex;
    UIButton *btnCur;//当前编辑菜品勾选的
    UITapGestureRecognizer *backClick;
    OrderDetailList *orderList;
    int pageindex;
    BOOL hasMore;
    NSString *uduserid;
    NSString *today;
    NSString *state;
}

@property (nonatomic, retain) NSString *shopidSC;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictSCTemp;//购物车
//@property (nonatomic, retain) NSMutableArray *shopcartDictSC;//购物车
@property (nonatomic, retain) UILabel *shopcartLabelSC;
//@property (nonatomic, retain) NSMutableDictionary *shopcartDictForSaveFile;//购物车
@property (nonatomic, retain) UITableView *tableView;
//- (id)initWithShopCartDict:(NSMutableDictionary*)shopcartDictSC ShopId:(NSString*)ShopId;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;


@property(nonatomic, retain) UIButton *btnAllCheck;
//餐品数量增加1
-(void)plusFoodToOrderSC:(id)sender;

//餐品数量减少1
-(void)minusFoodToOrderSC:(id)sender;

-(void) updateTableSC;

-(void) UpdateShopCartSC:(FoodInOrderModel *)foodmodel;

-(void) doSum;

-(void)getShopCart;

@end
