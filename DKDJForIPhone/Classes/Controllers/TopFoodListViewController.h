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
#import "TopFoodModel.h"
#import "MBProgressHUD.h"
#import "FoodTypeViewController.h"
#import "CachedDownloadManager.h"
#import "HJTableViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2

@interface TopFoodListViewController :  HJTableViewController <UITableViewDelegate, UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate, FoodTypeViewControllerDelegate>
{
    NSMutableArray*     foods;
    BOOL                isFollowers;
    BOOL                hasMore;
    int                 page;
    NSString            *tid;
    NSString            *foodtypeid;

    
    TwitterClient       *twitterClient;
    
    
    
    MBProgressHUD       *_progressHUD;
    
    NSUInteger          row;
    NSMutableDictionary *shopcartDictForSaveFile;//foodid FoodInOrderModel
    
    NSString            *uduserid;
}

@property (nonatomic, retain) NSString *uduserid;
@property (nonatomic, retain) NSMutableArray *foods;
@property (nonatomic, retain) NSString *foodtypeid;
@property (nonatomic, retain) NSString *defaultPath;
@property (nonatomic, retain) CachedDownloadManager*  imageDownload;


- (id)initWithTypeId:(NSString*)type;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

-(void)AddtoCart;


-(void) GetData;

@end