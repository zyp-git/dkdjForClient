//
//  AddOrderViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-5-18.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "GiftOrderViewController.h"
#import "EasyEat4iPhoneAppDelegate.h"
#import "FoodInOrderModel.h"
#import "FileController.h"
#import "LoginNewViewController.h"



@implementation GiftOrderViewController


@synthesize tableView;

@synthesize ordermodel;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

@synthesize lotterID;
@synthesize orderTableView;

@synthesize ordertimeDatePicker = ordertimeDatePicker_;
@synthesize ordertime = ordertime_;
@synthesize keyboardToolbar = keyboardToolbar_;

@synthesize uduserid;

@synthesize pickerDistribution;
@synthesize pickerSTime;

@synthesize distributionArray;
@synthesize payTypeArray;
//@synthesize onlineArray;


@synthesize orderId;
@synthesize oaddresse;
@synthesize otel;
@synthesize ousername;
@synthesize GName;
@synthesize GPoint;

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT         9
#define ORDER_FIELD_TAG      8

#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80

#define kWaiting          CustomLocalizedString(@"public_send", @"发送数据中...")
#define kNote             CustomLocalizedString(@"public_notice", @"提醒")
#define kConfirm          CustomLocalizedString(@"public_ok", @"确定")
#define kErrorNet         CustomLocalizedString(@"login_status_network_or_connection_error", @"网络错误")
#define kResult           CustomLocalizedString(@"gift_cart_add_finish", @"支付结果：%@")

- (id)initWithLotterID:(NSString*)rid gName:(NSString *)name gPoint:(NSString *)point
{
    
    //self.shopcartDict = [[NSMutableArray array] retain];
    self.fieldLabels = [[NSMutableArray alloc] initWithObjects:CustomLocalizedString(@"gift_order_list_g_name", @" 礼品名称:"),CustomLocalizedString(@"gift_order_list_u_point", @"  所需积分:"), CustomLocalizedString(@"user_name", @"  联系人:"),CustomLocalizedString(@"ordercontent_ph", @" 联系电话:"),CustomLocalizedString(@"order_addr", @" 收货地址:"),CustomLocalizedString(@"ordercontent_note", @" 备注信息:"),nil];
    orderType = 1;
    self.lotterID = rid;
    self.GPoint = point;
    self.GName = name;
    return  self;
}
- (id)initWithCart:(NSString *)gID GName:(NSString *)name gPoint:(NSString *)point GType:(int)type
{
    self.lotterID = gID;
    self.GPoint = point;
    self.GName = name;
    orderType = 0;
    gType = type;
    self.fieldLabels = [[NSMutableArray alloc] initWithObjects:CustomLocalizedString(@"gift_order_list_g_name", @" 礼品名称:"),CustomLocalizedString(@"gift_order_list_u_point", @"  所需积分:"), CustomLocalizedString(@"user_name", @"  联系人:"),CustomLocalizedString(@"ordercontent_ph", @" 联系电话:"),CustomLocalizedString(@"order_addr", @" 收货地址:"),CustomLocalizedString(@"order_detail_send_time", @" 送货时间:"), nil];
    return self;
}

