//
//  ChangePasswordViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "AppointmentOrderDetailNewViewController.h"
#import "FoodInOrderModelFix.h"

@implementation AppointmentOrderDetailNewViewController


@synthesize userid;
@synthesize orderID;
@synthesize userName;
@synthesize keyboardToolbar;
@synthesize dic;
@synthesize OrderDetailModel;
- (id)initOrderID:(NSString *)orderid
{
    [super init];
    if (self) {
        self.orderID = orderid;
    }
    return self;
}
- (id)initOrderModel:(AppointmentOrderDetailModel *)orderModel
{
    [super init];
    if (self) {
        self.OrderDetailModel = orderModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSArray *array = [[NSArray alloc] initWithObjects:@"旧密码:",@"新密码:",@"新密码:", nil];
    
        //[array release];
    
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"上一项", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"下一项", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"确定", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        
        [previousBarItem release];
        [nextBarItem release];
        [spaceBarItem release];
        [doneBarItem release];
    }
    LineCount = 3;
    startTag = 1;
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    self.title = @"预约订单详情";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];
    self.userName = [defaults objectForKey:@"username"];
    foods = [[NSMutableArray alloc] init];
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
    [self initView];
}

-(void)initView{
    float viewHeight;
    if (is_iPhone5) {
        viewHeight = 445;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 370;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, viewHeight)];
    int height = 10;
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(110, height, 100, 100)];
    rightArrow.image = OrderDetailModel.shopImage;
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 100;
    height += 10;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(60, height, 200, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.ShopName;
    lb.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:lb];
    [lb release];
    height += 25;
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 6;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 120.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.text = [NSString stringWithFormat:@"电话：%@", OrderDetailModel.ShopTel] ;
    [scrollView addSubview:lb];
    [lb release];
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(136, height - 2, 2, 17)];
    rightArrow.image = [UIImage imageNamed:@"vertical_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(139, height, 210, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.text = [NSString stringWithFormat:@"地址：%@", OrderDetailModel.ShopAddress] ;
    [scrollView addSubview:lb];
    [lb release];
    height += 19;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 6;
    
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"订单号";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 200.0, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.OrderId;
    [scrollView addSubview:lb];
    [lb release];
    height += 30;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 6;
    
    
    /*lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"订单状态";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 90.0, 15)];
    lb.textColor = [UIColor colorWithRed:251/255.0 green:90/255.0 blue:75/255.0 alpha:1.0];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = [self.dic objectForKey:@"State"];
    [scrollView addSubview:lb];
    [lb release];
    height += 30;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 6;*/
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"下单时间";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 200.0, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.OrderTime;
    [scrollView addSubview:lb];
    [lb release];
    height += 30;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"到店时间";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 200.0, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.endtime;
    [scrollView addSubview:lb];
    [lb release];
    height += 30;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 10;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"真实姓名";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 200, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.Reciver;
    [scrollView addSubview:lb];
    [lb release];
    height += 22;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 10;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"联系电话";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 200.0, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.phone;
    [scrollView addSubview:lb];
    [lb release];
    height += 22;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 10;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(30, height, 80.0, 15)];
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = @"用餐人数";
    [scrollView addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(110, height, 200, 15)];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = OrderDetailModel.reveint;
    [scrollView addSubview:lb];
    [lb release];
    height += 22;
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, height, 300, 2)];
    rightArrow.image = [UIImage imageNamed:@"horizontal_line.png"];
    [scrollView addSubview:rightArrow];
    [rightArrow release];
    height += 10;
    
    
    
    
    [scrollView setContentSize:CGSizeMake(320, height + 10)];
    [self.view addSubview:scrollView];
    [scrollView release];
}

#pragma mark GetData
-(void)getOrderDetail
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(orderDidReceive:obj:)];
    
    [twitterClient getOrderByOrderId:self.orderID];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
}

- (void)orderDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    //NSString *json = [NSString stringWithFormat:@"%@", obj];// stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    //json = [json stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    //1. 获取信息
    self.dic = (NSDictionary*)obj;
    
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [self.dic objectForKey:@"foodlist"];
    
    if ([ary count] == 0) {
        NSLog(@"[ary count] == 0");
        return;
    }
    
    // 将获取到的数据进行处理 形成列表
    NSLog(@"[ary count] == %lu",(unsigned long)[ary count]);
    int index = (int)[foods count];
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dict = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        FoodInOrderModelFix *model = [[FoodInOrderModelFix alloc] initWithDictionaryFix:dict];
        
        model.picPath = [imageDownload addTask:model.foodid url:nil showImage:nil defaultImg:@"" indexInGroup:index++ Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        [foods addObject:model];
        
        
        [model release];
    }
    [self initView];
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
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

    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [self.OrderDetailModel release];
    [self.keyboardToolbar release];
    [self.userid release];
    [self.userName release];
    [self.orderID release];
    [backClick release];
    [self.keyboardToolbar release];
    [self.dic release];
    [super dealloc];
}

#pragma mark ImageDowload

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = @"Icon.png";
        }
        if (task.groupType == 1) {
            FoodInOrderModelFix *model1;
            if (task.index >= 0 && task.index < [foods count]) {
                model1 = (FoodInOrderModelFix *)[foods objectAtIndex:task.index];
                
                model1.picPath = task.locURL;
                
                [model1 setImg:model1.picPath  Default:@"暂无图片"];
            }
        }
        
        
    }
    
}

-(void)updataUI:(int)type{
    
    
}


#pragma mark UIToolBar
- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 9) {
        tag -= 9;
    }
    rect.origin.y = -44.0f * tag;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect.origin.y += 64;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == startTag ? NO : YES];
    [nextBarItem setEnabled:tag == LineCount ? NO : YES];
}


- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if (sender != nil && [firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == startTag ? startTag : tag - 1;
        [firstResponder resignFirstResponder];
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        //[firstResponder resignFirstResponder];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
    }
}

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if (sender != nil && [firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == LineCount ? LineCount : tag + 1;
        [firstResponder resignFirstResponder];
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = startTag;
    while (index <= LineCount) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        NSTimeInterval animationDuration = 0.30f;
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            //rect.size.height -= 64;
            self.view.frame = rect;
        }else{
            self.view.frame = rect;
        }
        
        //[self resetLabelsColors];
    }
    [self animateView:0];
}



//选择地址的UITextField 点击不弹出键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self checkBarButton:textField.tag];
    [self animateView:textField.tag];
    if( textField.tag == 86 )
    {
        [self animateTextField:textField up:YES];
    }
}

-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 100;
    const float movementDuration = 0.3f;
    
    int movement = (up?-movementDistance:movementDistance);
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if( textField.tag == 86 )
    {
        [self animateTextField:textField up:NO];
    }
    
    return YES;
}

@end
