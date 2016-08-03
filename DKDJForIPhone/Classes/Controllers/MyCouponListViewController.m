//
//  MyCouponListViewController.m
//  HMBL
//
//  Created by ihangjing on 13-12-18.
//
//

#import "MyCouponListViewController.h"
#import "MyFriendsListViewController.h"
#import "MyCouponModel.h"
#import "MyFriendsListViewController.h"
#import "PXAlertView+Customization.h"
@interface MyCouponListViewController ()

@end

@implementation MyCouponListViewController

@synthesize dataList;
@synthesize tableView;
@synthesize searchValue;
@synthesize giverTableView;
@synthesize loadCell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(MyCouponListViewController *)initWithcUserID:(NSString *)userid{
    self = [super init];
    if (self != nil) {
        userID = userid;
        [userID retain];
        minMoney = 0.0f;
    }
    return self;
}

-(MyCouponListViewController *)initWithcHasMoney:(float)money  arry:(NSMutableArray *)arry keyArry:(NSMutableArray *)keyArry  UserID:(NSString *)userid LoadCell:(LoadCell *)cell
{
    self = [super init];
    if (self != nil) {
        userID = userid;
        [userID retain];
        minMoney = money;
        self.dataList = arry;
        couponKeyList = keyArry;
        
        self.loadCell = cell;
        
        //[loadCell retain];
        //[couponKeyList removeAllObjects];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (is_iPhone5) {
        viewHeight = 445;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 370;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    
    app.geverCoupon = 0;
    //indexPage = 1;
    //netself.dataList = [[NSMutableArray alloc] init];
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    UIBarButtonItem *saveButton;
    saveButton = [[UIBarButtonItem alloc]
                  initWithTitle:@"绑定优惠券"
                  style:UIBarButtonItemStyleDone
                  target:self
                  action:@selector(bandCoupon:)];
    if (minMoney == 0.0f) {
        
        
        self.loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
        
        [self.loadCell setType:MSG_TYPE_NO_MORE];
        self.loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
        [self.loadCell setType:MSG_TYPE_NO_MORE];
    }else{
        UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, viewHeight - 30.0, 320.0, 30)];
        notice.backgroundColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
        notice.textColor = [UIColor whiteColor];
        notice.text = [NSString stringWithFormat:@"您当前订单总金额为：%.2f", minMoney];
        notice.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:notice];
        [notice release];
        viewHeight -= 30;
        
        /*saveButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"确定选择"
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(bandCoupon:)];*/
        if (app.couponPage < app.couponTotal) {
            [self.loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
        }else{
            [self.loadCell setType:MSG_TYPE_NO_MORE];
        }
        indexPage = app.couponPage;
    }
    self.navigationItem.rightBarButtonItem = saveButton;

    if (self.dataList == nil) {
        self.dataList = [[NSMutableArray alloc] init];
    }
    
    
    
    
    isShowGiverTable = NO;
    self.giverTableView = [[UITableView alloc] initWithFrame:CGRectMake(320.0f, 0.0f, 60.0f, viewHeight)];
    self.giverTableView.delegate = self;
    self.giverTableView.tag = 1;
    self.giverTableView.dataSource = self;
    [self.view addSubview:self.giverTableView];
    
    tableViewType = 0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
    self.tableView.tag = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.tableView addGestureRecognizer:recognizer];
    
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    [self.tableView addGestureRecognizer:recognizer];
    
    [recognizer release];
    
    if (minMoney == 0.0f || [self.dataList count] == 0) {
        indexPage = 1;
        [self getMyCoupon];
    }
}

