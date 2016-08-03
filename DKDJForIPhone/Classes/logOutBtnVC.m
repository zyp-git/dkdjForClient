//
//  logOutBtnVC.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/8.
//
//

#import "logOutBtnVC.h"

@interface logOutBtnVC ()

@end

@implementation logOutBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    

    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    [btn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor=[UIColor whiteColor];
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [btn setTitleColor:app.sysTitleColor forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}
-(void)logOutBtnClick{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"userid"];
    [defaults setObject:@"" forKey:@"username"];
    
    [defaults synchronize];
    [self goBack];
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
