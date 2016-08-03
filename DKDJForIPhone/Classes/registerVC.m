//
//  registerVC.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/13.
//
//

#import "registerVC.h"
#import "loginNewViewController.h"
@interface registerVC ()

@end

@implementation registerVC
-(void)goBack{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(goTologin)];
    rightBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    CGFloat height=170;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];
    self.userName = [defaults objectForKey:@"username"];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"loginBackImg"];
    [self.view addSubview:imageView];
    
    
    tfPhone = [[UITextField alloc] initWithFrame:RectMake_LFL((375-250)/2+30, height, 200, 40)];
    tfPhone.tag = 1;
    tfPhone.delegate = self;
    tfPhone.textColor=[UIColor whiteColor];
    tfPhone.placeholder = CustomLocalizedString(@"login_name_notice", @"请输入注册时的手机号");
    [tfPhone setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfPhone.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tfPhone];
    
    UIImage * img=[UIImage imageNamed:@"手机"];
    UIImageView * phoneIcon = [[UIImageView alloc] initWithFrame:RectMake_LFL((375-250)/2+3, height+(40-img.size.height)/2, img.size.width, img.size.height)];
    phoneIcon.image = img;
    [self.view addSubview:phoneIcon];
    

    btnSendSMS = [[UIButton alloc] initWithFrame:RectMake_LFL(375-(375-250)/2-60, height+10, 60, 20)];
    btnSendSMS.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnSendSMS setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    btnSendSMS.titleLabel.textColor=[UIColor whiteColor];
    [btnSendSMS setTitle:@"获取验证码"forState:UIControlStateNormal];
    [btnSendSMS addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    [btnSendSMS setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self.view addSubview:btnSendSMS];
    
    height += 40;
    
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL((375-250)/2, height, 250, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line];
    
    height+=5;
    //注意开启验证码的时候，读取手机号码的地方为发送验证码按钮里面，可以防止获取到正确的验证码后在修改号码的问题
    tfSMSCode = [[UITextField alloc] initWithFrame:RectMake_LFL((375-250)/2+30, height, 200, 40)];
    tfSMSCode.delegate = self;
    tfSMSCode.inputAccessoryView = self.keyboardToolbar;
    tfSMSCode.font = [UIFont systemFontOfSize:14];
    tfSMSCode.placeholder = @"短信验证码";
    [tfSMSCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfSMSCode.textColor=[UIColor whiteColor];
    tfSMSCode.font = [UIFont systemFontOfSize:14];
    tfSMSCode.textColor=[UIColor whiteColor];
    [self.view addSubview:tfSMSCode];
    
    img=[UIImage imageNamed:@"注册验证码"];
    UIImageView * SMSCodeIV = [[UIImageView alloc] initWithFrame:RectMake_LFL((375-250)/2+3, height+(40-img.size.height)/2, img.size.width, img.size.height)];
    SMSCodeIV.image = img;
    [self.view addSubview:SMSCodeIV];
    
    height += 40;
    line=[[UIView alloc]initWithFrame:RectMake_LFL((375-250)/2, height, 250, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line];
    
    height += 5;
    
    tfPassword = [[UITextField alloc] initWithFrame:RectMake_LFL((375-250)/2+30, height, 200, 40)];
    tfPassword.delegate = self;
    tfPassword.inputAccessoryView = self.keyboardToolbar;
    [tfPassword setSecureTextEntry:YES];
    tfPassword.placeholder =@"请输入登录密码";
    [tfPassword setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfPassword.textColor=[UIColor whiteColor];
    tfPassword.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tfPassword];
    
    img=[UIImage imageNamed:@"密码"];
    UIImageView * passWordImg = [[UIImageView alloc] initWithFrame:RectMake_LFL((375-250)/2+3, height+(40-img.size.height)/2, img.size.width, img.size.height)];
    passWordImg.image = img;
    [self.view addSubview:passWordImg];
    
    height += 40;
    line=[[UIView alloc]initWithFrame:RectMake_LFL((375-250)/2, height, 250, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line];
    
    height+=5;
    
    tfPasswordR = [[UITextField alloc] initWithFrame:RectMake_LFL((375-250)/2+30, height, 200, 40)];
    tfPasswordR.delegate = self;
    tfPasswordR.inputAccessoryView = self.keyboardToolbar;
    [tfPasswordR setSecureTextEntry:YES];
    tfPasswordR.placeholder =@"请再次确认密码";
    [tfPasswordR setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    tfPasswordR.textColor=[UIColor whiteColor];
    tfPasswordR.font = [UIFont systemFontOfSize:14];
    tfPasswordR.textColor=[UIColor whiteColor];
    [self.view addSubview:tfPasswordR];
    img=[UIImage imageNamed:@"密码"];
    passWordImg = [[UIImageView alloc] initWithFrame:RectMake_LFL((375-250)/2+3, height+(40-img.size.height)/2, img.size.width, img.size.height)];
    passWordImg.image = img;
    [self.view addSubview:passWordImg];
    
    height += 40;
    line=[[UIView alloc]initWithFrame:RectMake_LFL((375-250)/2, height, 250, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line];
    
    height+=40;
    
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:RectMake_LFL((375-125)/2, height, 125, 40)];
    btnSave.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    [btnSave setTitle:@"注册" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)goTologin{
    LoginNewViewController * vc=[[LoginNewViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) timerFired:(id)senser{
    if (isGetCode) {
        nTimer--;
        [btnSendSMS setTitle:[NSString stringWithFormat:@"%d s", nTimer] forState:UIControlStateNormal];
        if (nTimer == 0) {
            [btnSendSMS setTitle:CustomLocalizedString(@"regedit_phone_code_send", @"获取验证码") forState:UIControlStateNormal];
            
            [btnSendSMS setBackgroundImage:backgroundImage forState:UIControlStateNormal];
            
            isGetCode = NO;
        }
    }
}
-(void)sendSMS:(UIButton *)btn{
    if (nTimer > 0) {
        return;
    }
    self.phone = tfPhone.text;
    if (self.phone.length < 11 || ! [app checkMobilePhone:self.phone]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_phone_code_send_failed", @"发送验证码失败") message:CustomLocalizedString(@"regedit_phone_error", @"请重新填写正确的手机号码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(SMSSendReceive:obj:)];
    
    [twitterClient sendSMSCode:self.phone];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
    [_progressHUD show:YES];
}
- (void)SMSSendReceive:(TwitterClient*)client obj:(NSObject*)obj{
    if (_progressHUD){
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
    
    NSDictionary* dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    if (state == 1) {
        self.SMSCode = [dic objectForKey:@"pwd"];
        int autoSMS = [[dic objectForKey:@"auto"] intValue];
        if (autoSMS == 0){
            tfSMSCode.text = self.SMSCode;
        }
        nTimer = 60;
        [btnSendSMS setBackgroundImage:nil forState:UIControlStateNormal];
        isGetCode = YES;
    }else if(state == -1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_phone_code_send_failed", @"发送验证码失败") message:CustomLocalizedString(@"regedit_have_phone", @"该手机号码已经注册，请更换手机号码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_phone_code_send_failed", @"发送验证码失败") message:CustomLocalizedString(@"public_net_or_data_error", @"网络或数据错误，请稍后再试！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
}

-(void)save:(id)sender
{
    
    NSString *code = tfSMSCode.text;//
    self.userName = tfUserName.text;
    self.password = tfPassword.text;//第一次密码
    self.email = tfEmail.text;
    self.phone=tfPhone.text;
    
    if(self.phone.length < 11){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_phone_error", @"请重新填写正确的手机号码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.phone compare:tfPhone.text] != NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_phone_change", @"中途你更换了手机号码！请稍后重新获取验证码！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (code.length < 1 || [code compare:self.SMSCode] != NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_smscode_error", @"请输入正确的短信验证码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(self.password.length < 6){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"rp_failed", @"请填写密码（至少6位）)") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    if ([self.password compare:tfPasswordR.text] != NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_password_two", @"两次输入的密码不一致，请重新设置密码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //NSString *_cityid = [[NSUserDefaults standardUserDefaults] stringForKey:@"CityId"];
    //联网进行注册
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(SaveReceive:obj:)];
    //NSString *sortPhone = @"";
    [twitterClient doRegedit:self.userName pw:self.password email:self.email phone:self.phone cityid:@"" rname:@""];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"regedit_notice", @"注册中...");
    [_progressHUD show:YES];
    
}
- (void)SaveReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    
    NSDictionary* dic = (NSDictionary*)obj;
    int state = [[dic objectForKey:@"state"] intValue];
    //设置
    if(state == 1){
        self.userid = [dic objectForKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userid forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"password"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_sucess_notice", @"注册成功") message:CustomLocalizedString(@"regedit_reg_sucess_notice", @"恭喜您注册成功，请稍后添加地址信息") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        alert.tag = 1;
        alert.delegate = self;
        [alert show];
        isRegSuccess = YES;
        [self goBack];
    }else{
        UIAlertView *alert;
        switch (state) {
            case -1:
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_reg_faild_notice", @"请重新注册") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                break;
            case -2:
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_have_user", @"用户名已经存在") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                break;
            case -3:
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_have_phone", @"手机号码已经存在") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                break;
            case -4:
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_have_email", @"邮箱已经存在") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                break;
            case -5:
            default:
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"regedit_reg_faild_notice", @"注册失败") message:CustomLocalizedString(@"regedit_no_rec", @"引荐人不存在") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                break;
                
        }
        
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