-(void)bandCoupon:(id)sender
{
    /*if (minMoney == 0.0f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择绑定方式" delegate:self cancelButtonTitle:@"输入券号" otherButtonTitles:@"扫描二维码",nil];
        
        alert.tag = 1;
        [alert show];
        [alert release];
    }else{
        if ([couponKeyList count] > 0) {
            [self goBack];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有选择任何优惠券！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
            [alert release];
        }
        
    }*/
    [couponKey release];
    couponKey = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 30.0)];
    couponKey.backgroundColor = [UIColor whiteColor];
    couponKey.delegate = self;
    couponKey.placeholder = @"请输入券号";
    //[couponKey resignFirstResponder]
    [PXAlertView showAlertWithTitle:@"请输入券号"
                            message:nil
                        cancelTitle:@"确定"
                         otherTitle:@"取消"
                        contentView:couponKey
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             //[couponKey resignFirstResponder];
                             //[self.tableView becomeFirstResponder];
                             if (buttonIndex == 0) {
                                 //开始绑定操作
                                 if (couponKey.text.length < 18) {
                                     
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确的券号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                                     alert.tag = 1;
                                     [alert show];
                                     [alert release];
                                     return;
                                 }
                                 [self bindCoupon];
                             }
                         }] ;
    /**/
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (minMoney != 0.0f) {
        return;
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        NSLog(@"swipe down");
        [self hideDeleteTable];
        //执行程序
        
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        NSLog(@"swipe up");
        [self hideDeleteTable];
        //执行程序
        
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe left");
        
        //执行程序
        [self showDeleteTable];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"swipe right");
        [self hideDeleteTable];
        //执行程序
        
    }
    
}



-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideDeleteTable
{
    if (tableViewType == 1) {
        return;
    }
    if (isShowGiverTable) {
        isShowGiverTable = NO;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        self.tableView.frame = CGRectMake(0, 0, 320, viewHeight);
        self.giverTableView.frame = CGRectMake(320, 0, 60, viewHeight);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
    }
}

-(void)showDeleteTable
{
    if (tableViewType == 1) {
        return;
    }
    isShowGiverTable = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    self.tableView.frame = CGRectMake(0, 0, 260, viewHeight);
    self.giverTableView.frame = CGRectMake(260, 0, 60, viewHeight);
    [self.giverTableView reloadData];
    CGPoint pt = [self.tableView contentOffset];
    [self.giverTableView setContentOffset:pt];//防止滚动时不对应
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (app.geverCoupon == 1) {
        //转赠成功，删除对应的数据
        [self.dataList removeObjectAtIndex:row1];
        [self.tableView beginUpdates];
        [self.giverTableView beginUpdates];
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        [newPath addObject:[NSIndexPath indexPathForRow:row1 inSection:0]];
        
        
        [self.tableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        [self.giverTableView deleteRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self.giverTableView endUpdates];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gevierFriend:(id)sender
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        row1 = [self.giverTableView indexPathForCell:(UITableViewCell *)[[[sender superview] superview] superview]].row;
    }else{
        row1 = [self.giverTableView indexPathForCell:((UITableViewCell *)[[sender superview] superview])].row;
    }
    MyCouponModel *model = [self.dataList objectAtIndex:row1];
    
    if (model == nil) {
        return;
    }
    if (model.isUser == 1) {
        
    }
    MyFriendsListViewController *viewController = [[MyFriendsListViewController alloc] initWithcCoupon:model userid:userID];
    [self.navigationController pushViewController:viewController animated:true];
    
}


-(void)dealloc
{
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
    [self.dataList release];
    [userID release];
    [self.tableView release];
    [couponKey release];
    [self.loadCell release];
    
    
    [gLoadCell release];
    [self.searchValue release];
    [HUD release];
    [backClick release];
    //[_progressHUD release];
    //[twitterClient release];
    [super dealloc];
}

#pragma mark NET

-(void) getMyCoupon
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", [NSString stringWithFormat:@"%d", indexPage], @"pageindex", @"30", @"pagesize", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(couponsDidReceive:obj:)];
    
    [twitterClient getCouponListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    
    
    [self.loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [param release];
    
    
}

- (void)couponsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
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
    //[self.foodModel release];
    int page = [[dic objectForKey:@"page"] intValue];
    int total  = [[dic objectForKey:@"total"] intValue];
    if (page == total) {
        [self.loadCell setType:MSG_TYPE_NO_MORE];
        
    }else{
        [self.loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    }
    app.couponPage = page;
    app.couponTotal = total;
    NSInteger prevCount = [self.dataList count];
    NSArray *ary = [dic objectForKey:@"datalist"];
    
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyCouponModel *model = [[MyCouponModel alloc] initWitchDic:dic];
        [self.dataList addObject:model];
        [model release];
    }
    if (page == 1) {
        [self.tableView reloadData];
    }else{
        int count = (int)[ary count];
        
        NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
        
        //刷新表格数据
        [self.tableView beginUpdates];
        
        //注意：indexPathForRow:prevCount + i
        for (int i = 0; i < count; ++i) {
            [newPath addObject:[NSIndexPath indexPathForRow:prevCount + i inSection:0]];
            //NSLog(@"FoodListViewController->foodsDidReceive %d",prevCount+i);
        }
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView endUpdates];
    }
}

