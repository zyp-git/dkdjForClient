//
//  OrderList.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LotterOrderListViewController.h"
#import "LoadCell.h"
#import "LotterOrder4ListModel.h"
#import "LotterOrderDetailViewController.h"
#import "LoginNewViewController.h"

@implementation LotterOrderListViewController

@synthesize orders;
@synthesize userid;
@synthesize ordersTableView;

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    
    //self.ordersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    //self.ordersTableView.delegate = self;
    //self.ordersTableView.dataSource = self;
    //[self.view addSubview:self.ordersTableView];
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
        
        LoginController.title =@"会员登录"; 
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图 
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
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
		
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",uduserid,@"userid",nil];
        
        [twitterClient getLotterOrderList:param];
    }
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [pageindex release];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
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

/*
 {"page":"1","total":"4", "orderlist":
 [{"orderid":"000052219400","shopname":"四季明湖明湖楼","addtime":"2012-03-28 22:19:28","totalmoney":"103.0","state":"20"},
 {"orderid":"000051741400","shopname":"四季明湖明湖楼","addtime":"2012-03-27 17:41:27","totalmoney":"153.0","state":"20"}]}
 */
- (void)ordersDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [loadCell.spinner stopAnimating];
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
        //无数据时会报错
        //[self.ordersTableView beginUpdates];
        //NSIndexPath *path = [NSIndexPath indexPathForRow:[orders count] inSection:0];
        //[self.ordersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationLeft];
        //[self.ordersTableView endUpdates];
        return;
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    if (totalpage > page)
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
        
        LotterOrder4ListModel *model = [[LotterOrder4ListModel alloc] initWithJsonDictionary:dic];
        [orders addObject:model];
        [model release];
    }
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [self.tableView reloadData];
    }
    else {
        
        int count = (int)[ary count];
        
        //每次只获取8个商家，若返回大于8个则只取8个
        /*if (count > 4)
        {
            count = 4;
        }*/
        
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
    return [orders count] + 1;
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
            
            //1. 订单编号
            CGRect nameLabelRect = CGRectMake(5, 5, 260, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            nameLabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            //订单状态
            CGRect stateLabelRect = CGRectMake(260, 5, 60, 12);
            UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
            
            stateLabel.textAlignment = NSTextAlignmentLeft;
            stateLabel.font = [UIFont boldSystemFontOfSize:12];
            stateLabel.tag = 5;
            stateLabel.textColor = [UIColor orangeColor];
            stateLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview: stateLabel];
            [stateLabel release];

            
            //2. 商家名称
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
            
            //3. 下单时间
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
            
            //4.订单金额
            CGRect addressValueRect = CGRectMake(5, 55, 260, 12);
            UILabel *addressValue = [[UILabel alloc] initWithFrame: 
                                     addressValueRect];
            
            addressValue.textAlignment = NSTextAlignmentLeft;
            addressValue.font = [UIFont boldSystemFontOfSize:12];
            addressValue.textColor = [UIColor grayColor];
            addressValue.tag = 4;
            addressValue.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:addressValue];
            [addressValue release];
            
		}
        
        LotterOrder4ListModel *ordermodel = [orders objectAtIndex:indexPath.row];
        
        if( ordermodel == nil)
        {
            return nil;
        }
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = [[NSString alloc] initWithFormat:@"礼品名称:%@",ordermodel.Pname];
        
        UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
        if (ordermodel.ReveVar == 0) {
            telLabel.text = [[NSString alloc] initWithFormat:@"是否兑奖:未兑奖"];
        }else{
            telLabel.text = [[NSString alloc] initWithFormat:@"是否兑奖:已兑奖"];
        }
        
        
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
        timeLabel.text = [[NSString alloc] initWithFormat:@"抽奖时间:%@",ordermodel.addtime];
        
        
        UILabel *stateLabel = (UILabel *)[cell.contentView viewWithTag:5];
        switch (ordermodel.state) {
            case 0:
                stateLabel.text = @"未中奖";
                break;
            case 1:
                stateLabel.text = @"中奖";
                break;
            default:
                break;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
	//加载更多数据的行被点击了，则加载下一页数据
    if (indexPath.row == [orders count]) {
        if(hasMore){
        if (twitterClient) return;
        
        [loadCell.spinner startAnimating];
        
        NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
        
        NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",uduserid,@"userid", nil];
        [twitterClient getLotterOrderList:param];
        }
        
    }
    else {
        
        LotterOrder4ListModel *model = [orders objectAtIndex:indexPath.row];
        
        LotterOrderDetailViewController *shopdetail = [[[LotterOrderDetailViewController alloc] initWithOrderid:model.RID] autorelease];
        
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
