//
//  OrderList.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CartOrderListViewController.h"
#import "LoadCell.h"
#import "CartOrder4ListModel.h"
#import "CartOrderDetailViewController.h"
#import "LoginNewViewController.h"

@implementation CartOrderListViewController

@synthesize orders;
@synthesize userid;
@synthesize ordersTableView;

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = CustomLocalizedString(@"user_center_point_order", @"礼品兑换订单");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSLog(@"setting userid:%@", uduserid);
    
    if ([uduserid intValue] > 0 )  
    {
        
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =CustomLocalizedString(@"login", @"会员登录");
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图 
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
    }
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    [backClick release];
    [loadCell release];
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

//建筑物列表视图中切换到商家列表中时调用此函数
- (id)initWithUserid:(NSString*)stateString
{
    hasMore = false;
    orders = [[NSMutableArray array] retain];

    
    page = 1;
    NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    if ([uduserid intValue] > 0 )
    {
        NSLog(@"initWithUserId:%@", userid);
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
		
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",uduserid,@"userid", nil];
        
        [twitterClient getCartOrderList:param];
    }
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [pageindex release];
    
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
    [loadCell.spinner stopAnimating];
    
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
    NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"total: %@",totalString);
        NSLog(@"page: %d",page);
    }
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    
    if ([ary count] == 0) {
        hasMore = false;
        
        return;
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    if(totalpage > page)
    {
        ++page;
        hasMore = true;
    }else{
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMore = false;
    }

    // 将获取到的数据进行处理 形成列表
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        CartOrder4ListModel *model = [[CartOrder4ListModel alloc] initWithJsonDictionary:dic];
        [orders addObject:model];
        [model release];
    }
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([orders count] == 0) {
        return 0;
    }
    NSInteger count = [orders count] + 1;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//show load more cell
    if (indexPath.row == [orders count]) {
        return loadCell;
    }
    else {
        
		static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
		
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            //自定义布局 分别显示以下几项
            //订单编号
            //商家名称
            //下单时间
            //订单金额
            
            //1. 礼品名称
            CGRect nameLabelRect = CGRectMake(5, 5, 260, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont boldSystemFontOfSize:12];
            nameLabel.tag = 1;
            nameLabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            //状态
            CGRect stateLabelRect = CGRectMake(260, 5, 60, 12);
            UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
            
            stateLabel.textAlignment = NSTextAlignmentLeft;
            stateLabel.font = [UIFont boldSystemFontOfSize:12];
            stateLabel.tag = 5;
            stateLabel.textColor = [UIColor orangeColor];
            stateLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview: stateLabel];
            [stateLabel release];

            
            //2. 使用积分
            CGRect telLabelRect = CGRectMake(5,25, 260, 12);
            UILabel *telLabel = [[UILabel alloc] initWithFrame:
                                 telLabelRect];
            
            telLabel.textAlignment = NSTextAlignmentLeft;
            telLabel.font = [UIFont boldSystemFontOfSize:12];
            telLabel.textColor = [UIColor grayColor];
            telLabel.tag = 2;
            telLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview: telLabel];
            [telLabel release];
            
            //3. 兑换时间
            CGRect timeValueRect = CGRectMake(5, 40, 260, 12);
            UILabel *timeValue = [[UILabel alloc] initWithFrame: 
                                  timeValueRect];
            
            timeValue.textAlignment = NSTextAlignmentLeft;
            timeValue.font = [UIFont boldSystemFontOfSize:12];
            timeValue.textColor = [UIColor grayColor];
            timeValue.tag = 3;
            timeValue.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:timeValue];
            [timeValue release];
            
            /*CGRect codeValueRect = CGRectMake(5, 55, 260, 12);
            UILabel *codeValue = [[UILabel alloc] initWithFrame:
                                  codeValueRect];
            
            codeValue.textAlignment = NSTextAlignmentLeft;
            codeValue.font = [UIFont boldSystemFontOfSize:12];
            codeValue.textColor = [UIColor grayColor];
            codeValue.tag = 4;
            codeValue.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:codeValue];
            [codeValue release];*/
            
		}
        
        CartOrder4ListModel *ordermodel = [orders objectAtIndex:indexPath.row];
        
        if( ordermodel == nil)
        {
            return nil;
        }
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_list_g_name", @"礼品名称:"), ordermodel.GiftName];
        
        UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
        telLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_list_u_point", @"使用积分:"), ordermodel.PayIntegral];
        
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
        timeLabel.text = [[NSString alloc] initWithFormat:@"%@%@",CustomLocalizedString(@"gift_order_list_c_time", @"兑换时间:"), ordermodel.OrderTime];
        
        /*UILabel *codeValue = (UILabel *)[cell.contentView viewWithTag:4];
        codeValue.text = [[NSString alloc] initWithFormat:@"验证码:%@",ordermodel.validcode];*/
        
        UILabel *stateLabel = (UILabel *)[cell.contentView viewWithTag:5];
        //stateLabel.text = ordermodel.State;
        switch (ordermodel.State) {
            case 0:
                stateLabel.text = CustomLocalizedString(@"check_state_0", @"未审核");
                break;
            case 1:
                stateLabel.text = CustomLocalizedString(@"check_state_1", @"审核通过");
                break;
            case 2:
                stateLabel.text = CustomLocalizedString(@"check_state_2", @"审核未通过");
                break;
            default:
                break;
        }
        //订单状态
        /*
        if( [ordermodel.State compare:@"1"] == NSOrderedSame )
        {
            stateLabel.text = @"新增订单";
        }
        else if([ordermodel.State compare:@"1"] == NSOrderedSame )
        {
            stateLabel.text = @"审核通过";
        }
        else if([ordermodel.State compare:@"4"] == NSOrderedSame )
        {
            stateLabel.text = @"正在配送";
        }
        else if([ordermodel.State compare:@"5"] == NSOrderedSame )
        {
            stateLabel.text = @"处理成功";
        }
        else if([ordermodel.State compare:@"6"] == NSOrderedSame )
        {
            stateLabel.text = @"订单取消";
        }
         */
        //[shopmodel release]; //此处不能做release操作，会导致程序报错
        
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
	//加载更多数据的行被点击了，则加载下一页数据
    if (indexPath.row == [orders count]) {
        if (hasMore) {
            if (twitterClient) return;
            
            [loadCell.spinner startAnimating];
            
            NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
            
            twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
            
            NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
            
            NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",uduserid,@"userid", nil];
            [twitterClient getCartOrderList:param];
        }
        
        
    }
    else {
        
        CartOrder4ListModel *model = [orders objectAtIndex:indexPath.row];
        
        CartOrderDetailViewController *shopdetail = [[[CartOrderDetailViewController alloc] initWithOrderid:model.OrderId] autorelease];
        
        [self.navigationController pushViewController:shopdetail animated:true];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
