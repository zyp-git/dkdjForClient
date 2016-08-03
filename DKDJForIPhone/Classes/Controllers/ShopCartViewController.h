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

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface ShopCartViewController :  HJViewController<UITableViewDelegate, UITableViewDataSource, HJPopViewBaseDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>{
    NSString*           shopidSC;
    int sumCountSC;

    UILabel             *shopcartLabelSC;
    UITableView *tableView;
    UIView *bottomView;//下面的显示
    UILabel *price;
    UILabel *price1;//合计
    float sumPriceSC ;
    int viewHeight;
    NSUInteger selectIntex;
    int colorIndex;
    UIButton *btnCur;//当前编辑菜品勾选的
    UITapGestureRecognizer *backClick;
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    int deleteIndex;
    UIImageView *backImageView;
}

@property (nonatomic, retain) NSString *shopidSC;

@property (nonatomic, retain) UILabel *shopcartLabelSC;

@property (nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UIToolbar *keyboardToolbar;

@property(nonatomic, retain) NSArray *colorArry;

@property(nonatomic, retain) UIButton *btnAllCheck;
@property(nonatomic, retain) NSString *uduserid;//用户编号
//餐品数量增加1
-(void)plusFoodToOrderSC:(id)sender;

//餐品数量减少1
-(void)minusFoodToOrderSC:(id)sender;

-(void) updateTableSC;

-(void) UpdateShopCartSC:(FoodInOrderModel *)foodmodel;

-(void) doSum;

-(void)getShopCart;

@end
