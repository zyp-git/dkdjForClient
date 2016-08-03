//
//  DisclaimerViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "tooles.h"

@implementation DisclaimerViewController

@synthesize tempTableView;

- (id)initWithSomething:(NSString*)Something
{
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = @"使用帮助";
    
    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 380) style:UITableViewStyleGrouped];
    self.tempTableView.delegate = self;
    self.tempTableView.dataSource = self;
    [self.view addSubview:self.tempTableView];
    
    [self.tempTableView setBackgroundColor:[tooles getAppBackgroundColor]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        
        CGRect nameLabelRect = CGRectMake(5, 5, 260, 20);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
        
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 1;
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        
        CGRect telLabelRect = CGRectMake(5,25, 260, 40);
        UILabel *telLabel = [[UILabel alloc] initWithFrame:
                             telLabelRect];
        
        telLabel.textAlignment = NSTextAlignmentLeft;
        telLabel.font = [UIFont boldSystemFontOfSize:12];
        telLabel.textColor = [UIColor grayColor];
        telLabel.tag = 2;
        
        [cell.contentView addSubview: telLabel];
        [telLabel release];
        
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    
    UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    if(indexPath.row == 0 )
    {
        nameLabel.text = @"第一步：确定您的位置";
        valueLabel.text = @"通过自行选择所处的建筑物或者通过地图定位找出周边可以配送到您所处位置的商家";
    }
    else if(indexPath.row == 1)
    {
        nameLabel.text = @"第二步：选择餐厅";
        valueLabel.text = @"从系统给出的商家列表中选择其中的一家，进入商家信息页面了解商家详情";    
    }
    else if(indexPath.row == 2)
    {
        nameLabel.text = @"第三步：选择餐品";
        valueLabel.text = @"从商家的餐品列表中根据个人需要选择相应的餐品加入购物车";    
    }
    else if(indexPath.row == 3)
    {
        nameLabel.text = @"第四步：提交订单，等待美食送上门";
        valueLabel.text = @"填写好送货信息：姓名 电话 地址，提交订单，等待美食送货上门";
    }
    valueLabel.lineBreakMode = NSLineBreakByWordWrapping; 
    valueLabel.numberOfLines = 2;
    
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.backgroundColor = [UIColor clearColor];
    
    valueLabel.font = [UIFont systemFontOfSize:12];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    valueLabel.textColor = [UIColor grayColor];
    valueLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
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
