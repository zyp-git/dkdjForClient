//
//  MyPointTopListViewController.m
//  HMBL
//
//  Created by ihangjing on 13-12-20.
//
//

#import "MyPointTopListViewController.h"
#import "PointTopModel.h"
#import "FoodDetailViewController.h"
@interface MyPointTopListViewController ()

@end

@implementation MyPointTopListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(MyPointTopListViewController *)initWithcUserID:(NSString *)userid  type:(int)type
{
    self = [super init];
    if (self) {
        userID = userid;
        [userID retain];
        topType = type;
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
    pageIndex = 1;
    dataList = [[NSMutableArray alloc] init];
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_NO_MORE];
    [self getPointTop];
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
    [loadCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NET
-(void) getPointTop
{
    //getfoodlistbyshopid.aspx?shopid=106
    // [taskLock lockWhenCondition:0];
    //[taskLock lock];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", [NSString stringWithFormat:@"%d", pageIndex], @"pageindex", [NSString stringWithFormat:@"%d", topType], @"type", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getPointTopListDidReceive:obj:)];
    
    [twitterClient getPointTopListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
     
     _progressHUD.dimBackground = YES;
     
     [self.view addSubview:_progressHUD];
     [self.view bringSubviewToFront:_progressHUD];
     _progressHUD.delegate = self;
     _progressHUD.labelText = @"加载中...";
     [_progressHUD show:YES];
    
    
    
    
    
    [param release];
}

- (void)getPointTopListDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    NSArray *ary = [dic objectForKey:@"list"];
    int page = [[dic objectForKey:@"page"] intValue];
    /*int total = [[dic objectForKey:@"total"] intValue];
    if (page >= total) {
        [loadCell setType:MSG_TYPE_NO_MORE];
    }*/
    NSInteger index = [dataList count];
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        PointTopModel *model = [[PointTopModel alloc] initWitchDic:dic];
        model.frImageLocalPath = [frImageDowload addTask:model.userID url:model.friendICON showImage:nil defaultImg:nil indexInGroup:index Goup:1];
        [model setFrImg:model.frImageLocalPath Default:@"friendDefault.png"];
        
        
        [dataList addObject:model];
        [model release];
    }
    [frImageDowload startTask];
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


#pragma mark cacheDowloat
-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type
{
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        if (task.locURL.length == 0) {
            task.locURL = @"friendDefault.png";
        }
        PointTopModel *model = [dataList objectAtIndex:i];
        
                model.frImageLocalPath = task.locURL;
                [model setFrImg:model.frImageLocalPath Default:@"friendDefault.png"];
                break;
        
        
        
        
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
        
        
    }else{
        
        
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
        
        
        
        UILabel *TopLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 60, 40)];
        TopLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        TopLabel.textAlignment = NSTextAlignmentCenter;
        //nameLabel.text = shopmodel.shopname;
        TopLabel.font = [UIFont boldSystemFontOfSize:14];
        TopLabel.tag = 1;
        [cell.contentView addSubview:TopLabel];
        [TopLabel release];
        
        UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 50.0, 40.0, 40.0)];
        backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
        [cell.contentView addSubview:backGImg];
        
        UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 52.0, 36.0, 36.0)];
        ico.tag = 2;
        [cell.contentView addSubview:ico];
        [ico release];
        //1. 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 180, 15)];
        nameLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 3;
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 180, 15)];
        pointLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        pointLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        pointLabel.font = [UIFont boldSystemFontOfSize:14];
        pointLabel.tag = 4;
        
        [cell.contentView addSubview: pointLabel];
        [pointLabel release];
        
       
        
        
        
    }
    PointTopModel *model = [dataList objectAtIndex:indexPath.row];
    
    
    
    if(model == nil)
    {
        return nil;
    }
    UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:2];
    ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
    ico.image = model.frImage;
    
    UILabel *topLabel = (UILabel *)[cell.contentView viewWithTag:1];
    topLabel.text = [NSString stringWithFormat:@"TOP%d", indexPath.row + 1];
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:3];
    nameLabel.text = model.userName;
    UILabel *pointLabel = (UILabel *)[cell.contentView viewWithTag:3];
    if (topType == 0) {
        pointLabel.text = [NSString stringWithFormat:@"花马币记录：%@", model.historyPoint];
    }else{
        pointLabel.text = [NSString stringWithFormat:@"公益积分：%@", model.publicPoint];
    }
    
    
    return cell;
}

@end
