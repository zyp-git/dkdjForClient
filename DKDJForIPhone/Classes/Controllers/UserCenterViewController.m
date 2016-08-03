//
//  UserCenterViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-3-31.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "UserCenterViewController.h"

#import "LoginNewViewController.h"
#import "UserInfoNewViewController.h"
#import "ChangePasswordViewController.h"
#import "OrderListNewViewController.h"
#import "MyCardListViewController.h"
#import "BindCardViewController.h"
#import "ShopCardListViewController.h"
#import "BindShopCardViewController.h"
#import "EasyEat4iPhoneAppDelegate.h"
#import "CartOrderListViewController.h"
#import "LotterOrderListViewController.h"
#import "UserAddressListViewController.h"
#import "tooles.h"
#import "OrderDetailViewController.h"
#import "HJScrollView.h"
#import "HJView.h"
#import "MyFriendsListViewController.h"
#import "MyCouponListViewController.h"
#import "MyPointListViewController.h"
#import "MyMessageListViewController.h"
#import "ShopCartViewController.h"
#import "PointsListViewController.h"
#import "MyCouponNewListViewController.h"
#import "UnPayOrderListViewController.h"
#import "MyFavorListViewController.h"
#import "AppointmentOrderListNewViewController.h"
#import "ShopNewListViewController.h"
@implementation UserCenterViewController

@synthesize uduserid;
@synthesize haveMoney;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = CustomLocalizedString(@"user_center_title", @"个人中心");
    }

    return self;
}
#pragma mark GetUserInfo
- (BOOL)AreLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uduserid = [defaults objectForKey:@"userid"];
    [uduserid retain];
    NSLog(@"islogin userid:%@", self.uduserid);
    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)getUserInfo:(TwitterClient*)sender obj:(NSObject*)obj
{
	[twitterClient release];
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    twitterClient = nil;
    NSDictionary *dic = (NSDictionary*)obj;
    userMoeny.text = [NSString stringWithFormat:CustomLocalizedString(@"user_center_moeny", @"余额：%.2f%@"), [[dic objectForKey:@"HaveMoney"] floatValue], CustomLocalizedString(@"public_moeny_0", @"￥")];
    userName.text = [dic objectForKey:@"username"];
    userPoint.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Point"]];
    userPhone.text = [dic objectForKey:@"phone"];
    
    //userCoupon.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"VoucherCount"]];//优惠券数量
    //self.myICONet = [dic objectForKey:@"pic"];
    //self.myICOPath = [imageDowload addTask:self.uduserid url:self.myICONet showImage:nil defaultImg:nil indexInGroup:1 Goup:1];
    //[self setImg:self.myICOPath Default:@"Icon.png"];
    //[imageDowload startTask];
    //[self.tableView reloadData];
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)iname{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        self.myICO = [[UIImage alloc] init];
        [self.myICO initWithContentsOfFile:imagePath];
    }else{
        self.myICO = [UIImage imageNamed:iname];
    }
    [fileManager release];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{ 
	return 2;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isShow) {
        if ([self IsLogin]) {
            [self AreLogin];
            /*UIBarButtonItem *logout = [[UIBarButtonItem alloc]
                                       initWithTitle:@"注销登陆"
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(logOut)];
            
            self.navigationItem.rightBarButtonItem = logout;*/
            if (twitterClient == nil) {
                twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getUserInfo:obj:)];
                
                [twitterClient getUserInfoByUserId:self.uduserid];
               
                
                
            }
            
        }else{
            return;
        }
        
    }else{
        isShow = NO;
        if (![self AreLogin]) {
            [self goBack];
            return;
        }
    }
}

-(void)btnSelectICON:(UIButton *)btn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:CustomLocalizedString(@"public_select", @"请选择")
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:CustomLocalizedString(@"public_img_phone", @"来自相册")];
    [actionSheet addButtonWithTitle:CustomLocalizedString(@"public_img_camare", @"来自摄像头")];
    [actionSheet addButtonWithTitle:CustomLocalizedString(@"public_cancel", @"取消")];
    
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 2;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];//IActionSheet的最后一项点击失效，点最后一项的上半区域时有效，这是在特定情况下才会发生，这个场景就是试用了UITabBar的时候才有。平时可以这样使用showInView:self.view
}

