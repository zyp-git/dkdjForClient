//
//  UserAddressDetailViewController.m
//  TSYP
//
//  Created by wulin on 13-9-9.
//
//

#import "UserAddressDetailViewController.h"
#import "CityListViewController.h"
#import "ByAreaListViewController.h"
#import "SearchOnMapViewController.h"
#define NUMBERS @"0123456789"

@implementation UserAddressDetailViewController{
    NSMutableArray <UITextField *>* textFiledArr;
    UIImageView * maleImgView;
    UIImageView * femaleImgView;
    NSInteger currentSexy;
}



-(id)initWithEdit{
    _editType = 0;
    shopID = nil;
    return self;
}
-(id)initDefault{
    _editType = 1;
    shopID = nil;
    return self;
    
}

-(id)initWithShopID:(NSString *)sid{
    _editType = 1;
    shopID = sid;
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.title=@"管理地址";
    uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    array = [[NSArray alloc] initWithObjects:@"地址:",@"楼号:",@"姓名:",@"电话:", nil];
    NSArray * holderTextArr=[NSArray arrayWithObjects:app.useLocation.addressDetail?app.useLocation.addressDetail:@"",@"例:16号楼666室",@"收货人姓名",@"收货人电话", nil];
    textFiledArr=[NSMutableArray array];
    NSArray * arr=[_model.address componentsSeparatedByString:@"|"];
    NSArray * textArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@|%@",arr[0],arr[1]],arr[2],[_model.receiverName substringToIndex:_model.receiverName.length-3],_model.phone, nil];

    
    
//    NSLog(@"%@%@%@%@",_model.address,_model.buildingName?_model.buildingName:@"",_model.receiverName,_model.phone);

    for (int i=0 ; i<4; i++) {
        UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(0, 10+50*i, 375, 40)];
        [self.view addSubview:view];
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(10, 0, 70, 40)];
        label.text=array[i];
        label.font=[UIFont systemFontOfSize:16];
        [view addSubview:label];
        
        UITextField * textField=[[UITextField alloc]initWithFrame:RectMake_LFL(70, 0, 375-140, 40)];
        textField.placeholder=holderTextArr[i];
        textField.tag=i;
        [textFiledArr addObject:textField];
        textField.textColor=[UIColor grayColor];
        textField.font=[UIFont systemFontOfSize:14];
        [view addSubview:textField];
        if (self.model){
            textField.text=textArr[i];
        }
        
        if (i==0) {
            UIButton * btn=[[UIButton alloc]initWithFrame:RectMake_LFL(70, 0, 375-140, 40)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
            btn.titleLabel.font=[UIFont systemFontOfSize:11];
            [btn addTarget:self action:@selector(goToMap:) forControlEvents:UIControlEventTouchDown];
            [view addSubview:btn];
        }
        if (i==2) {//CheckMark
            femaleImgView=[[UIImageView alloc]initWithFrame:RectMake_LFL(375-70, 10, 20, 20)];
            femaleImgView.image=[UIImage imageNamed:@"CheckMark"];
            femaleImgView.tag=1;
            [view addSubview:femaleImgView];
            UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(375-45, 0, 40, 40)];
            label.text=@"女士";
            [view addSubview:label];
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=1;
            btn.frame=RectMake_LFL(375-70, 0, 70, 40);
            [btn addTarget:self action:@selector(changeSexy:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            maleImgView=[[UIImageView alloc]initWithFrame:RectMake_LFL(375-140, 10, 20, 20)];
            maleImgView.image=[UIImage imageNamed:@"CheckMark选择"];
            femaleImgView.tag=0;
            [view addSubview:maleImgView];
            label=[[UILabel alloc]initWithFrame:RectMake_LFL(375-115, 0, 40, 40)];
            label.text=@"先生";
            [view addSubview:label];
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=0;
            btn.frame=RectMake_LFL(375-140, 0, 70, 40);
            [btn addTarget:self action:@selector(changeSexy:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
    }
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:RectMake_LFL((375-150)/2, 200+10, 150, 30)];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    saveBtn.backgroundColor=[UIColor colorWithRed:0/255.0 green:216/255.0 blue:226/255.0 alpha:0.7];
    
    [saveBtn setTitle:@"确认地址" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:saveBtn];
    
    if (_editType!=1) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49-64, self.view.bounds.size.width, 49)];
        [btn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.backgroundColor=app.sysTitleColor;
        [btn setTitle:@"删除该地址" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
}
-(void)deleteBtnClick{
    [self editAddress:-1];
}
-(void)changeSexy:(UIButton *)btn{
    
    if (btn.tag!=currentSexy) {
        if (btn.tag==0) {
            maleImgView.image=[UIImage imageNamed:@"CheckMark选择"];
            femaleImgView.image=[UIImage imageNamed:@"CheckMark"];
        }else{
            maleImgView.image=[UIImage imageNamed:@"CheckMark"];
            femaleImgView.image=[UIImage imageNamed:@"CheckMark选择"];
        }
        currentSexy=btn.tag;
    }
}
-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)save:(UIButton *)senser
{
    NSString * address;
    for (UITextField * textField in textFiledArr) {
        switch (textField.tag) {
            case 0:
                address =textField.text;
                break;
            case 1:
                address =[NSString stringWithFormat:@"%@|%@",address,textField.text];
                break;
            case 2:
                app.reciverAddress.receiverName =[NSString stringWithFormat:@"%@ %@",textField.text,currentSexy==0? @"先生":@"女士"];
                break;
            case 3:
                app.reciverAddress.phone = textField.text;
                break;
            default:
                break;
        }
    }
    app.reciverAddress.address=address;
    if(app.reciverAddress.address == nil )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_detail_gps_notice", @"请在地图上定位您的地址") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [self goToMap:nil];
        return;
    }
    if (![app checkMobilePhone:app.reciverAddress.phone]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_phone_notice", @"请输入正确的手机号码") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(app.reciverAddress.receiverName.length < 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"shop_cart_reciver_notice", @"请输入正确的收货人姓名") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self editAddress:_editType];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    bShowMap = NO;
}
-(void)editAddress:(int)type{
    
    Type = type;
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(editAddressOK:obj:)];
    NSDictionary* param;
    if (type > -1) {
        if (type == 1) {//新增uduserid
            param = [[NSDictionary alloc] initWithObjectsAndKeys:uduserid,@"userid",@"1", @"op", app.reciverAddress.receiverName, @"receiver", app.reciverAddress.address, @"address", app.reciverAddress.phone, @"mobilephone", app.reciverAddress.buildingName, @"BuildingName",app.reciverAddress.buildingName, @"buildingid", app.reciverAddress.lat, @"lat", app.reciverAddress.lon, @"lng",nil];
        }else{//编辑
            param = [[NSDictionary alloc] initWithObjectsAndKeys:uduserid,@"userid",@"0", @"op", app.reciverAddress.aID, @"dataid", app.reciverAddress.receiverName, @"receiver", app.reciverAddress.address, @"address", app.reciverAddress.phone, @"mobilephone", app.reciverAddress.buildingName, @"BuildingName",app.reciverAddress.buildingName , @"buildingid", app.reciverAddress.lat, @"lat", app.reciverAddress.lon, @"lng",nil];
        }
        
    }else{//删除
        param = [[NSDictionary alloc] initWithObjectsAndKeys:uduserid,@"userid",@"-1",@"op", app.reciverAddress.aID, @"dataid", nil];
    }

    [twitterClient saveUserAddressList:param];
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
    [_progressHUD show:YES];
}

