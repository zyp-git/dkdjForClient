//
//  ShopDetailViewController.m
//  EasyEat4iPhone
//
//  Created by dev on 12-1-5.
//  Copyright 2012 ihangjing.com. All rights reserved.
//

#import "GiftDetailViewController.h"
#import "FoodListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginNewViewController.h"
#import "GiftOrderViewController.h"
//原先此视图视图代码实现uitableview（未使用xib）但是遇到一个问题表格的最底部文字要手指拉着才能看，一放开会弹下去看不到，原因未明修改成从xib加载症状消失
@implementation GiftDetailViewController

@synthesize GiftId;
@synthesize GiftModel;
@synthesize telString;
@synthesize uduserid;
@synthesize lotterID;
//@synthesize shopdetailTableView;

- (id)initWithGiftId:(NSString*)giftId
{
    //if (self = [super initWithNibName:@"ShopDetailView" bundle:nil]) {
    //        //}
    //self.shopdetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    
    //self.shopdetailTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    //self.shopdetailTableView.delegate = self;
    //self.shopdetailTableView.dataSource = self;
    //[self.view addSubview:self.shopdetailTableView];
    //if (self = [super initWithNibName:@"ShopDetailView" bundle:nil]) {
    //    self.navigationItem.title = @"更改当前位置";
    //}
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    /*
    //设置UIView为圆角
    self.tableView.layer.cornerRadius = 10;//设置那个圆角的有多圆
    self.tableView.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    self.view.layer.borderColor = [[UIColor redColor] CGColor];//设置边框的颜色
    self.view.layer.masksToBounds = YES;//设为NO去试试
    */
    //UIView *view = (UIView *)[self.tableView.subviews viewWithTag:3];
    
    /*
    for(UIView *view in [self.tableView subviews])
    {
        view.layer.cornerRadius = 10;//设置那个圆角的有多圆
        view.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
        view.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
        view.layer.masksToBounds = YES;//设为NO去试试
        
        CGRect detailRect = CGRectMake(10,55, 200, 110);
        //[view setFrame:detailRect];
        [view.layer setFrame:detailRect];
    }
    */
    
    [self GetGiftDetail:giftId];
    
    //[GotoOrder setBackgroundImage:[UIImage imageNamed:@"titlebar_button_pressed.png"] forState:UIControlStateSelected];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
    [_progressHUD show:YES];  
    
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)GetGiftDetail:(NSString*)giftId
{
    
    NSLog(@"GetShopDetail:%@", giftId);
    
    GiftId = giftId;
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getGiftDetailDidSucceed:obj:)];
    
    //ulat = @"30.284243";
    //ulng = @"120.153432";
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:GiftId,@"id", nil];
    
    [twitterClient getGiftDetailByGiftId:param];
    
    connection = twitterClient;
}

-(void)getUserInfo:(TwitterClient*)sender obj:(NSObject*)obj
{
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    connection = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    NSDictionary *dict = (NSDictionary*)obj;
    userPoint = [[dict objectForKey:@"Point"] intValue];
    if (selectType == 1) {
        [self gotoLotter];
    }else{
        [self gotoCart];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //跳转到填写地址界面
    GiftOrderViewController *addorderView = [[[GiftOrderViewController alloc] initWithLotterID:self.lotterID gName:GiftModel.gName gPoint:[NSString stringWithFormat:@"%d", GiftModel.lotterPoint]] autorelease];
    
    [self.navigationController pushViewController:addorderView animated:YES];
}
- (void)getPirzeRecord:(TwitterClient*)sender obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
    connection = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    NSDictionary *dict = (NSDictionary*)obj;
    int state = [[dict objectForKey:@"state"] intValue];
    if (state == 1) {
        self.lotterID = [dict objectForKey:@"rid"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"gift_detail_c_sucess", @"恭喜您抽到该礼品") delegate:self cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"gift_detail_c_failed_0", @"您没有抽到该礼品") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (void)getGiftDetailDidSucceed:(TwitterClient*)sender obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    //[progressWindow hide];
    NSLog(@"getShopDetailDidSucceed");
    [twitterClient release];
    twitterClient = nil;
    connection = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    
    NSDictionary *dic = (NSDictionary*)obj;
    self.GiftModel = [[GiftInfoModel alloc] initWithJsonDictionaryOfDetail:dic];
   

    self.navigationItem.title = GiftModel.gName;

    [self.tableView reloadData];
    
    NSLog(@"reloadData");
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}  

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    ulat = [[NSUserDefaults standardUserDefaults] stringForKey:@"ulat"];
	ulng = [[NSUserDefaults standardUserDefaults] stringForKey:@"ulng"];
    userPoint = -1;
    //显示加载中
    
}

