//
//  ShopCartViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-16.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "AppointmentOrderListNewViewController.h"
#import "FoodInOrderModel.h"
#import "AddOrderViewController.h"
#import "FileController.h"
#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJEditShopCartNumberPopView.h"
#import "AppointmentOrderDetailNewViewController.h"

@implementation AppointmentOrderListNewViewController

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

@synthesize shopidSC;
//@synthesize shopcartDictSC;
@synthesize shopcartLabelSC;
@synthesize tableView;
@synthesize keyboardToolbar;

//@synthesize shopcartDictSCTemp;
//@synthesize shopcartDictForSaveFile;

#pragma mark GetOrderList
-(void)getOrderListData:(BOOL)isShowProcess
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d" , pageindex],@"pageindex",uduserid,@"userid", today,@"today", @"20", @"pagesize",nil];
    
    [twitterClient getAppointmentOrderList:param];
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

- (void)ordersDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    
    NSInteger prevCount = [orders count];//已经存在列表中的数量
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    pageindex = [[dic objectForKey:@"page"] intValue];
    NSString *totalString = [dic objectForKey:@"total"];
    
    
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic objectForKey:@"orderlist"];
    
    NSMutableArray *food;
    if (pageindex == 1) {
        prevCount = 0;
        if (select == 1) {//正在使用foods1。那么清空后台数据foods2的内容
            if ([orders2 count] != 0) {
                [orders2 removeAllObjects];
            }
            
            food = orders2;
            select = 2;
        }else{
            if ([orders1 count] != 0) {
                [orders1 removeAllObjects];
            }
            
            food = orders1;
            select = 1;
        }
    }else{
        food = orders;
    }
    
    if ([ary count] == 0) {
        hasMore = false;
        orders = food;
        food = nil;
        return;
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    if(totalpage > pageindex)
    {
        ++pageindex;
        hasMore = true;
    }else{
        hasMore = NO;
    }
    
    // 将获取到的数据进行处理 形成列表
    int index = (int)[food count];
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        AppointmentOrderDetailModel *model = [[AppointmentOrderDetailModel alloc] initWithJsonDictionary:dic];
        model.picPath = [imageDownload addTask:[NSString stringWithFormat:@"%d", model.shopID] url:model.ShopIcon showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        NSLog(@"OrderListViewController OrderId: %@", model.OrderId);
        [food addObject:model];
        [model release];
    }
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        orders = food;
        food = nil;
        [self.tableView reloadData];
    }
    else {
        
        int count = (int)[ary count];
        
        
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
    
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
        if (task.groupType == 1) {
            AppointmentOrderDetailModel *model1;
            if (task.index >= 0 && task.index < [orders count]) {
                model1 = (AppointmentOrderDetailModel *)[orders objectAtIndex:task.index];
                /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
                 
                 }*/
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }
        
        
    }
    
}

-(void)updataUI:(int)type{
    
    [self.tableView reloadData];
    
}
#pragma mark View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 
	}
	app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    

   
    pageindex = 1;
    [self getOrderListData:YES];

    
    [super viewWillAppear:animated];
}

-(void)getShopCart
{
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"上一项", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"下一项", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"确定", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        
        [previousBarItem release];
        [nextBarItem release];
        [spaceBarItem release];
        [doneBarItem release];
    }
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    viewHeight = 340;
    if (is_iPhone5) {
        viewHeight = 450;
    }
    today = @"0";
    state = @"-1";
    uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    self.title = @"我的预约订单";
    
    colorIndex = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self.view addSubview:self.tableView];
    
    orders1 = [[NSMutableArray alloc] init];
    orders2 = [[NSMutableArray alloc] init];
    
}



