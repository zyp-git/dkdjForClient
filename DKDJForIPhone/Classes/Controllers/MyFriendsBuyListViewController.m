//
//  MyFriendsBuyListViewController.m
//  HMBL
//
//  Created by ihangjing on 13-12-20.
//
//

#import "MyFriendsBuyListViewController.h"
#import "MyFriendBuy.h"
#import "FoodDetailViewController.h"
@interface MyFriendsBuyListViewController ()

@end

@implementation MyFriendsBuyListViewController
@synthesize food;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(MyFriendsBuyListViewController *)initWithcUserID:(NSString *)userid
{
    self = [super init];
    if (self) {
        userID = userid;
        [userID retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    frImageDowload = [[CachedDownloadManager alloc] initWitchReadDic:6 Delegate:self];
    foImageDowload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
    pageIndex = 1;
    dataList = [[NSMutableArray alloc] init];
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [self getBuyList];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
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
    [userID release];
    [dataList release];
    [backClick release];
    if (frImageDowload) {
        [frImageDowload stopTask];
        [frImageDowload release];
        frImageDowload = nil;
    }
    if (foImageDowload) {
        [foImageDowload stopTask];
        [foImageDowload release];
        foImageDowload = nil;
    }
    [self.food release];
    [loadCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NET
-(void) getBuyList
{
    //getfoodlistbyshopid.aspx?shopid=106
    // [taskLock lockWhenCondition:0];
    //[taskLock lock];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", [NSString stringWithFormat:@"%d", pageIndex], @"pageindex", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getBuyListDidReceive:obj:)];
    
    [twitterClient getFrinedsBuyListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
     
     _progressHUD.dimBackground = YES;
     
     [self.view addSubview:_progressHUD];
     [self.view bringSubviewToFront:_progressHUD];
     _progressHUD.delegate = self;
     _progressHUD.labelText = @"搜索中...";
     [_progressHUD show:YES];
    
    
    
     [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [param release];
}

- (void)getBuyListDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    
    
    if (obj == nil)
    {        return;
    }
    NSInteger prevCount = [dataList count];
    NSDictionary* dic = (NSDictionary*)obj;
    NSArray *ary = [dic objectForKey:@"datalist"];
    int page = [[dic objectForKey:@"page"] intValue];
    int total = [[dic objectForKey:@"total"] intValue];
    if (page >= total) {
        [loadCell setType:MSG_TYPE_NO_MORE];
    }
    int index = [dataList count];
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyFriendBuy *model = [[MyFriendBuy alloc] initWitchDic:dic];
        model.frImageLocalPath = [frImageDowload addTask:model.friendID url:model.friendICON showImage:nil defaultImg:nil indexInGroup:index Goup:1];
        [model setFrImg:model.frImageLocalPath Default:@"friendDefault.png"];
        
        model.foImageLocalPath = [foImageDowload addTask:model.foodID url:model.foodICON showImage:nil defaultImg:nil indexInGroup:index++ Goup:2];
        [model setFoImg:model.foImageLocalPath Default:@"暂无图片"];
        [dataList addObject:model];
        [model release];
    }
    [frImageDowload startTask];
    [foImageDowload startTask];
    if (page == 1) {
        [self.tableView reloadData];
    }else{
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            //NSLog(@"FoodListViewController->foodsDidReceive %d",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
    pageIndex++;
    
}

-(void) GetFoodDetailWithFoodID:(int)foodId
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", foodId], @"id",nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(foodDetailDidReceive:obj:)];
    
    [twitterClient getFoodDetailByShopId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    
    [param release];
    
    
}

- (void)foodDetailDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
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
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    //[self.foodModel release];
    
    self.food = [[FoodModel alloc] initWithJsonDictionary:dic];
    MyFriendBuy *model = [dataList objectAtIndex:selectRow];
    self.food.image = model.foImage;
    FoodDetailViewController *controller = [[[FoodDetailViewController alloc] initWithFood:food] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
   
    
}

#pragma mark cacheDowloat
-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type
{
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        if (task.locURL.length == 0) {
            task.locURL = @"friendDefault.png";
        }
        MyFriendBuy *model = [dataList objectAtIndex:i];
        switch (task.groupType) {
            case 1:
                model.frImageLocalPath = task.locURL;
                [model setFrImg:model.frImageLocalPath Default:@"friendDefault.png"];
                break;
            case 2:
                model.foImageLocalPath = task.locURL;
                [model setFoImg:model.foImageLocalPath Default:@"暂无图片"];
                break;
            default:
                break;
        }
        
        
        
    }
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
}

#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (dataList == nil || [dataList count] == 0) {
        return 0;
    }
    return [dataList count] + 1;
    
    
}
//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataList count]) {
        if ([loadCell getType] != MSG_TYPE_NO_MORE) {
            [self getBuyList];
        }
        
    }else{
        //去商品详情界面
        selectRow = indexPath.row;
        MyFriendBuy *model = [dataList objectAtIndex:selectRow];
        [self GetFoodDetailWithFoodID:[model.foodID intValue]];
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.row == [dataList count]) {
        return loadCell;
    }
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        
        UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 40.0, 40.0)];
        backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
        [cell.contentView addSubview:backGImg];
        
        UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 12.0, 36.0, 36.0)];
        ico.tag = 4;
        [cell.contentView addSubview:ico];
        [ico release];
        
        //1. 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 180, 15)];
        nameLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 1;
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(60.0, 27, 250, 71)];
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        view.tag = 2;
        [cell.contentView addSubview: view];
        [view release];
        
        UIImageView *fbackGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 40.0, 40.0)];
        fbackGImg.image = [UIImage imageNamed:@"index_food_img.png"];
        [view addSubview:fbackGImg];
        
        UIImageView *fico = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 12.0, 36.0, 36.0)];
        fico.tag = 3;
        [view addSubview:fico];
        [fico release];
        
        //1. 名称
        
        UILabel *fnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 180, 15)];
        fnameLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        fnameLabel.textAlignment = NSTextAlignmentLeft;
        fnameLabel.font = [UIFont boldSystemFontOfSize:14];
        fnameLabel.tag = 5;
        
        [view addSubview: fnameLabel];
        [fnameLabel release];
        
        UILabel *ftimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 180, 15)];
        ftimeLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        ftimeLabel.textAlignment = NSTextAlignmentLeft;
        ftimeLabel.font = [UIFont boldSystemFontOfSize:14];
        ftimeLabel.tag = 6;
        
        [view addSubview: ftimeLabel];
        [ftimeLabel release];
        
        
        
    }
    MyFriendBuy *model = [dataList objectAtIndex:indexPath.row];
    
    
    
    if(model == nil)
    {
        return nil;
    }
    UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:4];
    ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
    ico.image = model.frImage;
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    nameLabel.text = model.friendName;
    
    UIView *view = (UIView *)[cell.contentView viewWithTag:2];
    
    UIImageView *fico = (UIImageView *)[view viewWithTag:3];
    fico.image = nil;//这一步必须，要不然可能没办法实时更新图片
    fico.image = model.foImage;
    
    UILabel *fnameLabel = (UILabel *)[view viewWithTag:5];
    fnameLabel.text = model.foodName;
    
    UILabel *ftimeLabel = (UILabel *)[view viewWithTag:6];
    ftimeLabel.text = model.sendTime;
    
    return cell;
}

@end
