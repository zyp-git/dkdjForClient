//
//  ShopListViewController.h
//  EasyEat4iPhone
//
//  Created by dev on 11-12-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadCell.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "CachedDownloadManager.h"
#import "HJTableViewController.h"

#define MESSAGES_PER_PAGE 20

#define kNameValueTag     1
#define kColorValueTag    2
//UIViewController <UITableViewDelegate, UITableViewDataSource>
@interface ShopListViewController :  HJTableViewController<MBProgressHUDDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
    NSMutableArray*     shops;//纯指针作用
    NSMutableArray*     shops1;//后台数据1
    NSMutableArray*     shops2;//后台数据2
    int select;//1使用shops1的内容 2使用shops2的内容
    /*
     如果滚动视图的过程中，数据已经取到。并且准备清空原有数据时(page = 1时需要清空，如果一直加载更多时无需清空)这时候会导致程序崩溃
     这样提供两个内存数据，可以让视图继续滚动。等到后台数据更新完之后（清空已经使用过，并且不在使用的内存数据）在更新视图。这样就可以解决崩溃问题
     菜单视图中使用了同样的功能。
     */
    BOOL                isFollowers;
    BOOL                hasMore;
    
    int                 page;
    NSString*           shopname;
    NSString*           lat;//纬度
    NSString*           lng;//经度
    NSString*           istuan;
    NSString*           brandid;
    NSString*           bID;//建筑物编号
    NSString*           userID;
    
    NSString*           uaddress;
    NSString*           isbrand;
    
    double              ulat;
    double              ulng;
    LoadCell*           loadCell;
    TwitterClient*      twitterClient;
    MBProgressHUD       *_progressHUD;
    
    
    
    NSString*           aid;
    NSString*           gettype;
    NSString*  shopType;
    
    CachedDownloadManager*  imageDownload;
    
   
    NSMutableArray*     shopTypeNameArray;
    NSMutableArray*     shopTypeIDArray;
    UIButton* nearButton;
    NSString *nearFilter;
}

@property (nonatomic, retain) NSMutableArray *shops1;
@property (nonatomic, retain) NSMutableArray *shops2;
@property (nonatomic, retain) NSString *aid;
@property (nonatomic, retain) NSString *gettype;
@property (nonatomic, retain) CachedDownloadManager*  imageDownload;
@property (nonatomic, retain) NSString *defaultPath;

@property (nonatomic, retain) NSMutableArray*     shopTypeNameArray;
@property (nonatomic, retain) NSMutableArray*     shopTypeIDArray;
@property (nonatomic, retain) UIButton* nearButton;


//商家分类
- (id)initWithShopType:(NSString*)shoptype shoptypename:(NSString*)shoptypename;

//附近商家
- (id)initWithLocation;

- (id)initWithBid:(NSString *)bid;
// 收藏
- (id)initWithFavor:(NSString *)userid;
//搜索
- (id)initWithKeywords:(NSString*)keywords;

//推荐商家
-(id)initWithIsTuan;

//建筑物选择
-(id)initWithAid:(NSString*)aid areaname:areaName;

//连锁店分店列表
-(void)initWithBrandId:(NSString*)brandid shopname:(NSString*)shopname;

-(void)getShopList;

-(void)getShopListFix;

-(void)initPara;

@end

