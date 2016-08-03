//
//  UserCommentTalbeViewController.m
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "UserCommentTalbeViewController.h"
#import "UserCommentModel.h"
#import "DYRateView.h"
#import "CommendDetailViewController.h"
@interface UserCommentTalbeViewController ()

@end

@implementation UserCommentTalbeViewController
@synthesize FoodID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    self.title = @"商家评论";
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    commentList = [[NSMutableArray alloc] init];
    page = 1;
    imageDownload1 = [[CachedDownloadManager alloc] initWitchReadDic:14 Delegate:self];
    [self getCommentList];
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UserCommentTalbeViewController *)initWithcFoodID:(int)foodid
{
    [super init];
    if (self != nil) {
        
        self.FoodID = [NSString stringWithFormat:@"%d", foodid];
    }
    return self;
}

-(void)getCommentList
{
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.FoodID, @"shopid", [NSString stringWithFormat:@"%d", page], @"pageindex", @"8", @"pagesize", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(commentListDidReceive:obj:)];
    
    [twitterClient getFoodCommentListByFoodId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    
    [param release];
}

- (void)commentListDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
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
    
    NSInteger prevCount = (int)[commentList count];//已经存在列表中的数量
    
    if (obj == nil)
    {
        return;
    }
    
    //1. 获取到page total
    NSDictionary* dic = (NSDictionary*)obj;
    NSLog(@"%@",dic);
    //NSString *pageString = [dic objectForKey:@"page"];
    NSString *totalString = [dic objectForKey:@"total"];
    
    
    NSArray *ary = ary = [dic objectForKey:@"datalist"];
   
    if ([ary count] == 0) {
        hasMore = false;
        
        
        [self.tableView reloadData];
        return;
    }
    
    //判断是否有下一页
    int totalpage = [totalString intValue];
    
    if( totalpage > page ){
        ++page;
        hasMore = true;
    }else{
        hasMore = false;
    }

    int index = (int)[commentList count];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        UserCommentModel *model = [[UserCommentModel alloc] initWitchDic:dic];
        model.iconPath = [imageDownload1 addTask:[NSString stringWithFormat:@"%@%d", model.foodID, model.dataID] url:model.icon showImage:nil defaultImg:nil indexInGroup:index++ Goup:1];
        [model setImg:model.iconPath  Default:nil];
        [commentList addObject:model];
        [model release];
    }
    [imageDownload1 startTask];
    
    if (prevCount == 0) {
        //如果是第一页则直接加载表格
        [self.tableView reloadData];
        
        NSLog(@"CommentDidReceive reloadData");
    }
    else {
        
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            NSLog(@"FoodListViewController->foodsDidReceive %ld",prevCount+i);
        }
        
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (imageDownload1) {
        [imageDownload1 stopTask];
        [imageDownload1 release];
        imageDownload1 = nil;
    }
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    if (twitterClient) {
        [twitterClient release];
        twitterClient = nil;
    }
    [backClick release];
    [self.FoodID release];
    [super dealloc];
}
#pragma mark 图片下载完成

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    //一次任务下载完成
    
    
    
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        if (task.locURL.length == 0) {
            task.locURL = nil;
        }
        
        UserCommentModel *model;
        if (task.index >= 0 && task.index < [commentList count]) {
            model = (UserCommentModel *)[commentList objectAtIndex:task.index];
            /*if ([model1.picPath compare:task.locURL] == NSOrderedSame && model1.image != nil) {
             
             }*/
            model.iconPath = task.locURL;
            
            [model setImg:model.iconPath  Default:nil];
        }
        
        
        
        
    }
    
}
-(void)updataUI:(int)type{
    
    [self.tableView reloadData];
    
}
#pragma mark UITableView 相关代理
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = self.tableView.contentOffset;  // 当前滚动位移
    CGRect bounds = self.tableView.bounds;          // UIScrollView 可+视高度
    CGSize size = self.tableView.contentSize;         // 滚动区域
    UIEdgeInsets inset = self.tableView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if (y > (h + reload_distance)) {
        // 滚动到底部
        if(twitterClient == nil && hasMore){
            //读取更多数据
            //page++;
            [self getCommentList];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([commentList count] == 0) {
        return 0;
    }
    return [commentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([commentList count] > 0) {
        UserCommentModel *foodmodel = [commentList objectAtIndex:indexPath.row];
        if (foodmodel.image != nil) {
            return 165;
        }
    }
    
    return 115;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        static NSString *CellTableIdentifier = @"CellTableIdentifier";
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier: CellTableIdentifier] autorelease];
            
            
            
            
            //1. 名称
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 15)];
            
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.text = @"用户名：";
            nameLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: nameLabel];
            [nameLabel release];
            
            UILabel *unameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 15)];
            unameLabel.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
            unameLabel.tag = 1;
            unameLabel.textAlignment = NSTextAlignmentLeft;
            unameLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: unameLabel];
            [unameLabel release];
            
            
            UILabel *serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 60, 15)];
            
            serverLabel.textAlignment = NSTextAlignmentRight;
            serverLabel.text = @"服务：";
            serverLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: serverLabel];
            [serverLabel release];
            
            UILabel *userverLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, 25, 15)];
            userverLabel.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
            userverLabel.tag = 3;
            userverLabel.text = @"5分";
            userverLabel.textAlignment = NSTextAlignmentLeft;
            userverLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: userverLabel];
            [userverLabel release];
            
            UILabel *tasteLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 35, 50, 15)];
            
            tasteLabel.textAlignment = NSTextAlignmentRight;
            tasteLabel.text = @"口感：";
            tasteLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: tasteLabel];
            [tasteLabel release];
            
            UILabel *utasteLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 35, 25, 15)];
            utasteLabel.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
            utasteLabel.tag = 4;
            utasteLabel.textAlignment = NSTextAlignmentLeft;
            utasteLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: utasteLabel];
            [utasteLabel release];
            
            UILabel *outLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 35, 50, 15)];
            
            outLabel.textAlignment = NSTextAlignmentRight;
            outLabel.text = @"外观：";
            outLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: outLabel];
            [outLabel release];
            
            UILabel *uoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 35, 25, 15)];
            uoutLabel.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
            uoutLabel.tag = 5;
            uoutLabel.textAlignment = NSTextAlignmentLeft;
            uoutLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: uoutLabel];
            [uoutLabel release];
            
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 60, 15)];
            
            commentLabel.textAlignment = NSTextAlignmentRight;
            commentLabel.text = @"评论：";
            commentLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: commentLabel];
            [commentLabel release];
            
            UILabel *ucommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 250, 60)];
            ucommentLabel.tag = 6;
            
            ucommentLabel.textColor = [UIColor colorWithRed:170/255.0 green:174/255.0 blue:169/255.0 alpha:1.0];
            ucommentLabel.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
            ucommentLabel.numberOfLines = 0;
            ucommentLabel.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview: ucommentLabel];
            [ucommentLabel release];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 116, 50, 50)];
            [imgView setUserInteractionEnabled:YES];
            imgView.tag = 7;
            [cell.contentView addSubview:imgView];
            [imgView release];
            
            
        }
        
        
        UserCommentModel *foodmodel = [commentList objectAtIndex:indexPath.row];
        
        if( foodmodel == nil)
        {
            return nil;
        }
        
        UILabel *unameLabel = (UILabel *)[cell.contentView viewWithTag:1];
        unameLabel.text = foodmodel.userName;
        
        /*DYRateView * star = (DYRateView *)[cell.contentView viewWithTag:2];
        [star setRate:foodmodel.point];*/
        
        UILabel *userverLabel = (UILabel *)[cell.contentView viewWithTag:3];
        userverLabel.text = [NSString stringWithFormat:@"%d分", foodmodel.ServerG];
        
        UILabel *utasteLabel = (UILabel *)[cell.contentView viewWithTag:4];
        utasteLabel.text = [NSString stringWithFormat:@"%d分", foodmodel.FlavorG];
        
        UILabel *uoutLabel = (UILabel *)[cell.contentView viewWithTag:5];
        uoutLabel.text = [NSString stringWithFormat:@"%d分", foodmodel.OutG];
        
        
        
        UILabel *ucommentLabel = (UILabel *)[cell.contentView viewWithTag:6];
        ucommentLabel.text = foodmodel.value;
        
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:7];
        if (foodmodel.image) {
            imgView.image = nil;
            imgView.image = foodmodel.image;
            [imgView setHidden:NO];
        }else{
            imgView.image = nil;
            [imgView setHidden:YES];
        }
        return cell;
    
}

//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    CommendDetailViewController * viewController=[[CommendDetailViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}



@end
