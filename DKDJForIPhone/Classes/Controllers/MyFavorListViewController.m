//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyFavorListViewController.h"
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
#import "ShopDetailViewController.h"
#import "FoodDetailViewController.h"
@implementation MyFavorListViewController

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
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize dateTableView;









#pragma mark GetFavorShopList
-(void) GetFavorShopListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", shopPage];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", self.uduserid, @"userid", pageindex, @"pageindex",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(favorShopsDidReceive:obj:)];
    
    [twitterClient getFavorShopListByLocation:param];
    if (isShowProcess) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];
    }
    
    
    [param release];
    
    
}

- (void)favorShopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [shops count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    shopTotalPage = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",shopPage);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"list"];
    
    if ([ary count] == 0) {
        hasMoreShop = false;
        [self.dateTableView reloadData];
        return;
    }
    
    //判断是否有下一页
    
    
    if( shopTotalPage > shopPage )
    {
        ++shopPage;
        hasMoreShop = true;
    }
    else
    {
        hasMoreShop = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = [shops count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FShop4ListModel *model = [[FShop4ListModel alloc] initWithJsonDictionary:dic];
        model.isFav = 1;
        model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.shopid] url:model.icon showImage:nil defaultImg:@"" indexInGroup:index++ Goup:getType];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.shopname);
        [shops addObject:model];
        [model release];
    }
    
    [imageDownload startTask];
    isRemoveAllCell = NO;
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        
        [self.dateTableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.dateTableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}

#pragma mark GetFavFoodList
-(void) GetFavorFoodListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", foodPage];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", self.uduserid, @"userid", pageindex, @"pageindex",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(favorfoodsDidReceive:obj:)];
    
    [twitterClient getFavorFoodListByLocation:param];
    if (isShowProcess) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];
    }
    
    
    [param release];
    
    
}

- (void)favorfoodsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [foods count];//已经存在列表中的数量
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    foodTotalPage = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",shopPage);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodlist"];
    
    if ([ary count] == 0) {
        hasMoreFood = false;
        [self.dateTableView reloadData];
        return;
    }
    
    //判断是否有下一页
    
    
    if( foodTotalPage > foodPage )
    {
        ++foodPage;
        hasMoreFood = true;
    }
    else
    {
        hasMoreFood = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = (int)[foods count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        FoodModel *model = [[FoodModel alloc] initWithJsonDictionary:dic];
        model.isFav = 1;
        model.picPath = [imageDownload1 addTask:[NSString stringWithFormat:@"%d", model.foodid] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:getType];
        [model setImg:model.picPath Default:@"暂无图片"];
        [foods addObject:model];
        [model release];
    }
    
    [imageDownload1 startTask];
    isRemoveAllCell = NO;
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        
        [self.dateTableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.dateTableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.dateTableView endUpdates];
    }
}

#pragma mark 动态更新表
-(void)deleteTableLine
{
    
    
    NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
    
    //刷新表格数据
    [self.dateTableView beginUpdates];
    
    [newPath addObject:[NSIndexPath indexPathForRow:optIndex inSection:0]];
    
    [self.dateTableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
    //[self.dateTableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
    
    [self.dateTableView endUpdates];
}

#pragma mark FavFood
-(void)favFood{
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"提交中...";
    [_progressHUD show:YES];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(FavorSucceed:obj:)];
    
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.uduserid,@"userid", [NSString stringWithFormat:@"%d", food.foodid ], @"foodid", @"-1", @"op", nil];
    
    
    [twitterClient favorFood:param];
}
-(void)FavorSucceed:(TwitterClient*)sender obj:(NSObject*)obj;
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    //[progressWindow hide];
    NSLog(@"getShopDetailDidSucceed");
    [twitterClient release];
    twitterClient = nil;
    
    if (sender.hasError) {
        
        
        [sender alert];
        return;
    }
    [twitterClient release];
    twitterClient = nil;
    NSDictionary *dic = (NSDictionary *)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    if (state == 1) {
        [foods removeObjectAtIndex:optIndex];
        [self deleteTableLine];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"取消收藏成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"取消收藏失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
}

