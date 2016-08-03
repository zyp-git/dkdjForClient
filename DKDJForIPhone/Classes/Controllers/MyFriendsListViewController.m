//
//  MyFriendsListViewController.m
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "MyFriendsListViewController.h"
#import "MyPhoneAddressBookListViewController.h"
#import "MyFriendsBuyListViewController.h"
#import "MyPointTopListViewController.h"
@interface MyFriendsListViewController ()

@end

@implementation MyFriendsListViewController

@synthesize myFriendsList;
@synthesize imageDowload;
@synthesize tableView;
@synthesize searchValue;
@synthesize deleteTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(MyFriendsListViewController *)initWithcUserID:(NSString *)userid{
    self = [super init];
    if (self != nil) {
        couponModel = nil;
        userID = userid;
        [userID retain];
    }
    
    return self;
}

-(MyFriendsListViewController *)initWithcCoupon:(MyCouponModel *)model userid:(NSString *)userid{
    self = [super init];
    if (self != nil) {
        couponModel = model;
        [couponModel retain];
        userID = userid;
        [userID retain];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (is_iPhone5) {
        viewHeight = 365;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 290;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    optIndex = -1;
    indexPage = 1;
    db = [[DBHelper alloc] initOpenDataBase];
    if (db) {
        [db CreateTable];
        
        // = arry;
    }
    //netDataList = [[NSMutableArray alloc] init];
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    UIButton *friendsBuy;
    UIBarButtonItem *saveButton;
    if (couponModel == nil) {
        saveButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"通讯录"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(phoneCheck:)];
        viewHeight -= 5;
        UIButton *pointTop = [[UIButton alloc] initWithFrame:CGRectMake(0.0, viewHeight + 50, 106, 40)];
        [pointTop setImage:[UIImage imageNamed:@"point_top.png"] forState:UIControlStateNormal];
        //pointTop.backgroundColor = [UIColor colorWithRed:131/255.0 green:121/255.0 blue:0/255.0 alpha:1.0];
        //[pointTop setTitle:@"花马币排行" forState:UIControlStateNormal];
        [pointTop addTarget:self action:@selector(gotoPointTop:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:pointTop];
        [pointTop release];
        
        UIButton *publicTop = [[UIButton alloc] initWithFrame:CGRectMake(107.0, viewHeight + 50, 106, 40)];
        [publicTop setImage:[UIImage imageNamed:@"public_top.png"] forState:UIControlStateNormal];
        //publicTop.backgroundColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:100/255.0 alpha:1.0];
        //[publicTop setTitle:@"公益排行" forState:UIControlStateNormal];
        [publicTop addTarget:self action:@selector(gotoPublicTop:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:publicTop];
        [publicTop release];
        
        friendsBuy = [[UIButton alloc] initWithFrame:CGRectMake(214.0, viewHeight + 50, 106, 40)];
        [friendsBuy setImage:[UIImage imageNamed:@"friend_buy"] forState:UIControlStateNormal];
        //friendsBuy.backgroundColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
        //[friendsBuy setTitle:@"好友购买" forState:UIControlStateNormal];
        [friendsBuy addTarget:self action:@selector(gotoFriendsBuyList:) forControlEvents:UIControlEventTouchDown];
        
    }else{
        saveButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"确定选择"
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(phoneCheck:)];
        
        friendsBuy = [[UIButton alloc] initWithFrame:CGRectMake(0.0, viewHeight + 50, 320, 30)];
        friendsBuy.backgroundColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
        [friendsBuy setTitle:@"请选择您要赠送的好友" forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    [self.view addSubview:friendsBuy];
    [friendsBuy release];
    
    self.imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:6 Delegate:self];
    
    searchbar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    searchbar.delegate = self;
    //[searchbar setShowsCancelButton:NO];
    //[searchbar setShowsCancelButton:NO animated:YES];
    //searchbar.barStyle = UIBarStyleBlackTranslucent;
    //searchbar.showsCancelButton=YES;
    //searchbar.barStyle=UIBarStyleDefault;
    searchbar.placeholder=@"搜索好友：名称、手机号码";
    searchbar.keyboardType= UIKeyboardTypeDefault;
    searchbar.backgroundColor=[UIColor redColor];
    
    //UIView *segment = [searchbar.subviews objectAtIndex:0];
    
    //UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    //[segment addSubview: bgImage];
    searchbar.showsCancelButton=NO;
    [self.view addSubview:searchbar];
    //[searchbar release];
    
    isShowDeleteTable = NO;
    self.deleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(320.0f, 50.0f, 60.0f, viewHeight)];
    self.deleteTableView.delegate = self;
    self.deleteTableView.tag = 1;
    self.deleteTableView.dataSource = self;
    [self.view addSubview:self.deleteTableView];
    
    tableViewType = 0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, viewHeight)];
    self.tableView.tag = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
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
    
    
    
    	// Do any additional setup after loading the view.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        NSLog(@"swipe down");
        [self hideDeleteTable];
        //执行程序
        
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        NSLog(@"swipe up");
        [self hideDeleteTable];
        //执行程序
        
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe left");
        
        //执行程序
        [self showDeleteTable];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"swipe right");
        [self hideDeleteTable];
        //执行程序
        
    }
    
}
-(void)gotoPointTop:(id)sender
{
    MyPointTopListViewController *viewController = [[[MyPointTopListViewController alloc] initWithcUserID:userID type:0] autorelease];
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)gotoPublicTop:(id)sender
{
    MyPointTopListViewController *viewController = [[[MyPointTopListViewController alloc] initWithcUserID:userID type:1] autorelease];
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)gotoFriendsBuyList:(id)sender
{
    MyFriendsBuyListViewController *viewController = [[[MyFriendsBuyListViewController alloc] initWithcUserID:userID] autorelease];
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)phoneCheck:(id)sender
{
    //通讯录匹配
    if (couponModel == nil) {
        MyPhoneAddressBookListViewController *viewController = [[[MyPhoneAddressBookListViewController alloc] initWithUserid:userID] autorelease];
        [self.navigationController pushViewController:viewController animated:true];
    }else{
        [self geverCouponFriend];
    }
    
}
-(void)hideDeleteTable
{
    if (tableViewType == 1) {
        return;
    }
    if (isShowDeleteTable) {
        isShowDeleteTable = NO;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        self.tableView.frame = CGRectMake(0, 50, 320, viewHeight);
        self.deleteTableView.frame = CGRectMake(320, 50, 60, viewHeight);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
    }
}

