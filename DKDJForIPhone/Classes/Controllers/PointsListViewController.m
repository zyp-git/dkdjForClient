//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PointsDetailViewController.h"
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

#import "PointsListViewController.h"
#import "GiftDetailViewController.h"

@implementation PointsListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70
@synthesize foods1;
@synthesize foods2;
@synthesize shopid;
//@synthesize shopcartDict;

@synthesize imLeft;
//@synthesize shopcartDictForSaveFile;
@synthesize foodtypeid;
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize tableView;
@synthesize imRight;
@synthesize foodModel;
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    page = 1;
    if (is_iPhone5) {
        viewHeight = 460;
    }else{
        viewHeight = 370;
    }
    self.foodtypeid = @"1";
    self.title = CustomLocalizedString(@"gift_list_title", @"积分兑换");
    
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:3 Delegate:self];
    
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    showFoodTypeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowFoodType:)];
    
    [foodType addGestureRecognizer:showFoodTypeClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    self.foods1 = [[NSMutableArray array] retain];
    self.foods2 = [[NSMutableArray array] retain];
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    self.tableView.backgroundColor = [UIColor clearColor];
    /*self.tableView.tableHeaderView = headerView;
    [self.tableView addSubview:headerView];*/
    self.tableView.tag = 1;
    //self.imageDownload = [[CachedD
    [self.view addSubview:self.tableView];
    
    
    
    
}

-(void) imgClick:(UITapGestureRecognizer *)recognizer{
    self.imLeft.image = [UIImage imageNamed:@"points_point_sel.png"];
    self.imRight.image = [UIImage imageNamed:@"points_buy.png"];
    self.foodtypeid = @"1";
    page = 1;
    [self GetGiftListData:YES];
}

-(void) imgClick1:(UITapGestureRecognizer *)recognizer{
    self.imLeft.image = [UIImage imageNamed:@"points_point.png"];
    self.imRight.image = [UIImage imageNamed:@"points_buy_sel.png"];
    self.foodtypeid = @"2";
    page = 1;
    [self GetGiftListData:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //self.shopcartLabel.text = [NSString stringWithFormat:@"已点：%d份 合计：%.2f元", app.shopCart.foodCount, app.shopCart.allPrice];
    if (app.foodID != 0) {
        
        //[self GetFoodDetailWithFoodID:app.foodID];
        app.foodID = 0;
    }else{
        if ([foods count] == 0) {
            [self GetGiftListData:YES];
        }
        
    }
}








- (void)goToFoodDetail:(id)senser
{
    NSUInteger row1;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        row1 = [self.tableView indexPathForCell:(UITableViewCell *)[[[[senser superview] superview] superview] superview]].row;
    }else{
        row1 = [self.tableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    if (row1 == 0) {
        row1 = [self.tableView indexPathForCell:((UITableViewCell *)[[[senser superview] superview] superview])].row;
    }
    row1 *= 2;
    GiftModel *foodmodel;
    UIButton *btn = (UIButton *)senser;
    if(btn.tag == 10){
        row1++;
    }
    foodmodel = [foods objectAtIndex:row1];
    PointsDetailViewController *controller = [[[PointsDetailViewController alloc] initWithFood:foodmodel ShowGoToShop:YES] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
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
         self.tableView.frame = CGRectMake(0, 30, 320, viewHeight);
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
        self.tableView.frame = CGRectMake(100, 30, 220, viewHeight);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
        

    }
}

- (void) FoodTypeViewControllerValueChanged:(NSString *)typevalue
{
    NSString *SortID = typevalue;
    
    if([SortID compare:@"0" ] == NSOrderedSame)
    {
        
    }
    else
    {
        [foods removeAllObjects];
        
        self.foodtypeid = SortID;
        [self GetGiftListData:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    
    
    /*if (!app.mShopModel.mBUpdate) {
        [self.navigationController popViewControllerAnimated:YES];//返回上一界面
        return;
    }*/
    if (foods != nil) {
        [self updateTable];
    }else{
        [self doSum];
    }

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



- (id)initWithTypeId:(NSString*)type
{
    return self;
}

#pragma mark GetGift
-(void) GetGiftListData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", page];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", self.foodtypeid, @"ordertype", pageindex, @"pageindex", @"0", @"isbuy",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(giftsDidReceive:obj:)];
    
    [twitterClient getGiftList:param];
    if (isShowProcess) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
        [_progressHUD show:YES];
    }
    
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
    
    
}
- (void)giftsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    [twitterClient release];
    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [foods count] / 2;//已经存在列表中的数量
    if ([foods count] % 2 != 0) {//事实上为了方便，要求每次数据反悔偶数个，这样如果不是最后一页的话，不可能会存在在后一行存在左边有商品，右边没有的
        prevCount++;
    }
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total 
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    totalPage = [[dic objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"page: %d",page);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    NSMutableArray *food;
    if (page == 1) {
        prevCount = 0;
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([self.foods2 count] != 0) {
                [self.foods2 removeAllObjects];
            }
            
            food = self.foods2;
            select = 2;
        }else{
            if ([self.foods1 count] != 0) {
                [self.foods1 removeAllObjects];
            }
            
            food = self.foods1;
            select = 1;
        }
    }else{
        food = foods;
    }
    if ([ary count] == 0) {
        hasMore = false;
        foods = food;
        [loadCell setType:MSG_TYPE_NO_MORE];
        food = nil;
        [self.tableView reloadData];
        return;
    }
    
    //判断是否有下一页
    
    
    if( totalPage > page )
    {
        ++page;
        hasMore = true;
    }
    else
    {
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMore = false;
    }
    
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错 
    // 将获取到的数据进行处理 形成列表
    int index = [food count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        GiftModel *model = [[GiftModel alloc] initWithJsonDictionary:dic];
        
        model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%ld", (long)model.giftID] url:model.icon showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        [food addObject:model];
        [model release];
    }
    
    [imageDownload startTask];
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        foods = food;
        food = nil;
        [self.tableView reloadData];
        
        NSLog(@"ShopListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count] / 2;
        if([ary count] % 2 != 0){
            count++;
        }
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
}

#pragma mark ImageDowload

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    GiftModel *model1;
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        if (task.index >= 0 && task.index < [foods count]) {
            model1 = (GiftModel *)[foods objectAtIndex:task.index];
            /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                
            }*/
            model1.picPath = task.locURL;
            
            [model1 setImg:model1.picPath  Default:@"暂无图片"];
        }
        
    }
    
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
}

