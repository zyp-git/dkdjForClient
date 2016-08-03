//
//  ChangePasswordViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ChangePasswordViewController.h"


@implementation ChangePasswordViewController


@synthesize userid;
@synthesize userName;
@synthesize keyboardToolbar;

- (id)initUserInfo:(BOOL)isPay{
    _isPayPassword = isPay;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    LineCount = 3;
    startTag = 1;
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    if (_isPayPassword) {
        self.title = CustomLocalizedString(@"rp_title", @"修改登录密码");
    }else{
        self.title = CustomLocalizedString(@"rp_title1", @"修改支付密码");
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];

    self.userName = [defaults objectForKey:@"username"];

    UILabel *lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, 75, 355, 20)];
    lb.font=[UIFont systemFontOfSize:22];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text =[NSString stringWithFormat:@"%@*****%@",[self.userName substringToIndex:3],[self.userName substringFromIndex:8]];
    lb.textColor = [UIColor blackColor];
    [self.view addSubview:lb];
    
    int height = 140;
    
    if(_isPayPassword){
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, height-50, 355, 40)];
        lb.textColor = [UIColor redColor];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.text = CustomLocalizedString(@"rp_no_pay_password_notice", @"未设置过支付密码，原密码请留空");
        [self.view addSubview:lb];
        height += 20;
    }
    
    UIView * view =[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 355, 40)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, 0, 70, 40)];
    lb.font = [UIFont systemFontOfSize:14];
    if(_isPayPassword){
        lb.text = CustomLocalizedString(@"rp_o", @"原支付密码");
    }else{
        lb.text = CustomLocalizedString(@"rp_o", @"原登录密码");
    }
    [view addSubview:lb];
   
    tfOPassword = [[UITextField alloc] initWithFrame:RectMake_LFL(70, 0, 200, 40)];
    tfOPassword.tag = 1;
    tfOPassword.inputAccessoryView = self.keyboardToolbar;
    tfOPassword.delegate = self;
    [tfOPassword setSecureTextEntry:YES];
    tfOPassword.font =[UIFont systemFontOfSize:14];
    if(_isPayPassword){
        tfOPassword.placeholder = CustomLocalizedString(@"rp_o_notice", @"请输入原来的支付密码");
    }else{
        tfOPassword.placeholder = CustomLocalizedString(@"rp_o_notice", @"请输入原来的登录密码");
    }
    
    [view addSubview:tfOPassword];
    height += 50;
    
    view =[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 355, 40)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, 0, 70, 40)];
    lb.font =[UIFont systemFontOfSize:14];
    if(_isPayPassword){
        lb.text = CustomLocalizedString(@"rp_n", @"新支付密码");
    }else{
        lb.text = CustomLocalizedString(@"rp_n", @"新登录密码");
    }
    [view addSubview:lb];
    
    tfNPassword = [[UITextField alloc] initWithFrame:RectMake_LFL(70, 0, 200, 40)];
    [tfNPassword setSecureTextEntry:YES];
    tfNPassword.tag = 2;
    tfNPassword.inputAccessoryView = self.keyboardToolbar;
    tfNPassword.delegate = self;
    tfNPassword.font = [UIFont systemFontOfSize:14];
    if(_isPayPassword){
        tfNPassword.placeholder = CustomLocalizedString(@"rp_n_notice", @"请输入新的支付密码");
    }else{
        tfNPassword.placeholder = CustomLocalizedString(@"rp_n_notice", @"请输入新的登录密码");
    }
    [view addSubview:tfNPassword];
    
    height += 50;
    
    view=  [[UIView alloc]initWithFrame:RectMake_LFL(10, height, 355, 40)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];

    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10, 0, 70, 40)];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = CustomLocalizedString(@"rp_n1", @"重    复");
    [view addSubview:lb];
    
    tfNPassword1 = [[UITextField alloc] initWithFrame:RectMake_LFL(70, 0, 200, 40)];
    [tfNPassword1 setSecureTextEntry:YES];
    tfNPassword1.tag = 3;
    tfNPassword1.font = [UIFont systemFontOfSize:14];
    tfNPassword1.delegate = self;
    tfNPassword1.inputAccessoryView = self.keyboardToolbar;
    tfNPassword1.placeholder = CustomLocalizedString(@"rp_n1_notice", @"请再输入新的密码");
    [view addSubview:tfNPassword1];
    
    height += 85;

    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:RectMake_LFL((375-250)/2, height, 250, 40)];
    btnSave.backgroundColor = [UIColor colorWithRed:0/255.0 green:216/255.0 blue:226/255.0 alpha:0.3];
    [btnSave setTitle:CustomLocalizedString(@"public_ok", @"修改") forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
    
    
    self.userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];
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
    
    //UITextField *textview = (UITextField *)[self.orderTableView viewWithTag:90];
    oldpassword = tfOPassword.text;
    if (!_isPayPassword && oldpassword.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"rp_failed", @"您输入的旧密码不符合规则，至少6位字符！请重新输入！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //UITextField *textview1 = (UITextField *)[self.orderTableView viewWithTag:91];
    newpassword = tfNPassword.text;
    
    // *textview2 = (UITextField *)[self.orderTableView viewWithTag:92];
    againpassword = tfNPassword1.text;
    if (newpassword.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"rp_failed", @"您输入的新密码不符合规则，至少6位字符！请重新输入！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([newpassword compare:againpassword] != NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"regedit_password_two", @"两次新密码输入的不一致！请重新输入！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }

    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userid,@"userid",oldpassword,@"oldpassword",newpassword,@"newpassword", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(SaveReceive:obj:)];
    
    [twitterClient ResetPassword:param isPay:_isPayPassword];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
    [_progressHUD show:YES];
    
}

- (void)SaveReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    twitterClient = nil;
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    
    NSDictionary* tdic = (NSDictionary*)obj;
    NSString *uid = [tdic objectForKey:@"userid"];
    NSString *state = [tdic objectForKey:@"state"];
    
    if (uid) {
        NSLog(@"userid: %@",self.userid);
        NSLog(@"state: %@",state);
    }
    
    if([uid intValue] > 0 && [state compare:@"1" ] == NSOrderedSame)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"rp_c_sucess", @"更新成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"rp_c_failed", @"更新失败，请稍后再试") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
}



-(void)viewDidUnload
{
    [super viewDidUnload];
}
@end
