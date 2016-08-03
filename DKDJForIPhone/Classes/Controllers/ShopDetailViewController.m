//
//  ShopDetailViewController.m
//  EasyEat4iPhone
//
//  Created by dev on 12-1-5.
//  Copyright 2012 ihangjing.com. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "FoodListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "tooles.h"
#import "ShopListViewController.h"
#import "LoginNewViewController.h"
#import "FoodDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "CouponDetailViewController.h"
#import "MovieModel.h"
#import "DYRateView.h"
#import "KTVModel.h"
#import "AddOrderToServerNewViewController.h"
#import "HJView.h"
#import "UserCommentTalbeViewController.h"
#import "SearchOnMapViewController.h"
//原先此视图视图代码实现uitableview（未使用xib）但是遇到一个问题表格的最底部文字要手指拉着才能看，一放开会弹下去看不到，原因未明修改成从xib加载症状消失
@implementation ShopDetailViewController{
    NSMutableArray*  tableHeadBtnArr;
    UIImageView * userIcon;
    UILabel * userNameLabel;
    UILabel * userTimeLabel;
    
    UILabel * Goodlable;//好评率
}
static NSString *CellTableIdentifier = @"CellTableIdentifier";

#define VIEW_H (667-190)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    app = (EasyEat4iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}


-(id)initWithShopDetail:(ShopDetailModel *)model{
    if (self = [super init]) {
        self.shopDetail = model;
    }
    return self;
}

- (id)initWithShopId:(NSString*)shopId shopType:(int)shoptype{
    if (self = [super init]) {
        self.ShopId = shopId;
        [app.mShopModel setShopid:self.ShopId];
        app.mShopModel.mBUpdate = NO;
        nShopType = shoptype;
    }
    return self;
}

-(void)setImg:(NSString *)imagePath Default:(NSString *)name ImageView:(UIImageView *)image{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imagePath] == YES) {
        [image setImage:[UIImage imageWithContentsOfFile:imagePath]];
        //[image.image initWithContentsOfFile:imagePath];
    }else{
        [image setImage:[UIImage imageNamed:name]];
    }
}
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
}
- (void)gotoFoodList:(id)sender{
    [app setShopDetailMode:self.shopDetail];
    [self goBack];
}
-(void)gotoShopList{
    ShopListViewController *controller;
    UIAlertView *alert;
    switch (app.shopListType) {
        case 0:
            //附近外卖
            controller = [[ShopListViewController alloc] initWithLocation];
            [self.navigationController pushViewController:controller animated:true];
            break;
        case 1:
            //建筑物
            controller = [[ShopListViewController alloc] initWithBid:app.buildID];
            [self.navigationController pushViewController:controller animated:true];
            break;
        case 3:
            controller = [[ShopListViewController alloc] initWithFavor:self.uduserid];
            controller.title = @"我的收藏";
            [self.navigationController pushViewController:controller animated:true];
            break;
        case 2:
        default:
            //没有进入过商家列表
            alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请先从首页立即点餐或者店铺收藏进入商家列表！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];

            break;
    }
}
- (void)viewWillAppear:(BOOL)animated {
}
- (void)viewDidLoad {
    //显示加载中
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
    
    tvListView = [[UITableView alloc] initWithFrame:RectMake_LFL(0, 0, 375, VIEW_H)];
    tvListView.delegate = self;
    tvListView.dataSource = self;

    tvListView.separatorStyle = UITableViewCellSeparatorStyleNone;//不显示分割线
    
    [self.view addSubview:tvListView];

    
    tvListView.tableHeaderView = [[UIView alloc] initWithFrame:RectMake_LFL(0.0, 0.0, 375, 150)];
    UIView * headerView=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 40)];
    tvListView.tableHeaderView =headerView;
    