- (void)dealloc {
    //[loadCell release];
    
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
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [self.tableView release];
    //[self.foodtypes release];
    [self.foodtypeid release];
    foods = nil;
    [self.foods1 release];
    [self.foods2 release];
    [self.uduserid release];
    [self.shopid release];
    [self.imLeft release];
    [self.defaultPath release];
    [self.imRight release];
    [gotoShopCartClick release];
    [showFoodTypeClick release];
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





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        if(alertView.tag == 2){
            //显示购物车
            [app SetTab:3];
        }else if(alertView.tag == 3){
            if (foods == nil || [foods count] == 0) {
                [self GetGiftListData:YES];
            }
        }
    }
    else if( buttonIndex == 1 )
    {
        if (alertView.tag == 1) {
            //清空购物车
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"shopcartshopid"];
            [defaults synchronize];
            
            
            //加入新的餐品到购物车
            [self AddtoCart];
        }else if(alertView.tag == 2){
            //去水吧
            
        }
        
        
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

-(void) updateShopCart:(FoodModel *)food{
    [self UpdateShopCart:food];
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCart:(FoodModel *) foodmodel
{
    
}



//更新列表显示
-(void) updateTable
{
    [self doSum];
    [self.tableView reloadData];
}
#pragma mark talbeView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
        if ([foods count] == 0) {
            return 0;
        }
        return [foods count];
       
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//show load more cell
    if (tableView.tag == 1) {
        
            static NSString *CellTableIdentifier = @"CellTableIdentifier";
            
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
            
            if (cell == nil) {
                
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier: CellTableIdentifier] autorelease];
                //自定义布局 分别显示以下几项
                
                /*UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 80.0, 80.0)];
                backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [cell.contentView addSubview:backGImg];*/
                UIImage *viewroundImage = [[UIImage imageNamed:@"ll_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 0.0, 310, 100)];
                view.image = viewroundImage;
                [view setUserInteractionEnabled:YES];
                view.tag = 11;
                UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 120.0, 90.0)];
                ico.tag = 1;
               // backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [view addSubview:ico];
                [ico release];
                
                //1. 名称
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10, 100, 15)];
                nameLabel.textColor = [UIColor blackColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:12];
                nameLabel.tag = 3;
                
                [view addSubview: nameLabel];
                [nameLabel release];
                
                //3. 简介
                
                UILabel *intr = [[UILabel alloc] initWithFrame:CGRectMake(220.0, 10, 80, 15)];
                intr.textColor = [UIColor darkGrayColor];
                intr.textAlignment = NSTextAlignmentRight;
                intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                intr.numberOfLines = 0;
                //nameLabel.text = shopmodel.shopname;
                intr.font = [UIFont boldSystemFontOfSize:11];
                intr.tag = 5;
                
                [view addSubview: intr];
                [intr release];
                
                //2.价格
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                                       CGRectMake(130.0,70, 100, 12)];
                
                priceLabel.textAlignment = NSTextAlignmentLeft;
                priceLabel.font = [UIFont boldSystemFontOfSize:14];
                priceLabel.textColor = [UIColor redColor];
                priceLabel.tag = 7;
                
                [view addSubview: priceLabel];
                [priceLabel release];
                
                UILabel *point = [[UILabel alloc] initWithFrame:CGRectMake(220.0, 70, 80, 15)];
                point.textColor = [UIColor darkGrayColor];
                point.textAlignment = NSTextAlignmentRight;
                point.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                point.numberOfLines = 0;
                //nameLabel.text = shopmodel.shopname;
                point.font = [UIFont boldSystemFontOfSize:11];
                point.tag = 4;
                
                [view addSubview: point];
                [point release];

                
                
                
                [cell.contentView addSubview:view];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
                cell.backgroundColor = [UIColor clearColor];
                [view release];
                
                
               
            }
            int row = indexPath.row;
        
            GiftModel *foodmodel = [foods objectAtIndex:row];
            
            
            UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
        
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
        
            
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
            nameLabel.text = foodmodel.giftName;
        
        UILabel *point = (UILabel *)[cell.contentView viewWithTag:4];
       // NSString *value = [NSString stringWithFormat:@"兑换积分：%d",foodmodel.NeedIntegral];
        point.text = [NSString stringWithFormat:@"%@%ld",CustomLocalizedString(@"gift_list_req_point", @"兑换积分："), (long)foodmodel.NeedIntegral];
        
            UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
        //value= [NSString stringWithFormat:@"剩余数量：%d", foodmodel.cNum];
        if (foodmodel.cNum > 9999) {
            intr.text = [NSString stringWithFormat:@"%@>9999", CustomLocalizedString(@"gift_list_count", @"剩余数量")];
        }else{
            intr.text = [NSString stringWithFormat:@"%@%ld", CustomLocalizedString(@"gift_list_count", @"剩余数量："), (long)foodmodel.cNum];;
        }
        
            
            UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:7];
        
            
            priceLabel.text = [NSString stringWithFormat:@"%@%.2f", CustomLocalizedString(@"public_moeny_0", @"￥"), foodmodel.oPrice];
            
        
        
            
            return cell;
        

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 105;
    }else{
        return 50;//(indexPath.row == [foods count]) ? 60 : 40;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = self.tableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.tableView.bounds;          // UIScrollView 可视高度
    CGSize size = self.tableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(twitterClient == nil && hasMore){
            //读取更多数据
            //page++;
            [self GetGiftListData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        
        //加载更多数据的行被点击了，则加载下一页数据
        if (indexPath.row == [foods count]) {
            if(hasMore){
                if (twitterClient) return;
                
                [loadCell.spinner startAnimating];
                
                NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
                
                //读取商家列表 一次读取8个商家
                //pageindex=1&op=sid&shopname=test&lat=120.000&lng=30.000&nearfilter=1000&sid=103000000000
                twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(foodsDidReceive:obj:)];
                
                NSDictionary* param;// = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",self.self.shopid,@"shopid", nil];
                if([self.foodtypeid compare:@"0" ] == NSOrderedSame)
                {
                    param = [[NSDictionary alloc] initWithObjectsAndKeys:self.shopid,@"shopid", pageindex,@"pageindex", nil];
                }
                else
                {
                    param = [[NSDictionary alloc] initWithObjectsAndKeys:self.shopid,@"shopid",self.foodtypeid, @"typeid",pageindex,@"pageindex", nil];
                }
                
                [twitterClient getFoodListByShopId:param];
                
                NSLog(@"FoodListViewController->didSelectRowAtIndexPath : indexPath.row == [shops count]");
            }
        }
        else {
            GiftDetailViewController *controller = [[[GiftDetailViewController alloc] initWithGiftId:[NSString stringWithFormat:@"%ld", (long)((GiftModel *)[foods objectAtIndex:indexPath.row]).giftID]]autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
    }
}

@end