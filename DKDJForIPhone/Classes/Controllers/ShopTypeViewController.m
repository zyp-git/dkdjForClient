//
//  ShopTypeViewController.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-6-29.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ShopTypeViewController.h"
#import "ShopListViewController.h"

@implementation ShopTypeViewController

@synthesize tempTableView;

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = @"商家分类";
    
    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 380) style:UITableViewStylePlain];
    self.tempTableView.delegate = self;
    self.tempTableView.dataSource = self;
    [self.view addSubview:self.tempTableView];
    
    self.tempTableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {

        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier: CellTableIdentifier] autorelease];
        
        
    }
    
    if(indexPath.row == 0 )
    {
        cell.textLabel.text = @"商务简餐";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"中式炒菜";
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"西式日韩";
    }
    else if(indexPath.row == 3)
    {
        cell.textLabel.text = @"甜品小吃";
    }
    else if(indexPath.row == 4)
    {
        cell.textLabel.text = @"所有分类";

    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //设置UItableCelView背景  此处可以替换为背景图片，则可以实现更美观的列表
    /*
    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    backgrdView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = backgrdView;
    [backgrdView release];
     */
    
    return cell;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if(indexPath.row == 0 )
    {
        ShopListViewController *controller = [[[ShopListViewController alloc] initWithShopType:@"1" shoptypename:@"商务简餐"] autorelease];
        [self.navigationController pushViewController:controller animated:true];
    }
    else if( indexPath.row == 1 )
    {
        ShopListViewController *controller = [[[ShopListViewController alloc] initWithShopType:@"2" shoptypename:@"中式炒菜"] autorelease];
        [self.navigationController pushViewController:controller animated:true];
    }
    else if( indexPath.row == 2 )
    {
        ShopListViewController *controller = [[[ShopListViewController alloc] initWithShopType:@"3" shoptypename:@"西式日韩"] autorelease];
        [self.navigationController pushViewController:controller animated:true];
    }
    else if( indexPath.row == 3 )
    {
        ShopListViewController *controller = [[[ShopListViewController alloc] initWithShopType:@"4" shoptypename:@"甜品小吃"] autorelease];
        [self.navigationController pushViewController:controller animated:true];
    }
    else if( indexPath.row == 4 )
    {
        ShopListViewController *controller = [[[ShopListViewController alloc] initWithLocation] autorelease];
        [self.navigationController pushViewController:controller animated:true];
    }
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
    [super dealloc];
}

@end
