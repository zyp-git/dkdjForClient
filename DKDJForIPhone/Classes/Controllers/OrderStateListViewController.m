//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ActivityDetailViewController.h"
#import "LoadCell.h"
#import "FoodListCell.h"
#import "FoodModel.h"
#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "FileController.h"

#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJAppConfig.h"
#import "FoodAttrModel.h"

#import "OrderStateListViewController.h"
#import "ShopDetailViewController.h"
#import "AreaListViewController.h"
#import "SearchOnMapViewController.h"
#import "HJButton.h"
#import "FoodListViewController.h"
#import "ShopNewViewController.h"
@implementation OrderStateListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70
static NSString *CellTableIdentifier = @"CellTableIdentifier";
@synthesize getShopTypeID;//获取商家分类id
@synthesize orderStates;
@synthesize uduserid;



-(id)init
{
    self = [super init];
    if (self) {
        isShowLocationLabel = YES;
         OpenType = 2;
        isFavor = NO;
    }
    return self;
}


- (id)initOrderID:(NSString*)odid
{
    self  = [super init];
    if (self) {
        self.getShopTypeID = odid;
    }
    return self;
}

#pragma mark GetShopList
-(void) GetOrderStateListData:(BOOL)isShowProcess orderState:(int)state
{
    orderState = state;
    //getfoodlistbyshopid.aspx?shopid=106
    NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.getShopTypeID, @"orderid", nil];;
    
        //param se
   
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(orderStatesDidReceive:obj:)];
    
    [twitterClient getOrderStateList:param];
    
    
    
    [param release];
    
    
}

- (void)orderStatesDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    [twitterClient release];
    twitterClient = nil;
    
    
    
    if (client.hasError) {
        
        
        [client alert];
        
        return;
    }
    
    
    
    
    if (obj == nil)
    {
        
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    //NSString *pageString = [dic objectForKey:@"page"];
   
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"data"];
//    NSMutableArray *activity;
    
    if ([ary count] == 0) {
        return;
    }
    
    //判断是否有下一页
    
    [self.orderStates removeAllObjects];
//    int index = 0;//[activity count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        OrderStateMode *model = [[OrderStateMode alloc] initWithJsonDictionary:dic];
        
        if (i == [ary count] - 1) {
            model.isEnd = YES;
        }
        [self.orderStates addObject:model];
        [model release];
    }
    
    //[imageDownload1 startTask];
    //[imageDownload startTask];
    isRemoveAllCell = NO;
    [dateTableView reloadData];
    
}







#pragma mark ViewLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [dateTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //dateTableView.style = 1;//UITableViewStyleGrouped;
    //下面两行设置行高自适应计算
    dateTableView.rowHeight = UITableViewAutomaticDimension;
    dateTableView.estimatedRowHeight = 65;//// 设置为一个接近“平均”行高的值
    [self.view addSubview:dateTableView];
    NSArray* hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dateTableView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(dateTableView)];
    [self.view addConstraints:hConstraintArray];
    
    
    NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dateTableView]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(dateTableView)];
    [self.view addConstraints:vConstraintArray];
    
    
    
    
   
    
    
    
    
    
    self.orderStates = [[NSMutableArray array] retain];
    
    
    
    
    
    
    //下面两行设置行高自适应计算
    dateTableView.rowHeight = UITableViewAutomaticDimension;
    dateTableView.estimatedRowHeight = 80;//// 设置为一个接近“平均”行高的值
    dateTableView.delegate = self;
    dateTableView.dataSource = self;
    dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    /*dateTableView.tableHeaderView = headerView;
     [dateTableView addSubview:headerView];*/
    dateTableView.tag = 1;
    dateTableView.backgroundColor = [UIColor clearColor];
    dateTableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    
   
    
    
   
    
}



-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    //[self GetOrderStateListData:YES];
    
}



- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
   

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



- (id)initWithTypeId:(NSString*)type
{
    self = [super init];
    getType = @"-1";
    self.getShopTypeID = type;
    return self;
}



