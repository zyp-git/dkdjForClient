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
#import "ActivityListViewController.h"


@implementation ActivityListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70
@synthesize activitys1;
@synthesize activitys2;
@synthesize shopid;
//@synthesize shopcartDict;

@synthesize imLeft;
//@synthesize shopcartDictForSaveFile;
@synthesize foodtypeid;
@synthesize uduserid;
@synthesize defaultPath;
//@synthesize imageDownload;
@synthesize dateTableView;
@synthesize imRight;
@synthesize activityModel;


#pragma mark Start

-(void) imgClick:(UITapGestureRecognizer *)recognizer{
    self.imLeft.image = [UIImage imageNamed:@"btn_all_activity_sel.png"];
    self.imRight.image = [UIImage imageNamed:@"btn_shop_activity.png"];
    self.foodtypeid = @"1";
    page = 1;
    [self GetData:YES];
}

-(void) imgClick1:(UITapGestureRecognizer *)recognizer{
    self.imLeft.image = [UIImage imageNamed:@"btn_all_activity.png"];
    self.imRight.image = [UIImage imageNamed:@"btn_shop_activity_sel.jpg"];
    self.foodtypeid = @"2";
    page = 1;
    [self GetData:YES];
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

- (void) FoodTypeViewControllerValueChanged:(NSString *)typevalue
{
    NSString *SortID = typevalue;
    
    if([SortID compare:@"0" ] == NSOrderedSame)
    {
        
    }
    else
    {
        [activitys removeAllObjects];
        
        self.foodtypeid = SortID;
        [self GetData:YES];
    }
}

#pragma mark ViewLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    select = 1;
    page = 1;
    if (is_iPhone5) {
        viewHeight = 440;
    }else{
        viewHeight = 350;
    }
    self.foodtypeid = @"1";
    
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:10 Delegate:self];
    
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    showFoodTypeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowFoodType:)];
    
    [foodType addGestureRecognizer:showFoodTypeClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    self.activitys1 = [[NSMutableArray array] retain];
    self.activitys2 = [[NSMutableArray array] retain];
    
    
    imgTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
    imgTapRecognize.numberOfTapsRequired = 1;
    [imgTapRecognize setEnabled :YES];
    [imgTapRecognize delaysTouchesBegan];
    [imgTapRecognize cancelsTouchesInView];
    
    self.imLeft = [[UIImageView alloc] initWithFrame:
                   CGRectMake(70, 10, 90, 30)];
    self.imLeft.image = [UIImage imageNamed:@"btn_all_activity_sel.png"];
    self.imLeft.userInteractionEnabled = YES;//接受用户操作
    [self.imLeft addGestureRecognizer:imgTapRecognize];
    
    [self.view addSubview:self.imLeft];
    
    
    imgTapRecognize1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick1:)];
    imgTapRecognize1.numberOfTapsRequired = 1;
    [imgTapRecognize1 setEnabled :YES];
    [imgTapRecognize1 delaysTouchesBegan];
    [imgTapRecognize1 cancelsTouchesInView];
    self.imRight = [[UIImageView alloc] initWithFrame:
                    CGRectMake(160,10, 90, 30)];
    self.imRight.image = [UIImage imageNamed:@"btn_shop_activity.png"];
    self.imRight.userInteractionEnabled = YES;
    [self.imRight addGestureRecognizer:imgTapRecognize1];
    
    
    [self.view addSubview:self.imRight];
    
    
    
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, viewHeight - 5)];
    self.dateTableView.delegate = self;
    self.dateTableView.dataSource = self;
    self.dateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    /*self.dateTableView.tableHeaderView = headerView;
     [self.dateTableView addSubview:headerView];*/
    self.dateTableView.tag = 1;
    //self.imageDownload = [[CachedD
    self.dateTableView.backgroundColor = [UIColor clearColor];
    self.dateTableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.dateTableView];
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if ([activitys count] == 0) {
            [self GetData:YES];
    }
        
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if (activitys != nil) {
        [self updateTable];
    }else{
        [self doSum];
    }

    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//商家页面进入餐品列表页面