#pragma mark FavShop
-(void)FavorShop
{
    if( (![self IsLogin]) )
    {
        return;
    }
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"收藏中...";
    [_progressHUD show:YES];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(FavorShopSucceed:obj:)];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:uduserid,@"userid",[NSString stringWithFormat:@"%d", shop.shopid], @"togoid", @"-1", @"op", nil];
    
    [twitterClient favorShop:param];
    
    
}

-(void)FavorShopSucceed:(TwitterClient*)sender obj:(NSObject*)obj;
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    //[progressWindow hide];
    NSLog(@"getShopDetailDidSucceed");
    [twitterClient release];
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    NSDictionary *dic1 = (NSDictionary *)obj;
    int state1 = [[dic1 objectForKey:@"state"] intValue];
    UIAlertView *alert;
    switch (state1) {
            
        case 1:
            [shops removeObjectAtIndex:optIndex];
            [self deleteTableLine];
            alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"取消收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            break;
        case 2:
            alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您已经收藏了该商家！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            break;
        default:
            alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"操作失败，请稍后再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            break;
    }
    [alert show];
    [alert release];
}


- (void)gotoShopCart:(id)senser
{
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[[NSString alloc] initWithFormat:@"购物车为空"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        [app SetTab:2];
        
    }
}

- (void)goToActivityDetail:(id)senser
{
    NSUInteger row1;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        row1 = [self.dateTableView indexPathForCell:(UITableViewCell *)[[[[senser superview] superview] superview] superview]].row;
    }else{
        row1 = [self.dateTableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    if (row1 == 0) {
        row1 = [self.dateTableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    row1 *= 2;
    
}

-(void)ShowFoodType:(id)senser
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)FoodTypeTableHide:(id)sender
{
    if (isShowType) {
        isShowType = NO;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
         [UIView beginAnimations:nil context:context];
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
         self.dateTableView.frame = CGRectMake(0, 30, 320, viewHeight);
         [UIView setAnimationDelegate:self];
         // 动画完毕后调用animationFinished
         //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
         [UIView commitAnimations];
    }
    
}

-(void)FoodTypeTableShow:(id)sender
{
    if (!isShowType) {
        isShowType = YES;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.dateTableView.frame = CGRectMake(100, 30, 220, viewHeight);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
        

    }
}



#pragma mark ViewLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    shopPage = 1;
    foodPage = 1;
    if (is_iPhone5) {
        viewHeight = 420;
    }else{
        viewHeight = 310;
    }
    self.title = @"我的收藏";
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    imageDownload1 = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
    
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    showFoodTypeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowFoodType:)];
    
    [foodType addGestureRecognizer:showFoodTypeClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    self.uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    shops = [[NSMutableArray alloc] init];
    foods = [[NSMutableArray alloc] init];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    btnFavShop = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0, 158, 40)];
    [btnFavShop setTitle:@"收藏的店铺" forState:UIControlStateNormal];
    [btnFavShop setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnFavShop setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    btnFavShop.tag = 1;
    btnFavShop.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [btnFavShop addTarget:self action:@selector(favListCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFavShop];
    
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(159, 10, 2, 20)];
    rightArrow.image = [UIImage imageNamed:@"vertical_line.png"];
    [self.view addSubview:rightArrow];
    [rightArrow release];
    
    btnFavFood = [[UIButton alloc] initWithFrame:CGRectMake(162.0, 0, 159, 40)];
    [btnFavFood setTitle:@"收藏的单品" forState:UIControlStateNormal];
    [btnFavFood setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnFavFood setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    btnFavFood.tag = 2;
    btnFavFood.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [btnFavFood addTarget:self action:@selector(favListCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFavFood];
    
    
    
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, viewHeight)];
    self.dateTableView.delegate = self;
    self.dateTableView.dataSource = self;
    self.dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    /*self.dateTableView.tableHeaderView = headerView;
     [self.dateTableView addSubview:headerView];*/
    self.dateTableView.tag = 1;
    //self.imageDownload = [[CachedD
    self.dateTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    //self.dateTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.dateTableView];
    
    
    if (getType == 0) {
        btnFavShop.selected = YES;
        [self GetFavorShopListData:YES];
    }else{
        btnFavFood.selected = YES;
        [self GetFavorFoodListData:YES];
    }
    
    
    
    
}

