//
//  GpsAddressViewController.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-6-29.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "GpsAddressViewController.h"


@implementation GpsAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"更改当前位置";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 2; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	if (section == 0) 
    {
        return 1;
    }
	else if (section == 1)
    {
        return 1;
    }
    
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) 
    {
        return 40.0f;
    }
	else if (indexPath.section == 1)
	{
        return 40.0f;
	}
    
	return 0.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.tableView) 
	{
        if(section == 0 )
        {
            return @"当前位置";
        }
        else
        {
            return @"定位";
        }
	}
	else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //分组列表时此处的indexPath.row同时在几个组里面都有效，注意进行区别
    if (indexPath.section == 0) 
    {
        if(indexPath.row == 0 )
        {
            //返回首页
            [self.navigationController popToRootViewControllerAnimated:YES];
            //[self.navigationController popToViewController:_viewController animated:YES];
        }
    }
    else if (indexPath.section == 1) 
    {
        if(indexPath.row == 0 )
        {
            //清除位置信息 进入首页重新定位
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uaddress"];
            [[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"ulat"];
            [[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"ulng"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0f;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellStyle style =  UITableViewCellStyleDefault;
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"BaseCell"];
	if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"BaseCell"] autorelease];
	
    NSString *crayon = @"当前位置";
    
    if( indexPath.section == 0)
    {
        NSString *uaddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"uaddress"];
        crayon = uaddress;
    }
    else
    {
        if (indexPath.row == 0) {
            crayon = @"重新定位";
        }
    }
    
	cell.textLabel.text = crayon;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
	cell.textLabel.textColor = [UIColor blackColor];
	return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {   
    /*
     if (indexPath.row % 2)  
     {  
     [cell setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]];  
     }
     else 
     {  
     [cell setBackgroundColor:[UIColor clearColor]];  
     }  
     */
    
    [cell setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]];
    cell.textLabel.backgroundColor = [UIColor clearColor];  
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];  
}  

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //视图将要消失 
}

@end