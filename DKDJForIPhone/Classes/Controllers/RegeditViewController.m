//
//  RegeditViewController.m
//  EasyEat4iPhone
//
//  Created by zjf@ihangjing.com on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "RegeditViewController.h"
#import "EasyEat4iPhoneAppDelegate.h"
#import "tooles.h"
#import "AreaListViewController.h"

#define FIELDS_COUNT         6

@implementation RegeditViewController
  
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;
@synthesize _userName;
@synthesize _password;
@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize asiRequest;
@synthesize phone;
@synthesize servercode;

-(IBAction)cancel:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (IBAction)save:(id)sender
{
    [self resignKeyboard:nil];
    
    NSString* email;
    //NSString* phone;
    NSString* code;
    
    UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
    phone = textview4.text;//电话
    
    UITextField *textview3 = (UITextField *)[self.tableView viewWithTag:2];
    email = textview3.text;//电话
    //email = @"";//textview1.text;
    
    UITextField *textview1 = (UITextField *)[self.tableView viewWithTag:3];
    self._userName = textview1.text;
    
    UITextField *textview6 = (UITextField *)[self.tableView viewWithTag:5];
    self._password = textview6.text;//第一次密码
    
    //UITextField *textview3 = (UITextField *)[self.tableView viewWithTag:3];
    
    UITextField *textview7 = (UITextField *)[self.tableView viewWithTag:6];
    code = textview7.text;
    
    UITextField *textview8 = (UITextField *)[self.tableView viewWithTag:1];
    NSString *rPer = textview8.text;

    //验证码
    /*UITextField *textview5 = (UITextField *)[self.tableView viewWithTag:5];
    code = textview5.text;*/
    
    //UITextField *textview5 = (UITextField *)[self.tableView viewWithTag:5];
    //NSString *sortPhone = textview5.text;
    
    //判断是否为空
    //email = @"xxx@163.com";
    //self._userName  = @"xxx";
    //_password = @"xxxxxx";
    //phone  = @"12345678901";
    //NSLog(@"%@-%@",code,servercode);
    
    //NSString *codex = [[NSUserDefaults standardUserDefaults] stringForKey:@"servercode"];
    
    /*if(code.length < 4|| ![code isEqualToString:codex])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请填写正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }*/
    
   /* if(email.length < 2 ||![self validateEmail:email])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请填写正确的邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }*/
    
    if ([code compare:self._password] != NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"两次输入密码不一致！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if(phone.length < 11)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新填写正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if(self._userName.length < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请填写正确的用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if(_password.length < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请填写密码（至少6位）" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if(email.length < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请填写邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    /*if (_password == nil || textview3.text == nil || [_password compare:textview3.text] != NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"两次输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return;
    }*/
    
    
    

//    NSString *_cityid = [[NSUserDefaults standardUserDefaults] stringForKey:@"CityId"];
    //联网进行注册
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(RegeditReceive:obj:)];
    //NSString *sortPhone = @"";
    [twitterClient doRegedit:self._userName pw:_password email:email phone:phone cityid:app.Area.aID rname:rPer];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
	_progressHUD.labelText = @"注册中...";
    [_progressHUD show:YES];  
    
}

-(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [[tmpInvalidCharSet mutableCopy] autorelease];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /*
         *使用compare option 来设定比较规则，如
         *NSCaseInsensitiveSearch是不区分大小写
         *NSLiteralSearch 进行完全比较,区分大小写
         *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
         */
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
} 

- (void)RegeditReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    if (obj == nil) {
        return;
    }
    
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *userid = [dic objectForKey:@"userid"];
    int state = [[dic objectForKey:@"state"] intValue];
    
    if ([userid compare:@"0"] == NSOrderedSame) {
        NSLog(@"userid: %@",userid);
    }
    
    //设置
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:self._userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self._password forKey:@"password"];
    
    if([userid intValue] > 0 && state == 1)
    {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //貌似两种效果一样的
    }
    else
    {
        UIAlertView *alert;
        switch (state) {
            case -1:
                alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
            case -2:
                alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
            case -3:
                alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"手机号码已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
            case -4:
                alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"邮箱已经存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
            case -5:
                alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"引荐人不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
            default:
                alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                break;
        }
        
        [alert show];
        [alert release];
    }
}

-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
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
        
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
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
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
        
       /* NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y += 60;//view的X轴上移
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];//设置调整界面的动画效果*/
    }
}

-(void)selectArea:(id)senser{
    isShowArea = YES;
    AreaListViewController *viewController = [[[AreaListViewController alloc] initWithModelShow] autorelease];
    viewController.title = @"选择区域";
    [self presentModalViewController:viewController animated:true];
    
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [[NSArray alloc] initWithObjects:@"推荐会员:", @"电子邮箱:",@"会员名:", @"手机号码:",@"密码:",@"确认密码:",nil];
    self.fieldLabels = array;
    [array release];
    
    servercode = @"";
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    self.tempValues = dict;
    [dict release];
    //[super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
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
        nTimer = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [timer fire];
    }

}