//未使用XIB文件，使用代码建立界面
-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduseridX = [defaults objectForKey:@"userid"];
    
    NSLog(@"islogin userid:%@", uduseridX);
    
    if([uduseridX intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =CustomLocalizedString(@"login", @"会员登录");
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

-(void)save:(id)sender
{
    
    
    [self resignKeyboard:nil];
    if (isSubmit) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"gift_cart_add_again", @"您已经提交过该订单") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSString* address;
    NSString* tel;
    NSString* username;
    NSString* cutomername;
    NSString* remark;
    
    
    
    UITextField *textview1 = (UITextField *)[self.tableView viewWithTag:1];
    cutomername = textview1.text;
    
    UITextField *textview2 = (UITextField *)[self.tableView viewWithTag:2];
    tel = textview2.text;
    
    UITextField *textview3 = (UITextField *)[self.tableView viewWithTag:3];
    address = textview3.text;
    
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
    remark = textview4.text;
    
        
    
    
    self.uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    //判断是否位空
    if(cutomername.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_reciver_notice", @"请重新填写正确的收货人") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(![app checkMobilePhone:tel])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_phone_notice", @"请填写正确的联系电话") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if(address.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_addr_notice", @"请填写正确的地址") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
        
    //根据选择的支付方式进入不同的界面  支付后再正式提交订单  保存订单信息

    
        
    if (twitterClient)
        return;
    if (orderType == 0) {
        NSString *SendTime;
        switch (sentTime) {
            case 0:
                SendTime = CustomLocalizedString(@"gift_cart_time", @"不限");
                break;
            case 1:
                SendTime = CustomLocalizedString(@"gift_cart_time0", @"周一-周五");
                break;
            case 2:
                SendTime = CustomLocalizedString(@"gift_cart_time1", @"周末");
                break;
            default:
                SendTime = CustomLocalizedString(@"gift_cart_time", @"不限");
                break;
        }
        self.ordermodel = [NSString stringWithFormat:@"[{\"Address\":\"%@\",\"Cdate\":\"\",\"CustId\":\"%@\",\"UserName\":\"%@\",\"GiftName\":\"%@\",\"Date\":\"%@\",\"DetailId\":\"0\",\"GiftsId\":\"%@\",\"PayIntegral\":\"%@\",\"Person\":\"%@\",\"Phone\":\"%@\",\"State\":\"0\",\"sendtype\":\"%d\",\"ReveInt1\":\"%d\",\"remark\":\"\"}]", address, self.uduserid, username, self.GName, SendTime, self.lotterID, self.GPoint, cutomername, tel, sendType, gType];
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.ordermodel,@"Ordermodel",nil];
        [twitterClient SubmitGiftCart:param];
        
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
        [_progressHUD show:YES];
    }else{
        //联网提交订单
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
        
        [twitterClient SubmitOrder:self.ordermodel];
        
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
        [_progressHUD show:YES];
    }
        

     
}

//- (void) PayByCardViewControllerValueChanged:(NSString *)code cmoney:(NSString*)cmoney paypassword:(NSString*)paypassword
- (void) PayByCardsViewControllerValueChanged:(NSString *)upaypassword shopcardids:(NSString*)shopcardids cardids:(NSString*)cardids;
{
    //礼品卡支付界面返回
    //进行字符串替换 并提交订单
    //替换部分字符
    NSString * cardidsString = cardids;//礼品卡卡号
    NSString * shopcardidsString = shopcardids;//店铺券卡号
    NSString * paypasswordString = upaypassword;

    if([shopcardidsString isEqualToString:@"0"])
    {
        shopcardidsString = @"";
    }
    
    if([cardidsString isEqualToString:@"0"])
    {
        cardidsString = @"";
    }
    
    //self.cardid = cardidsString;
    //self.shopcardid = shopcardidsString;
    //self.paypassword = paypasswordString;
    
    NSLog(@"%@:%@:%@", cardidsString, shopcardidsString,paypasswordString);
    
    NSString * ordermodelfix = [[NSString alloc] initWithFormat:@"%@",self.ordermodel];
    //优先使用礼品卡，礼品卡金额不足使用店铺券，礼品卡和店铺券使用后都不足的则需要线下再支付，订单可以提交成功
    /*
     if(![codeString isEqualToString:@"200"] && ![shopcarscodeString isEqualToString:@"200"])
     {
     [tooles MsgBox:@"礼品卡/店铺券支付失败，请重新选择支付方式"];
     return;
     }
     */
    
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"cardpayvalue" withString:@"0"];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@CID" withString:cardidsString];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@isUseGiftCard" withString:@"0"];
    
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@ShopCardpay" withString:@"0"];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@ShopCardIDs" withString:shopcardidsString];
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"@isUseShopCard" withString:@"0"];
    
    ordermodelfix = [ordermodelfix stringByReplacingOccurrencesOfString :@"PayPasswordValue" withString:paypasswordString];
    
    
    NSLog(@"%@", ordermodelfix);
    
    if (twitterClient)
    {
        twitterClient = nil;
        NSLog(@"twitterClient");
        //return;
    }
    
    //联网提交订单
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
    
    [twitterClient SubmitOrder:ordermodelfix];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
    [_progressHUD show:YES];
     
}

