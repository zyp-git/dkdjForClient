//
//  CircleListViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import "CircleListViewController.h"

#import "CityListViewController.h"
#import "tooles.h"
#import "CircleModel.h"


@interface CircleListViewController ()

@end

@implementation CircleListViewController

@synthesize list;
@synthesize refreshing;
@synthesize pageindex;
@synthesize pagesize;
@synthesize pagecount;
@synthesize asiRequest;

//TODO:根据gps定位信息，显示当前所处的城市

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择商圈";
    
    hasMore = false;
    list = [[NSMutableArray array] retain];
    
    pageindex = 1;
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    //[loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    //self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    

    
}

- (id)initWithSectionId:(NSString*)sectionid
{
    NSLog(@"loadData......%ld",(long)self.pageindex);
    
    NSString *cityid = [[NSUserDefaults standardUserDefaults] stringForKey:@"CityId"];
    
    NSURL *url;
    
    url = [NSURL URLWithString:GetCircleListURLString(cityid, sectionid)];
    
    NSLog(@"url: %@",url);
    
    asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest setDelegate:self];
    [asiRequest setDidFinishSelector:@selector(GetResult:)];
    [asiRequest setDidFailSelector:@selector(GetErr:)];
    //发送startSynchronous消息后即开始在同一线程中执行HTTP请求，线程将一直等待直到请求结束（请求成功或者失败）。通过检查error属性可以判断请求是否成功或者有错误发生。
    [asiRequest startAsynchronous];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *color = [UIColor colorWithRed:255.0f/255.0f green:192.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.tintColor = color;//[UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    //[loadCell release];
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

#pragma mark - Your actions

-(void) GetErr:(ASIHTTPRequest *)request
{
    self.refreshing = NO;
    
    [tooles MsgBox:@"连接网络失败，请检查是否开启移动数据"];
}

//{"page":"1","total":"2", "datalist":[{"cid":"1","cname":"廊坊"},{"cid":"42","cname":"北京"}]}
-(void) GetResult:(ASIHTTPRequest *)request
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    if (self.refreshing) {
        //如果是刷新返回则清空原先结果
        self.refreshing = NO;
        [self.list removeAllObjects];
    }
    
    NSData *data =[request responseData];
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
    
    if (data == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSString *pageString = [dictionary objectForKey:@"page"];
    self.pagecount = [[dictionary objectForKey:@"total"] intValue];
    
    if (pageString) {
        NSLog(@"pageString: %@",pageString);
        NSLog(@"total: %ld",(long)self.pagecount);
    }
    
    if ([dictionary objectForKey:@"datalist"]) {
		NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"datalist"]];
        
        for (NSDictionary *item in array) {
            CircleModel *model = [[[CircleModel alloc]initWithJsonDictionary:item]autorelease];
            [self.list addObject:model];
        }
    }
    
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        
    }
    
    CircleModel *ordermodel = [list objectAtIndex:indexPath.row];
    
    if( ordermodel == nil)
    {
        return nil;
    }
    
    cell.textLabel.text = ordermodel.Name;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //再次进入商家菜单视图 重新加载数据
    //获取选择的分类编号
    
    CircleModel *model = [list objectAtIndex:indexPath.row];
    
    //保存商圈编号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:model.ID forKey:@"CircleID"];
    [defaults synchronize];
    
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];

    
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