-(void)btnClick:(UIButton*)btn
{
    UIViewController *viewController;
    switch (btn.tag) {
        case 0://账号管理
            viewController = [[[UserInfoNewViewController alloc] init] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 1://密码管理
            viewController = [[[ChangePasswordViewController alloc] initUserInfo:YES] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 2://我的优惠券
            viewController = [[[MyCouponNewListViewController alloc] init] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            break;
        default:
            break;
    }
}
#pragma mark 点击HJView
-(void)clickView:(id)sender
{
    HJView *view = (HJView *)sender;
    UIViewController *viewController;
    switch (view.tag) {
        case 1:
            //账号管理
            viewController = [[[UserInfoNewViewController alloc] init] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            
            
            break;
        case 2:
            //我的手机号码
            viewController = [[[UserInfoNewViewController alloc] init] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 3:
            //我的订单
            viewController = [[[OrderListNewViewController alloc] init] autorelease];
            [self.navigationController pushViewController:viewController animated:true];
            
            break;
        case 4://礼品兑换订单
            viewController = [[[CartOrderListViewController alloc] initWithUserid:@"0"] autorelease];
            viewController.title =CustomLocalizedString(@"user_center_point_order", @"我的礼品订单");
            [self.navigationController pushViewController:viewController animated:true];
            
            
            break;
        case 5://目前积分
            viewController = [[[MyPointListViewController alloc] initWithcUserID:self.uduserid] autorelease];
            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 6://修改登陆密码
            viewController = [[[ChangePasswordViewController alloc] initUserInfo:NO] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            
            
            break;
        case 7://修改支付密码
            viewController = [[[ChangePasswordViewController alloc] initUserInfo:YES] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            
            break;
        case 8://关注店家
            
            viewController = [[[ShopNewListViewController alloc] initWithFavor:self.uduserid] autorelease];
            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 9:
            //我的收货地址
            viewController = [[[UserAddressListViewController alloc] initWithDefault] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            break;
        default:
            break;
    }
}


-(void)gotoOrderList
{
    
}

-(void)gotoRepassword
{
    
}

-(void)gotoUserAddressList
{
    UserAddressListViewController *viewController = [[[UserAddressListViewController alloc] initWithDefault] autorelease];
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    //[self.view setBackgroundColor:[tooles getAppBackgroundColor]];
    //[self.tableView setBackgroundColor:[tooles getAppBackgroundColor]];
    if (is_iPhone5) {
        viewHeight = 450;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 350;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    self.title = CustomLocalizedString(@"user_center_title", @"个人中心");
    //imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:6 Delegate:self];
    
    
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];

    
    scrollView = [[HJScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, viewHeight)];
    /*UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 280, viewHeight)];
    bgview.image = viewroundImage;
    bgview.userInteractionEnabled = YES;*/
    int height = 10;
    
    viewroundImage = [[UIImage imageNamed:@"ll_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
   
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, height, 310, 80)];
    image.image = viewroundImage;
    image.userInteractionEnabled = YES;//不设置这个，那么UIScrollView的子视图都无法获取到点击事件
    
    
    HJView *view1 = [[HJView alloc] initWithFrame:CGRectMake(7, 7, 293, 30)];
    [view1 setClickDelegate:self];
    view1.tag = 1;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_name.png"];
    [view1 addSubview:img];
    [img release];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 100, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_name", @"昵称");
    [view1 addSubview:label1];
    [label1 release];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 178, 15)];
    userName.textColor = [UIColor grayColor];
    userName.font = [UIFont boldSystemFontOfSize:13];
    userName.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:userName];
    
    UIImageView *arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    
    
    [image addSubview:view1];
    //[view1 release];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, view1.frame.origin.y + view1.frame.size.height + 5, image.frame.size.width - 4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:207/255.0 alpha:1.0];
    [image addSubview:lineView];
    
    [view1 release];
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, lineView.frame.origin.y + 5, 293, 30)];
    [lineView release];
    [view1 setClickDelegate:self];
    
    view1.tag = 2;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_phone.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_phone", @"手机号码");
    [view1 addSubview:label1];
    [label1 release];
    
    userPhone = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 178, 15)];
    userPhone.textColor = [UIColor grayColor];
    userPhone.font = [UIFont boldSystemFontOfSize:13];
    userPhone.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:userPhone];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    [image addSubview:view1];
    [view1 release];
    
    [scrollView addSubview:image];
    [image release];
    
    height += 90;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(5, height, 310, 120)];
    image.image = viewroundImage;
    image.userInteractionEnabled = YES;//不设置这个，那么UIScrollView的子视图都无法获取到点击事件
    
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, 7, 293, 30)];
    [view1 setClickDelegate:self];
    view1.tag = 3;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_order.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_order", @"我的订单");
    [view1 addSubview:label1];
    [label1 release];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    
    
    [image addSubview:view1];
    //[view1 release];
    
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, view1.frame.origin.y + view1.frame.size.height + 5, image.frame.size.width - 4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:207/255.0 alpha:1.0];
    [image addSubview:lineView];
    
    [view1 release];
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, lineView.frame.origin.y + 5, 293, 30)];
    [lineView release];
    [view1 setClickDelegate:self];
    
    view1.tag = 4;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_gift.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_point_order", @"我的礼品订单");
    [view1 addSubview:label1];
    [label1 release];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    [image addSubview:view1];
    
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, view1.frame.origin.y + view1.frame.size.height + 5, image.frame.size.width - 4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:207/255.0 alpha:1.0];
    [image addSubview:lineView];
    [view1 release];
    
    
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, lineView.frame.origin.y + 5, 293, 30)];
    [lineView release];
    [view1 setClickDelegate:self];
    
    view1.tag = 5;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_point.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_point", @"目前积分");
    [view1 addSubview:label1];
    [label1 release];
    
    userPoint = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 178, 15)];
    userPoint.textColor = [UIColor grayColor];
    userPoint.font = [UIFont boldSystemFontOfSize:13];
    userPoint.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:userPoint];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    [image addSubview:view1];
    [view1 release];
    
    
    
    [scrollView addSubview:image];
    [image release];
    height += 130;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(5, height, 310, 160)];
    image.image = viewroundImage;
    image.userInteractionEnabled = YES;//不设置这个，那么UIScrollView的子视图都无法获取到点击事件
    
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, 7, 293, 30)];
    [view1 setClickDelegate:self];
    view1.tag = 6;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_password.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_login_password", @"修改登录密码");
    [view1 addSubview:label1];
    [label1 release];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    
    
    [image addSubview:view1];
    [view1 release];
    //[view1 release];
    
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, view1.frame.origin.y + view1.frame.size.height + 5, image.frame.size.width - 4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:207/255.0 alpha:1.0];
    [image addSubview:lineView];
    
    
    
    
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, lineView.frame.origin.y + 5, 293, 30)];
    [lineView release];
    [view1 setClickDelegate:self];
    
    view1.tag = 7;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_password.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_pay_password", @"修改支付密码");
    [view1 addSubview:label1];
    [label1 release];
    
    userMoeny = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 178, 15)];
    userMoeny.textColor = [UIColor grayColor];
    userMoeny.font = [UIFont boldSystemFontOfSize:13];
    userMoeny.textAlignment = NSTextAlignmentRight;
    [view1 addSubview:userMoeny];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    [image addSubview:view1];
    [view1 release];
    
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, view1.frame.origin.y + view1.frame.size.height + 5, image.frame.size.width - 4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:207/255.0 alpha:1.0];
    [image addSubview:lineView];
    
    
    
    
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, lineView.frame.origin.y + 5, 293, 30)];
    [lineView release];
    [view1 setClickDelegate:self];
    
    view1.tag = 8;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_shop.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_shop", @"关注店家");
    [view1 addSubview:label1];
    [label1 release];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    [image addSubview:view1];
    [view1 release];
    
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(1, view1.frame.origin.y + view1.frame.size.height + 5, image.frame.size.width - 4, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:207/255.0 alpha:1.0];
    [image addSubview:lineView];
    
    
    
    
    
    view1 = [[HJView alloc] initWithFrame:CGRectMake(7, lineView.frame.origin.y + 5, 293, 30)];
    [lineView release];
    [view1 setClickDelegate:self];
    
    view1.tag = 9;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    img.image = [UIImage imageNamed:@"icon_user_address.png"];
    [view1 addSubview:img];
    [img release];
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 248, 15)];
    label1.font = [UIFont boldSystemFontOfSize:14];
    label1.textColor = [UIColor colorWithRed:93/255.0 green:72/255.0 blue:55/255.0 alpha:1.0];
    label1.text = CustomLocalizedString(@"user_center_addr", @"我的收货地址");
    [view1 addSubview:label1];
    [label1 release];
    
    arrImgV = [[UIImageView alloc] initWithFrame:CGRectMake(278, 7, 15, 15)];
    arrImgV.image = [UIImage imageNamed:@"detail_ico.png"];
    [view1 addSubview:arrImgV];
    [arrImgV release];
    
    [image addSubview:view1];
    [view1 release];
    
    
    
    [scrollView addSubview:image];
    [image release];
    height += 140;
    
    
    
    
    height += 30;
    
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(50, height, 200, 30)];
    [logout setUserInteractionEnabled:YES];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [logout setTitle:CustomLocalizedString(@"user_center_exit", @"退出登录") forState:UIControlStateNormal] ;
    [logout setBackgroundImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage imageNamed:@"exit_press.png"] forState:UIControlEventTouchDown];
    [logout addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchDown];
    [scrollView addSubview:logout];
    [logout release];
    
    
    
    height += 35;
    [scrollView setContentSize:CGSizeMake(320, height + 10)];
    
    [self.view addSubview:scrollView];
    isShow = NO;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)logOut:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"userid"];
    [defaults setObject:@"" forKey:@"username"];
    
    [defaults synchronize];
    [self goBack];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (BOOL)IsLogin
{
    //NSLog(@"setting userid:%@", uduserid);
    [self refreshFields];
    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue] 
    {
        return YES;
    }
    else
    {
        LoginNewViewController *loginviewController = [[[LoginNewViewController alloc] init] autorelease];
        
        //loginviewController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图 
        UINavigationController *navController = [[[UINavigationController alloc]initWithRootViewController:loginviewController] autorelease];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        //[self.navigationController pushViewController:loginviewController animated:YES];
        isShow = YES;
                
        return NO;
    }
}

