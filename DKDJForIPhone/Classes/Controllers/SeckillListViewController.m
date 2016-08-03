//
//  SeckillListViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import "SeckillListViewController.h"

#import "LoadCell.h"
#import "SeckillListCell.h"
#import "SeckillDetailViewController.h"
#import "SeckillListModel.h"
#import "SectionListViewController.h"

@implementation SeckillListViewController

@synthesize shops;
@synthesize buildingid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    self.buildingid = @"0";
    
    //NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    self.buildingid = [[NSUserDefaults standardUserDefaults] stringForKey:@"BuildingId"];
    
    //如果没有坐标 处理
    hasMore = false;
    shops = [[NSMutableArray array] retain];
    
    page = 1;
    
    //判断是否已经选择过建筑物
    self.buildingid = @"2608";
    
    if(![self.buildingid isEqualToString:@"0"] && self.buildingid != nil && ![self.buildingid isEqualToString:@""])
    {
        [self getShopList];
    }
    else
    {
        //如未选择则进行选择
        NSString *cityid = [[NSUserDefaults standardUserDefaults] stringForKey:@"CityId"];
        
        SectionListViewController* viewController = [[[SectionListViewController alloc] initWithCityId:cityid] autorelease];
        
        viewController.title =@"选择区域";
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
        [self presentViewController:navController animated:YES completion:nil];
        
        [viewController release];
        
        //设置 类型 建筑物点击时根据类型进入不同的界面
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"buildingType"];
        [defaults synchronize];
    }
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(160, 240)];
    [self.view addSubview:indicatorView];
    
}

-(void)getShopList
{
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopsDidReceive:obj:)];
    
    //测试
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",buildingid,@"bid",@"8",@"pagesize", nil];
    
    [twitterClient getSeckillListByBid:param];
    
    [indicatorView startAnimating];
    /*
     _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
     
     _progressHUD.dimBackground = YES;
     
     [self.view addSubview:_progressHUD];
     [self.view bringSubviewToFront:_progressHUD];
     _progressHUD.delegate = self;
     _progressHUD.labelText = @"加载中...";
     [_progressHUD show:YES];
     */
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_SHOPS];
    
    [pageindex release];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

- (void)shopsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    //[indicatorView stopAnimating];
    
   [twitterClient release];
    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    
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
    }
    
    //判断是否有下一页
    //int totalpage = [totalString intValue];
    {
        ++page;
        hasMore = true;
    }
    
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        SeckillListModel *model = [[SeckillListModel alloc] initWithJsonDictionary:dic];
        
        NSLog(@"GroupListViewController title:%@", model.title);
        [shops addObject:model];
        [model release];
    }
    
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格 刚进来没有数据，获取后有数据时reload 显示数据
        [self.tableView reloadData];
        NSLog(@"GroupListViewController->shopsDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        //每次只获取8个商家，若返回大于8个则只取8个
        if (count > 8)
        {
            count = 8;
        }
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //重新刷新表格显示数据
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"ShopListViewController->shopsDidReceive %ld",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
    
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [loadCell release];
    [buildingid release];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shops count] + ((hasMore) ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//show load more cell
    if (indexPath.row == [shops count]) {
        return loadCell;
    }
    else {
        
		static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        SeckillListCell *cell =(SeckillListCell *) [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[[SeckillListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier: CellTableIdentifier] autorelease];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        SeckillListModel *shopmodel = [shops objectAtIndex:indexPath.row];
        
        if( shopmodel == nil)
        {
            return nil;
        }
        
        cell.titleLabel.text = shopmodel.title;
        
        NSString *price = [[NSString alloc] initWithFormat:@"原价:%@ 秒杀价:%@",shopmodel.price, shopmodel.nowdis ];
        
        cell.priceLabel.text = price;
        cell.timeLabel.text = shopmodel.inve3;
        cell.shopLabel.text = shopmodel.togoname;
        
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSLog(@"GroupListViewController->shopsDidReceive %@", shopmodel.title);
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == [shops count]) ? 60 : 76;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
	//加载更多数据的行被点击了，则加载下一页数据
    if (indexPath.row == [shops count])
    {
        if (twitterClient)
        {
            return;
        }
        
        [loadCell.spinner startAnimating];
        
        [self getShopList];
    }
    else
    {
        SeckillListModel *model = [shops objectAtIndex:indexPath.row];
        
        SeckillDetailViewController *shopdetail = [[[SeckillDetailViewController alloc] initWithGroupId:model.dataid] autorelease];
        
        [self.navigationController pushViewController:shopdetail animated:true];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

@end
