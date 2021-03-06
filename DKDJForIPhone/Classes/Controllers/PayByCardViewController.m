//
//  PayByCardViewController.m
//  RenRenzx
//
//  Created by zhengjianfeng on 12-10-11.
//
//

#import "PayByCardViewController.h"

#import "EasyEat4iPhoneAppDelegate.h"
#import "tooles.h"
#import "LoadCell.h"

@implementation PayByCardViewController

@synthesize orders;
@synthesize userid;
@synthesize lastIndexPath;
@synthesize cardid;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择礼品卡";
    
    hasMore = false;
    orders = [[NSMutableArray array] retain];
    
    page = 1;
    NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
    
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    if ([uduserid intValue] > 0 )
    {
        NSLog(@"initWithUserId:%@", userid);
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
        
        //state 0 获取有余额的  其他值为获取所有
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",@"8",@"pagesize",uduserid,@"userid",@"0",@"state", nil];
        
        [twitterClient getMyCardListByUserId:param];
    }
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [pageindex release];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    
    //UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 51.0, 35.0)];
    //[search setBackgroundImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
    //[search setBackgroundImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateHighlighted];
    //[search setBackgroundImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateDisabled];
    //[search setTitle:@"确定" forState:UIControlStateNormal];
    
    //[search addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"确定"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"取消"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    //设置tableview为可编辑状态
    //如果是继承  uitableview 的则此处写法 self.super
    //self.tableView.allowsSelectionDuringEditing = YES;
	//[self.tableView setEditing:YES animated:YES];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [loadCell release];
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

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
    _progressHUD = nil;
}

- (void)ordersDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [twitterClient release];
    twitterClient = nil;
    [loadCell.spinner stopAnimating];
    
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [orders count];//已经存在列表中的数量
    
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
    
    
    //2. 获取list
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    
    if ([ary count] == 0) {
        hasMore = false;
        //无数据时会报错
        //[self.ordersTableView beginUpdates];
        //NSIndexPath *path = [NSIndexPath indexPathForRow:[orders count] inSection:0];
        //[self.ordersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationLeft];
        //[self.ordersTableView endUpdates];
        return;
    }
    
    //判断是否有下一页
    //int totalpage = [totalString intValue];
    
    {
        ++page;
        hasMore = true;
    }
    
    // 将获取到的数据进行处理 形成列表
    for (int i = 0; i < [ary count]; ++i) {
        
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        MyCardModel *model = [[MyCardModel alloc] initWithJsonDictionary:dic];
        [orders addObject:model];
        [model release];
    }
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [self.tableView reloadData];
    }
    else {
        
        int count = (int)[ary count];
        
        //每次只获取8个商家，若返回大于8个则只取8个
        if (count > 8)
        {
            count = 8;
        }
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orders count] + ((hasMore) ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//show load more cell
    if (indexPath.row == [orders count]) {
        return loadCell;
    }
    else {
        
		static NSString *CellTableIdentifier = @"OrderCellTableIdentifier";
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
		
        //蓝色
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            CGRect nameLabelRect = CGRectMake(5, 5, 260, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            nameLabel.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            //1.
            CGRect stateLabelRect = CGRectMake(260, 5, 60, 12);
            UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
            
            stateLabel.textAlignment = NSTextAlignmentLeft;
            stateLabel.font = [UIFont boldSystemFontOfSize:12];
            stateLabel.tag = 5;
            stateLabel.textColor = [UIColor orangeColor];
            stateLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview: stateLabel];
            [stateLabel release];
            
            //2.
            CGRect telLabelRect = CGRectMake(5,25, 260, 12);
            UILabel *telLabel = [[UILabel alloc] initWithFrame:
                                 telLabelRect];
            
            telLabel.textAlignment = NSTextAlignmentLeft;
            telLabel.font = [UIFont boldSystemFontOfSize:12];
            telLabel.textColor = [UIColor grayColor];
            telLabel.tag = 2;
            telLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview: telLabel];
            [telLabel release];
            
            //3.
            CGRect timeValueRect = CGRectMake(5, 40, 260, 12);
            UILabel *timeValue = [[UILabel alloc] initWithFrame:
                                  timeValueRect];
            
            timeValue.textAlignment = NSTextAlignmentLeft;
            timeValue.font = [UIFont boldSystemFontOfSize:12];
            timeValue.textColor = [UIColor grayColor];
            timeValue.tag = 3;
            timeValue.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:timeValue];
            [timeValue release];
            
		}
        
        MyCardModel *ordermodel = [orders objectAtIndex:indexPath.row];
        
        if( ordermodel == nil)
        {
            return nil;
        }
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        nameLabel.text = [[NSString alloc] initWithFormat:@"礼品卡卡号:%@",ordermodel.cardnum];
        
        UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
        telLabel.text = [[NSString alloc] initWithFormat:@"面值:%.1f",[ordermodel.point floatValue]];
        
        UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:3];
        timeLabel.text = [[NSString alloc] initWithFormat:@"余额:%.1f",[ordermodel.cmoney floatValue]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0 && indexPath.row == lastIndexPath.row){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}

//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row == [orders count]) {
        if (twitterClient) return;
        
        [loadCell.spinner startAnimating];
        
        NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
        
        twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(ordersDidReceive:obj:)];
        
        NSString *uduserid = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
        
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",@"8",@"pagesize",uduserid,@"userid", nil];
        
        [twitterClient getMyCardListByUserId:param];
        
    }
    else
    {
        //设置选中值
        MyCardModel* cardItem = [orders objectAtIndex:indexPath.row];
        cardItem.checked = !cardItem.checked;
        
        int newRow = (int)[indexPath row];
        
        //int oldRow = [lastIndexPath row];
        int oldRow = (lastIndexPath != nil) ? (int)[lastIndexPath row] : -1;
        
        if (newRow != oldRow && indexPath.row != [orders count])
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
            lastIndexPath = [indexPath copy];//一定要这么写，要不报错
        }
        else
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            //lastIndexPath = indexPath;
            lastIndexPath = [indexPath copy];//一定要这么写，要不报错
        }
    }
}

- (void)setEditing:(BOOL)editting animated:(BOOL)animated
{
	if (!editting)
	{
		for (MyCardModel* item in orders)
		{
			item.checked = NO;
		}
	}
	[super setEditing:editting animated:animated];
}

-(void)cancel:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)done:(id)sender{
    
    self.cardid = @"";
    
    for (MyCardModel *model in orders)
    {
        if(model.checked)
        {
            self.cardid = model.ckey;
        }
    }
    
    [self.delegate SelectCardViewControllerChanged:self.cardid];
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
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

@end
