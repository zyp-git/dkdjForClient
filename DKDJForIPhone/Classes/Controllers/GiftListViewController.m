//
//  ShopListViewController.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-29.
//  Copyright 2011 ihangjing.com. All rights reserved.
//

#import "GiftListViewController.h"
#import "LoadCell.h"
#import "ShopListCell.h"
#import "GiftDetailViewController.h"
#import "GiftInfoModel.h"
@implementation GiftListViewController

#define ICON_TAG 1
#define NAME_TAG 2
#define TIME_TAG 3
#define TEL_TAG 4
#define ADDRESS_TAG 5

#define ROW_HEIGHT 70

@synthesize gifts;
@synthesize aid;
@synthesize gTypeID;
@synthesize cTypeID;
@synthesize imageDownload;
@synthesize defaultPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

	}
    [self initPara];
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    page = 1;
    [self getGiftList];
    //[UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"aboutbg2.png"]];
    self.imageDownload = [[CachedDownloadManager alloc] initWitchReadDic:1 Delegate:self];
    NSBundle *myBundle = [NSBundle mainBundle];
    self.defaultPath = [myBundle pathForAuxiliaryExecutable:@"nopic_skill.png"];
    [myBundle release];
    
    
    
    
    	
}

// 经纬度 半径范围
- (id)initWithDefault
{
    [self initPara];
    
    
    [self getGiftList];
    
    self.title = @"附近商家";
    
    return self;
}
-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    for (int i = index; i < [arry count]; i++) {
        ImageDowloadTask *task = [arry objectAtIndex:i];
        GiftInfoModel *model = [gifts objectAtIndex:i];
        model.locaPath = task.locURL;
    }
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
}