-(void) bindCoupon
{
    //getfoodlistbyshopid.aspx?shopid=106
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"username"];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"uid",userName, @"uname", couponKey.text, @"cardnum", nil];
   
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(bindCouponsDidReceive:obj:)];
    
    [twitterClient bindCouponListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"绑定中...";
    [_progressHUD show:YES];
    
    
    
    //[self.loadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    
    [param release];
    
    
}

- (void)bindCouponsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    [twitterClient release];
    twitterClient = nil;
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
    int state = [[dic objectForKey:@"code"] intValue];
    if (state == 200) {
        
        newCoupon = [[MyCouponModel alloc] init];
        newCoupon.isUser = 0;
        newCoupon.CKey = [dic objectForKey:@"ckey"];
        newCoupon.dataID = [[dic objectForKey:@"CID"] intValue];
        newCoupon.CValue = [dic objectForKey:@"point"];
        newCoupon.CMoneyLine = 0;
        newCoupon.CTimeLimity = 1;
        newCoupon.CActivity = 1;
        newCoupon.MoneyLine = [[dic objectForKey:@"moneyline"] floatValue];
        if (newCoupon.MoneyLine == 0.0f) {
            newCoupon.CMoneyLine = 1;
        }
        newCoupon.CType = [[dic objectForKey:@"ReveInt"] intValue];
        //newCoupon.haveMoenyValue =
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        alert.tag = 2;
        [alert show];
        [alert release];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@", [dic objectForKey:@"msg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [alert show];
        [alert release];
    }
}

#pragma mark UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    //[textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    NSInteger len = range.location + 1;
    NSInteger op = couponKey.text.length;
    if (op >= 19 && range.length == 0) {
        return NO;
    }
   /* if (op >= 19 && range.length > 0) {//删除
        couponKey.text = @"";
        return NO;
    }*/
    if (range.length > 0) {
        return YES;
    }
    if ((len == 5 && range.location == 4) || (len == 10 && range.location == 9) || (len == 15 && range.location == 14)) {
        couponKey.text = [NSString stringWithFormat:@"%@-%@", couponKey.text, string];
        return NO;
    }
    if (len == 4 || len == 9 || len == 14) {
        //
        couponKey.text = [NSString stringWithFormat:@"%@%@-", couponKey.text, string];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //返回一个BOOL值指明是否允许根据用户请求清除内容
    //可以设置在特定条件下才允许清除内容
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //返回一个BOOL值，指明是否允许在按下回车键时结束编辑
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [textField resignFirstResponder];//查一下resign这个单词的意思就明白这个方法了
    return YES;
}

