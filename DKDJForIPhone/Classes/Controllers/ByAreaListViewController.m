//
//  ShopListViewController.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-29.
//  Copyright 2011 ihangjing.com. All rights reserved.
//

#import "ByAreaListViewController.h"
#import "LoadCell.h"
#import "ShopListCell.h"
#import "GiftDetailViewController.h"
#import "UserAddressMode.h"
#import "AreaMode.h"
#import "ShopListViewController.h"
@implementation ByAreaListViewController

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 50

@synthesize area;
@synthesize aid;
@synthesize gTypeID;
@synthesize cTypeID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

	}
    [self initPara];
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    page = 1;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (Return) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Return = NO;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    NSBundle *myBundle = [NSBundle mainBundle];
    [myBundle release];
    self.area = [[NSMutableArray array] retain];
    page = 1;
    [self getAddrList];
    
    
    	
}

- (void)areaDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    
    NSInteger prevCount = [self.area count];//已经存在列表中的数量
    
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
    /*if (hasMore) {
     [self.tableView deleteRowsAtIndexPaths:[gifts count] withRowAnimation:YES];
     }*/
    if ([ary count] == 0) {
        hasMore = false;
        
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    if( totalpage > page )
    {
        ++page;
        hasMore = true;
    }
    else
    {
        [loadCell setType:MSG_TYPE_NO_MORE];
        hasMore = false;
    }
    //特别注意：此处如果设置未false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    
    if (page == 1) {
        
        [self.area removeAllObjects];
        prevCount = 0;
    }
    
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        AreaMode *model = [[AreaMode alloc] initWithJsonDictionaryByArea:dic];
        [self.area addObject:model];
        [model release];
    }
    if (prevCount == 0) {
        //如果是第一页则直接加载表格 刚进来没有数据，获取后有数据时reload 显示数据
        [self.tableView reloadData];
        NSLog(@"ShopListViewController->areaDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //重新刷新表格显示数据
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"ShopListViewController->areaDidReceive %d",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
}


// 经纬度 半径范围
- (id)initWithDefault:(NSString *)pID
{
    //[self initPara];
    self.cTypeID = pID;
    ShopID = nil;
    self.title = @"选择商圈";
    isReturn = NO;
    
    return self;
}
//更具商家编号来获取
- (id)initWithShopID:(NSString *)sID
{
    //[self initPara];
    self.cTypeID = nil;
    ShopID = sID;
    self.title = @"选择商圈";
    isReturn = YES;
    
    return self;
}

- (id)initWithDefaultReturn:(NSString *)pID
{
    //[self initPara];
    self.cTypeID = pID;
    self.title = @"选择商圈";
    isReturn = YES;
    return self;
}


-(void)updataUI{
    [self.tableView reloadData];
}

-(void)initPara
{
    //如果没有坐标 处理
    hasMore = false;
    self.area = [[NSMutableArray array] retain];
    
    page = 1;
    
    uaddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"uaddress"];
    
    shoptype = @"";
    istuan = @"0";
    shopname = @"";
    brandid = @"";
    isbrand = @"0";
    gTypeID = @"0";
    cTypeID = @"0";
    aid = @"0";
}


//商家分类列表中点击进入商家列表时调用此函数进行获取数据
- (id)initWithGiftType:(NSString*)giftType giftCType:(NSString*)giftCType
{
    [self initPara];
    
    gTypeID = giftType;
    cTypeID = giftCType;
    //self.navigationItem.title = shoptypename;

    [self getGiftList];
    
    return self;
}

-(void)getAddrList
{
    areaType = 1;
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(areaDidReceive:obj:)];
    
   
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",@"8",@"pagesize", self.cTypeID, @"sid", nil];
    
    [twitterClient getByAreaList:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_GIFTS];
    
    [pageindex release];
}



- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}  



- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [loadCell release];
    [gTypeID release];
    [cTypeID release];
    [aid release];
    [self.area release];
    //[ShopID release];//不可以释放
    
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
//返回有多少类型的表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//每个分类中包括多少行，由于只有一类，直接返回数组长度，如果对于多类别的，如年级的话，则可以返回每个年级中的班级数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.area count] == 0) {
        return 0;
    }
    return [self.area count] + 1;
    /*if (hasMore) {
        
    }else{
        return [gifts count];
    }*/
    //return [gifts count] + ((hasMore) ? 1 : 0);
}
//本函数用于显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	//show load more cell
    if (indexPath.row == [self.area count]) {
        //[self.imageDownload startTask];
        
            return loadCell;
        //}
        
    }
    else {
        
		static NSString *CellTableIdentifier = @"CellTableIdentifier";
		//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; 
        
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
		
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
           
            //1. 名称
            CGRect nameLabelRect = CGRectMake(20, 15, 205, 20);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            
            

           
		}else{
            /*while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }*/
        }
        
        //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
        
        AreaMode *shopmodel = [self.area objectAtIndex:indexPath.row];
        
        if( shopmodel == nil)
        {
            return nil;
        }
        
        
                
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        
        nameLabel.text = shopmodel.name;
        
        
       
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //设置UItableCelView背景
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = backgrdView;
        
        [backgrdView release];
        
        return cell;
    }
}
//每个行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger a = indexPath.row;
    return (indexPath.row == [self.area count]) ? ROW_HEIGHT : ROW_HEIGHT;
}
 //本函数用户处理用户点击列表行后的处理
//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row < [area count]) {
        AreaMode *mode = [self.area objectAtIndex:indexPath.row];
        
        if (mode != nil) {
            Return = YES;
            if (isReturn) {
                app.reciverAddress.buildingName = mode.name;
                app.reciverAddress.buildingid = mode.aID;
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            app.shopListType = 1;
            app.buildID = [mode aID];
            ShopListViewController *controller = [[[ShopListViewController alloc] initWithBid:mode.aID] autorelease];
            [self.navigationController pushViewController:controller animated:true];
        }else{
            if (hasMore) {
                if (twitterClient)
                {
                    return;
                }
                
                [loadCell.spinner startAnimating];
                
                
                [self getAddrList];
                
            }
        }
    }    
}

@end