-(void)initPara
{
    //如果没有坐标 处理
    hasMore = false;
    gifts = [[NSMutableArray array] retain];
    
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

-(void)getGiftList
{
    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(giftsDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.189053";
    //lng = @"120.163655";
    
    //http://renrenzx.com/android/GetShopListByLocation.aspx?bid=2620&gettype=1&shoptype=&shopname=&lat=&lng=&pagesize=8&pageindex=1
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",gTypeID,@"sortid",cTypeID,@"subsortid",@"8",@"pagesize", nil];
    
    [twitterClient getGiftList:param];
    
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

-(void)getShopListFix
{
//    NSString *pageindex = [[NSString alloc] initWithFormat:@"%d",page];
    
    //读取商家列表 一次读取8个商家
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(giftsDidReceive:obj:)];
    
    //lat = ulat;
    //lng = ulng;
    
    //测试
    //lat = @"30.284243";
    //lng = @"120.153432";
    
   /* NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:pageindex,@"pageindex",lat,@"lat",lng,@"lng",brandid,@"brandid", nil];
    
    [twitterClient getShopListByLocation:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];  
    
    loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    [loadCell setType:MSG_TYPE_LOAD_MORE_GIFTS];
    
    [pageindex release];*/
}

- (void)hudWasHidden:(MBProgressHUD *)hud   
{  
    [_progressHUD removeFromSuperview];  
    [_progressHUD release];  
    _progressHUD = nil;  
}  

/*
{"cachekey":"xxx","desc":"xxx","page":"1","status":"1","total":"3", "list":[{"DataID":"140", "TogoName":"老娘舅", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"120.176888","lat":"30.303508","sendmoney":"0"},{"DataID":"119", "TogoName":"弁当屋", "Grade":"0","sortname":"商务简餐","address":"庆春路118号嘉德广场一楼","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"120.180555","lat":"30.266256","sendmoney":"0"},{"DataID":"128", "TogoName":"家乐送", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"126", "TogoName":"味捷", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"127", "TogoName":"永和大王", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"85", "TogoName":"真功夫", "Grade":"0","sortname":"商务简餐","address":"文三路477号","Time1Start":"10:00","Time1End":"21:00","Time2Start":"10:00","Time2End":"21:00","distance":"0","Star":"1","lng":"120.131079","lat":"30.285177","sendmoney":"0"},{"DataID":"133", "TogoName":"粤之林", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"","lat":"","sendmoney":"0"},{"DataID":"131", "TogoName":"台奇香", "Grade":"1","sortname":"商务简餐","address":"提供主城区各餐厅外卖服务[除下沙/萧山]","Time1Start":"10:00","Time1End":"20:00","Time2Start":"10:00","Time2End":"20:00","distance":"0","Star":"1","lng":"120.178998","lat":"30.256732","sendmoney":"0"}]}
 */
- (void)giftsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    [loadCell.spinner stopAnimating];
    [twitterClient release];
    twitterClient = nil;
    if (client.hasError) {
        [client alert];
        return;
    }
    
    NSInteger prevCount = [gifts count];//已经存在列表中的数量
    
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
    if (page == 1) {
        [self.imageDownload cleanAllTask];
        [gifts removeAllObjects];
        prevCount = 0;
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
    
    
    
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        GiftInfoModel *model = [[GiftInfoModel alloc] initWithJsonDictionary:dic];
        [self.imageDownload addTask:model.gID url:model.pic showImage:nil defaultImg:defaultPath];
        NSLog(@"ShopListViewController shopname:%@", model.gName);
        [gifts addObject:model];
        [model release];
    }
    [self.imageDownload startTask];
    if (prevCount == 0) {
        //如果是第一页则直接加载表格 刚进来没有数据，获取后有数据时reload 显示数据
        [self.tableView reloadData];
        NSLog(@"ShopListViewController->giftsDidReceive reloadData");
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
            NSLog(@"ShopListViewController->giftsDidReceive %d",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];    
    }
    
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
    if (imageDownload != nil) {
        [imageDownload stopTask];
        [imageDownload release];
    }
    [gTypeID release];
    [cTypeID release];
    [aid release];
    [gifts release];
    [defaultPath release];
    
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
    if ([gifts count] == 0) {
        return 0;
    }
    return [gifts count] + 1;
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
    if (indexPath.row == [gifts count]) {
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
            /*
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];// 套用自己的圖片做為背景
            */
            //自定义布局 分别显示以下几项
            //名称
            //电话
            //营业时间
            //地址
            UIImageView *ico = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 50, 50)];
            ico.image = [[UIImage alloc] initWithContentsOfFile:self.defaultPath];
            ico.tag = 5;//不能使用0
            [cell.contentView addSubview:ico];
            [ico release];
            //1. 名称
            CGRect nameLabelRect = CGRectMake(60, 5, 205, 15);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
            
            nameLabel.textAlignment = NSTextAlignmentLeft;
            //nameLabel.text = shopmodel.shopname;
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            nameLabel.tag = 1;
            
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            //2. 送餐费
            CGRect telLabelRect = CGRectMake(60,25, 205, 12);
            UILabel *telLabel = [[UILabel alloc] initWithFrame:
                                 telLabelRect];
            
            telLabel.textAlignment = NSTextAlignmentLeft;
            //telLabel.text = shopmodel.tel;
            telLabel.font = [UIFont boldSystemFontOfSize:12];
            telLabel.textColor = [UIColor grayColor];
            telLabel.tag = 2;
            
            [cell.contentView addSubview: telLabel];
            [telLabel release];
            
            //3. 营业时间
            CGRect timeValueRect = CGRectMake(60, 40, 205, 12);
            UILabel *timeValue = [[UILabel alloc] initWithFrame:
                                  timeValueRect];
            
            timeValue.textAlignment = NSTextAlignmentLeft;
            //timeValue.text = shopmodel.OrderTime;
            timeValue.font = [UIFont boldSystemFontOfSize:12];
            timeValue.textColor = [UIColor grayColor];
            timeValue.tag = 3;
            
            [cell.contentView addSubview:timeValue];
            [timeValue release];
            
            //4.地址
            CGRect addressValueRect = CGRectMake(60, 55, 205, 12);
            UILabel *addressValue = [[UILabel alloc] initWithFrame:
                                     addressValueRect];
            
            addressValue.textAlignment = NSTextAlignmentLeft;
            //addressValue.text = shopmodel.address;
            addressValue.font = [UIFont boldSystemFontOfSize:12];
            addressValue.textColor = [UIColor grayColor];
            addressValue.tag = 4;
            
            [cell.contentView addSubview:addressValue];
            [addressValue release];
            

           
		}else{
            /*while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }*/
        }
        
        //if( cell = nil )外面进行赋值，否则会导致cell的值重复的问题，复用cell造成的
        
        GiftInfoModel *shopmodel = [gifts objectAtIndex:indexPath.row];
        
        if( shopmodel == nil)
        {
            return nil;
        }
        
        
        UIImageView *ico = (UIImageView *)[cell.contentView viewWithTag:5];
        UIImage *image = [[UIImage alloc] init];
        if (shopmodel.locaPath == nil || shopmodel.locaPath.length == 0) {
            image = [image initWithContentsOfFile:defaultPath];
        }else{
            image = [image initWithContentsOfFile:shopmodel.locaPath];
        }
        [ico setImage:image];
        [image release];
        //[ico1 ]
        
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        if (shopmodel.type == 1) {
            nameLabel.text = [NSString stringWithFormat:@"%@(现金券)", shopmodel.gName];
        }else{
            nameLabel.text = shopmodel.gName;
        }
        
        //NSString *aString = [[NSString alloc] initWithFormat:@"兑换积分:%d", ordermodel.needPoint];
        
        UILabel *telLabel = (UILabel *)[cell.contentView viewWithTag:2];
        telLabel.text = [[NSString alloc] initWithFormat:@"兑换积分:%d", shopmodel.needPoint];
        
        UILabel *timeValue = (UILabel *)[cell.contentView viewWithTag:3];
        timeValue.text = [[NSString alloc] initWithFormat:@"剩余数量:%d", shopmodel.stocks];
        
        UILabel *addressValue = (UILabel *)[cell.contentView viewWithTag:4];
        addressValue.text = [[NSString alloc] initWithFormat:@"礼品价格:%@", shopmodel.price];
        
        //[shopmodel release]; //此处不能做release操作，会导致程序报错
        
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
    return (indexPath.row == [gifts count]) ? 60 : 76;
}
 //本函数用户处理用户点击列表行后的处理
//点击一行时的事件 进入商家详细信息视图 传入商家编号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
	//加载更多数据的行被点击了，则加载下一页数据
    
        
    
    if (indexPath.row == [gifts count])
    {
        if (hasMore) {
            if (twitterClient)
            {
                return;
            }
            
            [loadCell.spinner startAnimating];
            
            if([isbrand compare:@"1" ] == NSOrderedSame)
            {
                [self getShopListFix];
            }
            else
            {
                [self getGiftList];
            }
        }
    }
    else 
    {
         GiftInfoModel *model = [gifts objectAtIndex:indexPath.row];
        
        //如果是连锁店 则需要获取分店列表
        
        GiftDetailViewController *shopdetail = [[[GiftDetailViewController alloc] initWithGiftId:model.gID] autorelease];
        
        [self.navigationController pushViewController:shopdetail animated:true];
        
    }
}

@end