- (void)addorderDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    //修改 tabbar 的 badgeValue 底部导航右上角的数字
    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:3];
    tController.tabBarItem.badgeValue = nil;

    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    //1. 获取信息
    NSDictionary *dic = (NSDictionary*)obj;
    //注意此处必须 用self.dic 不能直接使用dic 否则在其他函数中 self.dic是null
    
    NSString *state = [dic objectForKey:@"state"];
    
    if( [state compare:@"1"] == NSOrderedSame )
    {
        isSubmit = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_add_sucess", @"您的订单提交成功") delegate:self cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        alert.tag = 1;
        alert.delegate = self;
        [alert show];
        [alert release];
    }
    else
    {
        NSString *msg = [dic objectForKey:@"msg"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:msg delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        [self hideAlert];
        [self showAlertMessage:kErrorNet];
        [connection cancel];
        [connection release];
        connection = nil;
    }
    else
    {
        if (mData != nil)
        {
            [mData release];
            mData = nil;
        }
        mData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        NSLog(@"tn=%@",tn);
        //[UPPayPlugin startPay:tn sysProvide:nil spId:nil mode:@"00" viewController:self delegate:self];
        //mode  00 接入生产环境  01接入测试环境
    }
    [tn release];
    [connection release];
    connection = nil;
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self hideAlert];
    [self showAlertMessage:kErrorNet];
    [connection release];
    connection = nil;
    
    NSLog(@"didFailWithError");
}



//get mac
/*
- (NSString*)currentUID
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    NSString* noUID = @"";
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return noUID;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return noUID;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        return noUID;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return noUID;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}
*/

#pragma mark - Alert

- (void)showAlertWait
{
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
    [aiv release];
    [mAlert release];
}

- (void)showAlertMessage:(NSString*)msg
{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
    [mAlert release];
}

- (void)hideAlert
{
    if (mAlert != nil)
    {
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 123) {
		NSString *URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
 
}

- (void)setOrderTime
{
    self.ordertime = self.ordertimeDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    //NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-M-d HH:mm:ss"];
    
    NSLog(@"%@", [formatter stringFromDate:self.ordertime]);
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:2];
    
    textview4.text = [formatter stringFromDate:self.ordertime];//[dateFormatter stringFromDate:self.ordertime];
    
    [dateFormatter release];
}

- (void)ordertimeDatePickerChanged:(id)sender
{
    [self setOrderTime];
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}

