//
//  ShopNewViewController.m
//  HangJingForiphone
//
//  Created by ihangjing on 16/2/24.
//
//

#import "ShopNewViewController.h"
#import "FoodListViewController.h"
#import "ShopDetailViewController.h"
#import "SCNavTabBarController.h"
#import "LoginNewViewController.h"
#import "SearchOnMapViewController.h"
#import "CommitOrderViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MHNetwrok.h"

@interface ShopNewViewController ()<FoodListViewControllerDelegate>{
    NSMutableArray * titleLineViewArr;
    NSMutableArray <UILabel *>* titleLabelArr;
    UIScrollView * myScrollView;
    UIView * shopView;
    UILabel * postPriceLabel;
    
    NSMutableArray * shopInfoLabelArr;
    
}

@end

@implementation ShopNewViewController


-(void)loadHeaderView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView * backView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 150)];
    [self.view addSubview:backView];
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shop_back"]];
    backImageView.frame=backView.bounds;
    [backView addSubview:backImageView];
    self.ShopId = [NSString stringWithFormat:@"%d", app.mShopModel.shopid];
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
//    UIBarButtonItem * SearchBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索wq"] style:UIBarButtonItemStylePlain target:self action:nil];
//    SearchBtn.tintColor=[UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = SearchBtn;
    

    //zyp-mark商家信息
    //本控制器是商家信息，
    //含下单页面foodListViewController
    //商家页面
    //评论页面 shopDetailViewController
    foodListViewController = [[FoodListViewController alloc] init];
    foodListViewController.delegate=self;
    shopDetailViewController =[[ShopDetailViewController alloc]init];

    shopView=[[UIView alloc]init];
    
    NSArray * titileArr=[NSArray arrayWithObjects:@"商品",@"评论",@"商家",nil];
    
    titleLineViewArr=[NSMutableArray array];
    titleLabelArr =[NSMutableArray array];
    
    CGFloat x=0;int i=0;
    for (NSString * title in titileArr) {
        UIView * titleView=[[UIView alloc]initWithFrame:RectMake_LFL(x, 150, 375/3, 40)];
        titleView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:titleView];
        
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=RectMake_LFL(0, 0, 375/3, 40);
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [titleView addSubview:btn];
        
        
        UIView * lineView=[[UIView alloc ]initWithFrame:RectMake_LFL((375/3-30)/2,40-3, 30, 3)];
        lineView.backgroundColor=app.sysTitleColor;
        lineView.tag=i;
        [titleView addSubview:lineView];
        [titleLineViewArr addObject:lineView];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(0, 0, 375/3, 40)];
        label.text=title;
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:17];
        label.tag=i;
        [titleView addSubview:label];
        [titleLabelArr addObject:label];
        
        if (i==0) {
            lineView.alpha=1;
            label.textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        }else{
            lineView.alpha=0;
            label.textColor=[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        }
        
        x+=375/3;
        i++;
    }
    UIImageView * shopIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"图层-1"]];
    shopIcon.frame=RectMake_LFL(10, 60, 75, 75);
    shopIcon.image=app.mShopModel.image;
    [shopIcon sd_setImageWithURL:[NSURL URLWithString:app.mShopModel.icon] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    shopIcon.layer.masksToBounds = YES;
    shopIcon.layer.cornerRadius=shopIcon.frame.size.width/2;
    [backView addSubview:shopIcon];
    
    postPriceLabel=[[UILabel alloc]initWithFrame:RectMake_LFL(100, 90, 200, 14)];
    postPriceLabel.font=[UIFont systemFontOfSize:15];
    postPriceLabel.textColor=[UIColor whiteColor];
    postPriceLabel.text=[NSString stringWithFormat:@"起送价:%.0f元 配送费:%.0f元",self.shopDetail.startMoney,self.shopDetail.sendmoney];
    [backView addSubview:postPriceLabel];
    //公告板
    UILabel * BillboardLable=[[UILabel alloc]initWithFrame:RectMake_LFL(100, 110, 150, 14)];
    BillboardLable.font=[UIFont systemFontOfSize:14];
    BillboardLable.textColor=[UIColor whiteColor];
    BillboardLable.text=@"请提前30分钟下单";
    [backView addSubview:BillboardLable];
    
    //收藏按钮
    UIImage * image=[UIImage imageNamed:@"收藏"];
    btnShopFav=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnShopFav setImage:image forState:UIControlStateNormal];
    [btnShopFav setImage:[UIImage imageNamed:@"收藏-后"] forState:UIControlStateSelected];
    btnShopFav.frame=RectMake_LFL(375-62.5-10, 64+29, 62.5, 25);
    [btnShopFav addTarget:self action:@selector(Favor:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnShopFav];
    
    [self loadScrollView];
    
    UIView * longLineView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 190,375, 0.5)];
    longLineView.backgroundColor=[UIColor colorWithRed:202.0/255.0 green:202.0/255.0 blue:202.0/255.0 alpha:1];
    [self.view addSubview:longLineView];
    
}
-(void)mapClick{
    SearchOnMapViewController *viewController = [[SearchOnMapViewController alloc] initWithLat:[self.shopDetail.lat doubleValue] lon:[self.shopDetail.lng doubleValue] addr:self.shopDetail.address isShowPoint:YES] ;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navController animated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHeaderView];
    self.title = app.mShopModel.shopname;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    if (app.useLocation != nil) {
        ulat = [NSString stringWithFormat:@"%f", app.useLocation.lat];
        ulng = [NSString stringWithFormat:@"%f", app.useLocation.lon];
    }else{
        ulat = @"0.0";
        ulng = @"0.0";
    }
    
    if (self.shopDetail == nil) {
        [self GetShopDetail];
    }else{
        self.ShopId = [NSString stringWithFormat:@"%d", _shopDetail.shopid];
    }
    
}
-(void)FoodListViewControllerLetShopPushController:(UIViewController *)controller isPush:(BOOL)isPush{
    if (isPush) {
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)loadScrollView{
    CGFloat scrollH=667-150-40;
    myScrollView=[[UIScrollView alloc]initWithFrame:RectMake_LFL(0, 150+40, 375,scrollH)];
    myScrollView.showsVerticalScrollIndicator=NO;
    myScrollView.showsHorizontalScrollIndicator=NO;
    myScrollView.pagingEnabled=YES;
    myScrollView.contentSize=SizeMake_LFL(375*3, scrollH);
    myScrollView.delegate=self;
    [self.view addSubview:myScrollView];
    
    foodListViewController.view.frame=RectMake_LFL(0, 0, 375, scrollH);
    shopDetailViewController.view.frame=RectMake_LFL(375, 0, 375, scrollH);
    shopView.frame=RectMake_LFL(375*2, 0, 375, scrollH);
    
    shopDetailViewController.view.backgroundColor=[UIColor whiteColor];
    shopView.backgroundColor=[UIColor whiteColor];
    
    [myScrollView addSubview:foodListViewController.view];
    [myScrollView addSubview:shopDetailViewController.view];
    [myScrollView addSubview:shopView];

    [self loadShopView];
    
}

-(void)loadShopView{
    shopView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    NSArray * arr=[NSArray arrayWithObjects:@"icon_telephone",@"icon_dingwei",@"icon_time", nil];
    shopInfoLabelArr =[NSMutableArray array];
    
    UIView * whiteView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 120)];
    whiteView.backgroundColor=[UIColor whiteColor];
    [shopView addSubview:whiteView];

    
    for (int i=0; i<3; i++) {
        UIImageView * iconImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:arr[i]]];
        iconImageView.frame=RectMake_LFL(10, (40-14)/2+40*i, 14, 14);
        [whiteView addSubview:iconImageView];
        
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(29, (40-14)/2+40*i, 300, 14)];
        label.font=[UIFont systemFontOfSize:14];
        [whiteView addSubview:label];
        [shopInfoLabelArr addObject:label];
        label.tag=i;
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
        [whiteView addSubview:line];
        line.frame=RectMake_LFL(10, 40+ 40*i, 355, 0.5);

        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=RectMake_LFL(0, i*40, 375, 40);
        [whiteView addSubview:btn];
        [btn addTarget:self action:@selector(shopInfoLableClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
    }
    UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_left"]];
    imageView.frame=RectMake_LFL(375- 18, (40-15)/2, 8, 15);
    [whiteView addSubview:imageView];
    
    imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_left"]];
    imageView.frame=RectMake_LFL(375- 18, 40+(40-15)/2, 8, 15);
    [whiteView addSubview:imageView];
    
}
-(void)shopInfoLableClick:(UIButton *)btn{
    switch (btn.tag ) {
        case 0:
        {
            btn.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
            
            UIAlertController * ac=[UIAlertController alertControllerWithTitle:@"拨号" message:@"是否拨号给商家" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * aa=[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.shopDetail.tel]]];
            }];
            UIAlertAction * aa2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:aa];
            [ac addAction:aa2];
            [self presentViewController:ac animated:YES completion:nil];
            
            break;
        }
        case 1:
            btn.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.5];
            [self mapClick];
            break;
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.backgroundColor=[UIColor clearColor];
    });
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self changeTitleBtnStateWithNum:scrollView.contentOffset.x/375];
}
-(void)titleBtnClick:(UIButton *)btn{
    
    myScrollView.contentOffset=PointMake_LFL(btn.tag*375, 0);
    [self changeTitleBtnStateWithNum:(int)btn.tag];
}
-(void)changeTitleBtnStateWithNum:(int)num{
    int i=0;
    for (UIView * view in titleLineViewArr) {
        if (num==view.tag) {
            view.alpha=1;
            titleLabelArr[i].textColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        }else{
            view.alpha=0;
            titleLabelArr[i].textColor=[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        }
        i++;
    }
}

#pragma mark 获取商家信息
- (void)GetShopDetail
{
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getShopDetailDidSucceed:obj:)];
    
    NSDictionary* param;
    if (self.uduserid.length > 0) {
        param = [[NSDictionary alloc] initWithObjectsAndKeys:self.ShopId,@"shopid", ulat,@"lat",ulng,@"lng", self.uduserid, @"userid", nil];
    }else{
        param = [[NSDictionary alloc] initWithObjectsAndKeys:self.ShopId,@"shopid", ulat,@"lat",ulng,@"lng", nil];
    }
    [twitterClient getShopDetailByShopId:param];
    
}
- (void)getShopDetailDidSucceed:(TwitterClient*)sender obj:(NSObject*)obj;
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
    
    twitterClient = nil;
   
    
    if (sender.hasError) {
        [sender alert];
        return;
    }
    self.shopDetail = (ShopDetailModel *)[self loadView:(NSDictionary*)obj];
    self.shopDetail = (ShopDetailModel *)[shopDetailViewController loadView:(NSDictionary*)obj];
    [foodListViewController startReadFood:self.shopDetail];
    app.mShopModel.shopType = _shopDetail.Star;
    if (self.shopDetail.iscollect == 1) {
        [btnShopFav setSelected:YES];
    }else{
        [btnShopFav setSelected:NO];
    }

    
    
}
-(ShopDetailModel *)loadView:(NSDictionary *)json
{
    
    self.shopDetail = [[ShopDetailModel alloc] initWithJsonDictionary:json ];
    postPriceLabel.text=[NSString stringWithFormat:@"起送价:%.0f元 配送费:%.0f元",self.shopDetail.startMoney,self.shopDetail.sendmoney];

    
    UIView * tagView=[[UIView alloc]init];
    tagView.backgroundColor=[UIColor whiteColor];
    [shopView addSubview:tagView];
    CGFloat y=10;
    for (ShopTagMode * model in _shopDetail.shopTagList) {
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:RectMake_LFL(10, y, 15, 15)];
        [tagView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.Picture] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
        UILabel * label=[[UILabel alloc]initWithFrame:RectMake_LFL(30, y, 345, 15)];
        label.text=model.Title;
        label.font=[UIFont systemFontOfSize:12];
        [tagView addSubview:label];
        y+=25;
    }

    tagView.frame=RectMake_LFL(0, 10+40*3, 375, y);
    
    UIView * shopPictureView=[[UIView alloc]initWithFrame:RectMake_LFL(0,10+40*3+y+10, 375, 600)];
    [shopView addSubview:shopPictureView];
    shopPictureView.backgroundColor=[UIColor whiteColor];
    UILabel * label =[[UILabel alloc]init  ];
    label.frame=RectMake_LFL(0, 10, 375, 15);
    label.text=@"商家环境";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    [shopPictureView addSubview:label];
    
    NSArray * textArr=[NSArray arrayWithObjects:[NSString stringWithFormat:@"商家电话：%@",self.shopDetail.tel],[NSString stringWithFormat:@"商家地址：%@",self.shopDetail.address],[NSString stringWithFormat:@"配送时间：%@",self.shopDetail.OrderTime], nil];
    int i=0;
    for (UILabel * label in shopInfoLabelArr) {
        label.text=textArr[i];
        i++;
    }
    return self.shopDetail;
}


