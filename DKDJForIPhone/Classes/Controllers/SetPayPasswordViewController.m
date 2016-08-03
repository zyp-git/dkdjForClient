//
//  SetPayPasswordViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 13-3-13.
//
//

#import "SetPayPasswordViewController.h"


@implementation SetPayPasswordViewController

@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

@synthesize userid;
@synthesize orderTableView;
@synthesize dic;

- (id)initUserInfo
{
    self.orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 450) style:UITableViewStyleGrouped];
    self.orderTableView.delegate = self;
    self.orderTableView.dataSource = self;
    [self.view addSubview:self.orderTableView];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = [[NSArray alloc] initWithObjects:@"旧密码:",@"新密码:",@"新密码:", nil];
    
    self.fieldLabels = array;
    
    [array release];
    
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
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    self.orderTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    self.userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
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

-(void)save:(id)sender
{
    
    NSString            *oldpassword;
    NSString            *newpassword;
    NSString            *againpassword;
    
    UITextField *textview = (UITextField *)[self.orderTableView viewWithTag:90];
    oldpassword = textview.text;
    
    UITextField *textview1 = (UITextField *)[self.orderTableView viewWithTag:91];
    newpassword = textview1.text;
    
    UITextField *textview2 = (UITextField *)[self.orderTableView viewWithTag:92];
    againpassword = textview2.text;
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userid,@"userid",oldpassword,@"oldpassword",newpassword,@"newpassword", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(SaveReceive:obj:)];
    
    [twitterClient ResetPayPassword:param];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"更新成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if([uid intValue] > 0 && [state compare:@"-1" ] == NSOrderedSame)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"更新失败，原密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    if (_progressHUD){
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
    [fieldLabels release];
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
    return RegeditViewNumberOfEditableRows;
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
    
    label.text = [fieldLabels objectAtIndex:row];
    
    //cell右侧填充内容
    UITextField *textField = nil;
    
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
        {
            textField = (UITextField *)oneView;
        }
    }
    
    label.text = [fieldLabels objectAtIndex:row];
    
    switch (row) {
        case 0:
            textField.tag = 90;
            textField.returnKeyType = UIReturnKeyNext;
            textField.placeholder = @"如第一次设置则无需输入原密码";
            break;
        case 1:
            textField.tag = 91;
            textField.placeholder = @"请输入新密码";
            textField.returnKeyType = UIReturnKeyNext;
            break;
        case 2:
            textField.placeholder = @"请再次输入新密码";
            textField.tag = 92;
            textField.returnKeyType = UIReturnKeyGo;
            
            break;
        default:
            break;
    }
    
    [textField setSecureTextEntry:YES];
    
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

//选择地址的UITextField 点击不弹出键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
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