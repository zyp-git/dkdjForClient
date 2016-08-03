//
//  ChangePasswordViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "AddOrderToServerNewViewController.h"
#import "LoginNewViewController.h"
#import "UserAddressListViewController.h"
#import "UserAddressDetailViewController.h"
#import "OrderNewViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayModel.h"
#import "DataSigner.h"
@implementation AddOrderToServerNewViewController

@synthesize result;//这里声明为属性方便在于外部传入。支付宝
@synthesize userid;
@synthesize userName;
@synthesize payId;//支付编号
@synthesize keyboardToolbar;
@synthesize orderId;
@synthesize payPassword;
@synthesize bgView;
@synthesize tfAddress;
@synthesize tfGPSAddress;
@synthesize tfReciver;
@synthesize tfPhone;
@synthesize tfTime;
@synthesize tfRemark;
@synthesize tfPeople;//预约人数
@synthesize tfPayPassword;//
@synthesize payMoney;//在线支付金额
@synthesize btnPayMoeny;//货到付款
@synthesize btnPayAccount;//账户余额
@synthesize btnPayAlipay;//支付宝
@synthesize btnPayWXpay;//微信支付
- (id)initUserInfo:(BOOL)isPay
{
    
    isPayPassword = isPay;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (addOrderSucess) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (isShowAddressList) {
        isShowAddressList = NO;
        if(app.shopCart.buyType == 0){
            [self setDefaultAddress];
        }else{
            self.tfAddress.text = [NSString stringWithFormat:@"%@\r\n%@", app.reciverAddress.receiverName, app.reciverAddress.phone];
        }
        
        [self resignKeyboard:nil];
        return;
        
    }
    if (isShowNewAddress) {
        isShowNewAddress = NO;
        [self getAddrList];
        [self getPayMode];
        return;
    }
    
}