- (void)dealloc {
    if (twitterClient) {
        [twitterClient release];
        twitterClient = nil;
    }
    if (imageDowload != nil) {
        [imageDowload stopTask];
        [imageDowload release];
        imageDowload = nil;
    }
    [self.uduserid release];
    [self.haveMoney release];
    [self.myICO release];
    [self.myICONet release];
    [self.myICOPath release];
    [userPhone release];
    [userName release];
    [userInfoClick release];
    [userPoint release];
    [userCoupon release];
    [scrollView release];
    [backClick release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [self refreshFields];
}

- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uduserid = [defaults objectForKey:@"userid"];
    [uduserid retain];
}
#pragma mark UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if(buttonIndex == 1){
        imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark 保存图片到document

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}

#pragma mark 从文档目录下获取Documents路径

- (NSString *)documentFolderPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
#pragma mark MBProgressHUD
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

#pragma mark UIImagePicker
//用户选中图片
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSURL *imageURL = [info valueForKey:@"UIImagePickerControllerReferenceURL"];
    
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:[imageURL query]];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:@"UTF-8"];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:@"UTF-8"];
            [pairs setObject:value forKey:key];
        }
    }
    [scanner release];
    NSString *ext = [pairs objectForKey:@"ext"];
    if (ext == nil || ext.length < 1) {
        ext = @"jpg";
    }
    
    
    self.myICO = [self imageWithImageSimple:image scaledToSize:CGSizeMake(440.0, 330.0)];
    userICO.image = self.myICO;

    [self saveImage:self.myICO WithName:@"salesImageBig.jpg"];
    if (twitterClient == nil) {
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(upImageFinish:obj:)];
        
        [twitterClient Upload:self.myICO type:@"1" dataID:self.uduserid imageExtName:ext];
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"public_send", @"上传中...");
        [_progressHUD show:YES];
        
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [picker release];
    
}

-(void)upImageFinish:(TwitterClient*)sender obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        [twitterClient release];
        twitterClient = nil;
        return;
    }
    NSDictionary *dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    if (state == 1) {
        self.myICONet = [dic objectForKey:@"pic"];
        self.myICOPath = [imageDowload addTask:self.uduserid url:self.myICONet showImage:nil defaultImg:nil indexInGroup:1 Goup:1];
        [self setImg:self.myICOPath Default:@"Icon.png"];
        [imageDowload startTask];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_img_up_faild", @"头像上传失败，请稍后再试！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        
        [alert release];
        return;
    }
    
    //[self.tableView reloadData];
}
// 用户选择取消

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [picker release];
}
#pragma mark imageDowload
-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        self.myICOPath = task.locURL;
        [self setImg:self.myICOPath Default:@"Icon.png"];
    }
}

-(void)updataUI:(int)type{
    userICO.image = self.myICO;
}


//如果哪天有人知道原因请记得通知:zjf@ihangjing.com 
@end