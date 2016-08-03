//
//  BindCardViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-6.
//
//

#import "BindCardViewController.h"
#import "EasyEat4iPhoneAppDelegate.h"
#import "tooles.h"

@interface BindCardViewController ()

@end

@implementation BindCardViewController

@synthesize _userName;
@synthesize _password;
@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize asiRequest;

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT         5
#define ORDER_FIELD_TAG      2

- (void)viewDidLoad {
    
    [super viewDidLoad];
    /*
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    */
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"绑定"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    // Keyboard toolbar
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
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    UIScrollView *myscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
	[myscroll setContentSize:CGSizeMake(320, 480)];//高度多一个像素实现可以滚动
    myscroll.canCancelContentTouches = YES;
    myscroll.delegate = self;
    
    UIView *zoomView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, myscroll.contentSize.width, myscroll.contentSize.height)];
    zoomView.backgroundColor = [UIColor clearColor];
    
    UILabel *otherLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 20.0, 40.0, 30.0)];
    otherLabel.textAlignment =  NSTextAlignmentCenter;
    otherLabel.text = @"密码:";
    otherLabel.textColor = [UIColor blackColor];
    otherLabel.backgroundColor = [UIColor clearColor];
    otherLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    [zoomView addSubview:otherLabel];
    [otherLabel release];
    
    UITextField* usernametext1 = [[UITextField alloc] initWithFrame:CGRectMake(55, 20, 50, 30)];
    usernametext1.tag = 1;
    usernametext1.keyboardType = UIKeyboardTypeNumberPad;
    [usernametext1 setTextColor:[UIColor blackColor]];
    usernametext1.inputAccessoryView = self.keyboardToolbar;
    usernametext1.borderStyle = UITextBorderStyleRoundedRect;
    usernametext1.autocorrectionType = UITextAutocorrectionTypeYes;
    usernametext1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    usernametext1.textAlignment =  NSTextAlignmentCenter;
    [zoomView addSubview:usernametext1];
    [usernametext1 release];
    
    UILabel *spLabel1 = [ [UILabel alloc ] initWithFrame:CGRectMake(110, 20.0, 10.0, 30.0)];
    spLabel1.textAlignment =  NSTextAlignmentCenter;
    spLabel1.text = @"-";
    spLabel1.textColor = [UIColor blackColor];
    spLabel1.backgroundColor = [UIColor clearColor];
    spLabel1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    [zoomView addSubview:spLabel1];
    [spLabel1 release];
    
    UITextField* usernametext2 = [[UITextField alloc] initWithFrame:CGRectMake(125, 20, 50, 30)];
    usernametext2.tag = 2;
    [usernametext2 setTextColor:[UIColor blackColor]];
    usernametext2.inputAccessoryView = self.keyboardToolbar;
    usernametext2.borderStyle = UITextBorderStyleRoundedRect;
    usernametext2.autocorrectionType = UITextAutocorrectionTypeYes;
    usernametext2.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    usernametext2.textAlignment =  NSTextAlignmentCenter;
    usernametext2.keyboardType = UIKeyboardTypeNumberPad;
    [zoomView addSubview:usernametext2];
    [usernametext2 release];
    
    UILabel *spLabel2 = [ [UILabel alloc ] initWithFrame:CGRectMake(180, 20.0, 10.0, 30.0)];
    spLabel2.textAlignment =  NSTextAlignmentCenter;
    spLabel2.text = @"-";
    spLabel2.textColor = [UIColor blackColor];
    spLabel2.backgroundColor = [UIColor clearColor];
    spLabel2.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    [zoomView addSubview:spLabel2];
    [spLabel2 release];
    
    UITextField* usernametext3 = [[UITextField alloc] initWithFrame:CGRectMake(195, 20, 50, 30)];
    usernametext3.tag = 3;
    [usernametext3 setTextColor:[UIColor blackColor]];
    usernametext3.inputAccessoryView = self.keyboardToolbar;
    usernametext3.borderStyle = UITextBorderStyleRoundedRect;
    usernametext3.autocorrectionType = UITextAutocorrectionTypeYes;
    usernametext3.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    usernametext3.textAlignment =  NSTextAlignmentCenter;
    usernametext3.keyboardType = UIKeyboardTypeNumberPad;
    [zoomView addSubview:usernametext3];
    [usernametext3 release];
    
    UILabel *spLabel3 = [ [UILabel alloc ] initWithFrame:CGRectMake(250, 20.0, 10.0, 30.0)];
    spLabel3.textAlignment =  NSTextAlignmentCenter;
    spLabel3.text = @"-";
    spLabel3.textColor = [UIColor blackColor];
    spLabel3.backgroundColor = [UIColor clearColor];
    spLabel3.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    [zoomView addSubview:spLabel3];
    [spLabel3 release];
    
    UITextField* usernametext4 = [[UITextField alloc] initWithFrame:CGRectMake(265, 20, 50, 30)];
    usernametext4.tag = 4;
    [usernametext4 setTextColor:[UIColor blackColor]];
    usernametext4.inputAccessoryView = self.keyboardToolbar;
    usernametext4.borderStyle = UITextBorderStyleRoundedRect;
    usernametext4.autocorrectionType = UITextAutocorrectionTypeYes;
    usernametext4.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
    usernametext4.textAlignment =  NSTextAlignmentCenter;
    usernametext4.keyboardType = UIKeyboardTypeNumberPad;
    [zoomView addSubview:usernametext4];
    [usernametext4 release];
    
    UILabel *otherLabel1 = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 60.0, 40.0, 30.0)];
    
    otherLabel1.textAlignment =  NSTextAlignmentCenter;
    otherLabel1.text = @"卡号:";
    otherLabel1.textColor = [UIColor blackColor];
    otherLabel1.backgroundColor = [UIColor clearColor];
    otherLabel1.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(14.0)];
    [zoomView addSubview:otherLabel1];
    [otherLabel1 release];
    
    UITextField* passwordtext = [[UITextField alloc] initWithFrame:CGRectMake(55, 60, 180, 30)];
    passwordtext.borderStyle = UITextBorderStyleRoundedRect;
    passwordtext.autocorrectionType = UITextAutocorrectionTypeYes;
    passwordtext.tag = 5;
    passwordtext.returnKeyType = UIReturnKeyDone;
    passwordtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordtext setTextColor:[UIColor blackColor]];
    passwordtext.inputAccessoryView = self.keyboardToolbar;
    //[passwordtext setSecureTextEntry:YES];
    [zoomView addSubview:passwordtext];
    [passwordtext release];
    
    GradientButton    *loginButton;
    loginButton = [[GradientButton buttonWithType:UIButtonTypeCustom] retain];
    loginButton.frame = CGRectMake(50.0f,110.0f,220.0f, 35.0f);
    [loginButton setTitle:@"绑定" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton useGreenConfirmStyle];
    [zoomView addSubview:loginButton];
    [loginButton release];
    
    [myscroll addSubview:zoomView];
    [self.view addSubview:myscroll];
    
    //默认值为YES，设置为NO不能滚动
    myscroll.scrollEnabled = YES;
    myscroll.directionalLockEnabled = YES;
    myscroll.pagingEnabled = NO;
    myscroll.showsHorizontalScrollIndicator = YES;
    myscroll.bounces = YES;
}