#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 0) {
                //手工输入
                [couponKey release];
                couponKey = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 30.0)];
                couponKey.backgroundColor = [UIColor whiteColor];
                couponKey.delegate = self;
                couponKey.placeholder = @"请输入券号";
                //[couponKey resignFirstResponder]
                [PXAlertView showAlertWithTitle:@"请输入券号"
                                        message:nil
                                    cancelTitle:@"确定"
                                     otherTitle:@"取消"
                                    contentView:couponKey
                                     completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                         //[couponKey resignFirstResponder];
                                         //[self.tableView becomeFirstResponder];
                                         if (buttonIndex == 0) {
                                             //开始绑定操作
                                             if (couponKey.text.length < 18) {
                                                 
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入正确的券号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                                                 alert.tag = 1;
                                                 [alert show];
                                                 [alert release];
                                                 return;
                                             }
                                             [self bindCoupon];
                                         }
                                     }] ;
                
            }else{
                
                //二维码扫描
                
                
            }

            break;
        case 2:
            if (buttonIndex == 0) {
                
                NSInteger prevCount = [self.dataList count];
                [self.dataList addObject:newCoupon];
                [newCoupon release];
                if (prevCount == 0) {
                    [self.tableView reloadData];
                    return;
                }
                NSMutableArray *newPath = [[[NSMutableArray alloc] init] autorelease];
                [newPath addObject:[NSIndexPath indexPathForRow:prevCount inSection:0]];
                //刷新表格数据
                [self.tableView beginUpdates];
                
                //注意：indexPathForRow:prevCount + i
                
                
                    //NSLog(@"FoodListViewController->foodsDidReceive %d",prevCount+i);
                
                
                [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
                
                [self.tableView endUpdates];
            }
            
            break;
        default:
            break;
    }
    
}