-(void)setTextViewPlace:(BOOL)isShow
{
    [self.tfAddress setPlaceholderHiden:isShow];
    [self.tfAddress setPlaceholderHiden:isShow];
    [self.tfGPSAddress setPlaceholderHiden:isShow];
    [self.tfReciver setPlaceholderHiden:isShow];
    [self.tfPhone setPlaceholderHiden:isShow];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //NSArray *array = [[NSArray alloc] initWithObjects:@"旧密码:",@"新密码:",@"新密码:", nil];
    
        //[array release];
    float viewHeight;
    if (is_iPhone5) {
        viewHeight = 500;
    }else{
        viewHeight = 370;
    }
    
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
    
    if (ordertimeDatePicker == nil) {
        ordertimeDatePicker = [[UIDatePicker alloc] init];
        [ordertimeDatePicker addTarget:self action:@selector(ordertimeDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        ordertimeDatePicker.frame = CGRectMake(0, viewHeight, 320, 240);
        //ordertimeDatePicker.datePickerMode = UIDatePickerModeTime ;//只显示时间//UIDatePickerModeDateAndTime;//日期和时间
        
        NSDate *currentDate = [NSDate date];
        

        
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
        [ordertimeDatePicker setDate:rightdate animated:YES];
        
        NSTimeInterval  interval2 =24*60*60*7; //7:天数
        NSDate *maxdate = [currentDate initWithTimeIntervalSinceNow:+interval2];
        
        NSTimeInterval  interval3 =60*30; //30分钟后
        NSDate *mindate = [currentDate initWithTimeIntervalSinceNow:+interval3];
        
        [ordertimeDatePicker setMaximumDate:maxdate];
        [ordertimeDatePicker setMinimumDate:mindate];

    }
    
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];
    self.userName = [defaults objectForKey:@"username"];
    
    //CGRect frame = self.view.frame;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, self.view.frame.size.height)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];

    if (app.shopCart.buyType < 2) {
        self.title = CustomLocalizedString(@"shop_cart_recer_info_ok", @"确认您的收货信息");
    }else if(app.shopCart.buyType == 2){
        self.title = @"参加活动";
    }else if(app.shopCart.buyType == 4){
        self.title = @"购买优惠券";
    }else if(app.shopCart.buyType == 5){
        self.title = @"礼品兑换";
    }
    self.bgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 10, 314, self.view.frame.size.height-45)];

    self.bgView.userInteractionEnabled = YES;
    [scrollView addSubview:self.bgView];
    sendType = 1;
    sendTimeType = 0;
    payType = 0;
    addrType = 1;
    app.shopCart.canBuyType = app.shopCart.buyType;
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayComeBack:) name:APP_WX_PAY_COMBACK object:nil];//注册更新函数
    
    self.userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    if(app.shopCart.buyType != 4){
        [self getAddrList];
    }
}
-(void)WXPayComeBack:(id)sender
{
    OrderNewViewController *viewController = [[[OrderNewViewController alloc] initWithOrderId:self.orderId] autorelease];
    
    [self.navigationController pushViewController:viewController animated:true];
    [app.shopCart Clean];
    addOrderSucess = YES;
}
#pragma mark 界面控件初始化
-(void)initView
{
    int x = 3;
    int length = 308;
    UIImage *sUCheckImage = [[UIImage imageNamed:@"cart_unok.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(31, 0, 31,0) resizingMode:UIImageResizingModeStretch];
    UIImage *sCheckImage = [[UIImage imageNamed:@"cart_ok.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(31, 0, 31,0) resizingMode:UIImageResizingModeStretch];
    
    int height = 10;
    UIImageView *rightArrow;
    UIButton *btn;
    UIButton *btn1;
    UILabel *lb;
    payType = 4;//只有在线支付
    
    if (app.shopCart.canBuyType == 1) {
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = @"购买方式";
        [self.bgView addSubview:lb];
        [lb release];
        
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(70, height-5, 60, 25)];
        [btn setImage:sUCheckImage forState:UIControlStateNormal];
        [btn setImage:sCheckImage forState:UIControlStateSelected];
        btn.tag = 400;
        btn.selected = YES;
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn addTarget:self action:@selector(buyTypeCheck:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"预约" forState:UIControlStateNormal];
        [self.bgView addSubview:btn];
        [btn release];
        sendTimeType = 1;

        height += 30;
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
    }
    
    if(app.shopCart.buyType == 1)
    {//预约
        startTag = 9;
        LineCount = 14;
        
        height += 10;
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = @"预约人数";
        [self.bgView addSubview:lb];
        [lb release];
        
        self.tfPeople = [[HJTextView alloc] initWithFrame:CGRectMake(70, height-3, 200, 30) placeholder:@"请输入预约人数" font:[UIFont boldSystemFontOfSize:16] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        self.tfPeople.tag = 9;
        self.tfPeople.inputAccessoryView = self.keyboardToolbar;
        self.tfPeople.delegate = self;
        self.tfPeople.keyboardType = UIKeyboardTypeNumberPad;
        [self.bgView addSubview:self.tfPeople];//预约人数
        
        
        height += 30;
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
    }else if(app.shopCart.buyType == 2){
        startTag = 9;
        LineCount = 14;
        
        
        
        height += 10;
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = @"参与人数";
        [self.bgView addSubview:lb];
        [lb release];
        
        self.tfPeople = [[HJTextView alloc] initWithFrame:CGRectMake(70, height-3, 200, 30) placeholder:@"请输入参加人数" font:[UIFont boldSystemFontOfSize:16] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        self.tfPeople.tag = 9;
        self.tfPeople.inputAccessoryView = self.keyboardToolbar;
        self.tfPeople.delegate = self;
        self.tfPeople.font = [UIFont boldSystemFontOfSize:16];
        self.tfPeople.keyboardType = UIKeyboardTypeNumberPad;
        [self.bgView addSubview:self.tfPeople];//预约人数
        
        
        height += 30;
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
        
        

    }else{
        LineCount = 14;
        startTag = 10;
    }
    if (app.shopCart.buyType != 4) {
        height += 10;
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(x, height, 100, 25)];
        [btn setImage:sUCheckImage forState:UIControlStateNormal];
        [btn setImage:sCheckImage forState:UIControlStateSelected];
        btn.tag = 500;
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn addTarget:self action:@selector(addressTypeCheck:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:CustomLocalizedString(@"shop_cart_map_addr", @"地图定位") forState:UIControlStateNormal];
        [self.bgView addSubview:btn];
        
        
        btn1 = [[UIButton alloc] initWithFrame:CGRectMake(110, height, 80, 25)];
        [btn1 setImage:sUCheckImage forState:UIControlStateNormal];
        [btn1 setImage:sCheckImage forState:UIControlStateSelected];
        btn1.tag = 501;
        
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btn1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn1 addTarget:self action:@selector(addressTypeCheck:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitle:CustomLocalizedString(@"shop_cart_my_addr", @"地址库") forState:UIControlStateNormal];
        [self.bgView addSubview:btn1];
        
        if (addrType == 1) {
            btn.selected = YES;
        }
        else{
            btn1.selected = YES;
        }
        [btn release];
        [btn1 release];
        
        btnAddNewAddr = [[UIButton alloc] initWithFrame:CGRectMake(190, height - 5, 80, 30)];
        btnAddNewAddr.backgroundColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
        [btnAddNewAddr setHidden:YES];
        [btnAddNewAddr setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAddNewAddr setTitle:CustomLocalizedString(@"shop_cart_new_addr", @"新增地址") forState:UIControlStateNormal];
        [btnAddNewAddr addTarget:self action:@selector(btnAddNewOrder:) forControlEvents:UIControlEventTouchDown];
        [self.bgView addSubview:btnAddNewAddr];
        
        height += 30;
        
        
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        
        lb.text = CustomLocalizedString(@"user_name", @"联系人：");
            
        
        [self.bgView addSubview:lb];
        [lb release];
        
        height += 22;
        self.tfReciver = [[HJTextView alloc] initWithFrame:CGRectMake(x, height, length, 30) placeholder:CustomLocalizedString(@"user_hidden", @"请输入您的姓名") font:[UIFont boldSystemFontOfSize:12] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        
        
        self.tfReciver.tag = 10;
        self.tfReciver.inputAccessoryView = self.keyboardToolbar;
        self.tfReciver.delegate = self;
        
        [self.bgView addSubview:self.tfReciver];
        height += 32;
        
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        
        lb.text = CustomLocalizedString(@"shop_cart_tel", @"电话：");
        
        
        [self.bgView addSubview:lb];
        [lb release];
        
        height += 22;
        self.tfPhone = [[HJTextView alloc] initWithFrame:CGRectMake(x, height, length, 30) placeholder:CustomLocalizedString(@"no_phone", @"请输入您的手机号码") font:[UIFont boldSystemFontOfSize:12] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        
        self.tfPhone.keyboardType = UIKeyboardTypeNumberPad;
        self.tfPhone.tag = 11;
        self.tfPhone.inputAccessoryView = self.keyboardToolbar;
        self.tfPhone.delegate = self;
        
        //self.tfAddress.placeholder = @"选择您的收货地址";
        [self.bgView addSubview:self.tfPhone];
        
        height += 32;
        
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        
        lb.text = CustomLocalizedString(@"room_addr", @"地址：");
        
        height += 25;
        [self.bgView addSubview:lb];
        [lb release];
        
        
        self.tfGPSAddress = [[HJTextView alloc] initWithFrame:CGRectMake(x, height, length, 30) placeholder:CustomLocalizedString(@"shop_cart_gps_addr", @"请输入您的地址信息") font:[UIFont boldSystemFontOfSize:12] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        
        self.tfGPSAddress.delegate = self;
        self.tfGPSAddress.tag = 1000;
        self.tfGPSAddress.inputAccessoryView = self.keyboardToolbar;
        //self.tfAddress.delegate = self;
        
        //self.tfAddress.placeholder = @"选择您的收货地址";
        [self.bgView addSubview:self.tfGPSAddress];
        
        height += 32;
        
        self.tfAddress = [[HJTextView alloc] initWithFrame:CGRectMake(x, height, length, 90) placeholder:CustomLocalizedString(@"shop_cart_add_detail", @"具体地址，如：门牌号，房间号") font:[UIFont boldSystemFontOfSize:12] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        
        
        self.tfAddress.tag = 12;
        self.tfAddress.inputAccessoryView = self.keyboardToolbar;
        self.tfAddress.delegate = self;
        
        //self.tfAddress.placeholder = @"选择您的收货地址";
        [self.bgView addSubview:self.tfAddress];
        
        
        
        
        
        
        height += 95;
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
    }
    
    
    
    
    
    if (app.shopCart.buyType == 0) {
        height += 10;
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height + 5, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = CustomLocalizedString(@"shop_cart_send_type", @"配      送");
        [self.bgView addSubview:lb];
        [lb release];
        
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(70, height, 120, 25)];
        [btn setImage:sUCheckImage forState:UIControlStateNormal];
        [btn setImage:sCheckImage forState:UIControlStateSelected];
        btn.tag = 100;
        
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn addTarget:self action:@selector(addOrderCheck:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:CustomLocalizedString(@"shop_cart_send_mode_1", @"送货上门") forState:UIControlStateNormal];
        [self.bgView addSubview:btn];
        
        
        /*btn1 = [[UIButton alloc] initWithFrame:CGRectMake(160, height, 60, 25)];
        [btn1 setImage:sUCheckImage forState:UIControlStateNormal];
        [btn1 setImage:sCheckImage forState:UIControlStateSelected];
        btn1.tag = 101;
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btn1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn1 addTarget:self action:@selector(addOrderCheck:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitle:@"自取" forState:UIControlStateNormal];
        [self.bgView addSubview:btn1];*/
        
        if (sendType == 1) {
            btn.selected = YES;
        }
        /*else{
            btn1.selected = YES;
        }*/
        [btn release];
        //[btn1 release];
        height += 30;
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
        
    }
    
    if (app.shopCart.buyType == 0) {
        height += 10;
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height + 10, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        if (app.shopCart.buyType == 1) {
            lb.text = CustomLocalizedString(@"到店时间", @"到店时间");
        }else{
            lb.text = CustomLocalizedString(@"shop_cart_s_time", @"送达时间");
        }
        [self.bgView addSubview:lb];
        [lb release];
        
        if(app.shopCart.buyType == 0)
        {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(70, height+5, 80, 25)];
            [btn setImage:sUCheckImage forState:UIControlStateNormal];
            [btn setImage:sCheckImage forState:UIControlStateSelected];
            btn.tag = 200;
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [btn addTarget:self action:@selector(addOrderCheckTime:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:CustomLocalizedString(@"shop_cart_time_must", @"尽快送达") forState:UIControlStateNormal];
            [self.bgView addSubview:btn];
            
            btn1 = [[UIButton alloc] initWithFrame:CGRectMake(160, height + 5, 40, 25)];
            [btn1 setImage:sUCheckImage forState:UIControlStateNormal];
            [btn1 setImage:sCheckImage forState:UIControlStateSelected];
            btn1.tag = 201;
            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
            btn1.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [btn1 addTarget:self action:@selector(addOrderCheckTime:) forControlEvents:UIControlEventTouchUpInside];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.bgView addSubview:btn1];
            
            if (sendTimeType == 0) {
                btn.selected = YES;
            }
            else{
                btn1.selected = YES;
            }
            [btn1 release];
            [btn release];
            
            
            
            self.tfTime = [[HJTextView alloc] initWithFrame:CGRectMake(190, height, 114, 30) placeholder:@"" font:[UIFont boldSystemFontOfSize:10] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
            self.tfTime.tag = 13;
            self.tfTime.inputView = ordertimeDatePicker;
            self.tfTime.inputAccessoryView = self.keyboardToolbar;
            self.tfTime.delegate = self;
            self.tfTime.text = [self getSystemTime];
            [self.bgView addSubview:self.tfTime];
        }else{
            self.tfTime = [[HJTextView alloc] initWithFrame:CGRectMake(70, height, 200, 30) placeholder:@"" font:[UIFont boldSystemFontOfSize:10] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
            self.tfTime.tag = 13;
            
            self.tfTime.inputView = ordertimeDatePicker;
            self.tfTime.inputAccessoryView = self.keyboardToolbar;
            self.tfTime.delegate = self;
            self.tfTime.text = [self getSystemTime];
            [self.bgView addSubview:self.tfTime];
        }
        
        
        height += 40;
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
        
        height += 10;
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height + 10, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = CustomLocalizedString(@"shop_cart_pay_mode", @"付款方式");
        [self.bgView addSubview:lb];
        [lb release];
        
        
        btnPayMoeny = [[UIButton alloc] initWithFrame:CGRectMake(70, height- 5, 80, 25)];
        [btnPayMoeny setImage:sUCheckImage forState:UIControlStateNormal];
        [btnPayMoeny setImage:sCheckImage forState:UIControlStateSelected];
        btnPayMoeny.tag = 300;
        
        
        btnPayMoeny.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btnPayMoeny.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnPayMoeny addTarget:self action:@selector(addOrderCheckPay:) forControlEvents:UIControlEventTouchUpInside];
        [btnPayMoeny setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(app.shopCart.buyType == 0){
            [btnPayMoeny setTitle:CustomLocalizedString(@"pay_mode_0", @"货到付款") forState:UIControlStateNormal];
        }else{
            [btnPayMoeny setTitle:CustomLocalizedString(@"到店付款", @"到店付款") forState:UIControlStateNormal];
        }
        
        [self.bgView addSubview:btnPayMoeny];
        
        
        btnPayAlipay = [[UIButton alloc] initWithFrame:CGRectMake(160, height - 5, 80, 25)];
        [btnPayAlipay setImage:sUCheckImage forState:UIControlStateNormal];
        [btnPayAlipay setImage:sCheckImage forState:UIControlStateSelected];
        btnPayAlipay.tag = 301;
        
        btnPayAlipay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btnPayAlipay.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnPayAlipay addTarget:self action:@selector(addOrderCheckPay:) forControlEvents:UIControlEventTouchUpInside];
        [btnPayAlipay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnPayAlipay setTitle:CustomLocalizedString(@"pay_mode_1", @"支付宝") forState:UIControlStateNormal];
        [self.bgView addSubview:btnPayAlipay];
        
        height += 20;
        
        self.btnPayWXpay = [[UIButton alloc] initWithFrame:CGRectMake(70, height, 80, 25)];
        [self.btnPayWXpay setImage:sUCheckImage forState:UIControlStateNormal];
        [self.btnPayWXpay setImage:sCheckImage forState:UIControlStateSelected];
        self.btnPayWXpay.tag = 303;
        
        self.btnPayWXpay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        self.btnPayWXpay.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [self.btnPayWXpay addTarget:self action:@selector(addOrderCheckPay:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnPayWXpay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnPayWXpay setTitle:CustomLocalizedString(@"pay_mode_3", @"微信支付") forState:UIControlStateNormal];
        [self.bgView addSubview:self.btnPayWXpay];
        
        height += 20;
        
        btnPayAccount = [[UIButton alloc] initWithFrame:CGRectMake(70, height + 5, 80, 25)];
        [btnPayAccount setImage:sUCheckImage forState:UIControlStateNormal];
        [btnPayAccount setImage:sCheckImage forState:UIControlStateSelected];
        btnPayAccount.tag = 302;
        
        btnPayAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btnPayAccount.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btnPayAccount addTarget:self action:@selector(addOrderCheckPay:) forControlEvents:UIControlEventTouchUpInside];
        [btnPayAccount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnPayAccount setTitle:CustomLocalizedString(@"pay_mode_2", @"账户余额") forState:UIControlStateNormal];
        [self.bgView addSubview:btnPayAccount];
        
        self.tfPayPassword = [[HJTextView alloc] initWithFrame:CGRectMake(160, height + 5, 130, 30) placeholder:CustomLocalizedString(@"shop_cart_pay_password_notice", @"请输入支付密码") font:[UIFont boldSystemFontOfSize:10] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        
        self.tfPayPassword.inputAccessoryView = self.keyboardToolbar;
        self.tfPayPassword.keyboardType = UIKeyboardTypeASCIICapable;
        self.tfPayPassword.delegate = self;
        [self.tfPayPassword setSecureTextEntry:YES];
        [self.tfPayPassword setHidden:YES];
        [self.bgView addSubview:self.tfPayPassword];
        
        switch (payType) {
            case 1://支付bao
                btnPayAlipay.selected = YES;
                break;
            case 3://账户余额
                btnPayAccount.selected = YES;
                [self.tfPayPassword setHidden:NO];
                self.tfPayPassword.tag = 14;
                LineCount = 15;
                break;
            case 4://货到付款
                btnPayMoeny.selected = YES;
                
                break;
            default:
                break;
        }
        
        
        height += 40;
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
        
        height += 10;
        
        /*lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = CustomLocalizedString(@"", @"备注信息");
        [self.bgView addSubview:lb];
        [lb release];*/
        
        self.tfRemark = [[HJTextView alloc] initWithFrame:CGRectMake(x, height - 5, 304, 80) placeholder:CustomLocalizedString(@"shop_cart_remark_notice", @"请输入订单备注") font:[UIFont boldSystemFontOfSize:12] borderColor:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]];
        if (payType == 3) {
            self.tfRemark.tag = 15;
        }else{
            self.tfRemark.tag = 14;
        }
        
        //tfRemark.lineBreakMode = NSLineBreakByWordWrapping;
        //tfRemark.numberOfLines = 0;//最多行数
        self.tfRemark.inputAccessoryView = self.keyboardToolbar;
        self.tfRemark.delegate = self;
        //tfRemark.p;
        [self.bgView addSubview:self.tfRemark];
        height += 85;
        
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
        
        height += 20;
    }else if(app.shopCart.buyType == 2){
        height += 10;
        
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = @"联系邮箱";
        [self.bgView addSubview:lb];
        [lb release];
        
        self.tfRemark = [[HJTextView alloc] initWithFrame:CGRectMake(70, height - 5, 220, 30) placeholder:@"请输入联系邮箱" font:[UIFont boldSystemFontOfSize:12]];
        self.tfRemark.tag = 14;
        //tfRemark.lineBreakMode = NSLineBreakByWordWrapping;
        //tfRemark.numberOfLines = 0;//最多行数
        self.tfRemark.inputAccessoryView = self.keyboardToolbar;
        self.tfRemark.delegate = self;
        //tfRemark.p;
        [self.bgView addSubview:self.tfRemark];
        
        height += 30;
        
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
        
        height += 20;
    }else if(app.shopCart.buyType == 4 || app.shopCart.buyType == 5){
        height += 10;
        lb = [[UILabel alloc] initWithFrame:CGRectMake(x, height + 10, 60, 20)];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = @"支付方式";
        [self.bgView addSubview:lb];
        [lb release];
        
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(70, height+5, 200, 25)];
        [btn setImage:sUCheckImage forState:UIControlStateNormal];
        [btn setImage:sCheckImage forState:UIControlStateSelected];
        btn.tag = 300;
        
        btn.selected = YES;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//靠左对齐
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [btn addTarget:self action:@selector(addOrderCheckPay:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(app.shopCart.payType == 0){
            [btn setTitle:[NSString stringWithFormat:@"积分兑换，所需积分：%.0f", app.shopCart.cAllPrice] forState:UIControlStateNormal];
        }else{
            [btn setTitle:[NSString stringWithFormat:@"支付宝，所需金额：￥%.2f", app.shopCart.cAllPrice] forState:UIControlStateNormal];
        }
        
            
        [self.bgView addSubview:btn];
        
        
        
        [btn release];
        height += 40;
        
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(x, height, length, 2)];
        rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
        [self.bgView addSubview:rightArrow];
        [rightArrow release];
    }
    
    
    
    
    
    
    
    
   
    
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, height - 10, 100, 30)];
    //btnSave.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btnSave.backgroundColor = [UIColor colorWithRed:251/255.0 green:157/255.0 blue:75/255.0 alpha:1.0];
    if(app.shopCart.buyType < 2){
        [btnSave setTitle:CustomLocalizedString(@"shop_cart_recer_info", @"提交订单") forState:UIControlStateNormal];
    }else if(app.shopCart.buyType == 2){
        [btnSave setTitle:@"确认参加" forState:UIControlStateNormal];
    }else if(app.shopCart.buyType == 4){
        [btnSave setTitle:@"确认购买" forState:UIControlStateNormal];
    }else if(app.shopCart.buyType == 5){
        [btnSave setTitle:@"提交兑换" forState:UIControlStateNormal];
    }
    
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(addToServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:btnSave];
    [btnSave release];
    
    height += 30;
    [self setDefaultAddress];
    
    
    
    CGRect frame = self.bgView.frame;
    frame.size.height = height;
    self.bgView.frame = frame;
    [scrollView setContentSize:CGSizeMake(320, height + 50)];
}

-(void)ClearView{
    
    for (UIView *_view in self.bgView.subviews) {
        [_view removeFromSuperview];
        
    }
}

-(NSString *)getSystemTime
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateformatter stringFromDate:senddate];
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
} 

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc {
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
    [self.keyboardToolbar release];
    [self.userid release];
    [self.userName release];
    [self.btnPayAccount release];
    [self.btnPayAlipay release];
    [self.btnPayMoeny release];
    [self.tfGPSAddress release];
    [self.tfReciver release];
    [self.tfPhone release];
    [self.tfPeople release];
    [self.tfPayPassword release];
    [address release];
    [btnAddNewAddr release];
    [self.tfAddress release];
    [self.tfTime release];
    [backClick release];
    [self.tfRemark release];
    [scrollView release];
    [ordertimeDatePicker release];
    [self.orderId release];
    [self.bgView release];
    [super dealloc];
}
- (void)ordertimeDatePickerChanged:(id)sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    //NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-d HH:mm"];
    
    tfTime.text = [formatter stringFromDate:ordertimeDatePicker.date];//[dateFormatter stringFromDate:self.ordertime];
    
    [dateFormatter release];
}
#pragma mark UIAlterView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        //[app SetTab:3];
        [self.navigationController popViewControllerAnimated:YES];
        addOrderSucess = true;
        return;
    }
    
}
#pragma mark 提交订单到服务器
-(void)addToServer:(id)sender
{
    if (app.shopCart.buyType == 1){
        if(self.tfPeople.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入预约人数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            return;
        }else{
            app.shopCart.people = self.tfPeople.text;
        }

    }
    if (app.shopCart.buyType == 2) {
        if(self.tfPeople.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入参加人数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            return;
        }else{
            app.shopCart.people = self.tfPeople.text;
        }
        
        if(self.tfRemark.text.length < 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入联系邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            return;
        }
    }
    
    
    if(app.shopCart.buyType != 4){
        
        
        if (self.tfReciver.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"user_hidden", @"您的联系人信息不对！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            return;
        }
        
        if (![app checkMobilePhone:self.tfPhone.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"no_phone", @"您的联系电话不对！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            
            [alert release];
            return;
        }
        
        if (app.shopCart.buyType < 1) {
            if (self.tfAddress.text.length < 4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_add_detail", @"请输入具体地址") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                
                [alert release];
                return;
            }
        }
        
        if (payType == 3){
            if (self.payPassword.length < 6) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_pay_password_info", @"您输入的账户支付密码不对，不能少于6位") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                [alert show];
                
                [alert release];
                return;
            }else{
                app.shopCart.payPassword = self.payPassword;
            }
        }else{
            app.shopCart.payPassword = @"";
        
        }
        
        app.shopCart.custName = self.tfReciver.text;
        app.shopCart.phone = self.tfPhone.text;
        app.shopCart.Address = self.tfGPSAddress.text;
        app.shopCart.note = self.tfRemark.text;
        if (addrType == 1) {
            app.shopCart.Address = [NSString stringWithFormat:@"%@ %@", app.shopCart.Address, self.tfAddress.text];
            app.shopCart.uLat = [NSString stringWithFormat:@"%f", app.useLocation.lat];
            app.shopCart.uLng = [NSString stringWithFormat:@"%f", app.useLocation.lon];
        }else{
            app.shopCart.uLat = app.reciverAddress.lat;
            app.shopCart.uLng = app.reciverAddress.lon;
        }
        app.shopCart.payMode = payType;
        
        app.shopCart.addTime = [self getSystemTime];
        if (sendTimeType == 0) {
            
            app.shopCart.sendTime = [self getSystemTime];//@"尽快送达";
        }else
        {
            app.shopCart.sendTime = tfTime.text;
        }
        if (tfRemark.text.length > 0) {
            app.shopCart.note = tfRemark.text;
        }else{
            app.shopCart.note = @"";
        }

    }
    app.shopCart.areaID = @"0";
    app.shopCart.userID = self.userid;
    app.shopCart.userName = self.userName;
    app.shopCart.areaID = app.Area.cID;
    
    if (twitterClient) return;
    
    //联网提交订单
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addorderDidReceive:obj:)];
    if (app.shopCart.buyType < 2) {
        NSString *value = [app.shopCart getJSONString];
        [twitterClient SubmitOrder:value orderType:app.shopCart.buyType];
    }else if(app.shopCart.buyType == 2){
        NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.shopCart.userID, @"userID", app.shopCart.custName, @"person", app.shopCart.phone, @"tel", tfPeople.text, @"reveint1",tfRemark.text, @"email", app.shopCart.activityID, @"activitiesid",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
        [twitterClient JoinActivity:param];
    }else if(app.shopCart.buyType == 4){
        NSDictionary* param  = [[NSDictionary alloc] initWithObjectsAndKeys:app.shopCart.userID, @"userID", app.shopCart.activityID, @"voucherid", [NSString stringWithFormat:@"%d", app.shopCart.cFoodCount], @"count",nil];//isbuy 0表示线上商品，1表示线下商品 type 0表示热卖 2表示新品推荐
        [twitterClient buyCoupon:param];
    }else if(app.shopCart.buyType == 5){
        NSString *value = [app.shopCart getGiftJSONString];
        [twitterClient SubmitCart:value];
    }
    
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"shop_cart_add_order", @"提交中...");
    [_progressHUD show:YES];
    
    
    
}

