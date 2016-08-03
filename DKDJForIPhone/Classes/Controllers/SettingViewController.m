//
//  SettingViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "SettingViewController.h"
#import "resetUserInfoVC.h"


#import "DisclaimerViewController.h"
#import "ContactViewController.h"
#import "HJScrollView.h"
#import "HJView.h"
#import "tooles.h"
#import "NewsViewController.h"
#import "RegeditViewController.h"
#import "LoginNewViewController.h"
#import "PointsListViewController.h"
#import "STAlertView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayModel.h"
#import "DataSigner.h"
#import <ShareSDK/ShareSDK.h>
#import "logOutBtnVC.h"
#import "registerVC.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#define IMAGE_NAME @"sharesdk_img.jpg"
#define CONTENT @"大可到家"
#define SHARE_URL @"http://hmbl.cn"
#import "UIImageView+WebCache.h"

#define COMMENT @"　　1、“大可到家”致力于提供合理、准确、完整的资讯信息，但不保证信息的合理性、准确性和完整性，且不对因信息的不合理、不准确或遗漏导致的任何损失或损害承担责任。本网站所有信息仅供参考，不做交易和服务的根据， 如自行使用本网资料发生偏差，本站概不负责，亦不负任何法律责任。\r\n　　2、任何由于黑客攻击、计算机病毒侵入或发作、因政府管制而造成的暂时性关闭等影响网络正常经营的不可抗力而造成的损失，本网站均得免责。由于与本网站链接的其它网站所造成之个人资料泄露及由此而导致的任何法律争议和后果，本网站均得免责。\r\n　　3、本网站如因系统维护或升级而需暂停服务时，将事先公告。若因线路及非本公司控制范围外的硬件故障或其它不可抗力而导致暂停服务，于暂停服务期间造成的一切不便与损失，本网站不负任何责任。\r\n　　4、本网站使用者因为违反本声明的规定而触犯中华人民共和国法律的，一切后果自己负责，本网站不承担任何责任。\r\n　　5、凡以任何方式登陆本网站或直接、间接使用本网站资料者，视为自愿接受本网站声明的约束。\r\n　　6、本声明未涉及的问题参见国家有关法律法规，当本声明与国家法律法规冲突时，以国家法律法规为准。\r\n　　7、本网站如无意中侵犯了哪个媒体或个人的知识产权，请来信或来电告之，本网站将立即给予删除。"

@implementation SettingViewController{
    UIImageView * iocnImgView;
    UIButton *loginBtn;
    NSMutableArray * userValueLabelArr;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}


#pragma mark 判断用户是否登陆
- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    self.uduserName = [defaults objectForKey:@"username"];
}

- (BOOL)IsLogin{
    [self refreshFields];
    
    if([self.uduserid intValue]  > 0 ){
        [self getUserInfo];
        return YES;
    }
    else{
        return NO;
    }
}
//zyp  我的 界面
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self IsLogin]) {
        [loginBtn setHidden:YES];
        [iocnImgView setHidden:NO];
    }else{
        [loginBtn setHidden:NO];
        [iocnImgView setHidden:YES];
    }
}
#pragma mark - zyp 用户信息
-(void)getUserInfo{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(userInfoDidRec:obj:)];
    [twitterClient getUserInfoByUserId:self.uduserid];
}

-(void)userInfoDidRec:(TwitterClient*)sender obj:(NSObject*)obj{
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    twitterClient = nil;
    NSDictionary *dic = (NSDictionary*)obj;
    
    NSString * money = [NSString stringWithFormat:@"%.2f元", [[dic objectForKey:@"HaveMoney"] floatValue]];
    
    NSArray * arr=[NSArray arrayWithObjects:money,[NSString stringWithFormat:@"%d个",[[dic objectForKey:@"count"] intValue]] ,nil];
    int i=0;
    for (UILabel * lable in userValueLabelArr) {
        NSMutableAttributedString*str = [[NSMutableAttributedString alloc] initWithString:arr[i]];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(str.length-1,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(0, str.length-1)];
        lable.attributedText=str;
        i++;
    }
    
    userName.text = [dic objectForKey:@"truename"];
    point.text = [dic objectForKey:@"phone"];
    [iocnImgView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"test_Icon.png"]];
    
}

