//
//  ChangePasswordViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "LoginNewViewController.h"
#import "UserAddressDetailViewController.h"
#import "HJLabel.h"
#import "registerVC.h"
#import "FindPasswordiewController.h"
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"

@implementation LoginNewViewController{
    UIButton * SMSLoginStyleBtn;
    UIButton * passwordLoginStyleBtn;
    UIColor * btnColor;
    NSMutableArray <UIView *>* viewArr;

}


- (id)initUserInfo:(BOOL)isPay
{
    
    isPayPassword = isPay;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isRegSuccess) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout =UIRectEdgeNone;
    
    viewArr=[NSMutableArray array];
    UIColor * color = [UIColor lightGrayColor];

    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor grayColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goToRegister)];
    rightBtn.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    btnColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    
    self.title =@"登录";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];
    self.userName = [defaults objectForKey:@"username"];
    
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 0.6)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    
    
    SMSLoginStyleBtn=[[UIButton alloc]initWithFrame:RectMake_LFL(0,0.6 , 375/2, 40)];
    [SMSLoginStyleBtn setBackgroundColor:btnColor];
    [SMSLoginStyleBtn addTarget:self action:@selector(loginStyleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [SMSLoginStyleBtn setTitle:@"短信快捷登陆" forState:UIControlStateNormal];
    [SMSLoginStyleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [SMSLoginStyleBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:SMSLoginStyleBtn];
    
    passwordLoginStyleBtn=[[UIButton alloc]initWithFrame:RectMake_LFL(375/2, 0.6 , 375/2, 40)];
    [passwordLoginStyleBtn setBackgroundColor:[UIColor whiteColor]];
    [passwordLoginStyleBtn addTarget:self action:@selector(loginStyleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [passwordLoginStyleBtn setTitle:@"账号密码登陆" forState:UIControlStateNormal];
    [passwordLoginStyleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:passwordLoginStyleBtn];
    [passwordLoginStyleBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];

    [passwordLoginStyleBtn setSelected:YES];
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(375/2, 0, 0.5, 40)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
/***************************************************************************/
    UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, 41, 375, 600)];
    view.backgroundColor=[UIColor clearColor];
    [viewArr addObject:view];
    
    UIView * whiteBackView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 120+8)];
    whiteBackView.backgroundColor=[UIColor whiteColor];
    [view addSubview:whiteBackView];
    
    CGFloat height=8.5;
    tfPhoneR = [[UITextField alloc] initWithFrame:RectMake_LFL(40, height, 200, 40)];
    tfPhoneR.tag = 1;
    tfPhoneR.placeholder = @"请输入手机号";
    [tfPhoneR setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfPhoneR.font = [UIFont systemFontOfSize:16];
    [view addSubview:tfPhoneR];
    
    
    UIImageView * phoneIcon =[[UIImageView alloc] initWithFrame:RectMake_LFL(5, height+5, 30,30)];
    phoneIcon.image = [UIImage imageNamed:@"shouji"];
    [view addSubview:phoneIcon];
    
    btnSendSMS = [[UIButton alloc] initWithFrame:RectMake_LFL(375-90, height+5, 80, 30)];
    btnSendSMS.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSendSMS setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]];
    [btnSendSMS setTitle:@"获取验证码"forState:UIControlStateNormal];
    [btnSendSMS addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSendSMS];
    height += 40;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height+0.5, 355, 0.5)];
    line.backgroundColor=btnColor;
    [view addSubview:line];
    height+=1;
    
    tfSMSCode = [[UITextField alloc] initWithFrame:RectMake_LFL(40, height, 200, 40)];
    tfSMSCode.placeholder =@"请输入短信验证码";
    [tfSMSCode setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfSMSCode.font = [UIFont systemFontOfSize:16];
    [view addSubview:tfSMSCode];
    
    
    UIImageView * passWordImg =[[UIImageView alloc]initWithFrame:RectMake_LFL(5, height+5, 30,30)];
    passWordImg.image = [UIImage imageNamed:@"yanzhengma"];
    [view addSubview:passWordImg];
    
    
    height+=40;
    
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 355, 0.5)];
    line.backgroundColor=btnColor;
    [view addSubview:line];
    height+=1;
    
    UILabel *lable=[[UILabel alloc]initWithFrame:RectMake_LFL(0, height, 375, 40)];
    lable.text=@"未注册的手机号将自动创建为大可到家的用户";
    lable.textColor=[UIColor lightGrayColor];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.font=[UIFont systemFontOfSize:16];
    [view addSubview:lable];
    
    height+=40;
    height += 8;
    
    UIButton *loginBtns = [[UIButton alloc] initWithFrame:RectMake_LFL(20, height, 335, 35)];
    loginBtns.backgroundColor = app.sysTitleColor;
    [loginBtns setTitle:CustomLocalizedString(@"login_label_signin", @"登录") forState:UIControlStateNormal];
    [loginBtns setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtns addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtns.tag=100;
    [view addSubview:loginBtns];
    
/***************************************************************************/
    view=[[UIView alloc]initWithFrame:RectMake_LFL(0, 41, 375, 600)];
    view.backgroundColor=[UIColor clearColor];
    [viewArr addObject:view];
    
    whiteBackView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 80+8)];
    whiteBackView.backgroundColor=[UIColor whiteColor];
    [view addSubview:whiteBackView];
    
    height=8.5;
    tfPhone = [[UITextField alloc] initWithFrame:RectMake_LFL(40, height, 200, 40)];
    tfPhone.tag = 1;
    tfPhone.delegate = self;
    tfPhone.textColor=[UIColor lightGrayColor];
    tfPhone.placeholder = @"请输入手机号";
    [tfPhone setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfPhone.font = [UIFont systemFontOfSize:16];
    [view addSubview:tfPhone];
    
    
    phoneIcon = [[UIImageView alloc] initWithFrame:RectMake_LFL(5, height+5, 30,30)];
    phoneIcon.image = [UIImage imageNamed:@"zhanghao"];
    [view addSubview:phoneIcon];
    
    height += 40;

    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height+0.5, 355, 0.5)];
    line.backgroundColor=btnColor;
    [view addSubview:line];
    
    height+=1;
    
    tfPassword = [[UITextField alloc] initWithFrame:RectMake_LFL(40, height, 200, 40)];
    [tfPassword setSecureTextEntry:YES];
    tfPassword.placeholder =@"请输入登录密码";
    [tfPassword setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfPassword.textColor=[UIColor lightGrayColor];
    tfPassword.font = [UIFont systemFontOfSize:16];
    [view addSubview:tfPassword];
    

    passWordImg = [[UIImageView alloc] initWithFrame:RectMake_LFL(5, height+5, 30,30)];
    passWordImg.image = [UIImage imageNamed:@"mima"];
    [view addSubview:passWordImg];
    
    height += 40;
    line=[[UIView alloc]initWithFrame:RectMake_LFL(10, height, 355, 0.5)];
    line.backgroundColor=btnColor;
    [view addSubview:line];
    

    height += 8;
    
    UIButton * loginBtn = [[UIButton alloc] initWithFrame:RectMake_LFL(20, height, 335, 35)];
    loginBtn.backgroundColor = app.sysTitleColor;
    [loginBtn setTitle:CustomLocalizedString(@"login_label_signin", @"登录") forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag=100;
    [view addSubview:loginBtn];
    height += 35;
    
    UIButton * FindPasswordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    FindPasswordBtn.frame=RectMake_LFL(375-90, height+5, 70, 20);
    [FindPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [FindPasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [FindPasswordBtn addTarget:self action:@selector(goFindPassword) forControlEvents:UIControlEventTouchUpInside];
    [FindPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:FindPasswordBtn];
    
/***************************************************************************/
    timer =[[NSTimer alloc]init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [timer fire];
    [self loginStyleBtnClick:SMSLoginStyleBtn];

}
-(void)loginStyleBtnClick:(UIButton *)btn{
    
    if ([btn isSelected]) {
        return;
    }
    if (![SMSLoginStyleBtn isSelected]) {
        SMSLoginStyleBtn.backgroundColor=[UIColor whiteColor];
        passwordLoginStyleBtn.backgroundColor=btnColor;
        
        [self.view addSubview:viewArr[0]];
        [viewArr[1] removeFromSuperview];
    }else{
        SMSLoginStyleBtn.backgroundColor=btnColor;
        passwordLoginStyleBtn.backgroundColor=[UIColor whiteColor];
        
        [self.view addSubview:viewArr[1]];
        [viewArr[0] removeFromSuperview];
    }
    [SMSLoginStyleBtn setSelected:![SMSLoginStyleBtn isSelected]];
    [passwordLoginStyleBtn setSelected:![passwordLoginStyleBtn isSelected]];
   
    
}
-(void)goToRegister{
    registerVC * VC=[[registerVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
//    [self.navigationController presentViewController:VC animated:YES completion:nil];
}
-(void)goFindPassword{
    FindPasswordiewController *LoginNewViewController = [[FindPasswordiewController alloc] init];
    [self.navigationController pushViewController:LoginNewViewController animated:YES];
}
-(void) timerFired:(id)senser
{
    if (isGetCode) {
        nTimer--;
        [btnSendSMS setTitle:[NSString stringWithFormat:@"%d s", nTimer] forState:UIControlStateNormal];
        
        if (nTimer == 0) {
            [btnSendSMS setTitle:CustomLocalizedString(@"regedit_phone_code_send", @" 获取验证码") forState:UIControlStateNormal];
            
            isGetCode = NO;
        }
    }
}

-(void)sendSMS:(UIButton *)btn{
    if (nTimer > 0) {
        return;
    }
    
    self.phone = tfPhoneR.text;
    if (self.phone.length < 11 || ! [app checkMobilePhone:self.phone]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_phone_code_send_failed", @"发送验证码失败") message:CustomLocalizedString(@"regedit_phone_error", @"请重新填写正确的手机号码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString *url = APP_PATH  @"sendcode.aspx";
    url = [NSString stringWithFormat:@"%@?tel=%@&type=2", url, self.phone];
    [MHNetworkManager postReqeustWithURL:url params:nil successBlock:^(NSDictionary *returnData) {
        NSDictionary* dic = (NSDictionary*)returnData;
        
        self.SMSCode = [dic objectForKey:@"pwd"];
        nTimer = 60;
        isGetCode = YES;

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:YES];

}
-(void)login{
    
    if (![self.SMSCode isEqualToString:tfSMSCode.text]) {
        UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"提示" message:@"验证码有误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * aa1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        [ac addAction:aa1];
        
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    self.userName = tfPhone.text;
    NSString *url = APP_PATH  @"sendcode.aspx";
    url = [NSString stringWithFormat:@"%@?tel=%@&type=3", url, self.phone];
    [MHNetworkManager postReqeustWithURL:url params:nil successBlock:^(NSDictionary *returnData) {
        NSDictionary* dic = (NSDictionary*)returnData;

        self.userid = [dic objectForKey:@"userid"];
        
        //设置
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.userid forKey:@"userid"];
        [defaults setObject:self.userName forKey:@"username"];
        [defaults synchronize];
        
        if(self.userid.length >1){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"login_failed", @"登录失败") message:CustomLocalizedString(@"login_failed_notice", @"请输入正确的用户名和密码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
        }

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:YES];
    
}



-(void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loginBtnClick:(UIButton *)btn{
    
    self.userName = tfPhone.text;
    self.password = tfPassword.text;
    if (self.userName == nil || self.userName == nil || self.password.length < 1 || self.password.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"login_failed", @"登录失败") message:CustomLocalizedString(@"login_failed_notice", @"请输入正确的用户名和密码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(loginReceive:obj:)];
    
    [twitterClient doLoginByUserNameAndPassword:self.userName pw:self.password];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"login_status_logging_in", @"登录中...");
    [_progressHUD show:YES];
}

#pragma mark - 登陆
- (void)loginReceive:(TwitterClient*)client obj:(NSObject*)obj{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    if (obj == nil) {
        return;
    }
//    NSLog(@"%@",obj);
    NSDictionary* dic = (NSDictionary*)obj;
    self.userid = [dic objectForKey:@"userid"];
    int state = [[dic objectForKey:@"state"] intValue];
    
    if (_userid) {
        NSLog(@"userid: %@",_userid);
    }
    
    //设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userid forKey:@"userid"];
    [defaults setObject:self.userName forKey:@"username"];
    [defaults synchronize];
    
    if(state == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"login_failed", @"登录失败") message:CustomLocalizedString(@"login_failed_notice", @"请输入正确的用户名和密码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }

}


@end
