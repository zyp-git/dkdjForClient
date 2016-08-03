//
//  PayByCardsViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-7.
//
//

#import "PayByCardsViewController.h"

#import "EasyEat4iPhoneAppDelegate.h"
#import "tooles.h"
#import "UIGlossyButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+LayerEffects.h"

@interface PayByCardsViewController ()

@end

@implementation PayByCardsViewController

@synthesize _userName;
@synthesize _password;
@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize asiRequest;

@synthesize code;
@synthesize cmoney;
@synthesize paypassword;

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT         8
#define FIELDS_COUNTFix      1
#define ORDER_FIELD_TAG      2

- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    if (self.keyboardToolbarfix == nil) {
        self.keyboardToolbarfix = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbarfix.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:CustomLocalizedString(@"确定", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboardfix:)];
        
        [self.keyboardToolbarfix setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        
        
        [spaceBarItem release];
        [doneBarItem release];
    }
    
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    UIScrollView *myscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 370.0f)];
	[myscroll setContentSize:CGSizeMake(320, 480)];//高度多一个像素实现可以滚动
    myscroll.canCancelContentTouches = YES;
    myscroll.delegate = self;
    
    UIView *zoomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myscroll.contentSize.width, myscroll.contentSize.height)];
    zoomView.backgroundColor = [UIColor clearColor];
    
    UILabel *cardLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 10.0, 120.0, 30.0)];
    cardLabel.textAlignment =  NSTextAlignmentCenter;
    cardLabel.text = @"礼品卡支付>>";
    cardLabel.textColor = [UIColor blackColor];
    cardLabel.backgroundColor = [UIColor clearColor];
    cardLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    [zoomView addSubview:cardLabel];
    [cardLabel release];
    /*
    GradientButton    *loginButton;
    loginButton = [[GradientButton buttonWithType:UIButtonTypeCustom] retain];
    loginButton.frame = CGRectMake(50.0f,50.0f,220.0f, 35.0f);
    [loginButton setTitle:@"选择礼品卡" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(gotoCard:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 9001;
    [loginButton useGreenConfirmStyle];
    [zoomView addSubview:loginButton];
    [loginButton release];
     */
    
    // navigation bar button
	UIGlossyButton *gotoCardBtn = [[UIGlossyButton buttonWithType:UIButtonTypeCustom]retain];
	[gotoCardBtn setNavigationButtonWithColor:[UIColor navigationBarButtonColor]];
    gotoCardBtn.frame = CGRectMake(50.0f,50.0f,220.0f, 35.0f);
    [gotoCardBtn setTitle:@"选择礼品卡" forState:UIControlStateNormal];
    [gotoCardBtn addTarget:self action:@selector(gotoCard:) forControlEvents:UIControlEventTouchUpInside];
    gotoCardBtn.tag = 9001;
    [zoomView addSubview:gotoCardBtn];
    [gotoCardBtn release];
    
    //店铺券
    //团购秒杀不能使用店铺券
    NSString *ordertype = [[NSUserDefaults standardUserDefaults] stringForKey:@"ordertype"];
    
    UILabel *shopcardLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 95.0, 120.0, 30.0)];
    shopcardLabel.textAlignment =  NSTextAlignmentCenter;
    shopcardLabel.text = @"店铺券支付>>";
    shopcardLabel.textColor = [UIColor blackColor];
    shopcardLabel.backgroundColor = [UIColor clearColor];
    shopcardLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    if( ![ordertype isEqualToString:@"0"])
    {
        [shopcardLabel setHidden:YES];
    }
    [zoomView addSubview:shopcardLabel];
    [shopcardLabel release];
    
    /*
    GradientButton    *shopcardloginButton;
    shopcardloginButton = [[GradientButton buttonWithType:UIButtonTypeCustom] retain];
    shopcardloginButton.frame = CGRectMake(50.0f,130.0f,220.0f, 35.0f);
    [shopcardloginButton setTitle:@"选择店铺券" forState:UIControlStateNormal];
    [shopcardloginButton addTarget:self action:@selector(gotoShopcard:) forControlEvents:UIControlEventTouchUpInside];
    shopcardloginButton.tag = 9101;
    [shopcardloginButton useGreenConfirmStyle];
    [zoomView addSubview:shopcardloginButton];
    [shopcardloginButton release];
    */
    UIGlossyButton *gotoShopCardBtn = [[UIGlossyButton buttonWithType:UIButtonTypeCustom]retain];
	[gotoShopCardBtn setNavigationButtonWithColor:[UIColor doneButtonColor]];
    gotoShopCardBtn.frame = CGRectMake(50.0f,130.0f,220.0f, 35.0f);
    [gotoShopCardBtn setTitle:@"选择店铺券" forState:UIControlStateNormal];
    [gotoShopCardBtn addTarget:self action:@selector(gotoShopcard:) forControlEvents:UIControlEventTouchUpInside];
    gotoShopCardBtn.tag = 9101;
    if( ![ordertype isEqualToString:@"0"])
    {
        [gotoShopCardBtn setHidden:YES];
    }
    
    [zoomView addSubview:gotoShopCardBtn];
    [gotoShopCardBtn release];
    

    
    if( ![ordertype isEqualToString:@"0"])
    {
        
    }
    
    UILabel *paypasswordLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10,180.0, 80.0, 30.0)];
    paypasswordLabel.textAlignment =  NSTextAlignmentCenter;
    paypasswordLabel.text = @"支付密码:";
    paypasswordLabel.textColor = [UIColor blackColor];
    paypasswordLabel.backgroundColor = [UIColor clearColor];
    paypasswordLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    paypasswordLabel.tag = 9005;
    //[paypasswordLabel setHidden:YES];
    
    [zoomView addSubview:paypasswordLabel];
    [paypasswordLabel release];
    
    UITextField* passwordtext = [[UITextField alloc] initWithFrame:CGRectMake(100, 180, 120, 30)];
    passwordtext.keyboardType = UIKeyboardTypeNumberPad;
    [passwordtext setTextColor:[UIColor blackColor]];
    passwordtext.inputAccessoryView = self.keyboardToolbarfix;
    passwordtext.borderStyle = UITextBorderStyleRoundedRect;
    passwordtext.autocorrectionType = UITextAutocorrectionTypeYes;
    passwordtext.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    passwordtext.textAlignment =  NSTextAlignmentCenter;
    passwordtext.tag = 9004;
    //[passwordtext setHidden:YES];
    [passwordtext setSecureTextEntry:YES];
    [zoomView addSubview:passwordtext];
    [passwordtext release];
    
    //确定支付
    GradientButton    *backButton;
    backButton = [[GradientButton buttonWithType:UIButtonTypeCustom] retain];
    backButton.frame = CGRectMake(50.0f,230.0f,220.0f, 35.0f);
    [backButton setTitle:@"确定支付" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backtoaddorder:) forControlEvents:UIControlEventTouchUpInside];
    [backButton useGreenConfirmStyle];
    backButton.tag = 9102;
    //[backButton setHidden:YES];//隐藏
    [zoomView addSubview:backButton];
    [backButton release];
    
    
    [myscroll addSubview:zoomView];
    [self.view addSubview:myscroll];
    
    //默认值为YES，设置为NO不能滚动
    myscroll.scrollEnabled = YES;
    myscroll.directionalLockEnabled = YES;
    myscroll.pagingEnabled = NO;
    myscroll.showsHorizontalScrollIndicator = YES;
    myscroll.bounces = YES;
    
    self.cardid = @"0";
    self.shopcardid = @"0";
    
}

