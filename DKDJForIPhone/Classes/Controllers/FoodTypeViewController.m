//
//  FoodTypeViewController.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-4.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "FoodTypeViewController.h"
#import "FoodTypeModel.h"

@implementation FoodTypeViewController

@synthesize shoptypes;
@synthesize shopid;
@synthesize shoptyTableView;

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = @"分类";
    
    self.shoptyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    self.shoptyTableView.delegate = self;
    self.shoptyTableView.dataSource = self;
    [self.view addSubview:self.shoptyTableView];
}

- (id)initWithShopid:(NSString*)Shopid
{
    hasMore = false;
    shoptypes = [[NSMutableArray array] retain];
    
    page = 1;
    
    if ([Shopid intValue] > 0 )  
    {
        shopid = Shopid;
        
        NSLog(@"initWithShopid:%@", Shopid);
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
		
        
        [twitterClient getFoodTypeListByShopId:shopid];
    }
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    //[loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];

    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  
    
    self.shoptyTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}

/*
{"foodtypelist":[{"SortID":"6220","SortName":"便当类","JOrder":"1"},{"SortID":"6221","SortName":"单加类","JOrder":"1"},{"SortID":"6222","SortName":"粥类","JOrder":"1"}]}
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
    
//    NSInteger prevCount = [shoptypes count];//已经存在列表中的数量
    
    if (obj == nil){
        return;
    }
    
    //1. 获取到page total 
    NSDictionary* dic = (NSDictionary*)obj;
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodtypelist"];
    
    if ([ary count] == 0) {
        hasMore = false;
        return;
    }
    
    
    // 将获取到的数据进行处理 形成列表
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        FoodTypeModel *model = [[FoodTypeModel alloc] initWithJsonDictionary:dic];
        NSLog(@"OrderListnewViewController OrderId: %@", model.SortID);
        [shoptypes addObject:model];
        [model release];
    }
    
    //不分页  直接加载整个数据
    [self.shoptyTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shoptypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        
    }        
    
    FoodTypeModel *ordermodel = [shoptypes objectAtIndex:indexPath.row];
    
    if( ordermodel == nil)
    {
        return nil;
    }
    
    cell.textLabel.text = ordermodel.SortName;
    
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
    return 40;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //再次进入商家菜单视图 重新加载数据
    //获取选择的分类编号 
    
    FoodTypeModel *model = [shoptypes objectAtIndex:indexPath.row];
    
    [self.delegate FoodTypeViewControllerValueChanged:model.SortID];
    
    //保存编号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:model.SortID forKey:@"SortID"];
    [defaults synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
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