#pragma mark tableView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 2) {
        
        [self hideDeleteTable];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.dataList count]) {
        return 80;
    }
    MyCouponModel *model = [self.dataList objectAtIndex:indexPath.row];
    if (model.CTimeLimity == 0 && model.CMoneyLine == 0) {
        return 110;
    }else if(model.CTimeLimity == 0 || model.CMoneyLine == 0){
        return 95;
    }
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataList count] == 0) {
        return 0;
    }
    return [self.dataList count] + 1;
        
}
//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return;
    }
    if(indexPath.row == [self.dataList count]) {
        
        if (self.loadCell.getType == MSG_TYPE_LOAD_MORE_ORDERS) {
            indexPage++;
            [self getMyCoupon];
        }
    }else{
        if (minMoney != 0.0f) {
            MyCouponModel *model = [self.dataList objectAtIndex:indexPath.row];
            if (model.isUser == 1) {
                //使用过给出提示
                /*HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"优惠券已经使用过，无法再次使用";
                HUD.mode = MBProgressHUDModeText;
                
                //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
                //    HUD.yOffset = 150.0f;
                //    HUD.xOffset = 100.0f;
                
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{  
                    [HUD removeFromSuperview];  
                    [HUD release];  
                    HUD = nil;  
                }];*/
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该优惠券已经被使用过，无法再次使用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                
                [alert show];
                [alert release];
                return;
            }
            if (model.CMoneyLine == 0 && model.MoneyLine > minMoney) {
                //最低消费不达标
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"未达到到优惠券的使用最低消费%.2f标准", model.MoneyLine] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                
                [alert show];
                [alert release];
                return;
            }
            if ([couponKeyList count] > 4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"每次消费最多只能使用四张优惠券！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                
                [alert show];
                [alert release];
                return ;//每次最多只能使用四张优惠券
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (model.isSelect == 1) {
                model.isSelect = 0;
                [couponKeyList removeObjectAtIndex:model.indexSelect];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }else{
                model.isSelect = 1;
                model.indexSelect = (int)[couponKeyList count];
                [couponKeyList addObject:model];
                cell.contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:253/255.0 blue:208/255.0 alpha:1.0];
            }
            [self.tableView reloadData];
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == [self.dataList count]) {
        if (tableView.tag == 1) {
            return gLoadCell;
        }
        return self.loadCell;
    }
    
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        //自定义布局 分别显示以下几项
        if (tableView.tag == 1) {
            UIButton *delButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 40.0f, 50.0f, 28.0f)];
            delButton.tag = 1;
            delButton.titleLabel.font = [UIFont boldSystemFontOfSize:10];
            delButton.backgroundColor=[UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
            [delButton setTitle:@"赠予好友" forState:UIControlStateNormal];
            [delButton addTarget:self action:@selector(gevierFriend:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:delButton];
            [delButton release];
        }else{
           
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 60.0, 15.0)];
            name.text = @"券号：";
            name.textAlignment = NSTextAlignmentRight;
            name.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:name];
            [name release];
            
            UILabel *nameValue = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 10.0, 160.0, 15.0)];
            nameValue.tag = 1;
            nameValue.textColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
            nameValue.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:nameValue];
            [nameValue release];
            
            UILabel *stateValue = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 10.0, 80.0, 15.0)];
            stateValue.tag = 12;
            
            stateValue.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:stateValue];
            [stateValue release];
            
            UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 60.0, 15.0)];
            type.text = @"类型：";
            type.textAlignment = NSTextAlignmentRight;
            type.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:type];
            [type release];
            
            UILabel *typeValue = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 30.0, 70.0, 15.0)];
            typeValue.textColor = [UIColor colorWithRed:169/255.0 green:118/255.0 blue:15/255.0 alpha:1.0];
            typeValue.tag = 2;
            typeValue.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:typeValue];
            [typeValue release];
            
            UILabel *haveMoeny = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 30.0, 60.0, 15.0)];
            haveMoeny.text = @"余额：";
            haveMoeny.tag = 3;
            haveMoeny.textAlignment = NSTextAlignmentRight;
            haveMoeny.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:haveMoeny];
            [haveMoeny release];
            
            UILabel *haveMoenyValue = [[UILabel alloc] initWithFrame:CGRectMake(220.0, 30.0, 100.0, 15.0)];
            
            haveMoenyValue.tag = 4;
            haveMoenyValue.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:haveMoenyValue];
            [haveMoenyValue release];
            
            UILabel *all = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, 60.0, 15.0)];
            all.text = @"面值：";
            all.tag = 5;
            all.textAlignment = NSTextAlignmentRight;
            all.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:all];
            [all release];
            
            UILabel *allValue = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 50.0, 70.0, 15.0)];
            
            allValue.tag = 6;
            allValue.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:allValue];
            [allValue release];
            
            UILabel *gevierMoenyValue = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 50.0, 170.0, 15.0)];
            
            gevierMoenyValue.tag = 7;
            gevierMoenyValue.textColor = [UIColor colorWithRed:240/255.0 green:10/255.0 blue:49/255.0 alpha:1.0];
            gevierMoenyValue.font = [UIFont boldSystemFontOfSize:12];
            [cell.contentView addSubview:gevierMoenyValue];
            [gevierMoenyValue release];
            
            UILabel *persion1 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 70.0, 80.0, 15.0)];
            persion1.text = @"使用时间：";
            persion1.tag = 8;
            persion1.textAlignment = NSTextAlignmentRight;
            persion1.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:persion1];
            [persion1 release];
            
            UILabel *persion1Value = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 70.0, 70.0, 15.0)];
            
            persion1Value.tag = 9;
            persion1Value.font = [UIFont boldSystemFontOfSize:13];
            [cell.contentView addSubview:persion1Value];
            [persion1Value release];
            
            UILabel *persion2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 90.0, 80.0, 15.0)];
            persion2.text = @"最低消费：";
            persion2.tag = 10;
            persion2.textAlignment = NSTextAlignmentRight;
            persion2.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:persion2];
            [persion2 release];
            
            UILabel *persion2Value = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 90.0, 70.0, 15.0)];
            
            persion2Value.tag = 11;
            persion2Value.font = [UIFont boldSystemFontOfSize:14];
            [cell.contentView addSubview:persion2Value];
            [persion2Value release];
            
        }
    }
    
    MyCouponModel *model = [self.dataList objectAtIndex:indexPath.row];
        
        
        
    if(model == nil)
    {
        return nil;
    }
    if (tableView.tag == 1) {
        UIButton *delButton = (UIButton *)[cell.contentView viewWithTag:1];
        if (model.isUser == 1) {
            [delButton setHidden:YES];
        }else{
            [delButton setHidden:NO];
        }
    }
    else {
        
       
        
        
        UILabel *nameValue = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *typeValue = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *haveMoenyValue = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *haveMoeny = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *all = (UILabel *)[cell.contentView viewWithTag:5];
        UILabel *allValue = (UILabel *)[cell.contentView viewWithTag:6];
        
        nameValue.text = model.CKey;
        if (model.isSelect == 1) {
            //[couponKeyList addObject:model];
            cell.contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:253/255.0 blue:208/255.0 alpha:1.0];
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        if (model.CType == 1) {
            [haveMoeny setHidden:YES];
            [haveMoenyValue setHidden:YES];
            typeValue.text = @"现金券";
            //haveMoenyValue.text = [NSString stringWithFormat:@"%.2f￥", model.CMoney];
            
            all.text = @"面额：";
            allValue.text = [NSString stringWithFormat:@"%@￥", model.CValue];
        }else{
            [haveMoeny setHidden:YES];
            [haveMoenyValue setHidden:YES];
            typeValue.text = @"折扣券";
            
            all.text = @"折扣：";
            allValue.text = model.CValue;
        }
        
        UILabel *gevierMoenyValue = (UILabel *)[cell.contentView viewWithTag:7];
        if (model.GeivePerson != nil && model.GeivePerson.length > 0) {
            gevierMoenyValue.text = [NSString stringWithFormat:@"由好友[%@]赠送", model.GeivePerson];
        }else{
            gevierMoenyValue.text = @"";
        }
        
        UILabel *persion1 = (UILabel *)[cell.contentView viewWithTag:8];
        
        UILabel *persion1Value = (UILabel *)[cell.contentView viewWithTag:9];
        
        UILabel *persion2 = (UILabel *)[cell.contentView viewWithTag:10];
        
        UILabel *persion2Value = (UILabel *)[cell.contentView viewWithTag:11];
        if (model.CTimeLimity == 0 && model.CMoneyLine == 0) {
            [persion1 setHidden:NO];
            [persion2 setHidden:NO];
            [persion1Value setHidden:NO];
            [persion2Value setHidden:NO];
            persion1.text = @"使用时间：";
            persion2.text = @"最低消费：";
            
            persion1Value.text = [NSString stringWithFormat:@"%@到%@", model.StartTime, model.EndTime];
            persion2Value.text = [NSString stringWithFormat:@"%.2f￥", model.MoneyLine];
            persion2Value.textColor = [UIColor colorWithRed:240/255.0 green:10/255.0 blue:49/255.0 alpha:1.0];
            persion1Value.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        }else if(model.CTimeLimity == 0){
            [persion1 setHidden:NO];
            [persion2 setHidden:YES];
            [persion1Value setHidden:NO];
            [persion2Value setHidden:YES];
            persion1.text = @"使用时间：";
            persion1Value.text = [NSString stringWithFormat:@"%@到%@", model.StartTime, model.EndTime];
            persion1Value.textColor = [UIColor colorWithRed:240/255.0 green:10/255.0 blue:49/255.0 alpha:1.0];
        }else if(model.CMoneyLine == 0){
            [persion1 setHidden:NO];
            [persion2 setHidden:YES];
            [persion1Value setHidden:NO];
            [persion2Value setHidden:YES];
            persion1.text = @"最低消费：";
            persion1Value.text = [NSString stringWithFormat:@"%.2f￥", model.MoneyLine];
            persion1Value.textColor = [UIColor colorWithRed:240/255.0 green:10/255.0 blue:49/255.0 alpha:1.0];
        }else{
            [persion1 setHidden:YES];
            [persion2 setHidden:YES];
            [persion1Value setHidden:YES];
            [persion2Value setHidden:YES];
        }
        UILabel *stateValue = (UILabel *)[cell.contentView viewWithTag:12];
        //model.CActivity = 0;
        if (model.CActivity == 0) {
            //没有激活
            stateValue.text =@"未激活";
            stateValue.textColor = [UIColor colorWithRed:241/255.0 green:100/255.0 blue:9/255.0 alpha:1.0];
        }else{
            if (model.isUser == 0) {
                stateValue.text = @"未使用";
                stateValue.textColor = [UIColor colorWithRed:100/255.0 green:80/255.0 blue:149/255.0 alpha:1.0];
            }else{
                stateValue.text = @"使用过";
                stateValue.textColor = [UIColor colorWithRed:206/255.0 green:100/255.0 blue:149/255.0 alpha:1.0];
            }
        }
        
        
    }
    return cell;
}

@end