-(void)editAddressOK:(TwitterClient*)client obj:(NSObject*)obj{
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
  
        _progressHUD = nil;
    }
    
    twitterClient = nil;
    
    if (client.hasError) {
        [client alert];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_up_data_failed", @"更新数据失败！请稍后再试") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (obj == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_up_data_failed", @"更新数据失败！请稍后再试") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
//    NSLog(@"\n\n\n\n\n\n\n%@",dic);
    int type = [[dic objectForKey:@"state"] intValue];
    if (type > 0) {
        if (Type == 1) {
            app.reciverAddress.aID = [dic objectForKey:@"addressid"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:@"新增地址成功" delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            alert.tag = 1;
            alert.delegate = self;
        }else if(Type == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"user_edit_sucess", @"编辑地址成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            alert.tag = 1;
            alert.delegate = self;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"addr_list_del_sucess", @"删除地址成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            [alert show];
            [self cancel:nil];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"public_up_data_failed", @"更新数据失败！请稍后再试") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self cancel:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (twitterClient) {
        [twitterClient cancel];
        twitterClient = nil;
    }
    [super viewDidDisappear:animated];
}

#pragma mark select
-(void)goToMap:(id)senser{
    if (!bShowMap) {
        bShowMap = YES;
        NSLog(@"app.reciverAddress.lat%@", app.reciverAddress.lat);
        SearchOnMapViewController *viewController = [[SearchOnMapViewController alloc] initWithUserAddr:app.reciverAddress isSearch:YES];
        viewController.delegate=self;
        viewController.isOrderAddress=YES;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    
}
-(void)SearchOnMapViewController:(SearchOnMapViewController *)vc withLocation:(NSString *)locat{
    textFiledArr[0].text=locat;
}
#pragma mark UITextField delegate


@end