-(void)viewDidUnload
{
    //self.loginButton = nil;
    //self.registerButton = nil;
    
}

-(void)gotoCard:(id)sender
{
    PayByCardViewController *viewController = [PayByCardViewController alloc];
    
    viewController.title =@"选择礼品卡";
    viewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)gotoShopcard:(id)sender
{
    PayByShopCardViewController *viewController = [PayByShopCardViewController alloc];
    
    viewController.title =@"选择店铺券";
    viewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}


-(void)backtoaddorder:(id)sender{
    //消失并回调
    UITextField* passwordtext = (UITextField *)[self.view viewWithTag:9004];
    paypassword = passwordtext.text;
    
    NSLog(@"cardid:%@---shopcardid:%@",self.cardid,self.shopcardid);
    
    if([self.cardid isEqualToString:@"0"] && [self.shopcardid isEqualToString:@"0"])
    {
        [tooles MsgBox:@"请至少选择一种进行支付"];
        return;
    }
    
    if(paypassword.length < 2)
    {
        [tooles MsgBox:@"请输入支付密码"];
        return;
    }
    
    [self.delegate PayByCardsViewControllerValueChanged:self.paypassword shopcardids:self.shopcardid cardids:self.cardid ];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)SelectCardViewControllerChanged:(NSString *)usedcardid
{
    self.cardid = usedcardid;
    
    NSLog(@"cardid:%@,%@",self.cardid,usedcardid);
}

- (void)SelectShopCardViewControllerChanged:(NSString *)usedshopcardid
{
    self.shopcardid = usedshopcardid;
    
    NSLog(@"shopcardid:%@,%@",self.shopcardid,usedshopcardid);
}

// 这里按钮按下的时候退出 ModalViewController
-(void)dismiss:(id)inSender {
    //  如果是被 presentModalViewController 以外的实例调用，parentViewController 将是nil，下面的调用无效
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)resignKeyboardfix:(id)sender
{
    id firstResponder = [self getFirstResponderfix];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        //[self resetLabelsColors];
    }
}

- (id)getFirstResponderfix
{
    NSUInteger index = 0;
    while (index <= 9900) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
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
    
    if (tag > 4) {
        //rect.origin.y = -44.0f * (tag - 4);
        rect.origin.y = -44.0f * 1;
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
    //UITextField *textview4 = (UITextField *)[self.orderTableView viewWithTag:4];
    
    //if (tag == ORDER_FIELD_TAG && [textview4.text isEqualToString:@""]) {
    //    [self setOrderTime];
    //}
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

#pragma mark - Your actions
- (void)dealloc {
    RELEASE_SAFELY(keyboardToolbar_);
    [code release];
    [cmoney release];
    [paypassword release];
    
    [super dealloc];
}

@end