-(void)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    
    //UITableView *table = (UITableView *)[cell superview];
    
    NSIndexPath *textFieldIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    
    if (row >= RegeditViewNumberOfEditableRows)
    {
        row = 0;
    }
    
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex 
                                                         length:2];
    UITableViewCell *nextCell = [self.tableView
                                 cellForRowAtIndexPath:newPath];
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    isSubmit = NO;
    sendType = 2;
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    //NSArray *array = [[NSArray alloc] initWithObjects:@" 联系人:",@"  电话:", @"  地址:",@"送餐时间:",@"消费方式:",@"支付方式:",@"点菜方式:", @"桌子号:" ,@"备注:", nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 450)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.distributionArray = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"shop_cart_send_mode_1", @"送货"),CustomLocalizedString(@"shop_cart_send_mode_2", @"自取"),nil];
    self.payTypeArray = [[NSArray alloc] initWithObjects:CustomLocalizedString(@"gift_cart_time", @"不限"),CustomLocalizedString(@"gift_cart_time0", @"周一-周五"),CustomLocalizedString(@"gift_cart_time1", @"周末"),nil];
    //self.onlineArray = [[NSArray alloc] initWithObjects:@"支付宝",@"货到付款",nil];
    
    CGRect pickerRect = CGRectMake(0,460, 320, 360);
    
    self.pickerDistribution = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerDistribution.frame = pickerRect;
    self.pickerDistribution.showsSelectionIndicator = YES;
    [self.pickerDistribution setBackgroundColor:[UIColor clearColor]];
    self.pickerDistribution.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerDistribution.delegate=self;
    self.pickerDistribution.tag = 1;
    [self.view addSubview:self.pickerDistribution];
    
    self.pickerSTime = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerSTime.frame = pickerRect;
    self.pickerSTime.showsSelectionIndicator = YES;
    [self.pickerSTime setBackgroundColor:[UIColor clearColor]];
    self.pickerSTime.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerSTime.delegate=self;
    self.pickerSTime.tag = 2;
    [self.view addSubview:self.pickerSTime];
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    [self.view addSubview:self.tableView];
    
    
    
    //[array release];
    
       
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:CustomLocalizedString(@"public_add", @"提交")
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    if (self.ordertimeDatePicker == nil) {
        self.ordertimeDatePicker = [[UIDatePicker alloc] init];
        [self.ordertimeDatePicker addTarget:self action:@selector(ordertimeDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.ordertimeDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        NSDate *currentDate = [NSDate date];
        
        //NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        //[dateComponents setYear:-18];
        
        //NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate  options:0];
        //[dateComponents release];
        
        NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:@"shopcartstatus"];
        NSTimeInterval  interval1 = 60*30; //30分钟

        if(status > 0 )//营业 当前时间顺延30分钟
        {
            interval1 = 60*30;
        }
        else//如果商家未营业则顺延24小时
        {
            interval1 = 24*60*60;
        }
        
        NSDate *rightdate = [currentDate initWithTimeIntervalSinceNow:+interval1];
        [self.ordertimeDatePicker setDate:rightdate animated:YES];
        
        NSTimeInterval  interval2 =24*60*60*7; //7:天数
        NSDate *maxdate = [currentDate initWithTimeIntervalSinceNow:+interval2];
        
        NSTimeInterval  interval3 =60*30; //30分钟后
        NSDate *mindate = [currentDate initWithTimeIntervalSinceNow:+interval3];
        
        [self.ordertimeDatePicker setMaximumDate:maxdate];
        [self.ordertimeDatePicker setMinimumDate:mindate];
    }
    
    // Keyboard toolbar
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
    
    /*
    {
        UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
        NSDate *currentDate = [NSDate date];
        
        int status = [[NSUserDefaults standardUserDefaults] integerForKey:@"shopcartstatus"];
        NSTimeInterval  interval1 = 60*30; //30分钟
        
        if(status > 0 )//营业 当前时间顺延30分钟
        {
            interval1 = 60*30;
        }
        else//如果商家未营业则顺延24小时
        {
            interval1 = 24*60*60;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-M-d HH:mm:ss"];
        
        NSDate *rightdate = [currentDate initWithTimeIntervalSinceNow:+interval1];
        [self.ordertimeDatePicker setDate:rightdate animated:YES];
        textview4.text = [formatter stringFromDate:rightdate];
    }
    */
    
}

- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        //UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
        //if (nextLabel) {
        //    [self resetLabelsColors];
        //    [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        //}
        [self checkSpecialFields:previousTag];
    }
}

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        
        UITextField *nextField = (UITextField *)[self.tableView viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        //UILabel *nextLabel = (UILabel *)[self.view viewWithTag:nextTag + 10];
        //if (nextLabel) {
        //    [self resetLabelsColors];
        //    [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        //}
        [self checkSpecialFields:nextTag];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 3) {
        rect.origin.y = -44.0f * (tag - 3);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

- (void)checkSpecialFields:(NSUInteger)tag
{
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
    
    if (tag == ORDER_FIELD_TAG && [textview4.text isEqualToString:@""]) {
        [self setOrderTime];
    }
}

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        //[self resetLabelsColors];
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
    //self.pickerAddress = nil;
    //self.addressArray = nil;
}