-(void)updataUI:(int)type{
    if (type == 1) {
        
    }else if(type == 15){
        
    }else {
        
    }
    
}

#pragma mark 判断是否登陆
- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _uduserid = [defaults objectForKey:@"userid"];
    
    if([_uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init] ;
        
        LoginController.title =CustomLocalizedString(@"login", @"会员登录");
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        [self presentViewController:navController animated:YES completion:nil];
        
        return NO;
    }
}
#pragma mark 收藏商家
-(void)Favor:(id)senser;
{
    if( (![self IsLogin]) )
    {
        return;
    }
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"发送数据中...");
    [_progressHUD show:YES];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(FavorSucceed:obj:)];
    
    NSDictionary* param;// = [[NSDictionary alloc] initWithObjectsAndKeys:uduserid,@"userid", self.ShopId,@"togoid", @"1", @"op", nil];
    if (_shopDetail.iscollect == 1) {
        param = [[NSDictionary alloc] initWithObjectsAndKeys:_uduserid,@"userid", self.ShopId,@"togoid", @"-1", @"op", nil];
    }else{
        param = [[NSDictionary alloc] initWithObjectsAndKeys:_uduserid,@"userid", self.ShopId,@"togoid", @"1", @"op", nil];
    }
    [twitterClient favorShop:param];

}
-(void)FavorSucceed:(TwitterClient*)sender obj:(NSObject*)obj;
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        
        _progressHUD = nil;
    }
    [btnShopFav setSelected:YES];
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    NSDictionary *dic1 = (NSDictionary *)obj;
    int state1 = [[dic1 objectForKey:@"state"] intValue];
    UIAlertView *alert;
    switch (state1) {
            
        case 1:
            
            if (_shopDetail.iscollect == 1) {
                if (shop != nil) {//这个从收藏界面传过来的，如果这里点击了取消收藏，那边要同步更新
                    shop.isFav = 0;
                }
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"fav_cancel_sucess", @"取消收藏成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                _shopDetail.iscollect = 0;
                [btnShopFav setSelected:NO];
            }else{
                if (shop != nil) {
                    shop.isFav = 1;
                }
                alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"fav_sucess", @"收藏成功") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
                _shopDetail.iscollect = 1;
                [btnShopFav setSelected:YES];
            }
            break;
        case 2:
            alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"fav_alread", @"您已经收藏了该商家！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            _shopDetail.iscollect = 1;
            [btnShopFav setSelected:YES];
            break;
        default:
            alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"order_state_4", @"操作失败，请稍后再试！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
            break;
    }
    [alert show];
    
    
}

-(void)goBack{
    
    app.shopCart=nil;
    [self dismissViewControllerAnimated:YES completion:nil];//
}



@end