- (id)initWithShopid:(NSString*)Shopid sentmoney:(NSString*)sentmoneyString startSend:(NSString *)start fullFree:(float)full
{
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    hasMore = false;
    
    self.navigationItem.title = @"菜单";
    page = 1;
    [self.shopid release];
    self.shopid = Shopid;
    [self.shopid retain];
    sentmoney =  [sentmoneyString floatValue];
    startSend = [start floatValue];
    fullFree = full;
    
    app.SendMoney = sentmoney;
    app.startMoney = startSend;
    app.fullFree = full;
    
    
    
    return self;
}

- (id)initWithTypeId:(NSString*)type
{
    return self;
}

#pragma mark NetWork
-(void) GetData:(BOOL)isShowProcess
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSString *pageindex = [NSString stringWithFormat:@"%d", page];
    NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:@"20", @"pagesize", self.foodtypeid, @"type", pageindex, @"pageindex",nil];//type 0：所有活动 1：全场活动 2：商铺活动
    
    
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(activitysDidReceive:obj:)];
    
    [twitterClient getActivityListByShopId:param];
    if (isShowProcess) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        
        _progressHUD.dimBackground = YES;
        
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];
    }
    
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
    
    
}

- (void)activitysDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    NSInteger prevCount = [activitys count];//已经存在列表中的数量
    
    
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
    NSMutableArray *activity;
    if (page == 1) {
        prevCount = 0;
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([self.activitys2 count] != 0) {
                [self.activitys2 removeAllObjects];
            }
            
            activity = self.activitys2;
            select = 2;
        }else{
            if ([self.activitys1 count] != 0) {
                [self.activitys1 removeAllObjects];
            }
            
            activity = self.activitys1;
            select = 1;
        }
    }else{
        activity = activitys;
    }
    if ([ary count] == 0) {
        hasMore = false;
        activitys = activity;
        [loadCell setType:MSG_TYPE_NO_MORE];
        activity = nil;
        [self.dateTableView reloadData];
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
    int index = (int)[activity count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        ActivityModel *model = [[ActivityModel alloc] initWithJsonDictionary:dic];
        
        model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.dataID] url:model.ico showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"ShopListViewController shopname: %@", model.name);
        [activity addObject:model];
        [model release];
    }
    
    [imageDownload startTask];
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        activitys = activity;
        activity = nil;
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

#pragma mark ImageDowload

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    ActivityModel *model1;
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        if (task.index >= 0 && task.index < [activitys count]) {
            model1 = (ActivityModel *)[activitys objectAtIndex:task.index];
            /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                
            }*/
            model1.picPath = task.locURL;
            
            [model1 setImg:model1.picPath  Default:@"暂无图片"];
        }
        
    }
    
}