//    UIColor * garyColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];;
//    
//    UIView *line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 10)];
//    line.backgroundColor=garyColor;
//    [headerView addSubview:line];
//    
//    UIView *line2=[[UIView alloc]initWithFrame:RectMake_LFL(0, 100, 375, 10)];
//    line2.backgroundColor=garyColor;
//    [headerView addSubview:line2];
//    
//    UIView * line3=[[UIView alloc]initWithFrame:RectMake_LFL(375/2, 20, 0.5, 70)];
//    line3.backgroundColor=garyColor;
//    [headerView addSubview:line3];
//    
//    UILabel * lable=[[UILabel alloc]initWithFrame:RectMake_LFL(15, 35, 16*4, 16)];
//    lable.text=@"综合评分";
//    lable.textAlignment=NSTextAlignmentCenter;
//    lable.font=[UIFont systemFontOfSize:17];
//    [headerView addSubview:lable];
//    
//    UILabel * lable2 =[[UILabel alloc]initWithFrame:RectMake_LFL(64+30, 35, 100, 40)];
//    lable2.text=@"4.2";
//    lable2.textColor=app.sysTitleColor;
//    lable2.font=[UIFont boldSystemFontOfSize:42];
//    [headerView addSubview:lable2];
//    
//    Goodlable =[[UILabel alloc]initWithFrame:RectMake_LFL(15, 60, 16*4, 12)];
//    Goodlable.font=[UIFont systemFontOfSize:12];
//    Goodlable.textAlignment=NSTextAlignmentCenter;
//    Goodlable.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
//    [headerView addSubview:Goodlable];
//    
//    UILabel * lable3=[[UILabel alloc]initWithFrame:RectMake_LFL(375/2, 25, 367/2, 16)];
//    lable3.textAlignment=NSTextAlignmentCenter;
//    lable3.font=[UIFont systemFontOfSize:17];
//    lable3.text=@"评价标签";
//    [headerView addSubview: lable3];
//    
//    NSArray * textArr=[NSArray arrayWithObjects:@"速度快",@"味道好",@"质量优", nil];
//    for (int i=0; i<3; i++) {
//        UIImageView * imageView=[[UIImageView alloc]initWithFrame:RectMake_LFL(375/2+5+i*61.5, 56, 53, 20)];
//        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"圆角矩形-%d",i+2]];
//        UILabel * tagLabel=[[UILabel alloc]init];
//        tagLabel.frame=imageView.frame;
//        tagLabel.text=textArr[i];
//        tagLabel.textAlignment=NSTextAlignmentCenter;
//        tagLabel.font=[UIFont systemFontOfSize:13];
//        [headerView addSubview:imageView];
//        [headerView addSubview:tagLabel];
//    }
    
    tableHeadBtnArr=[NSMutableArray array];
    UIView *topBottomView=[[UIView alloc]init];
    topBottomView.frame=RectMake_LFL(0, 0, 375, 40);
    [headerView addSubview:topBottomView];
    for (int i=0; i<4; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=RectMake_LFL(14.5+(64+28)*i, (40-25)/2, 64, 25);
        btn.tag=i;
        [topBottomView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"圆角矩形"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"圆角矩形_选中"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(commendTitleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label=[[UILabel alloc]initWithFrame:btn.frame];
        label.tag=i;
        label.font=[UIFont systemFontOfSize:13];
        label.textAlignment=NSTextAlignmentCenter;
        [topBottomView addSubview:label];
        [tableHeadBtnArr addObject:label];
    }
    UIButton *btn=[UIButton new];
    btn.tag=0;
    [self commendTitleBtnClick:btn];
    

    foodClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoFoodList:)];
    fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor whiteColor];
    foodPage = 1;
    activityPage = 1;
    couponPage = 1;
    commentList = [[NSMutableArray alloc] init];
    page = 1;
    
}
-(void)commendTitleBtnClick:(UIButton *)btn{

    for (UILabel * label in tableHeadBtnArr) {
        if (label.tag==btn.tag) {
            label.textColor=app.sysTitleColor;
        }else{
            label.textColor=[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1];
        }
    }
    
}
#pragma mark zyp获取评论列表
-(void)getCommentList
{


    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", self.shopDetail.shopid], @"shopid", [NSString stringWithFormat:@"%d", page], @"pageindex", @"8", @"pagesize", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(commentListDidReceive:obj:)];
    
    [twitterClient getFoodCommentListByFoodId:param];

}