-(void)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
}

- (BOOL)IsLogin
{
    [self refreshFields];
    NSLog(@"islogin userid:%@", self.uduserid);
    
    if([self.uduserid intValue]  > 0 )  //[uduserid intValue]
    {
        if (userPoint == -1) {
            _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            
            _progressHUD.dimBackground = YES;
            
            [self.view addSubview:_progressHUD];
            [self.view bringSubviewToFront:_progressHUD];
            _progressHUD.delegate = self;
            _progressHUD.labelText = CustomLocalizedString(@"loading", @"加载中...");
            [_progressHUD show:YES];
            twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getUserInfo:obj:)];
            
            [twitterClient getUserInfoByUserId:self.uduserid];
            
            connection = twitterClient;
            return NO;
        }
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title = CustomLocalizedString(@"login", @"会员登录");
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        //[self.navigationController pushViewController:LoginNewViewController animated:true];
        
        [LoginNewViewController release];
        
        return NO;
    }
}

-(void)gotoCart{
    if (userPoint < GiftModel.needPoint) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"gift_detail_no_point", @"您的积分不够兑换") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    GiftOrderViewController *addorderView = [[[GiftOrderViewController alloc] initWithCart:GiftModel.gID GName:GiftModel.gName gPoint:[NSString stringWithFormat:@"%d", GiftModel.needPoint] GType:GiftModel.type] autorelease];
    
    [self.navigationController pushViewController:addorderView animated:YES];
}

-(void)gotoLotter{
    if (userPoint < GiftModel.lotterPoint) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"gift_detail_no_point_0", @"您的积分不够抽奖") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    userPoint -= GiftModel.lotterPoint;
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = CustomLocalizedString(@"public_send", @"提交中...");
    [_progressHUD show:YES];
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getPirzeRecord:obj:)];
    
    [twitterClient getPrizeRecord:self.uduserid pID:GiftModel.gID];
    
    connection = twitterClient;
}