-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduseridX = [defaults objectForKey:@"userid"];
    
    NSLog(@"islogin userid:%@", uduseridX);
    
    if([uduseridX intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        //LoginController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

//清空购物车
- (void)cancel:(id)sender
{
    //清除购物车
    
    [app SetTab:1];
    
}

- (void)gotoNext:(id)sender{
    if( (![self IsLogin]) ){
        return;
    }
    if(app.shopCart.allPrice > 0.0f)
    {
        if (sumPriceSC < app.startMoney) {
            NSString *msg = [NSString stringWithFormat:@"您购买的物品总价未达到商家的起送金额%.2f", app.startMoney];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:msg  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (sumPriceSC < app.fullFree && app.fullFree > 0.0f) {//保存运费
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%.2f", app.SendMoney] forKey:@"shopcartsentmoney"];
            
            
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:@"0.00" forKey:@"shopcartsentmoney"];
        }
        
        AddOrderViewController *addorderView = [[[AddOrderViewController alloc] initWithShopId:shopidSC ] autorelease];
        
        [self.navigationController pushViewController:addorderView animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"购物车中尚无餐品，请先选择餐品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)dealloc {
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
    [self.shopidSC release];
    [self.shopcartLabelSC release];
    [self.keyboardToolbar release];
    orders = nil;
    [orders1 release];
    [orders2 release];
    [backClick release];
    [uduserid release];
    [today release];
    [state release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}



#pragma mark UITableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
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
            [self getOrderListData:NO];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
        ico.tag = 4;
        [cell.contentView addSubview:ico];
        
        
        
        
        
        //1. 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 12, 210, 15)];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.tag = 1;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        //3. 简介
        
        UILabel *intr = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 210, 15)];
        intr.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        intr.textAlignment = NSTextAlignmentLeft;
        intr.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
        intr.numberOfLines = 0;
        //nameLabel.text = shopmodel.shopname;
        intr.font = [UIFont boldSystemFontOfSize:12];
        intr.tag = 3;
        intr.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: intr];
        [intr release];
        
        //2.价格
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                               CGRectMake(110,48, 240, 12)];
        
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont boldSystemFontOfSize:13];
        priceLabel.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        priceLabel.tag = 2;
        //priceLabelRect.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: priceLabel];
        [priceLabel release];
        
        
        
        
        //4.
        UILabel *numValue = [[UILabel alloc] initWithFrame:CGRectMake(110, 63, 210, 12)];
        
        //numValue.textAlignment = NSTextAlignmentLeft;
        numValue.font = [UIFont boldSystemFontOfSize:13];
        numValue.textColor = [UIColor colorWithRed:69/255.0 green:69/255.0 blue:69/255.0 alpha:1.0];
        numValue.tag = 6;
        numValue.textAlignment = NSTextAlignmentLeft;
        
        
        [cell.contentView addSubview:numValue];
        [numValue release];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 76, 290, 2.0)];
        lineImageView.image = [UIImage imageNamed:@"horizontal_line.png"];
        lineImageView.tag = 11;
        [lineImageView setHidden:YES];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
        
        
    }
    //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
    NSInteger n = indexPath.row;
    AppointmentOrderDetailModel *foodmodel = [orders objectAtIndex:n];
    
    if( foodmodel == nil)
    {
        return nil;
    }
    UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:4];
    ico.image = foodmodel.shopImage;
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    nameLabel.text = foodmodel.ShopName;//[NSString stringWithFormat:@"订单编号：%@", foodmodel.OrderId];
    
    UILabel *intr = (UILabel *)[cell.contentView viewWithTag:3];
    intr.text = [NSString stringWithFormat:@"预约时间：%@", foodmodel.endtime];
    
    UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:2];
    priceLabel.text = [NSString stringWithFormat:@"订单编号：%@", foodmodel.OrderId];
    
    UILabel *numValue = (UILabel *)[cell.contentView viewWithTag:6];
    numValue.text = [NSString stringWithFormat:@"预约人数：%@", foodmodel.reveint];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row < [orders count]) {
        AppointmentOrderDetailModel *foodmodel = [orders objectAtIndex:indexPath.row];
        UIViewController *viewController = [[[AppointmentOrderDetailNewViewController alloc] initOrderModel:foodmodel] autorelease];
        [self.navigationController pushViewController:viewController animated:true];
    }
    
}

@end