-(void)showDeleteTable
{
    if (tableViewType == 1) {
        return;
    }
    isShowDeleteTable = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    self.tableView.frame = CGRectMake(0, 50, 260, viewHeight);
    self.deleteTableView.frame = CGRectMake(260, 50, 60, viewHeight);
    [self.deleteTableView reloadData];
    CGPoint pt = [self.tableView contentOffset];
    [self.deleteTableView setContentOffset:pt];//防止滚动时不对应
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (myFriendsList == nil || [myFriendsList count] == 0) {
        [self ReadData];
        [self getFriends];
    }
    
}

-(void)ReadData{
    if (db) {
        self.myFriendsList = [db getAllFriends];
    }
    for (int i = 0; i < [self.myFriendsList count]; i++) {
        MyFriends *model = [myFriendsList objectAtIndex:i];
        model.imageLocalPath = [self.imageDowload addTask:[NSString stringWithFormat:@"%d", model.friendID] url:model.friendICON showImage:nil defaultImg:@"" indexInGroup:i Goup:1];
        [model setImg:model.imageLocalPath Default:@"friendDefault.png"];
    }
    [self.imageDowload startTask];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type
{
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        if (task.locURL.length == 0) {
            task.locURL = @"friendDefault.png";
        }
        MyFriends *model;
        switch (task.groupType) {
            case 1:
                model = [myFriendsList objectAtIndex:task.index];
                break;
            case 2:
                model = [searchList objectAtIndex:task.index];
                break;
            default:
                break;
        }
        model.imageLocalPath = task.locURL;
        [model setImg:model.imageLocalPath Default:@"friendDefault.png"];
        
        
    }
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
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
    [self.myFriendsList release];
    [userID release];
    [self.tableView release];
    if (self.imageDowload != nil) {
        [self.imageDowload stopTask];
        [self.imageDowload release];
    }
    [couponModel release];
    [loadCell release];
    [searchList release];
    [self.searchValue release];
    [searchbar release];
    [backClick release];
    //[_progressHUD release];
    //[twitterClient release];
    [super dealloc];
}
#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark NET

