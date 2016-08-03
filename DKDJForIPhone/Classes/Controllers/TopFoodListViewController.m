//
//  FoodListViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-28.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "TopFoodListViewController.h"
#import "FoodListCell.h"
#import "ShopCartViewController.h"
#import "FoodInOrderModel.h"
#import "FileController.h"

#import "LoginNewViewController.h"
#import "UIAlertTableView.h"
#import "HJAppConfig.h"
#import "FoodAttrModel.h"
#import "ShopDetailViewController.h"

@implementation TopFoodListViewController

/*16个每页
{"page":"1","total":"4", "foodlist":[{"FoodID":"1683","Name":"王老吉(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1680","Name":"旺仔牛奶(听)","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1667","Name":"雪碧(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1663","Name":"芬达(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1660","Name":"可乐(听)","Price":"4.5","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1654","Name":"杭味卤鸭腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1651","Name":"招牌烤鸡腿","Price":"11.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1647","Name":"秘制烤翅(2个)","Price":"8.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1645","Name":"皮蛋粥套餐","Price":"6.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1642","Name":"梅菜肉圆(1个)","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1640","Name":"香滑水蒸蛋","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1637","Name":"蔬菜蛋花汤","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1635","Name":"白粥套餐","Price":"5.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1631","Name":"奶黄包(2个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1628","Name":"卤蛋(1个)","Price":"2.0","Discount":"10.0","PackageFree":"0.0"},{"FoodID":"1625","Name":"原盅蒸饭","Price":"2.0","Discount":"10.0","PackageFree":"0.0"}]}
 */

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

@synthesize foods;
@synthesize foodtypeid;
@synthesize uduserid;
@synthesize defaultPath;
@synthesize imageDownload;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    NSLog(@"viewDidLoad");
    imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
    
    [self GetData];
    
    
}



-(void) GetData
{
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(foodsDidReceive:obj:)];
    
    [twitterClient getTopFoodListByShopId];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  
    

    
    foods = [[NSMutableArray array] retain];
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}  


- (void) FoodTypeViewControllerValueChanged:(NSString *)typevalue
{
    NSString *SortID = typevalue;
    
    if([SortID compare:@"0" ] == NSOrderedSame)
    {
        
    }
    else
    {
        [foods removeAllObjects];
        
        foodtypeid = SortID;
        [self GetData];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    NSLog(@"viewWillAppear");
    
        
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (id)initWithTypeId:(NSString*)type
{
    return self;
}

- (void)foodsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    [twitterClient release];
    twitterClient = nil;
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total 
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    
    if (pageString) {
        NSLog(@"pageindex: %@",pageString);
        NSLog(@"total: %@",totalString);
        NSLog(@"page: %d",page);
    }
    
    
    //2. 获取 foodlist
    //{"page":"1","total":"17", "foodlist":[{"foodid":"2869","foodname":"木瓜炖雪蛤","price":"33.0","num":"1000"}]}
    NSArray *ary = nil;
    ary = [dic objectForKey:@"Chartslist"];
    
    if ([ary count] == 0) {
        hasMore = false;
        [self.tableView reloadData];
        return;
    }
    
    //判断是否有下一页
    //int totalpage = [totalString intValue];
    //if( totalpage > page )
    {
        ++page;
        hasMore = true;
    }
    //else
    //{
    //    hasMore = false;
    //}
   
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        TopFoodModel *model = [[TopFoodModel alloc] initWithJsonDictionary:dic];
        [imageDownload addTask:model.foodid url:model.icon showImage:nil defaultImg:defaultPath];
        [foods addObject:model];
        [model release];
    }
    
    [imageDownload startTask];
    
    [self.tableView reloadData];
}


-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    for (int i = index; i < [arry count]; i++) {
        ImageDowloadTask *task = [arry objectAtIndex:i];
        TopFoodModel *model = [foods objectAtIndex:i];
        model.localPath = task.locURL;
    }
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
}