-(void)setBtnClicked{
    logOutBtnVC * vc=[[logOutBtnVC alloc]init];
    UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIBarButtonItem * setBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_seting"] style:UIBarButtonItemStylePlain target:self action:@selector(setBtnClicked)];
    setBtn.tintColor=[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem=setBtn;
    self.view.backgroundColor=[UIColor whiteColor];

    [self loadUserInfoImageView];
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 214, 375, 10)];
    
    line.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [self.view addSubview:line];
    NSArray * text=[NSArray arrayWithObjects:@"敬请期待",@"我的地址",@"敬请期待",@"我的退款",@"常见问题",@"商家入驻", nil];
    for (int i=0; i<3; i++) {
        UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(375.0/3.0*(i%3),224+ 375.0/3.0*(i/3), 375.0/3.0, 375.0/3.0)];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
        UIImage * img=[UIImage imageNamed:[NSString stringWithFormat:@"setBtn%d",i+1]];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=RectMake_LFL((375.0/3.0-img.size.width)/2, 375.0/3.0-55-img.size.height, img.size.width, img.size.height);
        [btn setImage:img forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.tag=i;
        [btn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(0, 75,375.0/3.0, 14)];
        label.text=text[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(375.0/3.0-1, 0, 0.5, 375.0/3.0)];
        line.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        [view addSubview:line];
        UIView * line2=[[UIView alloc]initWithFrame:RectMake_LFL(0, 375.0/3.0-1, 375.0/3.0,0.5)];
        line2.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        [view addSubview:line2];
    }
    UIButton * btn=[[UIButton alloc]initWithFrame:RectMake_LFL(50, 667-90, 375-100, 18)];
    [btn setTitle:@"客服电话：4001-663779" forState:UIControlStateNormal];
    [btn setTitleColor:app.sysTitleColor forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:19];
    [btn addTarget:self action:@selector(telBTnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-59, [UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor=[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [self.view addSubview:view];
//    [self viewDidAppear:YES];
}

 -(void)loadUserInfoImageView{
     UIImageView * userinfoImageView = [[UIImageView alloc] initWithFrame:RectMake_LFL(0.0, 0, 375, 214)];
     userinfoImageView.image=[UIImage imageNamed:@"my_back"];
     [self.view addSubview:userinfoImageView];
     
     
     loginBtn = [[UIButton alloc] initWithFrame:RectMake_LFL((375-80)/2, 57, 80, 30)];
     [loginBtn setTitle:@"登陆\\注册" forState:UIControlStateNormal];
     [loginBtn addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:loginBtn];
     loginBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
     [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
     loginBtn.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3];
     [self.view addSubview:loginBtn];
     
     
     iocnImgView = [[UIImageView alloc] initWithFrame:RectMake_LFL((375-90)/2, 27, 90, 90)];
     iocnImgView.layer.masksToBounds = YES;
     iocnImgView.layer.cornerRadius=iocnImgView.frame.size.width/2;
     iocnImgView.layer.borderWidth=3;
     iocnImgView.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor whiteColor]);
     [self.view addSubview:iocnImgView];
     UITapGestureRecognizer * gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoUserInfo:)];
     iocnImgView.userInteractionEnabled=YES;
     iocnImgView.multipleTouchEnabled = YES;
     [iocnImgView addGestureRecognizer:gesture];
     
     userName = [[UILabel alloc] initWithFrame:RectMake_LFL((375-200)/2, 97+30, 200, 15)];
     userName.font = [UIFont boldSystemFontOfSize:13];
     userName.textColor = [UIColor whiteColor];
     userName.textAlignment=NSTextAlignmentCenter;
     userName.backgroundColor = [UIColor clearColor];
     [userinfoImageView addSubview:userName];
     NSArray * nameArr=[NSArray arrayWithObjects:@"余额", @"代金券",@"收藏店铺",nil];
     userValueLabelArr=[NSMutableArray array];
     for (int i=0; i<3; i++) {
         UIImage * img=[UIImage imageNamed:nameArr[i]];
         UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
         [btn setImage:img forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(userInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
         btn.tag=i;
         btn.frame=RectMake_LFL(25+i*(375/3),214 -21 -5-img.size.height, img.size.width, img.size.height);
         [self.view addSubview:btn];
         
         UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(0+i*(375/3), 214-21, 75, 11)];
         label.text=nameArr[i];
         label.textColor=[UIColor whiteColor];
         label.textAlignment=NSTextAlignmentCenter;
         label.font=[UIFont systemFontOfSize:13];
         [userinfoImageView addSubview:label];
         
         
         UIImageView * line=[[UIImageView alloc]initWithFrame:RectMake_LFL(-1+i*(375/3),214-60, 1.5, 50)];
         line.image=[UIImage imageNamed:@"竖条分割线"];
         [userinfoImageView addSubview:line];
         
         if (i==1) {
             UIView * view=[[UIView alloc]initWithFrame:RectMake_LFL(65+i*(375/3), 214-60, 60, 50)];
             view.backgroundColor=[UIColor clearColor];
             [userinfoImageView addSubview:view];
             UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(0, 8, 60, 25)];
             label.text=@"敬请";
             label.textColor=[UIColor whiteColor];
             label.font=[UIFont systemFontOfSize:16];
             [view addSubview:label];
             label=[[UILabel alloc]initWithFrame:RectMake_LFL(0,23, 60, 25)];
             label.text=@"期待";
             label.font=[UIFont systemFontOfSize:16];
             label.textColor=[UIColor whiteColor];
             [view addSubview:label];
         }else{
             
             UILabel * label2=[[UILabel alloc]initWithFrame:RectMake_LFL(60+i*(375/3), 214-38, 65, 25)];
             label2.textColor=[UIColor whiteColor];
             [userinfoImageView addSubview:label2];
             [userValueLabelArr addObject:label2];
         }
     }
}
//更改个人信息
-(void)gotoUserInfo:(UITapGestureRecognizer *)gesture{
    
    
    [self refreshFields];

    if([self.uduserid intValue]  < 1){
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init] ;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    resetUserInfoVC*viewController = [[resetUserInfoVC alloc] init];
    viewController.iconImg=self.myICO;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];

}
-(void)userInfoBtn:(UIButton *)btn{
    [self refreshFields];
    if([self.uduserid intValue]  < 1)  //[uduserid intValue]
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController] ;
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    switch (btn.tag) {
        case 0:

            break;
        case 1:
            
            break;
        case 2:{
            UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:[[ShopNewListViewController alloc] initWithFavor:self.uduserid]];
            [self presentViewController:navi animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
}
-(void)BtnClicked:(UIButton *)btn{

    [self refreshFields];
    if([self.uduserid intValue]  < 1)  //[uduserid intValue]
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController] ;
        [self presentViewController:navController animated:YES completion:nil];
        return;
    }
    UIViewController* viewController;
    
    switch (btn.tag) {
        case 0:
            //消息提醒
//            viewController = [[PointsListViewController alloc] init] ;
//            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 1:
        {
            //我的收货地址
            viewController = [[UserAddressListViewController alloc] initWithDefault];
            UINavigationController * navi=[[UINavigationController alloc]initWithRootViewController:viewController];
            [self presentViewController:navi animated:YES completion:nil];
            break;
        }
        case 2:
            //我的评价
            break;
        case 3:
            //我的退款
            break;
        case 4:
            //常见问题
            //目前积分
//            viewController = [[MyPointListViewController alloc] initWithcUserID:self.uduserid];
//            [self.navigationController pushViewController:viewController animated:true];
            break;
        case 5:
            //商家入驻
            //修改登陆密码
//            
            break;
        default:
            break;
        case 11:
            break;
        case 13:{
        }
            break;
        case 14:
        {
            [self shareApp];
        }
            break;
    }
}
-(void)logOut:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"userid"];
    [defaults setObject:@"" forKey:@"username"];
    
    [defaults synchronize];
    [logout setHidden:YES];
    [noLoginView setHidden:NO];
    [userinfoView setHidden:YES];


}