-(void) getFriends
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", [NSString stringWithFormat:@"%d", indexPage], @"pageindex", @"30", @"pagesize", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(friendsDidReceive:obj:)];
    
    [twitterClient getFriendsListByUserId:param];
    
    /*_progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];*/
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
   // [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
    
    
}

- (void)friendsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    NSArray *ary = [dic objectForKey:@"datalist"];
    if (db && page == 1 && [self.myFriendsList count] != 0) {
            [db cleanTable];
        
    }
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyFriends *model = [[MyFriends alloc] initWitchDic:dic];
        if (db) {
            [db insertFriend:model];
        }
        [model release];
        //[netDataList addObject:model];
    }
    if (page < total) {
        indexPage++;
        [self getFriends];
    }else{
        [self ReadData];
        
    }
}

-(void) findFriends
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", self.searchValue, @"friendname", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(findfriendsDidReceive:obj:)];
    
    [twitterClient findFriendsListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
     
     _progressHUD.dimBackground = YES;
     
     [self.view addSubview:_progressHUD];
     [self.view bringSubviewToFront:_progressHUD];
     _progressHUD.delegate = self;
     _progressHUD.labelText = @"搜索中...";
     [_progressHUD show:YES];
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    // [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
    
    
}

- (void)findfriendsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    //int page = [[dic objectForKey:@"page"] intValue];
    //int total  = [[dic objectForKey:@"total"] intValue];
    NSArray *ary = [dic objectForKey:@"datalist"];
    [searchList removeAllObjects];
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyFriends *model = [[MyFriends alloc] initWitchDic:dic];
        model.imageLocalPath = [self.imageDowload addTask:[NSString stringWithFormat:@"%d", model.friendID] url:model.friendICON showImage:nil defaultImg:@"" indexInGroup:i Goup:2];
        [model setImg:model.imageLocalPath Default:@"friendDefault.png"];
        [searchList addObject:model];
        [model release];
        //[netDataList addObject:model];
    }
    [self.tableView reloadData];
}

-(void)addFriends:(id)sender
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row1 = [self.tableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]].row;
    }else{
        row1 = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    MyFriends *model = [searchList objectAtIndex:row1];
    if (model == nil) {
        return;
    }
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", model.friendName, @"friendname", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addFriendFinish:obj:)];
    
    [twitterClient addFriendsByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"请求中...";
    [_progressHUD show:YES];
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    // [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
}

- (void)addFriendFinish:(TwitterClient*)client obj:(NSObject*)obj
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
    
    NSDictionary* dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    if (state == 1) {
        MyFriends *model = [searchList objectAtIndex:row1];
        if (model) {
            if (db) {
                
                [db updateFriend:model];
                
            }
            [self.myFriendsList addObject:model];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"添加好友成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        
        [alert show];
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        
        [alert show];
        [alert release];
    }
    
}

-(void)delFriend:(id)sender
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row1 = [self.deleteTableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]].row;
    }else{
        row1 = [self.deleteTableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    MyFriends *model = [self.myFriendsList objectAtIndex:row1];
    if (model == nil) {
        return;
    }
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", [NSString stringWithFormat:@"%d", model.friendID ], @"friendid", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(delFriendFinish:obj:)];
    
    [twitterClient delFriendsByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"请求中...";
    [_progressHUD show:YES];
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    // [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
}

- (void)delFriendFinish:(TwitterClient*)client obj:(NSObject*)obj
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
    NSDictionary* dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    if (state == 1) {
        MyFriends *model = [self.myFriendsList objectAtIndex:row1];
        if (model) {
            if (db) {
                [db delFriend:model];
            }
            [self.myFriendsList removeObjectAtIndex:row1];
        }
        if ([self.myFriendsList count] == 0) {
            [self hideDeleteTable];
            [self.tableView reloadData];
            
        }else{
            [self.tableView beginUpdates];
            [self.deleteTableView beginUpdates];
            NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
            [newPath addObject:[NSIndexPath indexPathForRow:row1 inSection:0]];
            
            
            [self.tableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
            [self.deleteTableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            [self.deleteTableView endUpdates];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除好友成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        
        [alert show];
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        
        [alert show];
        [alert release];
    }
}

-(void)geverCouponFriend
{
    
    if (optIndex < 0) {
        return;
    }
    row1 = optIndex;
    MyFriends *model;
    if (tableViewType == 0) {
        model = [self.myFriendsList objectAtIndex:row1];
    }else{//网络搜索好友
        model = [searchList objectAtIndex:row1];
    }
    
    if (model == nil) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"username"];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"Uidold", [NSString stringWithFormat:@"%d", model.friendID ], @"Uid", model.friendName, @"Uname", [NSString stringWithFormat:@"%d", couponModel.dataID], @"cid", userName, @"Unameold",nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(geverCouponFriendFinish:obj:)];
    
    [twitterClient geverCouponFriendsByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"赠送中...";
    [_progressHUD show:YES];
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    // [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
}

- (void)geverCouponFriendFinish:(TwitterClient*)client obj:(NSObject*)obj
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
    NSDictionary* dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    if (state == 1) {
        app.geverCoupon = 1;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"转赠成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.tag = 2;
        
        [alert show];
        [alert release];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.tag = 1;
        
        [alert show];
        [alert release];
    }
}


#pragma mark UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchList release];
    searchList = nil;
    if (tableViewType == 1) {
        tableViewType = 0;
        [self.tableView reloadData];
    }
    
}

-(void)handleSearchForTerm:(NSString *)searchterm{
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    
    [searchBar setShowsCancelButton:YES animated:YES];
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    return YES;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self hideDeleteTable];
    self.searchValue = searchText;
    if (searchText.length > 0 && db) {
        searchList = [db getFriends:searchText];
        if ([searchList count] > 0) {
            for (int i = 0; i < [searchList count]; i++) {
                MyFriends *model = [searchList objectAtIndex:i];
                model.imageLocalPath = [self.imageDowload addTask:[NSString stringWithFormat:@"%d", model.friendID] url:model.friendICON showImage:nil defaultImg:@"" indexInGroup:i Goup:2];
                [model setImg:model.imageLocalPath Default:@"friendDefault.png"];
            }
            [self.imageDowload startTask];
        }
        tableViewType = 1;
        [self.tableView reloadData];
    }
}

