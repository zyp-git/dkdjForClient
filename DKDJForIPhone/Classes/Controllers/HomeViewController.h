//
//  MainViewController.h
//  EasyEat4iPhone
//
//  Created by zheng jianfeng on 11-12-29.
//  Copyright 2011 ihangjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "TwitterClient.h"
#import "MBProgressHUD.h"
#import "MyAddressLabel.h"
#import "AdvModel.h"
#import "CachedDownloadManager.h"
#import "EasyEat4iPhoneAppDelegate.h"
#import "HJViewController.h"
#import "ImageScrollViewControl.h"
#import "HJLabel.h"
#import "SearchOnMapViewController.h"
#import "HJButton.h"
#import "HJListViewPop.h"
#import "HomeCell.h"
#import "SDCycleScrollView.h"
@interface HomeViewController : HJViewController<UIAlertViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, MBProgressHUDDelegate, MyLabelDelegate, ImageScrollViewControlDelegate, UITableViewDataSource, UITableViewDelegate, HJPopViewBaseDelegate,UINavigationControllerDelegate,HomeCellDelegate,SDCycleScrollViewDelegate,SearchOnMapViewControllerDelegate> {

    //EasyEat4iPhoneAppDelegate *app;
    UIBarButtonItem *rightButton;
    UIBarButtonItem *leftButton;

    TwitterClient       *twitterClient;
    TwitterClient       *twitterClient1;
    MBProgressHUD       *_progressHUD;
    
    NSString *popAvdURL;//网络路径
    NSString *popAvdPath;//本地路径
    NSString *popAvdTitle;
    NSString *popAvdContent;
    int popAvdTime;
    
    NSMutableArray *popADVList;

    CachedDownloadManager*  imageDownload2;

    BOOL isShowPopAdv;
    int isNoFirst;//是否第一次启动
    
    NSMutableArray *foods;
    NSMutableArray *activitys;
    
    UITapGestureRecognizer *food1Click;
    UITapGestureRecognizer *food2Click;
    UITapGestureRecognizer *food3Click;
    
    UITapGestureRecognizer *activity1Click;
    UITapGestureRecognizer *activity2Click;
    UITapGestureRecognizer *activity3Click;
    
    BMKMapView * _mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    UITableView *tbView;
    HJScrollView *shopTypeView;
    NSMutableArray *shopTypeViewList;
    int shopPage;
    int shopTotalPage;
    NSMutableArray *shops;
    NSMutableArray *shops1;
    NSMutableArray *shops2;
    BOOL hasMoreShop;
    UITapGestureRecognizer *gotoCityClick;
    int select;
    
    NSMutableArray *orderByArry;
    NSMutableArray *activsArry;

    HJButton *btnOrder1;
    HJButton *btnOrder2;
    HJButton *btnOrder3;
    
    HJButton *btnOrder4;
    HJButton *btnOrder5;
    HJButton *btnOrder6;
    
    HJListViewPop *popView;
    HJListViewPop *popView1;
    HJListViewPop *popView2;
    //UIView *heardViewInTable;
    
    NSString *sortFlag;//0降序排序，1升序排序
    NSString *sortname;//排序字段
    int userOrderByIndex;//当前使用的排序索引
    int isPromotion;//是否有活动 0没有 1 有 -1所有
    BOOL isReadData;
}
@property (nonatomic, strong)HJLabel *lbTitle;
@property (nonatomic, strong) MyAddressLabel *addressText;
@property (nonatomic, strong) NSString *uduserid;
//@property(nonatomic, retain)UIView *zoomView;
@property (nonatomic, assign)BOOL isSe;
@property (nonatomic, strong) NSString *getShopTypeID;//获取商家分类id
@property (nonatomic, strong) UIView *foodView;
@property (nonatomic, strong)UIImageView *topFoodImageView1;
@property (nonatomic, strong)UIImageView *topFoodImageView2;
@property (nonatomic, strong)UIImageView *topFoodImageView3;
@property (nonatomic, strong)UILabel *topFoodName1;
@property (nonatomic, strong)UILabel *topFoodName2;
@property (nonatomic, strong)UILabel *topFoodName3;

@property (nonatomic, strong)UIImageView *topActImageView1;
@property (nonatomic, strong)UIImageView *topActImageView2;
@property (nonatomic, strong)UIImageView *topActImageView3;
@property (nonatomic, strong)UILabel *topActName1;
@property (nonatomic, strong)UILabel *topActName2;
@property (nonatomic, strong)UILabel *topActName3;
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)HomeCell * cell;



//-(void)showNearByShop:(id)sender;

//-(void)showShopType:(id)sender;

//-(void)showShop:(id)sender;

//-(void)showTuanShop:(id)sender;

//-(void)showSystem:(id)sender;

//-(void)showAddress:(id)sender;

//-(void)alertView:(UIAlertView *)alertView clickButtonAtIndex:(NSInteger) buttonIndex;

@end

