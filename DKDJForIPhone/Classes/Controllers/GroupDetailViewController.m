//
//  GroupDetailViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-10.
//
//

#import "GroupDetailViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "LoginNewViewController.h"
#import "FoodModel.h"
#import "FoodInOrderModel.h"

#import "FileController.h"

@implementation GroupDetailViewController

@synthesize shopid;
@synthesize dic;
@synthesize GroupId;
@synthesize title;
@synthesize price;
@synthesize uduserid;

- (id)initWithGroupId:(NSString*)shopId
{
    if (self = [super initWithNibName:@"ShopDetailView" bundle:nil]) {
        self.navigationItem.title = @"团购";
    }
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    [self GetShopDetail:shopId];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"参团"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(gotoOrder)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    self.shopcartDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)GetShopDetail:(NSString*)groupId
{
    
    NSLog(@"GetGroupDetail:%@", groupId);
    
    GroupId = groupId;
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getShopDetailDidSucceed:obj:)];
    
    [twitterClient getGroupDetailById:GroupId];
    
    connection = twitterClient;
}

- (void)getShopDetailDidSucceed:(TwitterClient*)sender obj:(NSObject*)obj;
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    NSLog(@"getShopDetailDidSucceed");
    [twitterClient release];
    twitterClient = nil;
    connection = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    
    self.dic = (NSDictionary*)obj;

    self.title = [self.dic objectForKey:@"Title"];
    self.price = [self.dic objectForKey:@"Discount"];
    self.shopid = [self.dic objectForKey:@"SupplyerId"];
    
    //测试
    //self.shopid = @"1";
    
    self.navigationItem.title = self.title;
    
    [self.tableView reloadData];
    
    //---------------------
    //保存当前商家配送费 购物车中需要使用
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.dic objectForKey:@"Inve2"]  forKey:@"shopcartsentmoney"];
    [defaults setObject:@"1" forKey:@"shopcartstatus"];
    [defaults setObject:@"1" forKey:@"ordertype"];
    [defaults synchronize];
    //---------------------
    
    NSLog(@"reloadData");
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

- (void)gotoOrder
{
    //进入购物车 进入购物车页面
    //判断购物车中是否有产品 有则需要清除
    if( (![self IsLogin]) )
    {
        return;
    }
    
    //检查购物车 如果不是此商家的则 需要清除购物车
    //NSString *shopcartshopid = [[NSUserDefaults standardUserDefaults] stringForKey:@"shopcartshopid"];
    
    //还原购物车
    self.shopcartDictForSaveFile = [NSMutableDictionary dictionaryWithDictionary:[FileController loadShopCart]];
    
    [self.shopcartDict removeAllObjects];
    
    for(NSString *key in self.shopcartDictForSaveFile)
    {
        NSDictionary *dic1 = [self.shopcartDictForSaveFile objectForKey:key];
        
        FoodInOrderModel *fmodelSC = [[FoodInOrderModel alloc] initWithDictionary:dic1];
        
        [self.shopcartDict setObject:fmodelSC forKey:key];
    }
    
    if(self.shopcartDict.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的购物车中有其商品，需要清空购物车后才能参团？" delegate:self cancelButtonTitle:@"取消." otherButtonTitles:@"清空",nil];
        
        [alert show];
        [alert release];
    }
    else
    {
        [self AddtoCart];
    }
}

