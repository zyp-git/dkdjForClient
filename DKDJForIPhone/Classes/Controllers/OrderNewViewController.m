//
//  OrderNewViewController.m
//  HangJingForiphone
//
//  Created by ihangjing on 16/2/24.
//
//

#import "OrderNewViewController.h"
#import "FoodListViewController.h"
#import "ShopDetailViewController.h"
#import "SCNavTabBarController.h"
#import "LoginNewViewController.h"
@interface OrderNewViewController ()

@end

@implementation OrderNewViewController
@synthesize shopDetail;
@synthesize uduserid;
@synthesize ShopId;
@synthesize orderId;
@synthesize dic;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = app.mShopModel.shopname;
    //UIImage *back = [UIImage imageNamed:@"back_ico.png"];
    self.ShopId = [NSString stringWithFormat:@"%d", app.mShopModel.shopid];
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [foodType setUserInteractionEnabled:YES];
    
    
    [foodType addGestureRecognizer:backClick];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    self.title = @"订单详情";
    
    foodListViewController = [[OrderStateListViewController alloc] initOrderID:self.orderId];
    foodListViewController.title = @"订单状态 ";
    
    
    shopDetailViewController = [[OrderDetailNewViewController alloc] initOrderID:self.orderId];
    shopDetailViewController.title = @"订单详情";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[foodListViewController, shopDetailViewController];
    navTabBarController.showArrowButton = NO;
    [navTabBarController addParentController:self];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self getOrderDetail];
    
}
#pragma mark 获取订单详情
-(void)getOrderDetail
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(orderDidReceive:obj:)];
    
    [twitterClient getOrderByOrderId:self.orderId];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
}

- (void)orderDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    //NSString *json = [NSString stringWithFormat:@"%@", obj];// stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    //json = [json stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    //1. 获取信息
    self.dic = (NSDictionary*)obj;
    
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [self.dic objectForKey:@"foodlist"];
    
    
    
    [shopDetailViewController initView:self.dic];
    [foodListViewController GetOrderStateListData:YES orderState:[[self.dic objectForKey:@"State"] intValue]];
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
}
#pragma mark 判断是否登陆
- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uduserid = [defaults objectForKey:@"userid"];
    
    if([uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[[LoginNewViewController alloc] init] autorelease];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithOrderId:(NSString*)odid
{
    self  = [super init];
    if (self) {
        self.orderId = odid;
    }
    return self;
}
-(void)goBack
{
   [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc
{
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
    [self.dic release];
    [self.orderId release];
    [self.ShopId release];
    [self.uduserid release];
    [self.shopDetail release];
    [foodListViewController release];
    [shopDetailViewController release];
    [backClick release];
    [super dealloc];
}

@end
