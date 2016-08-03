//
//  UserInfoViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "UserInfoViewController.h"

@implementation UserInfoViewController
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

@synthesize userid;
@synthesize orderTableView;
@synthesize dic;

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSArray *array =
    
    self.fieldLabels = [[NSArray alloc] initWithObjects:@"    用户名:",@"邮箱地址:",@"真实姓名:", @"电话号码:", @"QQ号码:", nil];;
    
    //[array release];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"保存" 
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    self.orderTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    self.userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
}

- (id)initUserInfo
{
    //NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSLog(@"setting userid:%@", self.userid);
    
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 450) style:UITableViewStyleGrouped];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    [self.view addSubview:self.orderTableView];
    
    if ([self.userid intValue] > 0 )  
    {
        //获取数据
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(doReceive:obj:)];
        
        [twitterClient getUserInfoByUserId:self.userid];
        
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.dimBackground = YES;
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"加载中...";
        [_progressHUD show:YES];  
    }
    
    dis = 0;
    return self;
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
} 

////{"userid":"6023","username":"lq","truename":"","email":"liuqiang@fanshigang.com","qq":"","phone":""}
- (void)doReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    self.dic = (NSDictionary*)obj;
    
    NSString *tuserid = [self.dic objectForKey:@"userid"];
    
    if([tuserid intValue] > 0)
    {
        [self.orderTableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:@"取信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save:(id)sender
{
        
    NSString            *truename;
    NSString            *email;
    NSString            *uname;
    NSString            *phone;
    NSString            *qq;
//    NSString    *sortPhone;
    
    UITextField *textview = (UITextField *)[self.orderTableView viewWithTag:90];
    uname = textview.text;
    
    UITextField *textview1 = (UITextField *)[self.orderTableView viewWithTag:91];
    email = textview1.text;

    UITextField *textview2 = (UITextField *)[self.orderTableView viewWithTag:92];
    truename = textview2.text;
    
    UITextField *textview3 = (UITextField *)[self.orderTableView viewWithTag:93];
    phone = textview3.text;
    /*UITextField *textview5 = (UITextField *)[self.orderTableView viewWithTag:95];
    sortPhone = textview5.text;*/
    
    UITextField *textview4 = (UITextField *)[self.orderTableView viewWithTag:94];
    qq = textview4.text;
    if (qq == nil) {
        qq = @"";
    }
    if (truename == nil) {
        truename = @"";
    }
    
    NSString *tuserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:tuserid,@"userid",uname,@"username",truename,@"truename",email,@"email",phone,@"phone", qq,@"qq", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(SaveReceive:obj:)];
    
    [twitterClient SaveUserInfo:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"提交中...";
    [_progressHUD show:YES];
     
}

- (void)SaveReceive:(TwitterClient*)client obj:(NSObject*)obj
{
        twitterClient = nil;
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    NSDictionary* tdic = (NSDictionary*)obj;
    NSString *uid = [tdic objectForKey:@"userid"];
    NSString *state = [tdic objectForKey:@"state"];
    
    if (uid) {
        NSLog(@"userid: %@",userid);
        NSLog(@"state: %@",state);
    }
    
    if([uid intValue] > 0 && [state compare:@"1" ] == NSOrderedSame)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"更新资料成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"更新失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)textFieldDone:(id)sender {
    UITableViewCell *cell =
    (UITableViewCell *)[[sender superview] superview];
    
    //UITableView *table = (UITableView *)[cell superview];
    
    NSIndexPath *textFieldIndexPath = [self.orderTableView indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    
    if (row >= RegeditViewNumberOfEditableRows)
    {
        row = 0;
    }
    
    NSUInteger newIndex[] = {0, row};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex 
                                                         length:2];
    UITableViewCell *nextCell = [self.orderTableView 
                                 cellForRowAtIndexPath:newPath];
    UITextField *nextField = nil;
    for (UIView *oneView in nextCell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView;
    }
    [nextField becomeFirstResponder];
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
    [textFieldBeingEdited release];
    [tempValues release];
    [self.fieldLabels release];
    [orderTableView release];
    [userid release];
    
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 1; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0f;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [self.fieldLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PresidentCellIdentifier = @"RegeditCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleDefault;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    //生成cell
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:style 
                                       reuseIdentifier:PresidentCellIdentifier] autorelease];
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(10, 10, 75, 25)];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = RegeditViewLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:label];
        [label release];
        
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:
                                      CGRectMake(90, 12, 200, 25)];
            textField.clearsOnBeginEditing = NO;
            [textField setDelegate:self];
            [textField addTarget:self 
                          action:@selector(textFieldDone:) 
                forControlEvents:UIControlEventEditingDidEndOnExit];
            
            textField.textAlignment = NSTextAlignmentLeft;
            textField.font = [UIFont boldSystemFontOfSize:12];
            textField.textColor = [UIColor grayColor];
            textField.backgroundColor = [UIColor clearColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [cell.contentView addSubview:textField];
        }
    }
    
    //cell左侧填充内容
    
    UILabel *label = (UILabel *)[cell viewWithTag:RegeditViewLabelTag];
    
    label.text = [self.fieldLabels objectAtIndex:row];
    
    //cell右侧填充内容
    UITextField *textField = nil;
    
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
        {
            textField = (UITextField *)oneView;
        }
    }
    //@"    用户名:",@"邮箱地址:",@"真实姓名:", @"电话号码:",@"QQ号码:", nil];
    label.text = [self.fieldLabels objectAtIndex:row];
    
    NSString *username = [self.dic objectForKey:@"username"];
    NSString *truename = [self.dic objectForKey:@"truename"];
    NSString *email = [self.dic objectForKey:@"email"];
    NSString *qq = [self.dic objectForKey:@"qq"];
    NSString *phone = [self.dic objectForKey:@"phone"];
   // NSString *sortPhone = [self.dic objectForKey:@"shortphone"];
    
    switch (row) {
        case 0:
            textField.tag = 90;
            textField.returnKeyType = UIReturnKeyNext;
            textField.enabled = false;
            textField.text = username;
            break;
        case 1:
            textField.tag = 91;
            textField.returnKeyType = UIReturnKeyNext;
            textField.text = email;
            break;
        case 2:
            textField.placeholder = @"请输入真实姓名";
            textField.tag = 92;
            textField.returnKeyType = UIReturnKeyNext;
            textField.text = truename;
            
            break;
        case 3:
            textField.placeholder = @"请输入联系号码";
            textField.tag = 93;
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = phone;
            break;
        /*case 4:
            textField.placeholder = @"请输入您的校园短号";
            textField.tag = 95;
            textField.returnKeyType = UIReturnKeyNext;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = sortPhone;
            break;*/
        case 4:
            textField.placeholder = @"请输入QQ";
            textField.tag = 94;
            textField.returnKeyType = UIReturnKeyDone;
            textField.text = qq;
            break;
        default:
            break;
    }
    
    if (textFieldBeingEdited == textField)
    {
        textFieldBeingEdited = nil;
    }
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, -100, 320, 480) ];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, 320, 480)];
    return YES;
}
    
//选择地址的UITextField 点击不弹出键盘
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return YES;
//}

/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( textField.tag == 93 || textField.tag == 94 )
    {
        //[self animateTextField:textField up:YES];
    }
}

-(void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    //需要计算总共移动了多少，移回多少
    
    const int movementDistance = 80;
    const float movementDuration = 0.3f;

    int movement = (up?-movementDistance:movementDistance);
    
    if( textField.tag == 94 && dis > 0 && movement > 0 )
    {
        //无需移动 
        movement = 0;
    }
    
    if( textField.tag == 93 && dis > 0 )
    {
        movement = 0;
    }
    
    dis = dis + movement;
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if( textField.tag == 93 || textField.tag == 94 )
    {
        if( dis > 0 )
        {
            [self animateTextField:textField up:NO];
        }
    }
    
    return YES;
}
*/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
}

@end