-(void)favDelClick:(UIButton *)btn
{
    NSUInteger row1;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row1 = [self.dateTableView indexPathForCell:(UITableViewCell *)[[[[btn superview] superview] superview] superview]].row;
    }else{
        row1 = [self.dateTableView indexPathForCell:((UITableViewCell *)[[[btn superview] superview] superview])].row;
    }
    if (row1 == 0) {
        row1 = [self.dateTableView indexPathForCell:((UITableViewCell *)[[[btn superview] superview] superview])].row;
    }
    optIndex = (int)row1;
    if (getType == 0) {//商家
        shop = [shops objectAtIndex:optIndex];
        [self FavorShop];
    }else{
        food = [foods objectAtIndex:optIndex];
        [self favFood];
    }
}

-(void)favListCheckboxClick:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = !btn.selected;
        if (btn.tag == 1) {
           // btnFavShop.selected = NO;
            btnFavFood.selected = NO;
            getType = 0;
            if ([shops count] == 0) {
                shopPage = 1;
                [self GetFavorShopListData:YES];
            }else{
                [self.dateTableView reloadData];
            }
        }else{
            btnFavShop.selected = NO;
            getType = 1;
            if ([foods count] == 0) {
                foodPage = 1;
                [self GetFavorFoodListData:YES];
            }else{
                [self.dateTableView reloadData];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (getType == 0 && shop != nil) {
        if (shop.isFav != 1) {
            [shops removeObjectAtIndex:optIndex];
            [self deleteTableLine];
        }
    }else if(food != nil){
        if(food.isFav != 1){
            [foods removeObjectAtIndex:optIndex];
            [self deleteTableLine];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
    
   

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (id)initWithTypeId:(int)type
{
    [super init];
    if (self) {
        getType = type;
    }
    return self;
}

#pragma mark ImageDowload

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        if (task.groupType == 0) {
            FShop4ListModel *model1;
            if (task.index >= 0 && task.index < [shops count]) {
                model1 = (FShop4ListModel *)[shops objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }else{
            FoodModel *model1;
            if (task.index >= 0 && task.index < [shops count]) {
                model1 = (FoodModel *)[foods objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }
        
        
    }
    
}

-(void)updataUI:(int)type{
   
    [self.dateTableView reloadData];
    
}

- (void)dealloc {
    //[loadCell release];
    
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
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [self.dateTableView release];
    [shops release];
    [foods release];
    [self.uduserid release];
    [btnFavFood release];
    [btnFavShop release];
    [self.defaultPath release];
    [gotoShopCartClick release];
    [showFoodTypeClick release];
    
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





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
        
        LoginController.title =@"会员登录";
        
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



#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (isRemoveAllCell) {
        return 0;
    }
    if (getType == 0) {
        count = (int)[shops count];
    }else{
        count = (int)[foods count];
    }
    
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//show load more cell
    //if (tableView.tag == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            
            
            UIImageView *ivBack = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10, 310, 120)];
            ivBack.image = [UIImage imageNamed:@"shop_img_back.png"];
            ivBack.userInteractionEnabled = YES;
            UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 7.0, 145.0, 105.0)];
            ico.tag = 1;
            
            [ivBack addSubview:ico];
            [ico release];
            
            //1. 名称
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(165.0, 10.0, 145, 110)];
            
            
            
            UILabel *nameLabel = [[UILabel alloc] init];
            [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            nameLabel.numberOfLines = 1;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:16];
            nameLabel.tag = 3;
            
            [view addSubview: nameLabel];
            
            
            //3. 简介
            
            UILabel *intr = [[UILabel alloc] init];
            [intr setTranslatesAutoresizingMaskIntoConstraints:NO];
            intr.textColor = [UIColor darkGrayColor];
            intr.textAlignment = NSTextAlignmentLeft;
            intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            intr.numberOfLines = 3;
            //nameLabel.text = shopmodel.shopname;
            intr.font = [UIFont boldSystemFontOfSize:12];
            intr.tag = 5;
            
            [view addSubview: intr];
            
            UILabel *npriceLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(180.0, 0.0, 50, 15)];
            npriceLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            npriceLabel.numberOfLines = 1;
            [npriceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            npriceLabel.textAlignment = NSTextAlignmentLeft;
            npriceLabel.font = [UIFont boldSystemFontOfSize:14];
            npriceLabel.textColor = [UIColor colorWithRed:147/255.0 green:0/255.0 blue:6/255.0 alpha:1.0];
            npriceLabel.tag = 7;
            [view addSubview: npriceLabel];
            
            UILabel *opriceLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(240.0, 0.0, 50, 15)];
            opriceLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            opriceLabel.numberOfLines = 1;
            [opriceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            opriceLabel.textAlignment = NSTextAlignmentLeft;
            opriceLabel.font = [UIFont boldSystemFontOfSize:10];
            opriceLabel.textColor = [UIColor darkGrayColor];
            opriceLabel.tag = 8;
            
            [view addSubview: opriceLabel];
            
            UIButton *btnDel = [[UIButton alloc] init];
            [btnDel setTranslatesAutoresizingMaskIntoConstraints:NO];
            btnDel.tag = 9;
            [btnDel setBackgroundImage:[UIImage imageNamed:@"favor_list_del.png"] forState:UIControlStateNormal];
            [btnDel addTarget:self action:@selector(favDelClick:) forControlEvents:UIControlEventTouchDown];
            //line.image = [UIImage imageNamed:@"favor_list_del.png"];
            [view addSubview: btnDel];
            
            
            
            
            UIImageView *line1 = [[UIImageView alloc] init];
            line1.tag = 6;
            [line1 setTranslatesAutoresizingMaskIntoConstraints:NO];
            line1.image = [UIImage imageNamed:@"limit_list_right.png"];
            [view addSubview: line1];
            
            
            //3.去看看
            
            NSDictionary *dict1 = NSDictionaryOfVariableBindings(nameLabel, npriceLabel,intr,npriceLabel,opriceLabel,line1,btnDel);
            NSDictionary *metrics = @{@"hPadding":@5, @"rightPadding":@15, @"linePadding":@0,@"nameTopPadding":@8,@"typeIcoWigth":@20,@"nameRightPadding":@-5};
            NSString *vfl = @"H:|-hPadding-[nameLabel]-rightPadding-|";
            //NSString *vfl1 = @"H:|-hPadding-[priceLabel1]-3-[priceLabel]-hPadding-[line1]";
            NSString *vfl2 = @"H:|-hPadding-[intr]-rightPadding-|";
            //NSString *vfl10 = @"V:[nameLabel]-0-[intr]-hPadding-[priceLabel1]";
            
            NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-0-[intr(>=45)]";
            
            
            NSString *vfl6 = @"H:|-hPadding-[npriceLabel(>=10)]-0-[opriceLabel(>=10)]";
            NSString *vfl13 = @"V:[npriceLabel(15)]-3-|";
            NSString *vfl14 = @"V:|-0-[opriceLabel(15)]-3-|";
            NSString *vfl8 = @"V:[line1(typeIcoWigth)]-5-|";
            NSString *vfl4 = @"H:[line1(typeIcoWigth)]-20-|";
            //NSString *vfl5 = @"V:|-0-[line(typeIcoWigth)]";
            //NSString *vfl10 = @"H:[line(typeIcoWigth)]-10-|";
            NSString *vfl9 = @"H:[btnDel(15)]-18-|";
            NSString *vfl7 = @"V:|-nameRightPadding-[btnDel(25)]";
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:dict1]];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            /*[view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl10
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];*/
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl7
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl8
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl9
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:dict1]];
            
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl13
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:dict1]];
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl14
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:dict1]];
            [ivBack addSubview:view];
            [cell.contentView addSubview:ivBack];
            [nameLabel release];
            [intr release];
            [npriceLabel release];
            [opriceLabel release];
            [btnDel release];
            [line1 release];
            [view release];
            [ivBack release];
            
            
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            
            
        }
        UIImageView *line1 = (UIImageView *)[cell.contentView viewWithTag:6];
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
        UILabel * opriceLabel = (UILabel *)[cell.contentView viewWithTag:8];
        UILabel * npriceLabel = (UILabel *)[cell.contentView viewWithTag:7];
        if (getType == 0) {//收藏商家
            FShop4ListModel *foodmodel = [shops objectAtIndex:indexPath.row];
            
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            opriceLabel.text = @"";
            npriceLabel.text = @"";
            [line1 setHidden:YES];
            nameLabel.text = foodmodel.shopname;
            
            intr.text = foodmodel.des;
        }else{//收藏商品
            FoodModel *foodmodel = [foods objectAtIndex:indexPath.row];
            
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            [line1 setHidden:NO];
            
            nameLabel.text = foodmodel.foodname;
            
           // opriceLabel.text = [NSString stringWithFormat:@"￥%.2f", foodmodel.oPrice];
            npriceLabel.text = [NSString stringWithFormat:@"￥%.2f", foodmodel.price];
            //lTime.text = foodmodel.EndTime1;
            intr.text = foodmodel.Disc;
        }
        
        
        
        //priceLabel1.text = foodmodel.Explain;
        return cell;
        
        
        

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 125;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = self.dateTableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.dateTableView.bounds;          // UIScrollView 可视高度
    CGSize size = self.dateTableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.dateTableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(getType == 0 && twitterClient == nil && hasMoreShop){
            //读取更多数据
            //page++;
            [self GetFavorShopListData:NO];
        }else if(getType == 0 && twitterClient == nil && hasMoreFood){
            [self GetFavorFoodListData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    optIndex = indexPath.row;
        //加载更多数据的行被点击了，则加载下一页数据
    if (getType == 0) {
        if (indexPath.row < [shops count]) {
            if (indexPath.row < [shops count]) {
                shop = [shops objectAtIndex:optIndex];
                ShopDetailViewController *controller = [[[ShopDetailViewController alloc] initWithShop:shop]autorelease];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else{
        if (indexPath.row < [foods count]) {
            if (indexPath.row < [foods count]) {
                food = [foods objectAtIndex:indexPath.row];
                FoodDetailViewController *controller = [[[FoodDetailViewController alloc] initWithFood:food ShowGoToShop:YES] autorelease];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
    
        
    
}

#pragma mark Table view delegate



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[deleteDic removeObjectForKey:[shops objectAtIndex:indexPath.row]];
    
}

#pragma mark searchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    /*ShopListViewController *controller = [[[ShopListViewController alloc] initWithKeywords:searchBar.text] autorelease];
     
     [self.navigationController pushViewController:controller animated:true];*/
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)handleSearchForTerm:(NSString *)searchterm{
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    //searchBar.showsScopeBar = YES;
    
    //[searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:YES animated:YES];
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    return YES;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    //  searchBar.showsScopeBar = NO;
    
    // [searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
    
}

@end