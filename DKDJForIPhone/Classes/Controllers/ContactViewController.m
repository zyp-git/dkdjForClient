//
//  ContactViewController.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ContactViewController.h"

#import "tooles.h"

@implementation ContactViewController

@synthesize tempTableView;

- (id)initWithSomething:(NSString*)Something
{
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //UIColor *color = [UIColor colorWithRed:215.0f/255.0f green:9.0f/255.0f blue:21.0f/255.0f alpha:1.0f];
    
    //[UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    //直接进入会调用此函数 从其他页面进入也会调用此函数
    [super viewDidLoad];
    self.navigationItem.title = @"联系我们";
    
    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 380) style:UITableViewStyleGrouped];
    self.tempTableView.delegate = self;
    self.tempTableView.dataSource = self;
    [self.view addSubview:self.tempTableView];
    
    //ios 6下背景无法显示
    [self.tempTableView setBackgroundColor:[tooles getAppBackgroundColor]];
    //[self.view setBackgroundColor:[tooles getAppBackgroundColor]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: CellTableIdentifier] autorelease];
    }
    
    //if(indexPath.row == 0 )
    //{
        //cell.textLabel.text = @"客服电话：";
        //cell.detailTextLabel.text = @"4008-888-888";
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //}
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"系统网址";
        cell.detailTextLabel.text = @"http://www.ibogu.com.cn";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"邮箱地址：";
        cell.detailTextLabel.text = @"ibogu@foxmail.com";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
