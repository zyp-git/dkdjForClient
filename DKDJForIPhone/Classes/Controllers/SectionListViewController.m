//
//  SectionListViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-4.
//
//

#import "SectionListViewController.h"
#import "tooles.h"
#import "GiftInfoModel.h"

@interface SectionListViewController ()

@end

@implementation SectionListViewController

@synthesize list;
@synthesize refreshing;
@synthesize pageindex;
@synthesize pagesize;
@synthesize pagecount;
@synthesize asiRequest;
@synthesize defaultPath;
@synthesize imageDownload;

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    NSBundle *myBundle = [NSBundle mainBundle];
    self.imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:3 Delegate:self];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    [myBundle release];
    self.navigationItem.title = @"积分兑换";
    
    hasMore = false;
    list = [[NSMutableArray array] retain];
    
    pageindex = 1;
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    //[loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
}

-(void)cancel:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithGetData
{
    NSLog(@"loadData......%ld",(long)self.pageindex);
    
    //NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSURL *url;
    //pageindex, Pagesize, sortid, subsortid, Gname
    url = [NSURL URLWithString:GetGiftListURLString(@"1", @"8", @"0", @"0", @"")];
    
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
    
    return  self;
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

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    /*FShop4ListModel *shopmodel = [shops objectAtIndex:0];
     shopmodel.shopname=@"测试";
     [self.tableView reloadData];*/
    for (int i = index; i < [arry count]; i++) {
//        ImageDowloadTask *task = [arry objectAtIndex:i];
        
    }
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
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
            GiftInfoModel *model = [[[GiftInfoModel alloc]initWithJsonDictionary:item]autorelease];
            [self.imageDownload addTask:model.gID url:model.pic showImage:nil defaultImg:defaultPath];
            [self.list addObject:model];
        }
    }
    [self.imageDownload startTask];
    
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
        UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 50)];
        ico.image = [[UIImage alloc] initWithContentsOfFile:self.defaultPath];
        ico.tag = 5;//不能使用0
        [cell.contentView addSubview:ico];
        [ico release];
        //1. 名称
        CGRect nameLabelRect = CGRectMake(60, 5, 205, 15);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 1;
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        //2. 兑换积分
        CGRect telLabelRect = CGRectMake(60,25, 205, 12);
        UILabel *telLabel = [[UILabel alloc] initWithFrame:
                             telLabelRect];
        
        telLabel.textAlignment = NSTextAlignmentLeft;
        //telLabel.text = shopmodel.tel;
        telLabel.font = [UIFont boldSystemFontOfSize:12];
        telLabel.textColor = [UIColor grayColor];
        telLabel.tag = 2;
        
        [cell.contentView addSubview: telLabel];
        [telLabel release];
        
        //3. 剩余数量
        CGRect timeValueRect = CGRectMake(60, 40, 205, 12);
        UILabel *timeValue = [[UILabel alloc] initWithFrame:
                              timeValueRect];
        
        timeValue.textAlignment = NSTextAlignmentLeft;
        //timeValue.text = shopmodel.OrderTime;
        timeValue.font = [UIFont boldSystemFontOfSize:12];
        timeValue.textColor = [UIColor grayColor];
        timeValue.tag = 3;
        
        [cell.contentView addSubview:timeValue];
        [timeValue release];
        
        //4.礼品价格
        CGRect addressValueRect = CGRectMake(60, 55, 205, 12);
        UILabel *addressValue = [[UILabel alloc] initWithFrame:
                                 addressValueRect];
        
        addressValue.textAlignment = NSTextAlignmentLeft;
        //addressValue.text = shopmodel.address;
        addressValue.font = [UIFont boldSystemFontOfSize:12];
        addressValue.textColor = [UIColor grayColor];
        addressValue.tag = 4;
        
        [cell.contentView addSubview:addressValue];
        [addressValue release];
        
    }
    
    GiftInfoModel *ordermodel = [list objectAtIndex:indexPath.row];
    
    if( ordermodel == nil)
    {
        return nil;
    }
    
    UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:5];
    UIImage *image = [[UIImage alloc] init];
    if (ordermodel.locaPath == nil || ordermodel.locaPath.length == 0) {
        image = [image initWithContentsOfFile:defaultPath];
    }else{
        image = [image initWithContentsOfFile:ordermodel.locaPath];
    }
    [ico setImage:image];
    [image release];
    //[ico1 ]
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    if (ordermodel.type == 1) {
        nameLabel.text = [NSString stringWithFormat:@"%@(现金券)", ordermodel.gName];
    }else{
        nameLabel.text = ordermodel.gName;
    }
    
    //NSString *aString = [[NSString alloc] initWithFormat:@"兑换积分:%d", ordermodel.needPoint];
    
    UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
    telLabel.text = [[NSString alloc] initWithFormat:@"兑换积分:%d", ordermodel.needPoint];
    
    UILabel *timeValue = (UILabel *)[cell.contentView viewWithTag:3];
    timeValue.text = [[NSString alloc] initWithFormat:@"剩余数量:%d", ordermodel.stocks];
    
    UILabel *addressValue = (UILabel *)[cell.contentView viewWithTag:4];
    addressValue.text = [[NSString alloc] initWithFormat:@"礼品价格:%@", ordermodel.price];
    
    //[shopmodel release]; //此处不能做release操作，会导致程序报错
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //设置UItableCelView背景
    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    backgrdView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = backgrdView;
    
    [backgrdView release];
    
    
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
    
    GiftInfoModel *model = [list objectAtIndex:indexPath.row];
    
    //保存编号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:model.gID forKey:@"SectionID"];
    [defaults synchronize];
    
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    CircleListViewController *viewController = [[[CircleListViewController alloc] initWithSectionId:model.gID] autorelease];
    viewController.title =@"选择商圈";
    [self.navigationController pushViewController:viewController animated:true];
    
    //SectionListViewController* viewController = [[[SectionListViewController alloc] initWithCityId:cityid] autorelease];
    
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    //[self presentViewController:navController animated:YES completion:nil];
    
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