-(void)AddtoCart
{
    NSDictionary *dicfix = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"foodid",self.title,@"foodname",self.price,@"price",@"1",@"foodCount",nil];
    
    FoodInOrderModel *model = [[FoodInOrderModel alloc] initWithDictionary:dicfix];

    //加入购物车
    [self.shopcartDict setObject: model forKey:model.foodid];
    NSLog(@"加入购物车 forKey:%@", model.foodname);
    
    {
        //修改 tabbar 的 badgeValue 底部导航右上角的数字
        UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:3];
        tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",1];
    }
    
    //保存购物车中商家的编号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:shopid forKey:@"shopcartshopid"];
    [defaults synchronize];
    
    //保存购物车
    //进行转换
    [self.shopcartDictForSaveFile removeAllObjects];
    
    for(NSString *key in self.shopcartDict)
    {
        FoodInOrderModel *fmodelX = [[FoodInOrderModel alloc] init];
        
        fmodelX = [self.shopcartDict objectForKey:key];
        
        NSString * c = [[NSString alloc] initWithFormat :@"%d", fmodelX.foodCount];
        NSString * p = [[NSString alloc] initWithFormat :@"%f", fmodelX.price];
        
        NSDictionary *cartdic = [[NSDictionary alloc]initWithObjectsAndKeys:fmodelX.foodid,@"foodid",fmodelX.foodname,@"foodname",p,@"price",c,@"foodCount",nil];
        
        [self.shopcartDictForSaveFile setObject: cartdic forKey:fmodelX.foodid];
        
        NSLog(@"fmodelX:%@, %d, %@", fmodelX.foodid,fmodelX.foodCount,c);
    }
    
    NSLog(@"self.shopcartDictForSaveFile:%lu", (unsigned long)self.shopcartDictForSaveFile.count);
    [FileController saveShopCart:self.shopcartDictForSaveFile];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        
    }
    else if( buttonIndex == 1 )
    {
        //清空购物车
        [self.shopcartDict removeAllObjects];
        //加入新的餐品到购物车
        [self AddtoCart];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ulat = [[NSUserDefaults standardUserDefaults] stringForKey:@"ulat"];
	ulng = [[NSUserDefaults standardUserDefaults] stringForKey:@"ulng"];
    
    
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
        return YES;
    }
    else
    {
        LoginNewViewController *LoginController = [[LoginNewViewController alloc] init];
        
        LoginController.title =@"会员登录";
        
        //注意：此处这样实现可以显示有顶部navigationbar的试图
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:LoginController];
        //使用 presentModalViewController可创建模式对话框，可用于视图之间的切换 底部不出现tab bar
        [self presentViewController:navController animated:YES completion:nil];
        //[self.navigationController pushViewController:LoginNewViewController animated:true];
        
        [LoginNewViewController release];
        
        return NO;
    }
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
	if (tableView == self.tableView)
	{
        if(section == 1 )
        {
            return @"团购详情";
        }
    }
    
    return nil;
}

