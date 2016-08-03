//
//  FoodDetailViewController.m
//  HMBL
//
//  Created by ihangjing on 13-11-24.
//
//

#import "ActivityDetailViewController.h"
#import "NewsViewController.h"
#import "UserCommentTalbeViewController.h"
#import "ShopDetailViewController.h"
#import "FShop4ListModel.h"
#import "HJLable.h"
#import "LoginNewViewController.h"
#import "AddOrderToServerNewViewController.h"
#import "FoodListViewController.h"
@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController
@synthesize food;
@synthesize keyboardToolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(ActivityDetailViewController *)initWithFood:(ActivityModel *)Food
{
    [super init];
    
    if (self != nil) {
        self.food = Food;
    }
    
    return self;
}
-(void)endInPut:(id)sender{
    
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"public_last", @"上一项")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"public_next", @"下一项")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"public_ok", @"确定")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        
        [previousBarItem release];
        [nextBarItem release];
        [spaceBarItem release];
        [doneBarItem release];
    }
    
    if (is_iPhone5) {
        viewHeight = 500;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 420;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    
    self.title = @"活动详情";
   
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    float heigth = 0.0f;
    
    myscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, viewHeight)];
    myscroll.userInteractionEnabled = YES;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(0, heigth, 320, 320)];
    if (self.food.image == nil) {
        imageDowloader = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
        self.food.picPath = [imageDowloader addTask:[NSString stringWithFormat:@"%d", self.food.dataID] url:self.food.ico showImage:nil defaultImg:@"" indexInGroup:index Goup:1];
        [self.food setImg:food.picPath Default:@"暂无图片"];
        [imageDowloader startTask];
    }
    img.image = self.food.image;
    [myscroll addSubview:img];
    
    
    heigth += 320.0;
    heigth += 15;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10.0, heigth, 320, 15)];
    name.textColor = [UIColor blackColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont boldSystemFontOfSize:16];
    name.text = self.food.name;
    [myscroll addSubview:name];
    [name release];
    
    heigth += 20;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 2;
    
    UILabel *lb;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 300, 90)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    lb.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
    lb.numberOfLines = 6;
    lb.text = [NSString stringWithFormat:@"活动说明：%@", self.food.Disc];
    [myscroll addSubview:lb];
    [lb release];
    heigth += 95;
    
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 300, 15)];
    lb.textColor = [UIColor redColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = [NSString stringWithFormat:@"活动时间：%@-%@", self.food.starttime, self.food.endtime];
    [myscroll addSubview:lb];
    [lb release];
    
    heigth += 20;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 310, 15)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    if (self.food.atype == 1) {//全场积分活动
        lb.text = [NSString stringWithFormat:@"全场积分活动，积分：%d", self.food.needpoint];
    }else if(self.food.atype == 0){
        lb.text = [NSString stringWithFormat:@"全场线下活动,折扣：%.1f", self.food.disCount * 10];
    }else if(self.food.atype == 2){
        lb.text = [NSString stringWithFormat:@"商铺线下活动,折扣：%.1f", self.food.disCount * 10];
    }else{
        lb.text = [NSString stringWithFormat:@"商铺线上活动,折扣：%.1f", self.food.disCount * 10];
    }
    
    [myscroll addSubview:lb];
    [lb release];
    heigth += 27;
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 5;
    
    if (food.atype == 3 || food.atype == 1) {//只有商家线上活动才能参加
        UIButton *btnAddCart = [[UIButton alloc] initWithFrame:CGRectMake(110, heigth, 100, 35)];
        btnAddCart.backgroundColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
        [btnAddCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        if(food.atype == 3)
        {
            [btnAddCart setTitle:@"进入店铺" forState:UIControlStateNormal];
        }
        else
        {
            [btnAddCart setTitle:@"立即参加" forState:UIControlStateNormal];
        }
        
        
        
        [btnAddCart addTarget:self action:@selector(addShopCart:) forControlEvents:UIControlEventTouchDown];
        [myscroll addSubview:btnAddCart];
        [btnAddCart release];
        
        
        
        heigth += 35;
    }
    heigth += 5;
    
    
    [myscroll setContentSize:CGSizeMake(320, heigth + 5)];//高度多像素实现可以滚动
    
    //[myscroll addSubview:view];
    
    
    
    
  
    [self.view addSubview:myscroll];
    //[view release];
    
    
    
	// Do any additional setup after loading the view.
}