-(void)goLogin:(UIButton *)btn
{
    
    LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
//    registerVC * registervc=[[registerVC alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark 分享操作
-(void)shareApp
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    NSString *value = [NSString stringWithFormat:@"您好,我在使用%@手机版订餐App，手机上直接可以点外卖很方便不妨你也试用一下：http://%@/app.aspx", app.appName, HOST];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:value
                                       defaultContent:value
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:value
                                                  url: [NSString stringWithFormat:@"http://%@/app.aspx", HOST]
                                          description:value
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPadContainerWithView:gifView arrowDirect:UIPopoverArrowDirectionUp];
    [container setIPhoneContainerWithViewController:self];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
    
}
#pragma mark 获取支付数据
-(void)getRechID:(float)moeny{
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(rechIDDidReceive:obj:)];

    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.uduserid, @"userid", [NSString stringWithFormat:@"%.2f", moeny],@"AddMoney", @"1", @"paymodel", nil];
    
    [twitterClient getRechID:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.labelText = CustomLocalizedString(@"acount_input_get_notice", @"获取充值数据中...");
    [_progressHUD show:YES];
    
}

- (void)rechIDDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    if (_progressHUD){
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    twitterClient = nil;
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    if (obj == nil){
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic1 = (NSDictionary*)obj;
    
    int state = [[dic1 objectForKey:@"state"] intValue];
    if (state == 1) {
        self.payId = [dic1 objectForKey:@"payorderid"];
        [self aliPay:nil money:payMoeny type:1];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"获取支付数据失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark 支付宝

-(void)aliPay:(NSString *)odid money:(float)payMoney type:(int)payType{
    if (payMoney > 0.0f) {
        isGotoPay = YES;
        //payMoney = 0.1;//
        if (self.payId == nil) {
            [self getRechID:payMoney];
            return;
        }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        AliPayModel *order = [[AliPayModel alloc] init];
        order.partner = AliPartner;
        order.seller = AliSeller;
        
        order.tradeNO = self.payId; //订单ID（由商家自行制定）
        
        order.productName = [NSString stringWithFormat:@"%@IOS支付宝账号充值：%@", appName, self.payId]; //商品标题
        order.productDescription = [NSString stringWithFormat:@"充值编号：%@", self.payId]; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",payMoney]; //商品价格
        order.notifyURL =  @"http%3A%2F%2Fwww.woydian.com%2FAlipay%2Fiosnotify.aspx"; //回调URL
        
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.showUrl = @"m.alipay.com";
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        NSString *appScheme = @"AliPayDGWM";
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order description];
        NSLog(@"orderSpec = %@",orderSpec);

        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        id<DataSigner> signer = CreateRSADataSigner(AliPrivateKey);
        NSString *signedString = [signer signString:orderSpec];
        self.payId = nil;//每次支付都要重新获取
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = nil;
        if (signedString != nil) {
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                [self getUserInfo];
            }]; 
        }
    }
}

#pragma mark 短信发送后回调
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //比如这里只要求让短信界面消失，不做其他处理
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)telBTnClick{
    UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"拨号" message:@"是否拨号给客服" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * aa=[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://03128777785"]];
    }];
    UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:aa];
    [ac addAction:aa2];
    [self presentViewController:ac animated:YES completion:nil];
    
}

@end