- (void)addorderDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    twitterClient = nil;
    //1. 获取信息
    NSDictionary *dic = (NSDictionary*)obj;
    //注意此处必须 用self.dic 不能直接使用dic 否则在其他函数中 self.dic是null
    int state;
    if (app.shopCart.buyType < 2) {
        state = [[dic objectForKey:@"orderstate"] intValue];
        
        //self.payMoney = [[dic objectForKey:@"Currentprice"] floatValue];
        
        self.orderId = [dic objectForKey:@"orderid"];
        //测试
        //state = @"1";
        
        //{"orderid":"120925213201002220","orderstate":"1"}
        if(state == 1)
        {
            if(addrType == 1){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.tfReciver.text forKey:@"Reciver"];
                [defaults setObject:self.tfPhone.text forKey:@"Phone"];
                [defaults setObject:self.tfAddress.text forKey:@"RoomDr"];
                [defaults synchronize];
            }

                OrderNewViewController *viewController = [[[OrderNewViewController alloc] initWithOrderId:self.orderId] autorelease];
                
                [self.navigationController pushViewController:viewController animated:true];
                [app.shopCart Clean];
                addOrderSucess = YES;
   
        }
        else
        {
            NSString *msg = [dic objectForKey:@"msg"];
            if (msg == nil) {
                msg = CustomLocalizedString(@"public_net_or_data_error", @"网络或数据错误！请稍后再试！");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:msg delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if(app.shopCart.buyType == 2){
        state = [[dic objectForKey:@"state"] intValue];
        if(state == 1 )
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:@"您的参与活动已经提交成功" delegate:self cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 1;
            [alert show];
            [alert release];
            [app.shopCart Clean];
            addOrderSucess = YES;
            
            
        }
        else
        {
            NSString *msg = [dic objectForKey:@"msg"];
            if (msg == nil) {
                msg = CustomLocalizedString(@"public_net_or_data_error", @"网络或数据错误！请稍后再试！");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:msg delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if(app.shopCart.buyType == 5){
        state = [[dic objectForKey:@"state"] intValue];
        if(state == 1 )
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_add_sucess", @"您的礼品兑换成功") delegate:self cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 1;
            [alert show];
            [alert release];
            [app.shopCart Clean];
            addOrderSucess = YES;
            
            
        }
        else
        {
            NSString *msg = [dic objectForKey:@"msg"];
            if (msg == nil) {
                msg = CustomLocalizedString(@"public_net_or_data_error", @"网络或数据错误！请稍后再试！");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:msg delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if(app.shopCart.buyType == 4){
        self.orderId = [dic objectForKey:@"payorderid"];
        self.payMoney = [[dic objectForKey:@"Currentprice"] floatValue];
        if(self.orderId.length > 0)
        {
            if(app.shopCart.payType == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:@"您的优惠券购买成功" delegate:self cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                alert.delegate = self;
                alert.tag = 1;
                [alert show];
                [alert release];
            }
            else
            {
                
                [self aliPay:self.orderId money:self.payMoney type:1];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [app.shopCart Clean];
            addOrderSucess = YES;
            
            
        }
        else
        {
            NSString *msg = [dic objectForKey:@"msg"];
            if (msg == nil) {
                msg = CustomLocalizedString(@"public_net_or_data_error", @"网络或数据错误！请稍后再试！");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_add_order_faild", @"提交失败！请稍后再试") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
    
    
}
#pragma mark 获取支付数据
-(void)getPayID:(float)moeny{

    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(payIDDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.189053";
    //lng = @"120.163655";
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.orderId, @"orderid", [NSString stringWithFormat:@"%.2f", moeny],@"price", nil];
    
    [twitterClient getPayID:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"pay_load_id", @"获取支付数据中...");
    [_progressHUD show:YES];
    
}

- (void)payIDDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    
    twitterClient= nil;
    
    if (client.hasError) {
        [client alert];
        [client release];
        client = nil;
        return;
    }
    [client release];
    client = nil;
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic1 = (NSDictionary*)obj;
    
    int state = [[dic1 objectForKey:@"state"] intValue];
    if (state == 1) {
        self.payId = [dic1 objectForKey:@"batch"];
        [self gotoOnLinPay:self.payMoney orderid:self.orderId];
        //[self aliPay:self.orderId money:(app.shopCart.cAllPrice + app.shopCart.cSendMoney + app.shopCart.cPackageFee) type:1];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"pay_load_id_error", @"获取支付数据失败！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark 在线支付

-(void)gotoOnLinPay:(float)payMoney orderid:(NSString *)odid
{
    if (payMoney > 0.0f) {
        //payMoney = 0.01;//测试用
        if (self.payId == nil) {
            [self getPayID:payMoney];
            return;
        }
        if (payType == 1) {//支付宝
            [self aliPay:odid money:payMoney type:1];
        }else if(payType == 5){
            //微信
            [app WXsendPay:odid payid:self.payId price:payMoney];
            self.payId = nil;
        }
        
    }
}

#pragma mark 支付宝

-(void)aliPay:(NSString *)odid money:(float)payMoney type:(int)payType
{
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    
    AliPayModel *order = [[AliPayModel alloc] init];
    order.partner = AliPartner;
    order.seller = AliSeller;
    
    order.tradeNO = self.payId; //订单ID（由商家自行制定）
    
    order.productName = [NSString stringWithFormat:@"%@%@%@", app.appName, CustomLocalizedString(@"shop_cart_pay_title", @"IOS支付，订单编号："), odid]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"%@%@，%@%@", CustomLocalizedString(@"order_detail_id", @"订单编号："), odid, CustomLocalizedString(@"pay_payid", @"支付编号："), self.payId]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",payMoney]; //商品价格
    order.notifyURL =  [NSString stringWithFormat:@"http%%3A%%2F%%2F%@%%2FAlipay%%2Fiosnotify.aspx", HOST];//回调URL @"http%3A%2F%2Fmapdc.ihangjing.com%2FAlipay%2Fiosnotify.aspx"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"AliPayHangJing";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AliPrivateKey);
    NSString *signedString = [signer signString:orderSpec];
    self.payId = nil;//每次支付都要重新获取
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            int state = [[resultDic objectForKey:@"resultStatus"] intValue];
            NSNotification* notification;
            if (state == 9000) {
                notification = [NSNotification notificationWithName:APP_URL_COMBACK object:nil];
            }else if(state == 6001){
                notification = [NSNotification notificationWithName:APP_URL_COMBACK_CANCEL object:nil];
            }else{
                notification = [NSNotification notificationWithName:APP_URL_COMBACK_FAILD object:nil];
            }
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            OrderNewViewController *viewController = [[[OrderNewViewController alloc] initWithOrderId:self.orderId] autorelease];
            
            [self.navigationController pushViewController:viewController animated:true];
            [app.shopCart Clean];
            addOrderSucess = YES;
        }];
        
    }

}



#pragma mark 获取商家支付方式
-(void)getPayMode
{
    return;
    [self.btnPayAccount setHidden:YES];
    [self.btnPayAlipay setHidden:YES];
    [self.btnPayMoeny setHidden:YES];
    
    address = [[NSMutableArray alloc] init];
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(payModeDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.189053";
    //lng = @"120.163655";
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", ((ShopCardModel *)[app.shopCart.shopCartArry objectAtIndex:0]).shopID],@"shopid", nil];
    
    [twitterClient getPayMode:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
    
}





- (void)payModeDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    NSDictionary* dic1 = (NSDictionary*)obj;
    
    
    //2. 获取list
    
    NSArray *ary = nil;
    ary = [dic1 objectForKey:@"datalist"];
    
    if ([ary count] > 0) {
        int p = 0;
        for (int i = 0; i < [ary count]; ++i) {
            NSDictionary *dic2 = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic2 isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            int state = [[dic2 objectForKey:@"cid"] intValue];
            switch (state) {
                case 1:
                    [self.btnPayMoeny setHidden:NO];
                    p |= 2;
                    break;
                case 3:
                    [self.btnPayAccount setHidden:NO];
                    break;
                    p |= 4;
                case 4:
                    [self.btnPayAlipay setHidden:NO];
                    p |= 1;
                    break;
                default:
                    break;
            }
        }
        if ((p & 1) == 1) {
            btnPayMoeny.selected = YES;
            payType = 4;
        }else{
            btnPayMoeny.selected = NO;
            if ((p & 2) == 2)
            {
                self.btnPayAlipay.selected = YES;
                payType = 1;
            }else{
                self.btnPayAccount.selected = YES;
                payType = 3;
            }
        }
    }
    
    
}
#pragma mark GetAddressList

-(void)getAddrList
{
    
    address = [[NSMutableArray alloc] init];
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(addressDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.189053";
    //lng = @"120.163655";
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"pageindex",userid,@"userid",@"100",@"pagesize", nil];
    
    [twitterClient getUserAddressList:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
    
}





- (void)addressDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    NSDictionary* dic1 = (NSDictionary*)obj;
    
    
    //2. 获取list
    
    NSArray *ary = nil;
    ary = [dic1 objectForKey:@"list"];
    
    
    [address removeAllObjects];
    if ([ary count] > 0) {
        for (int i = 0; i < [ary count]; ++i) {
            NSDictionary *dic2 = (NSDictionary*)[ary objectAtIndex:i];
            if (![dic2 isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            UserAddressMode *model = [[UserAddressMode alloc] initWithJsonDictionary:dic2];
            [address addObject:model];
            [model release];
        }
        app.reciverAddress = [address objectAtIndex:0];
        
        if(app.shopCart.buyType == 0){
            //self.tfAddress.text = [NSString stringWithFormat:@"%@\r\n%@\r\n%@", app.reciverAddress.receiverName, app.reciverAddress.phone, app.reciverAddress.address];
            [self setDefaultAddress];
            
        }else{
            self.tfAddress.text = [NSString stringWithFormat:@"%@\r\n%@", app.reciverAddress.receiverName, app.reciverAddress.phone];
        }
        
        
    }
    
    
}
#pragma mark CheckButton
-(void)addOrderCheckPay:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        UIButton *btn1;
        switch (btn.tag) {
            case 300:
                payType = 4;
                btn1 = (UIButton *)[self.view viewWithTag:301];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:302];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:303];
                btn1.selected = NO;

                [self.tfPayPassword setHidden:YES];
                self.tfPayPassword.tag = 2000;
                self.tfPayPassword.text = @"";
                self.payPassword = @"";
                LineCount = 14;
                self.tfRemark.tag = 14;
                break;
            case 301:
                payType = 1;
                btn1 = (UIButton *)[self.view viewWithTag:300];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:302];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:303];
                btn1.selected = NO;

                [self.tfPayPassword setHidden:YES];
                self.tfPayPassword.tag = 2000;
                self.tfPayPassword.text = @"";
                self.payPassword = @"";
                LineCount = 14;
                self.tfRemark.tag = 14;
                break;
            case 302:
                payType = 3;
                btn1 = (UIButton *)[self.view viewWithTag:300];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:301];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:303];
                btn1.selected = NO;

                [self.tfPayPassword setHidden:NO];
                self.tfPayPassword.tag = 14;
                LineCount = 15;
                self.tfRemark.tag = 15;
                break;
            case 303:
                payType = 5;
                btn1 = (UIButton *)[self.view viewWithTag:300];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:301];
                btn1.selected = NO;
                btn1 = (UIButton *)[self.view viewWithTag:302];
                btn1.selected = NO;

                [self.tfPayPassword setHidden:YES];
                self.tfPayPassword.tag = 2000;
                self.tfPayPassword.text = @"";
                self.payPassword = @"";
                LineCount = 14;
                self.tfRemark.tag = 14;
                break;
            default:
                break;
        }
    }

}
-(void)addOrderCheckTime:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        UIButton *btn1;
        switch (btn.tag) {
            case 200:
                sendTimeType = 0;
                btn1 = (UIButton *)[self.view viewWithTag:201];
                btn1.selected = NO;
                break;
            case 201:
                sendTimeType = 1;
                btn1 = (UIButton *)[self.view viewWithTag:200];
                btn1.selected = NO;
                break;
            default:
                break;
        }
    }
    //[self resignKeyboard:nil];
}
-(void)setDefaultAddress
{
    if (addrType == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *value = [defaults objectForKey:@"Reciver"];
        if (value != nil || value.length > 0) {
            self.tfReciver.text = value;
            [self.tfReciver setPlaceholderHiden:YES];
        }else{
            self.tfReciver.text = @"";
            [self.tfReciver setPlaceholderHiden:NO];
        }
        
        value = [defaults objectForKey:@"Phone"];
        if (value != nil || value.length > 0) {
            self.tfPhone.text = value;
            [self.tfPhone setPlaceholderHiden:YES];
        }else{
            self.tfPhone.text = @"";
            [self.tfPhone setPlaceholderHiden:NO];
        }
        value = [defaults objectForKey:@"RoomDr"];
        if (value != nil || value.length > 0) {
            self.tfAddress.text = value;
            [self.tfAddress setPlaceholderHiden:YES];
        }else{
            self.tfAddress.text = @"";
            [self.tfAddress setPlaceholderHiden:NO];
        }
        self.tfGPSAddress.text = app.useLocation.addressDetail;//[NSString stringWithFormat:@"%@\r\n%@", app.reciverAddress.receiverName, app.reciverAddress.phone];
        [self.tfGPSAddress setPlaceholderHiden:YES];
       // self.tfAddress.text = @"";
       // [self.tfAddress setPlaceholderHiden:NO];
    }else{
        if (app.reciverAddress != nil) {
            
            self.tfReciver.text = app.reciverAddress.receiverName;
            self.tfPhone.text = app.reciverAddress.phone;
            self.tfAddress.text = app.reciverAddress.address;//[NSString stringWithFormat:@"%@\r\n%@", app.reciverAddress.receiverName, app.reciverAddress.phone];
            self.tfGPSAddress.text = app.reciverAddress.address;
            [self setTextViewPlace:YES];
            
            
        }

    }
}
-(void)addressTypeCheck:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        UIButton *btn1;
        switch (btn.tag) {
            case 500:
                addrType = 1;
                btn1 = (UIButton *)[self.view viewWithTag:501];
                btn1.selected = NO;
                [btnAddNewAddr setHidden:YES];
                [self setDefaultAddress];
                break;
            case 501:
                addrType = 2;
                btn1 = (UIButton *)[self.view viewWithTag:500];
                btn1.selected = NO;
                [btnAddNewAddr setHidden:NO];
                if (!isShowAddressList) {
                    isShowAddressList = YES;
                    UserAddressListViewController *viewController = [[[UserAddressListViewController alloc] initWithArry:address] autorelease];
                    
                    [self.navigationController pushViewController:viewController animated:true];
                }
                break;
            default:
                break;
        }
    }

}
-(void)addOrderCheck:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        UIButton *btn1;
        switch (btn.tag) {
            case 100:
                sendType = 1;
                btn1 = (UIButton *)[self.view viewWithTag:101];
                btn1.selected = NO;
                break;
            case 101:
                sendType = 2;
                btn1 = (UIButton *)[self.view viewWithTag:100];
                btn1.selected = NO;
                break;
            default:
                break;
        }
    }

}
-(void)buyTypeCheck:(UIButton *)btn
{
    if (!btn.selected) {
        btn.selected = YES;
        UIButton *btn1;
        switch (btn.tag) {
            case 400:
                app.shopCart.buyType = 1;
                btn1 = (UIButton *)[self.view viewWithTag:401];
                btn1.selected = NO;
                break;
            case 401:
                app.shopCart.buyType = 0;
                btn1 = (UIButton *)[self.view viewWithTag:400];
                btn1.selected = NO;
                break;
            default:
                break;
        }
        [self ClearView];
        [self initView];
    }

}

#pragma mark BtnClick
-(void)btnAddNewOrder:(UIButton *)btn
{
    if (!isShowNewAddress) {

        isShowNewAddress = YES;
        app.reciverAddress = nil;
        app.reciverAddress = [[UserAddressMode alloc] init];
        UserAddressDetailViewController *controller = [[[UserAddressDetailViewController alloc] initWithShopID:[NSString stringWithFormat:@"%d", app.mShopModel.shopid]] autorelease];
        //[controller setTitle:@"新增地址"];
        [self.navigationController pushViewController:controller animated:true];
    }
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
