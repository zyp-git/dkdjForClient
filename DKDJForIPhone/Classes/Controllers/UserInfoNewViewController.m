//
//  ChangePasswordViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-2.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "UserInfoNewViewController.h"
#import "LoginNewViewController.h"
#import "MHUploadParam.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"

@implementation UserInfoNewViewController{
    NSMutableArray <UILabel*>* LabelArr;
    NSMutableArray <UITextField*>* textFieldArr;
}




- (id)initUserInfo:(BOOL)isPay
{
    
    isPayPassword = isPay;
    return self;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSArray *)textArr{
    if (_textArr==nil) {
        _textArr=[NSArray arrayWithObjects:@"昵称:",@"电话:",@"邮箱:",@"QQ:", nil];
    }
    return _textArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    LineCount = 4;
    startTag = 1;
    
    LabelArr=[NSMutableArray array];
    textFieldArr=[NSMutableArray array];
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.title = CustomLocalizedString(@"user_title", @"账号管理");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userid = [defaults objectForKey:@"userid"];
    self.userName = [defaults objectForKey:@"username"];
    
    self.edgesForExtendedLayout =UIRectEdgeNone;
    


    for (int i=0; i<4; i++) {
        UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, 10+i*50, 375, 40)];
        [self.view addSubview:view];
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 60, 40)];
        label.font=[UIFont systemFontOfSize:17];
        label.text=self.textArr[i];
        label.tag=0;
        [view addSubview:label];
        [LabelArr addObject:label];
        
        UITextField * textField=[[UITextField alloc]initWithFrame:RectMake_LFL(65, 0, 375-80, 40)];
        textField.tag=i;
        [view addSubview:textField];
        [textFieldArr addObject:textField];
    }
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:RectMake_LFL(175/2,350, 200, 30)];
    btnSave.backgroundColor = app.sysTitleColor;
    [btnSave setTitle:CustomLocalizedString(@"user_save", @"保存") forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSave];
    
    self.userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    [self AreLogin];
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
    
    NSString * url = APP_PATH  @"saveuserinfo.aspx";
    
    NSArray * arr=@[@"truename",@"phone",@"email",@"qq"];
    
    NSMutableDictionary * param=[NSMutableDictionary dictionaryWithObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"userid"] forKey:@"userid"];
    
    for (UITextField * textField in textFieldArr) {
        if (textField.text.length>0) {
            [param setValue:textField.text forKey:arr[textField.tag]];
        }else{
            [param setValue:textField.placeholder.length>0 ? textField.placeholder:@"" forKey:arr[textField.tag]];
        }
    }
    
    [MHNetworkManager postReqeustWithURL:url params:param successBlock:^(NSDictionary *returnData) {
        [self SaveReceive:returnData];
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
    
}

- (void)SaveReceive:(NSDictionary *)tdic{
   
    NSString *uid = [tdic objectForKey:@"userid"];
    NSString *state = [tdic objectForKey:@"state"];
    
    if (uid) {
        NSLog(@"userid: %@",self.userid);
        NSLog(@"state: %@",state);
    }
    
    if([uid intValue] > 0 && [state compare:@"1" ] == NSOrderedSame)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"user_edit_sucess", @"更新成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"user_edit_failed", @"更新失败，请稍后再试") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}



-(void)viewDidUnload
{
    [super viewDidUnload];
}
#pragma mark GetUserInfo
- (void)AreLogin{
    NSString *url = APP_PATH  @"getuserinfo.aspx";
    [MHNetworkManager postReqeustWithURL:url params:@{@"userid":self.userid} successBlock:^(NSDictionary *returnData) {
        NSDictionary *dict = returnData;
        NSArray * arr=[NSArray arrayWithObjects:[dict objectForKey:@"truename"],[dict objectForKey:@"phone"],[dict objectForKey:@"email"],[dict objectForKey:@"qq"], nil];
        int i=0;
        for (NSString * str in arr) {
            textFieldArr[i].placeholder=str;
            i++;
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];

}

@end
