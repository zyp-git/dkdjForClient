//
//  CommitOrderViewController.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/3.
//
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "FoodInOrderModel.h"
#import "HJViewController.h"
#import "HJEditShopCartNumberPopView.h"
#import "UserAddressListViewController.h"
#import "TwitterClient.h"
#import "FoodInOrderModel.h"
#import "HJViewController.h"
#import "HJEditShopCartNumberPopView.h"

@interface CommitOrderViewController : HJViewController<MBProgressHUDDelegate,UserAddressListViewControllerDelegate>
@property(nonatomic, strong) NSString *uduserid;
@property(nonatomic, strong) NSString *orderId;
@property (weak,nonatomic) UITableView * cartTableView;
@property (nonatomic,strong) NSString * payPassword;
@property (nonatomic,strong) NSString * payId;
@property (nonatomic,assign) CGFloat  payMoney;
@property (nonatomic,strong) NSString * tfAddress;
@end
