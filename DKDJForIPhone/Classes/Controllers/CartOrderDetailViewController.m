//

//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "CartOrderDetailViewController.h"

#import "LoadCell.h"


@implementation CartOrderDetailViewController

@synthesize orderid;
//@synthesize ordersTableView;
@synthesize foods;
@synthesize cartOrder;
@synthesize shopcartDict;
@synthesize stateString;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    
    //[self.view addSubview:self.ordersTableView];
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    shopcartDict = [[NSMutableArray array] retain];
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [backClick release];
    [super dealloc];
}

//建筑物列表视图中切换到商家列表中时调用此函数
- (id)initWithOrderid:(NSString*)OrderId
{
    if (self = [super initWithNibName:@"OrderDetailView" bundle:nil]) {
        self.navigationItem.title = CustomLocalizedString(@"gift_order_detail_title", @"礼品兑换详情");
    }
    
    orderid = OrderId;
        
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(orderDidReceive:obj:)];
        
    [twitterClient getCartOrderByOrderId:orderid];
        
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];  

    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    return self;
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
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
    
    //1. 获取信息
    NSDictionary *dic = (NSDictionary*)obj;
    
    self.cartOrder = [[CartOrderDetailModel alloc] initWithJsonDictionary:dic];
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [self.tableView reloadData];
    
    NSLog(@"tableView reloadData");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //if (indexPath.row == [shopcartDict count]) {
    //    return loadCell;
    //}
    
    static NSString *PresidentCellIdentifier = @"OrderDetailCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:style 
                                       reuseIdentifier:PresidentCellIdentifier] autorelease];
    }
    
    if(self.cartOrder == nil )
    {
        NSLog(@"self.dic == nil");
        return cell;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];

    NSLog(@"indexPath.section %ld",(long)indexPath.section);
    
    if( indexPath.section == 0 )
    {
        NSLog(@"row:%lu", (unsigned long)row);
        cell.detailTextLabel.text = @"";
        
        switch (row) {
            case 0:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_list_g_name", @"礼品名称:"), self.cartOrder.GiftName];
                //由于下面的菜单列表中有 detailTextLabel cell复用滚动后 菜单的价格信息会在这里显示，所以要进行清除
                break;
            case 1:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_list_u_point", @"使用积分:"), self.cartOrder.PayIntegral];
                break;
            case 2:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_list_c_time", @"兑换时间:"), self.cartOrder.OrderTime];
                break;
            case 3:
                switch (self.cartOrder.State) {
                    case 0:
                        cell.textLabel.text = CustomLocalizedString(@"check_state_0",@"  状态:未审核");
                        break;
                    case 1:
                        cell.textLabel.text = CustomLocalizedString(@"check_state_1",@"  状态:审核通过");
                        break;
                    case 2:
                        cell.textLabel.text = CustomLocalizedString(@"check_state_2",@"  状态:审核未");
                        break;
                    default:
                        break;
                }
                
                break;
            default:
                break;
        }
    }
    else if( indexPath.section == 1 )
    {
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.text = @"";
        switch (row) {
            case 0:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"order_detail_reciver", @"联系人:"), self.cartOrder.Person];
                break;
            case 1:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"ordercontent_ph", @"联系电话:"), self.cartOrder.Phone];
                break;
            case 2:
                /*if ([self.cartOrder.sendtype compare:@"1"] == NSOrderedSame) {
                    cell.textLabel.text = [[NSString alloc] initWithFormat:@"取货地址:%@",self.cartOrder.remark];
                }else{*/
                    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"order_addr", @"送货地址:"), self.cartOrder.Address];
               // }
                
                break;
            case 3:
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_detail_rev_time", @"取送货时间:"), self.cartOrder.Date];
                break;
            default:
                break;
        }
    }    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //输入框点击行时不做任何处理
    
    return nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if(section == 0 )
    {
        return CustomLocalizedString(@"gift_order_detail_info", @"订单信息");
    }
    else if(section == 1 )
    {
        return CustomLocalizedString(@"gift_order_detail_re_info", @"收货信息");
    }
    
    return nil;
}

//设置rowHeight  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
       
    return 30.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if( section == 0 )
    {
        return 4;
    }
    else if( section == 1 )
    {
        return 4;
    }
    
    return 0;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
@end
