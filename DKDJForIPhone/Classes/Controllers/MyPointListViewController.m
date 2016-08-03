//
//  MyPointListViewController.m
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "MyPointListViewController.h"
#import "MyFriendsListViewController.h"
#import "MyPointModel.h"
#import "MyFriendsListViewController.h"
#import "PXAlertView+Customization.h"
@interface MyPointListViewController ()

@end

@implementation MyPointListViewController

@synthesize dataList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(MyPointListViewController *)initWithcUserID:(NSString *)userid{
    self = [super init];
    if (self != nil) {
        userID = userid;
        [userID retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    indexPage = 1;
    //netself.dataList = [[NSMutableArray alloc] init];
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    
    self.dataList = [[NSMutableArray alloc] init];
    
    
    
    
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    [loadCell setType:MSG_TYPE_SEARCH_NET];
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.tableView addGestureRecognizer:recognizer];
    
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self.tableView addGestureRecognizer:recognizer];
    
    [recognizer release];
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    self.title = CustomLocalizedString(@"point_list_title", @"积分记录");
    [self getPointList];
    
    
    	// Do any additional setup after loading the view.
}





-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)dealloc
{
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
    [self.dataList release];
    [userID release];
    [loadCell release];
    
    [backClick release];
    //[_progressHUD release];
    //[twitterClient release];
    [super dealloc];
}

#pragma mark NET

-(void) getPointList
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", [NSString stringWithFormat:@"%d", indexPage], @"pageindex", @"30", @"pagesize", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(pointListDidReceive:obj:)];
    
    [twitterClient getPointListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
    
    
    
    [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [param release];
    
    
}

- (void)pointListDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    int page = [[dic objectForKey:@"page"] intValue];
    int total  = [[dic objectForKey:@"total"] intValue];
    if (page == total) {
        [loadCell setType:MSG_TYPE_NO_MORE];
        
    }else{
        [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    }
    NSInteger prevCount = [self.dataList count];
    NSArray *ary = [dic objectForKey:@"datalist"];
    
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyPointModel *model = [[MyPointModel alloc] initWitchDic:dic];
        [self.dataList addObject:model];
        [model release];
    }
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
}

#pragma mark tableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataList count] == 0) {
        return 0;
    }
    return [self.dataList count] + 1;
        
}
//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return;
    }
    if(indexPath.row == [self.dataList count]) {
        
        if (loadCell.getType == MSG_TYPE_LOAD_MORE_ORDERS) {
            indexPage++;
            [self getPointList];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == [self.dataList count]) {
        return loadCell;
    }
    
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 60.0, 15.0)];
        name.text = CustomLocalizedString(@"point_list_point", @"积分：");
        name.textAlignment = NSTextAlignmentRight;
        name.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:name];
        [name release];
        
        UILabel *nameValue = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 10.0, 160.0, 15.0)];
        nameValue.tag = 1;
        nameValue.textColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
        nameValue.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:nameValue];
        [nameValue release];
        
        UILabel *stateValue = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 10.0, 80.0, 15.0)];
        stateValue.tag = 2;
        
        stateValue.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:stateValue];
        [stateValue release];
        
        UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 60.0, 15.0)];
        type.text = CustomLocalizedString(@"point_list_remark", @"说明：");
        type.textAlignment = NSTextAlignmentRight;
        type.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:type];
        [type release];
        
        UILabel *typeValue = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 30.0, 250.0, 45.0)];
        typeValue.textColor = [UIColor redColor];
        typeValue.tag = 3;
        typeValue.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:typeValue];
        [typeValue release];
        
        
        
        
        
        UILabel *persion1 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 60.0, 15.0)];
        persion1.text = CustomLocalizedString(@"point_list_time", @"时间：");
        persion1.textAlignment = NSTextAlignmentRight;
        persion1.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:persion1];
        [persion1 release];
        
        UILabel *persion1Value = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 80.0, 250.0, 15.0)];
        
        persion1Value.tag = 4;
        persion1Value.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview:persion1Value];
        [persion1Value release];
        
        
        
        
        
    }
    
    MyPointModel *model = [self.dataList objectAtIndex:indexPath.row];
    
    
    
    if(model == nil)
    {
        return nil;
    }
    UILabel *pointValue = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *comentValue = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *dateTimeValue = (UILabel *)[cell.contentView viewWithTag:4];
//    UILabel *typeValue = (UILabel *)[cell.contentView viewWithTag:2];
    pointValue.text = model.point;
    comentValue.text = model.comment;
    dateTimeValue.text = model.dataTime;
    /*if (model.type == 0) {
        typeValue.text = @"普通积分";
    }else{
        typeValue.text = @"公益积分";
    }*/
    
    
    
    
    
    return cell;
}

@end