-(void)viewDidUnload
{
    //self.loginButton = nil;
    //self.registerButton = nil;
    
}

// 这里按钮按下的时候退出 ModalViewController
-(void)dismiss:(id)inSender {
    //  如果是被 presentModalViewController 以外的实例调用，parentViewController 将是nil，下面的调用无效
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    //返回主视图
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
        
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        
        [self checkSpecialFields:nextTag];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
    while (index <= FIELDS_COUNT) {
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
    
    if (tag > 5) {
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

- (void)save:(id)sender
{
    //获取输入得值
    UITextField *textview1 = (UITextField *)[self.view viewWithTag:1];
    UITextField *textview2 = (UITextField *)[self.view viewWithTag:2];
    UITextField *textview3 = (UITextField *)[self.view viewWithTag:3];
    UITextField *textview4 = (UITextField *)[self.view viewWithTag:4];
    
    UITextField *textview5 = (UITextField *)[self.view viewWithTag:5];
    
    self._userName = textview5.text;
    self._password = [[NSString alloc] initWithFormat:@"%@-%@-%@-%@", textview1.text,textview2.text,textview3.text,textview4.text];
    
    NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSURL *url;
    
    url = [NSURL URLWithString:GetBindCardURLString(uduserid,self._userName, self._password)];
    
    NSLog(@"url: %@",url);
    
    asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest setDelegate:self];
    [asiRequest setDidFinishSelector:@selector(GetResult:)];
    [asiRequest setDidFailSelector:@selector(GetErr:)];
    [asiRequest startAsynchronous];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
	_progressHUD.labelText = @"提交中...";
    [_progressHUD show:YES];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

#pragma mark - Your actions

-(void) GetErr:(ASIHTTPRequest *)request
{
    [tooles MsgBox:@"连接网络失败，请检查是否开启移动数据"];
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    NSData *data =[request responseData];
    NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
    
    if (data == nil)
    {
        return;
    }
    //{'code':'-1','msg':'卡号或者密码错误，请重新输入','cardnum':'0','point':'0','cmoney':'0','CID':'0'}
    
    NSString *code = [dic objectForKey:@"code"];
    
    if ([code isEqualToString:@"200"]) {
        NSString *msg = [[NSString alloc] initWithFormat:@"绑定成功:礼品卡面值:%@,剩余金额:%@",[dic objectForKey:@"point"],[dic objectForKey:@"cmoney"] ];
        [tooles MsgBox:msg];
    }
    else
    {
        NSString *msg = [dic objectForKey:@"msg"];
        [tooles MsgBox:msg];
    }
    
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userid forKey:@"userid"];
    [defaults synchronize];
    
    if([userid intValue] > 0 && state == 1)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请输入正确的用户名和密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    */
}

- (void)dealloc {
    RELEASE_SAFELY(keyboardToolbar_);
    
    [super dealloc];
}

@end
