//
//  ShopCartViewController.m
//  EasyEat4iPhone
//  Created by OS Mac on 12-5-16.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "OrderListNewViewController.h"
#import "FoodInOrderModel.h"
#import "AddOrderViewController.h"
#import "FileController.h"
#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJEditShopCartNumberPopView.h"
#import "Order4ListModel.h"
#import "OrderNewViewController.h"
#import "FoodInOrderModelFix.h"
#import "CommendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"
@implementation OrderListNewViewController{
    NSMutableArray * receiveOrderArr;
    NSMutableArray * sendingOrderArr;
    NSMutableArray * orders;
    NSString * orderID;
    NSMutableArray <NSMutableArray *>* foodsArr;//每个订单对应的食物数组
    UIView * nonOrderView;
    
}

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 90
@synthesize shopidSC;
@synthesize shopcartLabelSC;
@synthesize keyboardToolbar;
@synthesize colorArry;
#pragma mark 获取订单详情
#pragma mark GetOrderList zyp  我的订单列表
-(void)getOrderListData:(BOOL)isShowProcess
{
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d" , pageindex],@"pageindex",uduserid,@"userid", @"8", @"pagesize",nil];

    NSString *url = APP_PATH  @"getorderlistbyuserid.aspx";
    
    [MHNetworkManager postReqeustWithURL:url params:param successBlock:^(NSDictionary *returnData) {
        [self ordersDidReceive:returnData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}

- (void)ordersDidReceive:(NSDictionary *)dic
{
    NSLog(@"ordersDidReceive%@",dic);

    pageindex = [[dic objectForKey:@"page"] intValue];
    [self.orderTableView.mj_header endRefreshing];
    //2. 获取list
    NSArray *ary = [dic objectForKey:@"orderlist"];
    // 将获取到的数据进行处理 形成列表
    orders=[NSMutableArray array];

    for (NSDictionary * dic in ary) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
//        NSLog(@"%@",dic);
        Order4ListModel *model = [[Order4ListModel alloc] initWithJsonDictionary:dic];
        [orders addObject:model];
        if (model.Sendtate==3) {
            [receiveOrderArr addObject:model];
        }else{
            [sendingOrderArr addObject:model];
        }

    }
    
    [self.orderTableView reloadData];
    
}

#pragma mark View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    today = @"0";
    state = @"-1";
    uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];

    self.title = @"订单";
    self.edgesForExtendedLayout =UIRectEdgeNone;
    CGFloat viewH=667-40-49;
    
    UIView * topView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 40)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 39.4, 375, 0.6)];
    line.backgroundColor=[UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1];
    [topView addSubview:line];
    
    btnProcess=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnProcess setTitle:@"未完成" forState:UIControlStateNormal];
    btnProcess.frame=RectMake_LFL(375/2-162.5, (40-25)/2, 150, 25);
    [btnProcess setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1-light"] forState:UIControlStateSelected];
    [btnProcess setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
    [btnProcess setTitleColor:app.sysTitleColor forState:UIControlStateNormal];
    [btnProcess setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [topView addSubview:btnProcess];
    btnProcess.selected=YES;
    btnProcess.tag=1;
    
    btnFinish=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnFinish setTitle:@"已完成" forState:UIControlStateNormal];
    btnFinish.frame=RectMake_LFL(375/2+25/2, (40-25)/2, 150, 25);
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1-light"] forState:UIControlStateSelected];
    [btnFinish setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
    [btnFinish setTitleColor:app.sysTitleColor forState:UIControlStateNormal];
    [btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [topView addSubview:btnFinish];
    
    [btnProcess addTarget:self action:@selector(orderListCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnFinish addTarget:self action:@selector(orderListCheckboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView * tableViewe2= [[UITableView alloc] initWithFrame:RectMake_LFL(0, 40, 375, viewH-50) style:UITableViewStylePlain];
    self.orderTableView=tableViewe2;
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    self.orderTableView.tag=0;
    self.orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        receiveOrderArr =[NSMutableArray array];
        sendingOrderArr= [NSMutableArray array];
        orders=[NSMutableArray array];
        [self getOrderListData:YES];
    }];
    [self.view addSubview:self.orderTableView];
    if ([self IsLogin]) {
        [self.orderTableView.mj_header beginRefreshing];
    }else{
        UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"您还没有登陆" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * aa=[UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
            [self presentViewController:navController animated:YES completion:nil];
        }];
        [ac addAction:aa];
        aa=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:aa];
        [self.navigationController presentViewController:ac animated:YES completion:nil];
    }
}
#pragma mark - view生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    pageindex = 1;
    if ([self IsLogin]) {
        if (self.orderTableView.mj_header.state==MJRefreshStateIdle) {
            [self.orderTableView.mj_header beginRefreshing];
        }
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
   
}
- (void)viewDidDisappear:(BOOL)animated{
    if (twitterClient) {
        [twitterClient cancel];
        twitterClient = nil;
    }
}
-(void)orderListCheckboxClick:(UIButton *)btn{

    if (btn.selected==NO) {
        btnProcess.selected = ! btnProcess.selected;
        btnFinish.selected = ! btnFinish.selected;
    }
    [self.orderTableView reloadData];
    
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uduserid = [defaults objectForKey:@"userid"];
}

- (BOOL)IsLogin{
    [self refreshFields];
    if([uduserid intValue]  > 0 ){
        return YES;
    }
    else{
        return NO;
    }
}

//清空购物车
- (void)cancel:(id)sender{
    //清除购物车
    [app SetTab:1];
    
}

#pragma mark UITableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = self.orderTableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.orderTableView.bounds;          // UIScrollView 可视高度
    CGSize size = self.orderTableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.orderTableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(twitterClient == nil && hasMore){
            //读取更多数据
            [self getOrderListData:NO];
        }
    }

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    
    [nonOrderView removeFromSuperview];
    nonOrderView=nil;
    nonOrderView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 200, 375, 200)];
    nonOrderView.backgroundColor=[UIColor clearColor];
    UIImageView * imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"订单-(4)"]];
    imgView.frame=RectMake_LFL((375-90)/2,0, 90, 90);
    [nonOrderView addSubview:imgView];
    UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL((375-150)/2, 100, 150, 30)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor lightGrayColor];
    [nonOrderView addSubview:label];
    
    if ([btnProcess isSelected]) {
        if ([sendingOrderArr count]==0) {
            [self.view addSubview:nonOrderView];
            label.text=@"您没有未完成的订单";
        }
        return [sendingOrderArr count];
    }else{
        if ([receiveOrderArr count]==0) {
            label.text=@"您还没有完成的订单";
            [self.view addSubview:nonOrderView];
        }
        return [receiveOrderArr count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([btnProcess isSelected]) {
        OrderListCell * cell=[OrderListCell cellProcessWithTableView:tableView];
        cell.delegate=self;
        return cell;
    }else{
        OrderListCell * cell= [OrderListCell cellProcessWithTableView:tableView];
        cell.delegate=self;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([btnProcess isSelected]) {
        ((OrderListCell *)cell).orderModel=[sendingOrderArr objectAtIndex:indexPath.row];
    }else{
        ((OrderListCell *)cell).orderModel=[receiveOrderArr objectAtIndex:indexPath.row];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([btnProcess isSelected]) {
        return CGRectGetMaxY(RectMake_LFL(0, 0, 375, 100));
    }else{
        return CGRectGetMaxY(RectMake_LFL(0, 0, 375, 100));
    }
}
//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_orderTableView deselectRowAtIndexPath:indexPath animated:true];
    NSArray *orderArr=[btnProcess isSelected]? sendingOrderArr : receiveOrderArr;
        Order4ListModel *foodmodel = [orderArr objectAtIndex:indexPath.row];
        UIViewController *viewController = [[OrderDetailNewViewController alloc] initOrderID:foodmodel.OrderId];
        [self.navigationController pushViewController:viewController animated:true];
    
}
-(void)OrderListCell:(OrderListCell *)cell gotoComment:(NSInteger)BtnTag{
    
    CommendDetailViewController * viewContro=[[CommendDetailViewController alloc]initWithFood:cell.orderModel.foodsArr[0] orderID:cell.orderModel.OrderId];
    UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:viewContro];
    [self presentViewController:navi animated:YES completion:nil];
}

@end