-(void)lotter:(id)sender{
    if( (![self IsLogin]) )
    {
        selectType = 1;
        return;
    }
    [self gotoLotter];
    
}
-(void)exchan:(id)sender{
    if( (![self IsLogin]) )
    {
         selectType = 2;
        return;
    }
    if(self.GiftModel.stocks < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalizedString(@"public_notice", @"提醒") message:CustomLocalizedString(@"gift_detail_no_gift", @"对不起，礼品已经被兑换完！") delegate:nil cancelButtonTitle:CustomLocalizedString(@"public_ok", @"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    [self gotoCart];
    
    
}
#pragma mark - Table View Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	
    return nil;
}

//设置rowHeight  
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
    return 40.0f; 
}  

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.GiftModel == nil) {
        return 0;
    }
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *PresidentCellIdentifier = @"GiftDetailCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:style 
                                       reuseIdentifier:PresidentCellIdentifier] autorelease];
        if (indexPath.section == 0)
        {
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 39)];
            name.tag = 1;
            name.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:name];
            
            [name release];
            
            UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, 205, 39)];
            value.tag = 2;
            value.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:value];
            
            [value release];
        }else{
            UIImage *normalImage1 = [UIImage imageNamed:@"titlebar_button_normal.png"];
            UIImage *highlightedImage1 = [UIImage imageNamed:@"titlebar_button_pressed.png"];
            
            UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 100, 39)];
            btn1.tag = 1;
            btn1.backgroundColor = [UIColor clearColor];
            
            [btn1 setTitle:CustomLocalizedString(@"gift_detail_buy", @"兑换") forState:UIControlStateNormal];
            [btn1  setBackgroundImage:normalImage1 forState:UIControlStateNormal];
            [btn1 setBackgroundImage:highlightedImage1  forState:UIControlStateHighlighted];
            [btn1 addTarget:self action:@selector(exchan:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn1];
            
            [btn1 release];
            
            /*UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 100, 39)];
            btn2.tag = 1;
            btn2.backgroundColor = [UIColor clearColor];
            [btn2 setTitle:@"抽奖" forState:UIControlStateNormal];
            [btn2  setBackgroundImage:normalImage1 forState:UIControlStateNormal];
            [btn2 setBackgroundImage:highlightedImage1  forState:UIControlStateHighlighted];
            [btn2 addTarget:self action:@selector(lotter:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn2];
            
            [btn2 release];*/
        }
    }
    
    if (indexPath.section == 0) {
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *value = (UILabel *)[cell.contentView viewWithTag:2];
        switch (row) {
            case 0:
                name.text = CustomLocalizedString(@"gift_order_list_g_name", @"礼品名称：");
                value.text = GiftModel.gName;
                break;
            case 1:
                name.text = CustomLocalizedString(@"gift_list_req_point", @"兑换积分：");
                value.text = [NSString stringWithFormat:@"%d", GiftModel.needPoint];
                break;
            /*case 1:
                name.text = @"抽奖积分：";
                value.text = [NSString stringWithFormat:@"%d", GiftModel.lotterPoint];
                break;*/
            case 2:
                name.text = CustomLocalizedString(@"gift_detail_money", @"礼品价格：");
                value.text = GiftModel.price;
                break;
            case 3:
                name.text = CustomLocalizedString(@"gift_list_count", @"剩余数量：");
                value.text = [NSString stringWithFormat:@"%d", GiftModel.stocks];;
                break;
            /*case 5:
                name.text = @"自取地址：";
                value.text = GiftModel.pkAddress;
                break;*/
            default:
                break;
        }
    }
    
    /*if(self.dic == nil)
    {
        NSLog(@"dic==nil");
        return cell;
    }
    
    NSLog(@"dic!=nil");
    
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
    
    if( indexPath.section == 1 )
    {
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        switch (row) {
            case 0:
            {
                cell.textLabel.text = @"商家地址";
                cell.detailTextLabel.text = [dic objectForKey:@"address"];
            }
            break;
            case 1:
            {
                cell.textLabel.text = @"订餐电话";
                if([[dic objectForKey:@"isshowphone"] isEqualToString:@"0"])
                {
                    //不显示电话
                   cell.detailTextLabel.text =  @"暂无此商家电话";
                }
                else
                {
                    cell.detailTextLabel.text = [dic objectForKey:@"tel"];
                }
            }
            break;
            case 2:
            {
                cell.textLabel.text = @"配送机构";
                cell.detailTextLabel.text = [dic objectForKey:@"sendtype"];
            }
            break;
            case 3:
            {
                cell.textLabel.text = @"商家简介";
                cell.detailTextLabel.text = [self.dic objectForKey:@"desc"];
                cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping; 
                cell.detailTextLabel.textColor = [UIColor grayColor];
                // 列寬
                CGFloat contentWidth = self.tableView.frame.size.width;
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:13];
                
                // 該行要顯示的內容
                NSString *content = [self.dic objectForKey:@"desc"];
                
                // 計算出顯示完內容需要的最小尺寸
                CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                
                CGRect rect = [cell.detailTextLabel textRectForBounds:cell.detailTextLabel.frame limitedToNumberOfLines:0];
                
                // 設置顯示榘形大小
                rect.size = size;
                // 重置列文本區域
                cell.detailTextLabel.frame = rect;
                
                // 設置自動換行(重要)
                cell.detailTextLabel.numberOfLines = 0;
                // 設置顯示字體(一定要和之前計算時使用字體一至)
                cell.detailTextLabel.font = font;
            }
            break;
            default:
                break;
        }
    }
    else
    {
        // 最低起送 送餐费用
        NSString *sentfee = [self.dic objectForKey:@"sendmoney"];
        
        NSString *timeString = [NSString stringWithFormat:@"%@-%@ %@-%@", [dic objectForKey:@"Time1Start"], [dic objectForKey:@"Time1End"], [dic objectForKey:@"Time2Start"], [dic objectForKey:@"Time2End"]];
        
        NSString *distance = [self.dic objectForKey:@"distance"];
        
        CGRect LabelRect1 = CGRectMake(20, 10, 80, 15);
        UILabel *nameLabel1 = [[UILabel alloc] initWithFrame:LabelRect1];
        
        nameLabel1.textAlignment = NSTextAlignmentLeft;
        nameLabel1.text = @"服务时间:";
        nameLabel1.font = [UIFont boldSystemFontOfSize:14];
        nameLabel1.tag = 1;
        nameLabel1.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel1];
        [nameLabel1 release];

        CGRect ValueRect1 = CGRectMake(85, 10, 180, 15);
        UILabel *valueLabel1 = [[UILabel alloc] initWithFrame:ValueRect1];
        
        valueLabel1.textAlignment = NSTextAlignmentLeft;
        valueLabel1.text = timeString;
        valueLabel1.font = [UIFont boldSystemFontOfSize:14];
        valueLabel1.tag = 10;
        valueLabel1.textColor = [UIColor orangeColor];
        valueLabel1.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: valueLabel1];
        [valueLabel1 release];

        
        CGRect LabelRect2 = CGRectMake(20, 30, 80, 15);
        UILabel *nameLabel2 = [[UILabel alloc] initWithFrame:LabelRect2];

        nameLabel2.textAlignment = NSTextAlignmentLeft;
        nameLabel2.text = @"送餐费用:";
        nameLabel2.font = [UIFont boldSystemFontOfSize:14];
        nameLabel2.tag = 3;
        nameLabel2.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel2];
        [nameLabel2 release];
        
        
        CGRect ValueRect2 = CGRectMake(85,30, 180, 15);
        UILabel *valueLabel2 = [[UILabel alloc] initWithFrame:ValueRect2];
        
        valueLabel2.textAlignment = NSTextAlignmentLeft;
        valueLabel2.text = sentfee;
        valueLabel2.font = [UIFont boldSystemFontOfSize:14];
        valueLabel2.tag = 20;
        valueLabel2.textColor = [UIColor orangeColor];
        valueLabel2.backgroundColor = [UIColor clearColor];

        //---------------------
        //保存当前商家配送费 购物车中需要使用
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[[self.dic objectForKey:@"sendmoney"] stringByReplacingOccurrencesOfString :@"￥" withString:@""] forKey:@"shopcartsentmoney"];
        
        //保存商家的状态 提交订单中送餐时间有关联
        [defaults setObject:[[self.dic objectForKey:@"status"] stringByReplacingOccurrencesOfString :@"￥" withString:@""] forKey:@"shopcartstatus"];
        [defaults setObject:@"0" forKey:@"ordertype"];
        [defaults synchronize];
        //---------------------
        
        [cell.contentView addSubview: valueLabel2];
        [valueLabel2 release];
        
        CGRect LabelRect3 = CGRectMake(20, 50, 80, 15);
        UILabel *nameLabel3 = [[UILabel alloc] initWithFrame:LabelRect3];
        
        nameLabel3.textAlignment = NSTextAlignmentLeft;
        nameLabel3.text = @"距离您约:";
        nameLabel3.font = [UIFont boldSystemFontOfSize:14];
        nameLabel3.tag = 2;
        nameLabel3.backgroundColor = [UIColor clearColor];

        [cell.contentView addSubview: nameLabel3];
        [nameLabel3 release];
        
        CGRect ValueRect3 = CGRectMake(85, 50, 180, 15);
        UILabel *valueLabel3 = [[UILabel alloc] initWithFrame:ValueRect3];
        
        valueLabel3.textAlignment = NSTextAlignmentLeft;
        valueLabel3.text = distance;
        valueLabel3.font = [UIFont boldSystemFontOfSize:14];
        valueLabel3.tag = 30;
        valueLabel3.textColor = [UIColor orangeColor];
        valueLabel3.backgroundColor = [UIColor clearColor];

        [cell.contentView addSubview: valueLabel3];
        [valueLabel3 release];
        
    }
    [rowAsNum release];*/

    return cell;
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
        
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //输入框点击行时不做任何处理

    return nil;

}

- (void)cancel: (id)sender
{
    if (connection) {
        [connection cancel];
        [connection autorelease];
        connection = nil;
    }
    
    //[progressWindow hide];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [dic release];
    [super dealloc];
}

@end