-(void)updataUI:(int)type{
    [self.dateTableView reloadData];
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
    [imgTapRecognize release];
    [imgTapRecognize1 release];
    [self.dateTableView release];
    //[self.foodtypes release];
    [self.foodtypeid release];
    activitys = nil;
    [self.activitys1 release];
    [self.activitys2 release];
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
            if (activitys == nil || [activitys count] == 0) {
                [self GetData:YES];
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

-(void) updateShopCart:(ActivityModel *)model{
    [self UpdateShopCart:model];
}

//更新购物车 计算购物车信息 并更新
-(void) UpdateShopCart:(ActivityModel *) model
{
    
}



/*-(void)imageSingClick:(UITapGestureRecognizer*) gesture
{
}*/

//更新列表显示
-(void) updateTable
{
    [self doSum];
    [self.dateTableView reloadData];
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (tableView.tag == 1) {
        if ([activitys count] == 0) {
            return 0;
        }
        count = (int)[activitys count];
        return count;
    }else{
        return [app.arryFoodType count];
    }
    
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
                
                
                UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 0.0, 180.0, 135.0)];
                ico.tag = 1;
               // backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
                [cell.contentView addSubview:ico];
                [ico release];
                
                //1. 名称
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(185.0, 0.0, 130, 135)];
                
                view.backgroundColor = [UIColor whiteColor];
                
                UIImageView *typeIco = [[UIImageView alloc] init];
                [typeIco setTranslatesAutoresizingMaskIntoConstraints:NO];
                typeIco.tag = 2;
                [view addSubview:typeIco];
                
                
                UILabel *nameLabel = [[UILabel alloc] init];
                [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                nameLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:0/255.0 blue:50/255.0 alpha:1.0];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                nameLabel.numberOfLines = 2;
                //nameLabel.text = shopmodel.shopname;
                nameLabel.font = [UIFont boldSystemFontOfSize:14];
                nameLabel.tag = 3;
                
                [view addSubview: nameLabel];
                
                
                //3. 简介
                
                UILabel *intr = [[UILabel alloc] init];
                [intr setTranslatesAutoresizingMaskIntoConstraints:NO];
                intr.textColor = [UIColor darkGrayColor];
                intr.textAlignment = NSTextAlignmentLeft;
                intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                intr.numberOfLines = 2;
                //nameLabel.text = shopmodel.shopname;
                intr.font = [UIFont boldSystemFontOfSize:12];
                intr.tag = 5;
                
                [view addSubview: intr];
                
                
                //2.价格
                UILabel *priceLabel1 = [[UILabel alloc] init];
                priceLabel1.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                priceLabel1.numberOfLines = 1;
                [priceLabel1 setTranslatesAutoresizingMaskIntoConstraints:NO];
                priceLabel1.textAlignment = NSTextAlignmentLeft;
                priceLabel1.font = [UIFont boldSystemFontOfSize:14];
                priceLabel1.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
                priceLabel1.tag = 71;
                [view addSubview: priceLabel1];
                
                
                
                
                UILabel *priceLabel = [[UILabel alloc] init];
                priceLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                priceLabel.numberOfLines = 1;
                [priceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                priceLabel.textAlignment = NSTextAlignmentLeft;
                priceLabel.font = [UIFont boldSystemFontOfSize:17];
                priceLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:0/255.0 blue:50/255.0 alpha:1.0];
                priceLabel.tag = 7;
                [view addSubview: priceLabel];
                
                
                UILabel *line1 = [[UILabel alloc] init];
                line1.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
                line1.numberOfLines = 1;
                [line1 setTranslatesAutoresizingMaskIntoConstraints:NO];
                line1.textAlignment = NSTextAlignmentCenter;
                line1.font = [UIFont boldSystemFontOfSize:8];
                line1.text = @"////////////////////////////////////////";
                line1.textColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                line1.tag = 72;
                [view addSubview: line1];
                
                
                //3.去看看
               
                NSDictionary *dict1 = NSDictionaryOfVariableBindings(typeIco, nameLabel, priceLabel,intr,priceLabel1,line1);
                NSDictionary *metrics = @{@"hPadding":@5, @"vPadding":@5, @"linePadding":@0,@"nameTopPadding":@8,@"typeIcoWigth":@40,@"nameRightPadding":@-15};
                NSString *vfl = @"H:|-hPadding-[nameLabel]-nameRightPadding-[typeIco]";
                NSString *vfl1 = @"H:|-hPadding-[priceLabel1(<=60)]-3-[priceLabel]-hPadding-|";
                NSString *vfl2 = @"H:|-hPadding-[intr]-hPadding-|";
                
                NSString *vfl3 = @"V:|-nameTopPadding-[nameLabel]-0-[intr]";
                
                NSString *vfl4 = @"H:|-80-[typeIco(typeIcoWigth)]-0-|";
                
                NSString *vfl5 = @"V:|-0-[typeIco(typeIcoWigth)]-85-|";
                NSString *vfl6 = @"V:[priceLabel(20)]-5-|";
                NSString *vfl7 = @"V:[priceLabel1(15)]-5-|";
                NSString *vfl8 = @"V:[line1(15)]-25-|";
                NSString *vfl9 = @"H:|-10-[line1]-10-|";
                
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
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
                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];

                [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:dict1]];
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
                [cell.contentView addSubview:view];
                [typeIco release];
                [nameLabel release];
                [intr release];
                [priceLabel1 release];
                [priceLabel release];
                [line1 release];
                [view release];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中色，无色
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                
                
               
            }
            int row = indexPath.row;
            ActivityModel *foodmodel = [activitys objectAtIndex:row];
            
            
            UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:1];
            UIImageView *typeIco = (UIImageView *)[cell.contentView viewWithTag:2];
            UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
            UILabel *intr = (UILabel *)[cell.contentView viewWithTag:5];
            UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:7];
            UILabel * priceLabel1 = (UILabel *)[cell.contentView viewWithTag:71];
            
            ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
            ico.image = foodmodel.image;
            if (foodmodel.atype == 1) {
                typeIco.image = [UIImage imageNamed:@"jifen.png"];
            }else{
                typeIco.image = nil;//这一步必须，要不然可能没办法实时更新图片
            }
        /*if ([self.foodtypeid intValue] == 2) {
            
        }*/
            if ([self.foodtypeid intValue] == 2) {//商铺活动
                nameLabel.text = foodmodel.tName;
                
                
                intr.text = foodmodel.name;
            }else{
                nameLabel.text = foodmodel.name;
                
                
                intr.text = foodmodel.Disc;
            }
            
            if (foodmodel.disCount > 0.0) {
                priceLabel.text = [NSString stringWithFormat:@"%.1f", foodmodel.disCount * 10];
                priceLabel1.text = @"最低折扣";
            }else if(foodmodel.needpoint > 0){
                priceLabel.text = [NSString stringWithFormat:@"%d", foodmodel.needpoint];
                priceLabel1.text = @"参与积分";
            }else{
                priceLabel.text = @"";
                priceLabel1.text = @"";
            }
            
            
           
            
            
            
           // priceLabel.text = ;
            
            
            
            return cell;
        

    }else{
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            cell.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0];
            
            UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 30.0, 30.0)];
            backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
            [cell.contentView addSubview:backGImg];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30,  30)];
            imageView.tag = 1;
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *textFiled = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 40)];
            
            //UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 50)];
            textFiled.tag = 2;
            textFiled.backgroundColor = [UIColor clearColor];
            textFiled.font = [UIFont boldSystemFontOfSize:10];
            textFiled.textColor = [UIColor whiteColor];
            //textFiled.contentStretch = UIControlContentVerticalAlignmentCenter;//剧中显示
            
            textFiled.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            textFiled.numberOfLines = 0;
            [cell.contentView addSubview:textFiled];
            
            [textFiled release];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 100, 2)];
            line.backgroundColor = [UIColor colorWithRed:8/255.0 green:8/255.0 blue:8/255.0 alpha:1.0];
            [cell.contentView addSubview:line];
            [line release];
        }
        //UIImage *image;
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:1];
        UILabel *name = (UILabel *)[cell viewWithTag:2];
        FoodTypeModel *model = [app.arryFoodType objectAtIndex:indexPath.row];
        imageView.image = model.image;
        name.text = model.SortName;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 140;
    }else{
        return 50;//(indexPath.row == [foods count]) ? 60 : 40;
    }
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
        if(twitterClient == nil && hasMore){
            //读取更多数据
            //page++;
            [self GetData:NO];
        }
    }
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        
        //加载更多数据的行被点击了，则加载下一页数据
        if (indexPath.row < [activitys count]) {
            ActivityDetailViewController *controller = [[[ActivityDetailViewController alloc] initWithFood:(ActivityModel *)[activitys objectAtIndex:indexPath.row]]autorelease];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end