- (void)commentListDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{

    twitterClient = nil;

    [tvListView beginUpdates];
    
    [tvListView setTableHeaderView:tvListView.tableHeaderView];
    [tvListView endUpdates];
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount =(int) [commentList count];//已经存在列表中的数量
    
    if (obj == nil){
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSLog(@"%@",dic);
    //NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    NSArray *ary = ary = [dic objectForKey:@"datalist"];
    
    if ([ary count] == 0) {
        hasMore = false;

        [tvListView reloadData];
        return;
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    
    if( totalpage > page ){
        ++page;
        hasMore = true;
    }
    else{
        hasMore = false;
    }
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    int index = (int)[commentList count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        UserCommentModel *model = [[UserCommentModel alloc] initWitchDic:dic];
        if (model.userName || model.value || model.image) {//判断数据是否存在

            [commentList addObject:model];
        }
        
    }
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [tvListView reloadData];
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[NSMutableArray alloc] init];
        
        //刷新表格数据
        [tvListView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
//            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [tvListView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [tvListView endUpdates];
    }
}


-(void)removeAllTableView{
    isRemoveAllCell = YES;
    [tvListView reloadData];
    UITableViewCell *cell = [tvListView dequeueReusableCellWithIdentifier:CellTableIdentifier];;
    while (1) {
        if (cell) {
            [cell removeFromSuperview];
        }else{
            break;
        }
        cell = [tvListView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    }
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

}

- (void)viewDidUnload {

}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoCommandClick
{
    UserCommentTalbeViewController *viewController = [[UserCommentTalbeViewController alloc] initWithcFoodID:self.shopDetail.shopid];
    [self.navigationController pushViewController:viewController animated:true];
}

- (BOOL)IsLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    uduserid = [defaults objectForKey:@"userid"];
    
    if([uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =CustomLocalizedString(@"login", @"会员登录");
        UINavigationController *navController = [[UINavigationController alloc]init];

        [self presentViewController:navController animated:YES completion:nil];
        return NO;
    }
}

#pragma mark NetGet

#pragma mark 按钮操作，网络
-(void)lShopZanClick
{//点赞
    
    if (!isCommand) {
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
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(PraiseSucceed:obj:)];

        
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:@"PType", @"Field",self.ShopId,@"shopid", uduserid,@"userid", nil];
        
        [twitterClient praiseShop:param];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"com_already", @"您已经评论过了，无须再评论") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];

    }
    
    
}
-(void)lShopOkClick
{//点赞
    if (!isCommand) {
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
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(OkPraiseSucceed:obj:)];

        
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:@"RcvType", @"Field", self.ShopId,@"shopid", uduserid,@"userid", nil];
        
        [twitterClient praiseShop:param];
        

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"com_already", @"您已经评论过了，无须再评论") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];

    }
    
    
}
-(void)lShopBadClick
{//点赞
    if (!isCommand) {
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
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(BadPraiseSucceed:obj:)];

        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:@"IsCallCenter", @"Field", self.ShopId,@"shopid", uduserid,@"userid", nil];
        
        [twitterClient praiseShop:param];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"com_already", @"您已经评论过了，无须再评论") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];

    }
    
    
}
-(void)btnGotoAddOrder:(UIButton *)btn
{
    if( (![self IsLogin]) )
    {
        return;
    }
    [app setShopDetailMode:self.shopDetail];
    app.shopCart.buyType = 1;
    [app.shopCart addFoodAttr:app.mShopModel food:nil attrIndex:0];
    AddOrderToServerNewViewController *addorderView = [[AddOrderToServerNewViewController alloc] init ] ;
    
    [self.navigationController pushViewController:addorderView animated:YES];
}