//设置rowHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 )
    {
        return 80.f;
    }
    else if(indexPath.section == 1 )
    {
        if( indexPath.row == 3 )
        {
            //自适应高度
            // 列寬
            CGFloat contentWidth = self.tableView.frame.size.width;
            // 用何種字體進行顯示
            UIFont *font = [UIFont systemFontOfSize:13];
            
            // 該行要顯示的內容
            NSString *content = [self.dic objectForKey:@"desc"];
            // 計算出顯示完內容需要的最小尺寸
            CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            
            // 這裏返回需要的高度
            return size.height+80;
            
            //return 200.0f;
        }
        else
        {
            return 40.0f;
        }
    }
    return 40.0f;
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if( section == 1 )
    {
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *PresidentCellIdentifier = @"ShopDetailCellIdentifier";
    UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentCellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:style
                                       reuseIdentifier:PresidentCellIdentifier] autorelease];
    }
    
    if(self.dic == nil)
    {
        NSLog(@"dic==nil");
        return cell;
    }
    
    NSLog(@"dic!=nil");
    
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:(int)row];
    
    if( indexPath.section == 1 )
    {
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        /*
         {"gId":"10","Title":"团购测试项目","nowdis":"5.0","Inve3":"0天-09时-34分-36秒","price":"100.0","Discount":"50.0","InUser":"5","togoname":"山东人家","Inve4":"测试一下而已木有地址"}
         */
        switch (row) {
            case 0:
            {
                cell.textLabel.text = @"商家名称";
                cell.detailTextLabel.text = [dic objectForKey:@"togoname"];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"商家地址";
                cell.detailTextLabel.text = [dic objectForKey:@"Inve4"];
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"特别提醒";
                cell.detailTextLabel.text = [dic objectForKey:@"tixing"];
                
                // 列寬
                CGFloat contentWidth = self.tableView.frame.size.width;
                
                // 用何種字體進行顯示
                UIFont *font = [UIFont systemFontOfSize:13];
                
                // 該行要顯示的內容
                NSString *content = [self.dic objectForKey:@"tixing"];
                
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
            case 3:
            {
                cell.textLabel.text = @"团购简介";
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
        
        /*
        CGRect LabelRect1 = CGRectMake(20, 10, 80, 15);
        UILabel *nameLabel1 = [[UILabel alloc] initWithFrame:LabelRect1];
        
        nameLabel1.textAlignment = NSTextAlignmentLeft;
        nameLabel1.text = @"价格:";
        nameLabel1.font = [UIFont boldSystemFontOfSize:14];
        nameLabel1.tag = 1;
        nameLabel1.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel1];
        [nameLabel1 release];
        */
        CGRect ValueRect1 = CGRectMake(20, 10, 280, 15);
        UILabel *valueLabel1 = [[UILabel alloc] initWithFrame:ValueRect1];
        
        NSString *prices = [[NSString alloc] initWithFormat:@"原价:%@ 折扣:%@ 现价:%@ 运费:%@",[self.dic objectForKey:@"price"],[self.dic objectForKey:@"nowdis"],[self.dic objectForKey:@"Discount"],[self.dic objectForKey:@"Inve2"] ];
        
        valueLabel1.textAlignment = NSTextAlignmentLeft;
        valueLabel1.text = prices;
        valueLabel1.font = [UIFont boldSystemFontOfSize:14];
        valueLabel1.tag = 10;
        valueLabel1.textColor = [UIColor orangeColor];
        valueLabel1.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: valueLabel1];
        [valueLabel1 release];
        
        
        CGRect LabelRect2 = CGRectMake(20, 30, 80, 15);
        UILabel *nameLabel2 = [[UILabel alloc] initWithFrame:LabelRect2];
        
        nameLabel2.textAlignment = NSTextAlignmentLeft;
        nameLabel2.text = @"剩余时间:";
        nameLabel2.font = [UIFont boldSystemFontOfSize:14];
        nameLabel2.tag = 3;
        nameLabel2.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel2];
        [nameLabel2 release];
        
        
        CGRect ValueRect2 = CGRectMake(85,30, 180, 15);
        UILabel *valueLabel2 = [[UILabel alloc] initWithFrame:ValueRect2];
        
        valueLabel2.textAlignment = NSTextAlignmentLeft;
        valueLabel2.text = [self.dic objectForKey:@"Inve3"];
        valueLabel2.font = [UIFont boldSystemFontOfSize:14];
        valueLabel2.tag = 20;
        valueLabel2.textColor = [UIColor orangeColor];
        valueLabel2.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: valueLabel2];
        [valueLabel2 release];
        
        CGRect LabelRect3 = CGRectMake(20, 50, 80, 15);
        UILabel *nameLabel3 = [[UILabel alloc] initWithFrame:LabelRect3];
        
        nameLabel3.textAlignment = NSTextAlignmentLeft;
        nameLabel3.text = @"参团人数:";
        nameLabel3.font = [UIFont boldSystemFontOfSize:14];
        nameLabel3.tag = 2;
        nameLabel3.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: nameLabel3];
        [nameLabel3 release];
        
        CGRect ValueRect3 = CGRectMake(85, 50, 180, 15);
        UILabel *valueLabel3 = [[UILabel alloc] initWithFrame:ValueRect3];
        
        valueLabel3.textAlignment = NSTextAlignmentLeft;
        valueLabel3.text = [self.dic objectForKey:@"InUser"];
        valueLabel3.font = [UIFont boldSystemFontOfSize:14];
        valueLabel3.tag = 30;
        valueLabel3.textColor = [UIColor orangeColor];
        valueLabel3.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview: valueLabel3];
        [valueLabel3 release];
        
    }
    [rowAsNum release];
    
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