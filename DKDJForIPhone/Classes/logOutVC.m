//
//  logOutVC.m
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/8.
//
//

#import "logOutVC.h"

@interface logOutVC ()

@end

@implementation logOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.bounds.size.width, 49)];
    [btn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal ];
    btn.titleLabel.textColor=
    
}
-(void)logOutBtnClick{
    
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