-(ShopDetailModel *)loadView:(NSDictionary *)json
{
    self.shopDetail = [[ShopDetailModel alloc] initWithJsonDictionary:json ];

    if (self.shopDetail.sortId == 35)
    {
        nShopType = 1;
    }
    else if(self.shopDetail.sortId == 36)
    {
        nShopType = 2;
    }
    else
    {
        nShopType = 0;
    }


    [tvListView beginUpdates];
    [tvListView setTableHeaderView:tvListView.tableHeaderView];
    [tvListView endUpdates];
    [self getCommentList];
    Goodlable.text=[NSString stringWithFormat:@"好评率%.0f%%",((float)self.shopDetail.startsendtime/((float)self.shopDetail.startsendtime+(float)self.shopDetail.okCount+(float)self.shopDetail.badCount))*100];
    
    for (UILabel * label in tableHeadBtnArr) {
        switch (label.tag) {
            case 0:
                [label setText:[NSString stringWithFormat:@"全部(%d)", self.shopDetail.startsendtime+self.shopDetail.okCount+self.shopDetail.badCount] ];
                break;
            case 1:
                [label setText:[NSString stringWithFormat:@"好评(%d)", self.shopDetail.startsendtime] ];
                break;
            case 2:
                [label setText:[NSString stringWithFormat:@"中评(%d)", self.shopDetail.okCount] ];
                break;
            case 3:
                [label setText:[NSString stringWithFormat:@"差评(%d)", self.shopDetail.badCount]];
                break;
            default:
                break;
        }
    }
    
    return self.shopDetail;
}


#pragma mark dowLoad


-(void)updataUI:(int)type{
    if (type == 1) {

    }else if(type == 15){

    }else {
  
    }
    
}

#pragma mark UIalertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [app SetTab:0];
    }
}
- (void)cancel: (id)sender
{
    if (twitterClient) {
        [twitterClient cancel];

        twitterClient = nil;
    }
}



#pragma mark UITableView

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = tvListView.contentOffset;  // 当前滚动位移
    CGRect bounds = tvListView.bounds;          // UIScrollView 可+视高度
    CGSize size = tvListView.contentSize;         // 滚动区域
    UIEdgeInsets inset = tvListView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(twitterClient == nil && hasMore){
            //读取更多数据
            [self getCommentList];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (UserCommentModel *mode in commentList) {
        if (!mode.value ) {
            [commentList removeObject:mode];
        }
    }
    return [commentList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] ;

        UILabel *ucommentLabel = [[UILabel alloc] init];
        ucommentLabel.frame=RectMake_LFL(80, 20, 300, 50);
        ucommentLabel.tag = 6;
        ucommentLabel.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
        ucommentLabel.lineBreakMode =NSLineBreakByWordWrapping;
        ucommentLabel.numberOfLines = 0;
        ucommentLabel.font = [UIFont boldSystemFontOfSize:12];
        [cell.contentView addSubview: ucommentLabel];
        
        UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, 0, 375, 0.5)];
        [cell.contentView addSubview:line];
        line.backgroundColor=[UIColor colorWithRed:225.0/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        
        UIView * line2=[[UIView alloc]initWithFrame:RectMake_LFL(0, 80, 375, 0.5)];
        [cell.contentView addSubview:line2];
        line2.backgroundColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        userIcon=[[UIImageView alloc]initWithFrame:RectMake_LFL(10, 15, 50, 50)];
        userIcon.image=[UIImage imageNamed:@"test_Icon.png"];
        userIcon.layer.masksToBounds=YES;
        userIcon.layer.cornerRadius=userIcon.frame.size.width/2;
        
        userIcon.backgroundColor=app.sysTitleColor;
        
        [cell.contentView addSubview:userIcon];
        
        userNameLabel =[[UILabel alloc]initWithFrame:RectMake_LFL(70, 15, 200, 14)];
        userNameLabel.font=[UIFont systemFontOfSize:16];
        [cell.contentView addSubview:userNameLabel];
        
        userTimeLabel =[[UILabel alloc] initWithFrame:RectMake_LFL(375-110, 13, 100, 12)];
        userTimeLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        userTimeLabel.textAlignment = NSTextAlignmentRight;
        userTimeLabel.font = [UIFont systemFontOfSize:11];

        [cell.contentView addSubview:userTimeLabel];
    }
    
    UserCommentModel *userModel = [commentList objectAtIndex:indexPath.row];
    if( userModel == nil){
        return nil;
    }
//    userIcon.image=userModel.image;
    userNameLabel.text=userModel.userName;
    userTimeLabel.text=[userModel.time substringWithRange:NSMakeRange(4, 11)];
    
    NSString *value = [NSString stringWithFormat:@"%@", userModel.value];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[value dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    UILabel *ucommentLabel = (UILabel *)[cell.contentView viewWithTag:6];
    ucommentLabel.attributedText = attrStr;//foodmodel.value;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return CGRectGetMaxY(RectMake_LFL(0, 0, 375, 80));
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
