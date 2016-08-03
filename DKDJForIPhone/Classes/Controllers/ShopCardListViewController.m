//
//  ShopCardListViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 13-2-26.
//
//

#import "ShopCardListViewController.h"
#import "LoadCell.h"
#import "LoginNewViewController.h"

@implementation ShopCardListViewController

@synthesize orders;
@synthesize userid;

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = @"我的店铺券";
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
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
- (id)initWithUserid
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
        
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",@"8",@"pagesize",uduserid,@"userid", nil];
        
        [twitterClient getShopCardListByUserId:param];
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
 {"cardnum":"111128","point":"100","ckey":"1111-1111-1111-1128","cmoney":"100.0","CID":"18"}
 */
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
    //int totalpage = [totalString intValue];
    
    {
        ++page;
        hasMore = true;
    }
    
    // 将获取到的数据进行处理 形成列表
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        ShopCardModel *model = [[ShopCardModel alloc] initWithJsonDictionary:dic];
        [orders addObject:model];
        [model release];
    }
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [self.tableView reloadData];
    }
    else {
        
        int count = (int)[ary count];
        
        //每次只获取8个，若返回大于8个则只取8个
        if (count > 8)
        {
            count = 8;
        }
        
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
    return [orders count] + ((hasMore) ? 1 : 0);
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
            
            //1.
            CGRect stateLabelRect = CGRectMake(260, 5, 60, 12);
            UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
            
            stateLabel.textAlignment = NSTextAlignmentLeft;
            stateLabel.font = [UIFont boldSystemFontOfSize:12];
            stateLabel.tag = 5;
            stateLabel.textColor = [UIColor orangeColor];
            stateLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview: stateLabel];
            [stateLabel release];
            
            
            //2.
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
            
            //3.
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
		}
        
        ShopCardModel *ordermodel = [orders objectAtIndex:indexPath.row];
        
        if( ordermodel == nil)
        {
            return nil;
        }
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = [[NSString alloc] initWithFormat:@"店铺券券号:%@",ordermodel.cardnum];
        
        UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
        telLabel.text = [[NSString alloc] initWithFormat:@"面值:%.1f",[ordermodel.point floatValue]];
        
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
        timeLabel.text = [[NSString alloc] initWithFormat:@"余额:%.1f",[ordermodel.cmoney floatValue]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row == [orders count]) {
        if (twitterClient) return;
        
        [loadCell.spinner startAnimating];
        
        NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
        
        NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
        
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",@"8",@"pagesize",uduserid,@"userid", nil];
        
        [twitterClient getShopCardListByUserId:param];
        
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