- (void)dealloc {
    //[loadCell release];
    [heardView release];
    if (_progressHUD1)
    {
        [_progressHUD1 removeFromSuperview];
        [_progressHUD1 release];
        _progressHUD1 = nil;
    }
    if (twitterClient1) {
        [twitterClient1 release];
        twitterClient1 = nil;
    }
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    if (twitterClient) {
        [twitterClient release];
        twitterClient = nil;
    }
    if (imageDownload1 != nil) {
        [imageDownload1 stopTask];
        [imageDownload1 release];
    }
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    
    [dateTableView release];
    [self.orderStates release];
    [self.uduserid release];
    
    [self.getShopTypeID release];
    [backClick release];
    //[_progressHUD release];
    //[twitterClient release];
    
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}






- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
}

- (BOOL)IsLogin
{
    [self refreshFields];
    NSLog(@"islogin userid:%@", self.uduserid);
    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =CustomLocalizedString(@"login", @"会员登录");
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        //[self.navigationController pushViewController:LoginNewViewController animated:true];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

-(void) doSum
{
}





/*-(void)imageSingClick:(UITapGestureRecognizer*) gesture
{
}*/


#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return heardView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    count = (int)[self.orderStates count];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //show load more cell
    //if (tableView.tag == 1)
    {
        
        
        
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        //NSArray* hConstraintArray;
        
        //NSArray* vConstraintArray;
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            UIView *leftView = [[UIView alloc] init];
            [leftView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView addSubview:leftView];
            
            NSArray* hConstraintArray;
            
            
            NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[leftView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(leftView)];
            [cell.contentView addConstraints:vConstraintArray];
            
            UIImageView *hLine1 = [[UIImageView alloc] init];
            hLine1.backgroundColor = app.sysTitleColor;
            [hLine1 setTranslatesAutoresizingMaskIntoConstraints:NO];
            [leftView addSubview:hLine1];
            hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[hLine1(1)]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(hLine1)];
            [cell.contentView addConstraints:hConstraintArray];
            //垂直居中
            /*NSLayoutConstraint* heightConstraint1 = [NSLayoutConstraint constraintWithItem:hLine1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            heightConstraint1.active = YES;*/
            //水平居中
            NSLayoutConstraint* hheightConstraint1 = [NSLayoutConstraint constraintWithItem:hLine1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            hheightConstraint1.active = YES;
            
            UIImageView *stateImgView = [[UIImageView alloc] init];
            stateImgView.image = [UIImage imageNamed:@"send_ico"];
            [stateImgView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [leftView addSubview:stateImgView];
            hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[stateImgView(20)]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(stateImgView)];
            [cell.contentView addConstraints:hConstraintArray];
            //垂直居中
            NSLayoutConstraint* heightConstraint2 = [NSLayoutConstraint constraintWithItem:stateImgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            heightConstraint2.active = YES;
            
            //水平居中
            NSLayoutConstraint* hheightConstraint2 = [NSLayoutConstraint constraintWithItem:stateImgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            hheightConstraint2.active = YES;
            
            UIImageView *hLine2 = [[UIImageView alloc] init];
            hLine2.tag = 1;
            hLine2.backgroundColor = app.sysTitleColor;
            [hLine2 setTranslatesAutoresizingMaskIntoConstraints:NO];
            [leftView addSubview:hLine2];
            hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[hLine2(1)]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(hLine2)];
            [cell.contentView addConstraints:hConstraintArray];
            //垂直居中
           /* NSLayoutConstraint* hheightConstraint3 = [NSLayoutConstraint constraintWithItem:hLine2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
            hheightConstraint3.active = YES;*/
            //水平居中
            NSLayoutConstraint* heightConstraint3 = [NSLayoutConstraint constraintWithItem:hLine2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            heightConstraint3.active = YES;
            
            vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hLine1][stateImgView(20)][hLine2]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(hLine1, stateImgView, hLine2)];
            [cell.contentView addConstraints:vConstraintArray];
            
            
            
            UIImage *imgBg = [UIImage imageNamed:@"takeout_status_flow_item_bg"];
            UIImageView *rightView = [[UIImageView alloc] init];
            rightView.image = [imgBg resizableImageWithCapInsets:UIEdgeInsetsMake(28, 58, 29, 59) resizingMode:UIImageResizingModeStretch];
            //rightView.backgroundColor = [UIColor blackColor];
            [rightView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView addSubview:rightView];
            vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightView]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(rightView)];
            [cell.contentView addConstraints:vConstraintArray];
            
            hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[leftView(40)][rightView]-5-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(leftView, rightView)];
            [cell.contentView addConstraints:hConstraintArray];
            
            UILabel *lbName = [[UILabel alloc] init];
            lbName.tag = 2;
            lbName.numberOfLines = 1;
            [lbName setTranslatesAutoresizingMaskIntoConstraints:NO];
            [rightView addSubview:lbName];
            lbName.textColor = [UIColor blackColor];
            lbName.font = [UIFont boldSystemFontOfSize:12];
            
            UILabel *lbTime = [[UILabel alloc] init];
            lbTime.tag = 3;
            lbTime.numberOfLines = 1;
            [lbTime setTranslatesAutoresizingMaskIntoConstraints:NO];
            [rightView addSubview:lbTime];
            lbTime.textAlignment = NSTextAlignmentRight;
            lbTime.textColor = [UIColor grayColor];
            lbTime.font = [UIFont boldSystemFontOfSize:10];
            
            
            hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[lbName][lbTime(120)]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(lbName, lbTime)];
            [cell.contentView addConstraints:hConstraintArray];
            
            
            UILabel *lbTitle = [[UILabel alloc] init];
            lbTitle.tag = 4;
            lbTitle.numberOfLines = 1;
            [lbTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
            [rightView addSubview:lbTitle];
            lbTitle.textColor = [UIColor grayColor];
            lbTitle.font = [UIFont boldSystemFontOfSize:12];
            hConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lbTitle]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(lbTitle)];
            [cell.contentView addConstraints:hConstraintArray];
            vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[lbName][lbTitle]-15-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(lbName, lbTitle)];
            [cell.contentView addConstraints:vConstraintArray];
            vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[lbTime(lbName)]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(lbTime, lbName)];
            [cell.contentView addConstraints:vConstraintArray];
            
            [rightView release];
            [hLine1 release];
            [hLine2 release];
            [stateImgView release];
            [leftView release];
            [lbTitle release];
            [lbTime release];
            [lbName release];
            
            
        }
        UIImageView *hLine2 = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *lbName = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *lbTime = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *lbTitle = (UILabel *)[cell.contentView viewWithTag:4];
        OrderStateMode *model = [self.orderStates objectAtIndex:indexPath.row];
        lbName.text = model.name;
        lbTime.text = model.addtime;
        lbTitle.text = model.subtitle;
        if (model.isEnd && orderState > 2 && orderState != 7 ) {
            [hLine2 setHidden:YES];
        }else{
            [hLine2 setHidden:NO];
        }
        return cell;
        
        
        
        
    }
}

// 注意：除非行高极端变化并且你已经明显的觉察到了滚动时滚动条的“跳跃”现象，你才需要实现此方法；否则，直接用tableView的estimatedRowHeight属性即可。
/*
 - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // 以必需的最小计算量，返回一个实际高度数量级之内的估算行高。
 // 例如：
 //
 if ([self isTallCellAtIndexPath:indexPath]) {
 return 350.0f;
 } else {
 return 40.0f;
 }
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*FShop4ListModel *foodmodel = [shops objectAtIndex:indexPath.row];
    if ([foodmodel.shopTagList count] > 0) {
        return 73 + ([foodmodel.shopTagList count] * 13);
    }*/
    return 65;
}



//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[deleteDic removeObjectForKey:[self.activitys objectAtIndex:indexPath.row]];
    
}

@end