- (void)dealloc {
    [textFieldBeingEdited release];
    [tempValues release];
    [fieldLabels release];
    //[orderTableView release];
    //[shopcartDict release];
    [lotterID release];
    
    [distributionArray release];
    [payTypeArray release];
    
    //[onlineArray release];
    
    [pickerDistribution release];
    [pickerSTime release];
    [self.ousername release];
    [self.oaddresse release];
    [self.otel release];
    [self.GName release];
    [self.GPoint release];
    RELEASE_SAFELY(ordertimeDatePicker_);
    RELEASE_SAFELY(keyboardToolbar_);
    
    if (indicator) {
        [indicator release];
        indicator = nil;
    }
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0f;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return [self.fieldLabels count] - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PresidentCellIdentifier = @"RegeditCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleDefault;
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];

    //生成cell
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:style 
                                       reuseIdentifier:PresidentCellIdentifier] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(10, 10, 85, 25)];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = RegeditViewLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:label];
        [label release];
        
        if(indexPath.section == 1){
            UITextField *textField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(100, 12, 200, 25)];
            textField.clearsOnBeginEditing = NO;
            [textField setDelegate:self];
            [textField addTarget:self 
                      action:@selector(textFieldDone:) 
            forControlEvents:UIControlEventEditingDidEndOnExit];
            
            textField.textAlignment = NSTextAlignmentLeft;
            textField.font = [UIFont boldSystemFontOfSize:12];
            textField.textColor = [UIColor grayColor];
            textField.backgroundColor = [UIColor clearColor];
            //设置键盘完成按钮，相应的还有“Return”"GO""Google"等
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:textField];
        }else{
            UILabel *textField = [[UILabel alloc] initWithFrame:
                                      CGRectMake(100, 12, 200, 25)];
            textField.textColor = [UIColor grayColor];
            textField.backgroundColor = [UIColor clearColor];
            textField.tag = 8;
            [cell.contentView addSubview:textField];
        }
    }
    
    //cell左侧填充内容
    
    UILabel *label = (UILabel *)[cell viewWithTag:RegeditViewLabelTag];
    
    
    
    //cell右侧填充内容
    
    
    if (indexPath.section == 1) {
        UITextField *textField;// = (UITextField *)[cell.contentView viewWithTag:1];
        for (UIView *oneView in cell.contentView.subviews)
        {
            if ([oneView isMemberOfClass:[UITextField class]])
            {
                textField = (UITextField *)oneView;
            }
        }
        
        label.text = [fieldLabels objectAtIndex:row + 2];
        switch (row) {
            case 0:
                textField.placeholder = CustomLocalizedString(@"user_hidden", @"请输入真实姓名");
                textField.tag = 1;
                textField.returnKeyType = UIReturnKeyNext;
                textField.inputAccessoryView = self.keyboardToolbar;
                
                if(ousername != nil && ![ousername isEqualToString:@""] )
                {
                    [textField setText:ousername];
                }
                
                break;
            case 1:
                textField.placeholder = CustomLocalizedString(@"no_phone", @"请填写真实号码以联系确认");
                textField.tag = 2;
                textField.returnKeyType = UIReturnKeyNext;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.inputAccessoryView = self.keyboardToolbar;
                
                if(otel != nil && ![otel isEqualToString:@""] )
                {
                    [textField setText:otel];
                }
                
                break;
            case 2:
                textField.placeholder = CustomLocalizedString(@"gift_cart_addr", @"请输入送货地址");
                textField.tag = 3;
                textField.inputAccessoryView = self.keyboardToolbar;
                textField.returnKeyType = UIReturnKeyNext;
                /*if (sendType == 2) {
                    if(oaddresse != nil && ![oaddresse isEqualToString:@""] )
                    {
                        [textField setText:oaddresse];
                    }else{
                        textField.text = @"";
                    }
                }else{
                    textField.inputView = self.pickerDistribution;
                    textField.text = @"自取";
                }*/
                
                
                break;
            case 3:
            {
                
                
                textField.tag = 4;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                textField.inputView = self.pickerSTime;
                textField.text = CustomLocalizedString(@"gift_cart_time", @"不限");
                
                /*if (orderType == 0) {
                    if (sendType == 2) {
                        textField.inputView = self.pickerDistribution;
                        textField.text = @"送货";
                    }else{
                        textField.inputView = self.pickerSTime;
                        textField.text = @"不限";
                    }
                }else{
                    textField.placeholder = @"请输入备注信息";
                }*/
                
                
            }
                
                break;
            case 4:
                textField.placeholder = CustomLocalizedString(@"gift_cart_time", @"不限");
                textField.tag = 5;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                textField.inputView = self.pickerSTime;
                textField.text = CustomLocalizedString(@"gift_cart_time", @"不限");
                //textField.inputView = self.;
                
                
                
                break;
            /*case 5:
                
                textField.tag = 6;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                
                
                break;*/
            case 5:
                textField.placeholder = @"";
                textField.tag = 7;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                
                
                
                break;
            case 6:
                
                textField.placeholder = CustomLocalizedString(@"shop_cart_remark_notice", @"请输入备注");
                textField.tag = 8;
                textField.returnKeyType = UIReturnKeyDone;
                textField.inputAccessoryView = self.keyboardToolbar;
                break;
                
            default:
                break;
        }
        if (textFieldBeingEdited == textField)
        {
            textFieldBeingEdited = nil;
        }
    }else{
        UILabel *textField = (UILabel *)[cell.contentView viewWithTag:8];
        
        label.text = [fieldLabels objectAtIndex:row];
        switch (row) {
            case 0:
                textField.text = self.GName;
                
                
                
                break;
            case 1:
                textField.text = self.GPoint;
                
                break;
        }
    }
    
    
    
    
    //textField.tag = row;
    return cell;
        
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section == 0 && indexPath.row == 0 )
    {
        NSLog(@"------------didSelectRowAtIndexPath ");
    }
}