- (void)dealloc {
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

//餐品数量增加1
-(void)plusFoodToOrder:(id)sender
{
    row = [self.tableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    TopFoodModel *foodmodel = [foods objectAtIndex:row];
    ShopDetailViewController *shopdetail = [[[ShopDetailViewController alloc] initWithShopId:foodmodel.togoID] autorelease];
    
    [self.navigationController pushViewController:shopdetail animated:true];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [foods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
        
		static NSString *CellTableIdentifier = @"CellTableIdentifier";
		//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; 
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
		
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            //自定义布局 分别显示以下几项
            UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 50)];
            ico.image = [[UIImage alloc] initWithContentsOfFile:self.defaultPath];
            ico.tag = 5;//不能使用0
            [cell.contentView addSubview:ico];
            [ico release];
            //1. 名称
            CGRect nameLabelRect = CGRectMake(60, 5, 100, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            //2. 销量
            CGRect countLabelRect = CGRectMake(160, 5, 100, 15);
            UILabel *countLabel = [[UILabel alloc] initWithFrame:countLabelRect];
            
            countLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            countLabel.font = [UIFont boldSystemFontOfSize:14];
            countLabel.tag = 2;
            
            [cell.contentView addSubview: countLabel];
            [countLabel release];
            
            //3.店铺名称
            CGRect priceLabelRect = CGRectMake(60,25, 160, 25);
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:
                                 priceLabelRect];
            
            priceLabel.textAlignment = NSTextAlignmentLeft;
            priceLabel.font = [UIFont boldSystemFontOfSize:12];
            priceLabel.textColor = [UIColor grayColor];
            priceLabel.tag = 3;
            
            [cell.contentView addSubview: priceLabel];
            [priceLabel release];
            
                        
            //5. +
            UIButton *plusButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
            plusButton.frame = CGRectMake(225, 25, 80, 25);
            plusButton.tag = 4;
            [plusButton setTitle:@"看商家" forState:UIControlStateNormal];
            [plusButton setBackgroundImage:[UIImage imageNamed:@"titlebar_button_normal.png"] forState:UIControlStateNormal];
            [plusButton setBackgroundImage:[UIImage imageNamed:@"titlebar_button_pressed.png"] forState:UIControlStateSelected];//设置选择状态

            [plusButton addTarget:self action:@selector(plusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:plusButton];
            
            //2. 销量
            CGRect desLabelRect = CGRectMake(60, 55, 100, 20);
            UILabel *desLabel = [[UILabel alloc] initWithFrame:desLabelRect];
            
            desLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            desLabel.font = [UIFont boldSystemFontOfSize:14];
            desLabel.tag = 6;
            
            [cell.contentView addSubview: desLabel];
            [desLabel release];
		}
        
        //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
        
        TopFoodModel *foodmodel = [foods objectAtIndex:indexPath.row];
        
        if( foodmodel == nil)
        {
            return nil;
        }
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:5];
        UIImage *image = [[UIImage alloc] init];
        if (foodmodel.localPath == nil || foodmodel.localPath.length == 0) {
            image = [image initWithContentsOfFile:defaultPath];
        }else{
            image = [image initWithContentsOfFile:foodmodel.localPath];
        }
        [ico setImage:image];
        [image release];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = foodmodel.foodname;
    
        UILabel *countLabel = (UILabel *)[cell.contentView viewWithTag:2];
        countLabel.text = [NSString stringWithFormat:@"销量：%@", foodmodel.count];
    
        UILabel * priceLabel = (UILabel *)[cell.contentView viewWithTag:3];
    
        priceLabel.text = [NSString stringWithFormat:@"店铺名称：%@", foodmodel.togoName];
        
        UILabel *desLabel = (UILabel *)[cell.contentView viewWithTag:6];
        desLabel.text = foodmodel.des;
        NSLog(@"UITable foodid:%@",foodmodel.foodid );
        
        NSLog(@"shopcartDictForSaveFile.count:%lu",(unsigned long)shopcartDictForSaveFile.count );
        
        

        //[shopmodel release]; //此处不能做release操作，会导致程序报错
        //原因:
        //展开配件 灰色V按钮 蓝色按钮：UITableViewCellAccessoryDetailDisclosureButton
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;//(indexPath.row == [foods count]) ? 60 : 40;
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
	//加载更多数据的行被点击了，则加载下一页数据
    if (indexPath.row == [foods count]) {
        
    }
    else {
        NSLog(@"FoodListViewController->didSelectRowAtIndexPath : else indexPath.row == [shops count]");
        
    }
}

@end