-(void) timerFired:(id)senser
{
    if (isGetCode) {
        nTimer--;
        UILabel *label = (UILabel *)[self.tableView viewWithTag:RegeditViewLabelTag];
        label.text = [NSString stringWithFormat:@"%d秒后未收到验证码重试！", nTimer];
        if (nTimer == 0) {
            label.text = @"发送验证码";
            isGetCode = NO;
        }
    }
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
    [timer invalidate];
    [textFieldBeingEdited release];
    [tempValues release];
    [fieldLabels release];
    [servercode release];
    [phone release];
    [backClick release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0f;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    if(section == 0 )
    {
        return [self.fieldLabels count];
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PresidentCellIdentifier = @"RegeditCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleDefault;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    if( indexPath.section == 0)
    {
        //生成cell
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:style 
                                           reuseIdentifier:PresidentCellIdentifier] autorelease];
            UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(10, 10, 75, 25)];
            label.textAlignment = NSTextAlignmentRight;
            label.tag = RegeditViewLabelTag;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            
            UITextField *textField = [[UITextField alloc] initWithFrame:
                                      CGRectMake(90, 12, 200, 25)];
            textField.tag = indexPath.row + 1;
            textField.clearsOnBeginEditing = NO;
            [textField setDelegate:self];
            [textField addTarget:self 
                          action:@selector(textFieldDone:) 
                forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.contentView addSubview:textField];
        }
        
        //cell填充内容
        NSUInteger row = [indexPath row];
        
        UILabel *label = (UILabel *)[cell viewWithTag:RegeditViewLabelTag];
        UITextField *textField = (UITextField *)[cell viewWithTag:indexPath.row + 1];
        
        /*for (UIView *oneView in cell.contentView.subviews)
        {
            if ([oneView isMemberOfClass:[UITextField class]])
                textField = (UITextField *)oneView;
        }*/
        
        label.text = [fieldLabels objectAtIndex:row];
        
        if (textFieldBeingEdited == textField)
            textFieldBeingEdited = nil;
        
        textField.tag = row+1;
        textField.inputAccessoryView = self.keyboardToolbar;
        switch (indexPath.row) {
            case 0:
                textField.placeholder = @"推荐会员名，可不填";
                break;
            case 1:
                textField.placeholder = @"请输入邮箱";
                break;
            case 2:
                textField.placeholder = @"请输入会员名";
                
                break;
            case 3:
                textField.placeholder = @"请输入手机号码";
                textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 4:
                textField.placeholder = @"请输入登陆密码";
                [textField setSecureTextEntry:YES];
                break;
            case 5:
                textField.placeholder = @"请确认您的密码";
                [textField setSecureTextEntry:YES];
                break;
            case 6:
                textField.placeholder = @"请输入密码";
                
                break;
            default:
                break;
        }
        /*if(indexPath.row == 5)
        {
            
            
        }
        if (indexPath.row == 1) {
            [textField addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventEditingDidBegin];
            textField.text = app.Area.name;
        }
        if(indexPath.row == 3 || indexPath.row == 4)
        {
            
        }*/
        
        return cell;
        
    }
    else
    {
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:style 
                                           reuseIdentifier:PresidentCellIdentifier] autorelease];
            
            /*UILabel *label = [[UILabel alloc] initWithFrame:
                              CGRectMake(10, 10, 280, 25)];
            label.textAlignment = NSTextAlignmentCenter;//居中
            label.tag = RegeditViewLabelTag;
            label.font = [UIFont boldSystemFontOfSize:14];
            label.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:label];
            
            [label release];*/
            UIButton *label1 = [[UIButton alloc] initWithFrame:
                                CGRectMake(110, 3, 100, 40)];
            [label1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
            
            [label1 setTitle:@"注册" forState:UIControlStateNormal];

            [label1 setImage:[UIImage imageNamed:@"reg.png"] forState:UIControlStateNormal];
            //label1.backgroundColor=[UIColor colorWithRed:169/255.0 green:118/255.0 blue:15/255.0 alpha:1.0];
            [label1 addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:label1];
            
            [label1 release];
        }
        
        /*UILabel *label = (UILabel *)[cell viewWithTag:RegeditViewLabelTag];
        label.text = @"发送验证码";*/
        
        return cell;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 1) 
    {
        if(!isGetCode && indexPath.row == 0)
        {
            //[self dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];
            //发送验证码
            NSURL *url;
            
            UITextField *textview4 = (UITextField *)[self.tableView viewWithTag:4];
            phone = textview4.text;
            
            if(phone.length < 11)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"请重新填写正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                return;
            }
            
            isGetCode = YES;
            nTimer = 60;
            UILabel *label = (UILabel *)[aTableView viewWithTag:RegeditViewLabelTag];
            label.text = [NSString stringWithFormat:@"%d秒后未收到验证码重试！", nTimer];
            url = [NSURL URLWithString:GetCodeURLString(phone)];
            
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
            _progressHUD.labelText = @"发送中...";
            [_progressHUD show:YES];
        }
    }
    
}

#pragma mark - Your actions

-(void) GetErr:(ASIHTTPRequest *)request
{
    isGetCode = NO;
    UILabel *label = (UILabel *)[self.tableView viewWithTag:RegeditViewLabelTag];
    label.text = @"发送验证码";
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
    
    if([[dic objectForKey:@"state"] isEqualToString:@"1"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[dic objectForKey:@"pwd"] forKey:@"servercode"];
        [defaults synchronize];
        
        [tooles MsgBox:@"获取验证码成功，请输入手机接收到的短信验证码"];
        NSLog(@"%@", [dic objectForKey:@"pwd"]);
    }
    else
    {
        isGetCode = NO;
        UILabel *label = (UILabel *)[self.tableView viewWithTag:RegeditViewLabelTag];
        label.text = @"发送验证码";
        [tooles MsgBox:@"获取验证码失败，同一个手机号码只能注册一次"];
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

@end