#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //输入框点击行时不做任何处理
    if(indexPath.section == 0 )
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //填充信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.ousername = [defaults objectForKey:@"orderusername"];
    self.otel = [defaults objectForKey:@"ordertel"];
    self.oaddresse = [defaults objectForKey:@"orderaddress"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( pickerView.tag == 1)
    {
        return distributionArray.count;
    }
    else if( pickerView.tag == 2)
    {
        return payTypeArray.count;
    }
    else if( pickerView.tag == 3)
    {
    }
    else if( pickerView.tag == 4)
    {
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( pickerView.tag == 1)
    {
        return [distributionArray objectAtIndex:row];
    }
    else if( pickerView.tag == 2)
    {
        return [payTypeArray objectAtIndex:row];
    }
    else if( pickerView.tag == 3)
    {
    }
    else if( pickerView.tag == 4)
    {
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    /*self.fieldLabels = [[NSMutableArray alloc] initWithObjects:@" 礼品名称:",@"  所需积分:", @"  客户姓名:",@" 联系电话:",@" 收货地址:",@" 备注信息:",nil];
     self.fieldLabels = [[NSMutableArray alloc] initWithObjects:@" 礼品名称:",@"  所需积分:", @"  客户姓名:",@" 联系电话:",@" 收货地址:",@" 配送方式:",@" 取送货时间:", nil]*/
    
    if( pickerView.tag == 1)
    {//外卖和现场点菜
        if (orderType == 0) {
            if (sendType == 2) {
                UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:3];
                textview4.text = CustomLocalizedString(@"shop_cart_send_mode_2", @"自取");
                UITextField *textview1 = (UITextField *)[self.tableView viewWithTag:4];
                textview1.text = CustomLocalizedString(@"gift_cart_time", @"不限");
                sentTime = 0;
                sendType = 1;
                [self.fieldLabels removeObjectAtIndex:4];
                
            }else{
                UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
                textview4.text = CustomLocalizedString(@"shop_cart_send_mode_1", @"送货");
                UITextField *textview1 = (UITextField *)[self.tableView viewWithTag:5];
                textview1.text = CustomLocalizedString(@"gift_cart_time", @"不限");
                sentTime = 0;
                sendType = 2;
                [self.fieldLabels insertObject:CustomLocalizedString(@"addr_list_addr", @" 收货地址:") atIndex:4];
            }
            [self.tableView reloadData];
        }
       
    }
    else if( pickerView.tag == 2)
    {
        //UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:6];
        sentTime = (int)row;
        if (orderType == 0) {
            if (sendType == 2) {
                UITextField *textview6 = (UITextField *)[self.tableView viewWithTag:5];
                textview6.text = [payTypeArray objectAtIndex:row];
            }else{
                UITextField *textview6 = (UITextField *)[self.tableView viewWithTag:4];
                textview6.text = [payTypeArray objectAtIndex:row];
            }
            
        }
        
        
    }
    else if( pickerView.tag == 3)
    {
        //UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:7];
        //textview4.text = [onlineArray objectAtIndex:row];
    }
    else if( pickerView.tag == 4)
    {
        //UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:6];
        
        //UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:7];
        //textview4.text = [offlineArray objectAtIndex:row];
    }

}


@end