#pragma mark tableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 2) {
        [searchbar resignFirstResponder];
        [self hideDeleteTable];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableViewType == 0) {
        return [self.myFriendsList count];
    }else{
        
        return [searchList count] + 1;
    }
    
}
//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchbar resignFirstResponder];
    
    if (tableViewType == 1 && indexPath.row == [searchList count]) {
        //网络搜索好友
        [self findFriends];
        return;
    }
    if (tableView.tag == 2) {
        optIndex = (int)indexPath.row;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    if (tableViewType == 1 && indexPath.row == [searchList count]) {
        return loadCell;
    }
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        if (tableView.tag == 1) {
            UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 13.0f, 50.0f, 28.0f)];
            delButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
            delButton.backgroundColor=[UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
            [delButton setTitle:@"删除好友" forState:UIControlStateNormal];
            [delButton addTarget:self action:@selector(delFriend:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:delButton];
            [delButton release];
        }else{
            UIImageView *backGImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 40.0, 40.0)];
            backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
            [cell.contentView addSubview:backGImg];
            
            UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 12.0, 36.0, 36.0)];
            ico.tag = 4;
            // backGImg.image = [UIImage imageNamed:@"index_food_img.png"];
            [cell.contentView addSubview:ico];
            [ico release];
            
            //1. 名称
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 180, 15)];
            nameLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            UIButton *addFriend = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 35)];
            [addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
            addFriend.tag = 2;
            addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:10];
            [addFriend setTitle:@"加为好友" forState:UIControlStateNormal];
            addFriend.backgroundColor=[UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
            [addFriend addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchDown];
            [addFriend setHidden:YES];
            [cell.contentView addSubview:addFriend];
            
            
            [addFriend release];
        }
    }
    if (tableView.tag == 2) {
        MyFriends *model;
        if (tableViewType == 0) {
            model = [self.myFriendsList objectAtIndex:indexPath.row];
        }else{
            model = [searchList objectAtIndex:indexPath.row];
        }
        
        
        if(model == nil)
        {
            return nil;
        }
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:4];
        ico.image = nil;//这一步必须，要不然可能没办法实时更新图片
        ico.image = model.image;
        /*if (foodmodel.foodid == 28) {
         row++;
         row--;
         }*/
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = model.friendName;
        
        UIButton *addFriend = (UIButton *)[cell.contentView viewWithTag:2];
        [addFriend setHidden:YES];
        if (tableViewType == 1 && model.isFriend == 0) {
            [addFriend setHidden:NO];
        }
    }
    return cell;
}

@end