-(void)shareFood:(id)sender{
    //点赞接口
}

-(void)favFood:(id)sender{
    //收藏菜品接口
}
-(void)addShopCart:(id)sender{
    //加入购物车
    if( (![self IsLogin]) )
    {
        return;
    }
    if(food.atype == 1){
        if(food.atype == 1)
        {//全场积分活动有人数限制
            if(food.peoplecount >= food.quota ){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"人数已满，不能参加" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                
                [alert release];
                return;
            }
            app.shopCart.canJoinPeople = food.quota - food.peoplecount;//能参加的人数
        }
        app.shopCart.buyType = 2;
        app.shopCart.activityID = [NSString stringWithFormat:@"%d", food.dataID];
        app.shopCart.activityName = food.name;
        AddOrderToServerNewViewController *addorderView = [[[AddOrderToServerNewViewController alloc] init ] autorelease];
        
        [self.navigationController pushViewController:addorderView animated:YES];
    }else{
        
        
        FShop4ListModel *shop = [[FShop4ListModel alloc] init];
        shop.shopid = food.tid;
        [app setShopMode:shop];
        app.shopCart.buyType = 3;
        app.shopCart.activityID = [NSString stringWithFormat:@"%d", food.dataID];
        //app.shopCart.activityName = food.name;
        /*ShopDetailViewController *viewController = [[[ShopDetailViewController alloc] initWithShopid:[NSString stringWithFormat:@"%d", food.tid] sentmoney:@"0.0" startSend:@"0.0" fullFree:0.0 bspeak:0] autorelease];*/
        
        ShopDetailViewController *viewController = [[[ShopDetailViewController alloc] initWithShop:shop buytype:3 activityid:app.shopCart.activityID] autorelease];
        
        [self.navigationController pushViewController:viewController animated:YES];
        [shop release];
    }
}
- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduseridX = [defaults objectForKey:@"userid"];
    if([uduseridX intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[[LoginNewViewController alloc] init] autorelease];

        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        return NO;
    }
}

-(void)goShopCartNow:(id)sender{
    //马上结算
}


-(void)gotoShopDetail:(id)sender
{
    UIViewController *viewController = [[[ShopDetailViewController alloc] initWithShopId:[NSString stringWithFormat:@"%d", food.tid]  shopType:0] autorelease];
    
    [self.navigationController pushViewController:viewController animated:true];
}
-(void)gotoDis
{
    
}
-(void)gotoNotice
{
}



- (void)viewDidDisappear:(BOOL)animated
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
}


#pragma mark ImageDowload
-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    ImageDowloadTask *task = [arry objectAtIndex:index];
    if (task.locURL.length == 0) {
        task.locURL = @"Icon.png";
    }
    self.food.picPath = task.locURL;
    [self.food setImg:self.food.picPath  Default:@"暂无图片"];
    
}
-(void)updataUI:(int)type{
    img.image = nil;
    img.image = self.food.image;
    [img updateConstraints];
}



-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
}


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (imageDowloader != nil) {
        [imageDowloader stopTask];
        [imageDowloader release];
    }
    [backClick release];
    [gotoShopCartClick release];
    [numViewList release];
    [img release];
    [self.food release];
    [myscroll release];
    [DiscClick release];//产品描述单击
    [noticeClick release];//产品提示单击
    [userCommentClick release];//用户评论
    [super dealloc];
}

@end
