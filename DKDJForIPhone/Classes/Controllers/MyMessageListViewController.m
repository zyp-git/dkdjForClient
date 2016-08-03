//
//  MyMessageListViewController.m
//  HMBL
//
//  Created by ihangjing on 14-1-9.
//
//

#import "MyMessageListViewController.h"
#import "MyMessageModel.h"
#import "RegexKitLite.h"
#import "SCGIFImageView.h"
#import "CustomLongPressGestureRecognizer.h"
@interface MyMessageListViewController ()

@end

@implementation MyMessageListViewController
@synthesize tableView;
@synthesize tfSendMessage;//发送消息输入框
@synthesize btnSend;//发送消息按钮
@synthesize messageArry;//消息队列
@synthesize m_rowHeights;//高度
@synthesize m_labelArray;//lbale队列
@synthesize m_emojiDic;
@synthesize userID;
@synthesize msgLoadCell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(MyMessageListViewController *)initWithcUserID:(NSString *)userid
{
    self = [super init];
    if (self) {
        self.userID = userid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (is_iPhone5) {
        viewHeight = 395;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 320;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, -50.0, 320, viewHeight + 50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;//去掉分割线
    [self.view addSubview:self.tableView];
    
    UIColor *color = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewHeight + 1, 320, 2)];
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    float lengths[] = {10,0};//表示先绘制10个点，再跳过10个点 如果把lengths值改为｛10, 20, 10｝，则表示先绘制10个点，跳过20个点，绘制10个点，跳过10个点，再绘制20个点，如此反复
    CGContextRef line1 = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line1, color.CGColor);
    
    CGContextSetLineDash(line1, 0, lengths, 2);  //画虚线 设置虚线的样式
    CGContextMoveToPoint(line1, 0.0, 0);    //开始画线 将路径绘制的起点移动到一个位置，即设置线条的起点
    CGContextAddLineToPoint(line1, 320.0, 0);//在图形上下文移动你的笔画来指定线条的重点
    CGContextStrokePath(line1);//创建你已经设定好的路径。此过程将使用图形上下文已经设置好的颜色来绘制路径。
    
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClosePath(line1);
    [self.view addSubview:imageView1];
    [imageView1 release];
    
    
    
    self.messageArry = [[NSMutableArray alloc] init];
    self.tfSendMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, viewHeight + 3, 280, 46)];
    self.tfSendMessage.delegate = self;
    self.tfSendMessage.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    self.tfSendMessage.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    self.tfSendMessage.scrollEnabled = YES;//是否可以拖动
    //self.tfSendMessage..placeholder = @"请输入。。。";
    //[self.tfSendMessage addTarget:self action:@selector(startInPut:) forControlEvents:UIControlEventEditingDidBegin];
    //[self.tfSendMessage addTarget:self action:@selector(endInPut:) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:self.tfSendMessage];
    
    self.btnSend = [[UIButton alloc] initWithFrame:CGRectMake(self.tfSendMessage.frame.size.width, self.tfSendMessage.frame.origin.y, 320 - self.tfSendMessage.frame.size.width, self.tfSendMessage.frame.size.height)];
    self.btnSend.backgroundColor = color;
    [self.btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.btnSend setTitle:@"发表" forState:UIControlStateNormal];
    [self.btnSend addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.btnSend];
    
    
    
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.tfSendMessage.frame.origin.y + self.tfSendMessage.frame.size.height, 320, 2)];
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    
    line1 = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line1, color.CGColor);
    CGContextSetLineDash(line1, 0, lengths, 2);  //画虚线 设置虚线的样式
    CGContextMoveToPoint(line1, 0.0, 0);    //开始画线 将路径绘制的起点移动到一个位置，即设置线条的起点
    CGContextAddLineToPoint(line1, 320.0, 0);//在图形上下文移动你的笔画来指定线条的重点
    CGContextStrokePath(line1);//创建你已经设定好的路径。此过程将使用图形上下文已经设置好的颜色来绘制路径。
    
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClosePath(line1);
    [self.view addSubview:imageView1];
    [imageView1 release];
    
    frImageDowload = [[CachedDownloadManager alloc] initWitchReadDic:6 Delegate:self];
    msgImageDowload = [[CachedDownloadManager alloc] initWitchReadDic:7 Delegate:self];
    NSArray *wk_paceImageNumArray = [[NSArray alloc]initWithObjects:@"emoji_0.png",@"emoji_1.png",@"emoji_2.png",@"emoji_3.png",@"emoji_4.png",@"emoji_5.png",@"emoji_6.png",@"emoji_7.png",@"emoji_8.png",@"emoji_9.png",@"emoji_10.png",@"emoji_11.png", nil];
    NSArray *wk_paceImageNameArray = [[NSArray alloc]initWithObjects:@"[大笑]",@"[难过]",@"[伤心]",@"[尴尬]",@"[疑惑]",@"[喜欢]",@"[期待]",@"[呆萌]",@"[惊讶]",@"[生气]",@"[害羞]",@"[开心]", nil];
    self.m_emojiDic = [[NSDictionary alloc] initWithObjects:wk_paceImageNumArray forKeys:wk_paceImageNameArray];
    
    self.m_labelArray = [NSMutableArray array];
    self.m_rowHeights = [NSMutableArray array];
    self.msgLoadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    [self.msgLoadCell setType:MSG_TYPE_NO_MORE];
    pageIndex = 1;
    [self getMyMessage];
}
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)startInPut{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.y = -130;
    self.view.frame = rect;
    [UIView commitAnimations];
}

-(void)endInPut{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    rect.origin.y = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect.origin.y += 64;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
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
    [backClick release];
    [self.msgLoadCell release];
    [self.tableView release];
    [self.btnSend release];
    [self.tfSendMessage release];
    [self.messageArry release];
    if (frImageDowload) {
        [frImageDowload stopTask];
        [frImageDowload release];
        frImageDowload = nil;
    }
    if (msgImageDowload) {
        [msgImageDowload stopTask];
        [msgImageDowload release];
        msgImageDowload = nil;
    }
    [self.userID release];
    [self.m_rowHeights release];
    [self.m_labelArray release];
    [self.m_emojiDic release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendMessage:(id)sender
{
    if (self.tfSendMessage.text.length < 1) {
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送消息不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];*/
        return;
    }
    [self sendMyMessage];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self startInPut];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self endInPut];
}
- (void)leaveEditMode {
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    /*if ([text isEqualToString:@"\n"]) {不需要换行
        [textView endEditing:YES];
        return NO;
    }*/
    return YES;
}

#pragma mark cacheDowloat
-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type
{
    ImageDowloadTask *task;
    for (int i = index; i < [arry count]; i++) {
        task = [arry objectAtIndex:i];
        
        MyMessageModel *model = [self.messageArry objectAtIndex:i];
        switch (task.groupType) {
            case 1:
                model.frImageLocalPath = task.locURL;
                [model setUserImageWithPath:model.frImageLocalPath Default:@"friendDefault.png"];
                break;
            case 2:
                model.msgImageLocalPath = task.locURL;
                [model setUserImageWithPath:model.msgImageLocalPath Default:@"暂无图片"];
                break;
            default:
                break;
        }
        
        
        
    }
}

-(void)updataUI:(int)type{
    [self.tableView reloadData];
}

#pragma mark NET
-(void)getMyMessage
{
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userID, @"userid", [NSString stringWithFormat:@"%d", pageIndex], @"pageindex", @"5", @"pagesize", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(messagesDidReceive:obj:)];
    
    [twitterClient getMyMessageListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    
    
    [param release];
}

- (void)messagesDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    page = [[dic objectForKey:@"page"] intValue];
    total  = [[dic objectForKey:@"total"] intValue];
    if (page == total) {
        
        [self.msgLoadCell setType:MSG_TYPE_NO_MORE];
    }else{
        [self.msgLoadCell setType:MSG_TYPE_LOAD_MORE_ORDERS];
    }
    NSInteger prevCount = [self.messageArry count];
    NSArray *ary = [dic objectForKey:@"datalist"];
    NSInteger index = prevCount;
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyMessageModel *model = [[MyMessageModel alloc] initWitchDic:dic];
        model.frImageLocalPath = [frImageDowload addTask:model.userID url:model.userICO showImage:nil defaultImg:nil indexInGroup:index Goup:1];
        [model setUserImageWithPath:model.frImageLocalPath Default:@"friendDefault.png"];
        
        model.msgImageLocalPath = [msgImageDowload addTask:model.dataID url:model.pic showImage:nil defaultImg:nil indexInGroup:index++ Goup:2];
        [model setMsgImageWithPath:model.msgImageLocalPath Default:@"暂无图片"];
        [self.messageArry addObject:model];
        [model release];
    }
    [self creatLabelArray];
    [self.tableView reloadData];
    if (page == 1) {
        [self scrollTableToFoot:YES];
    }else{
        NSIndexPath *ip = [NSIndexPath indexPathForRow:7 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

-(void)sendMyMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"username"];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userID, @"userid", userName, @"username", self.tfSendMessage.text, @"msg", nil];
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(sendMessagesDidReceive:obj:)];
    
    [twitterClient sendMyMessageListByUserId:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    
    
    
    [param release];
}

- (void)sendMessagesDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
    int state = [[dic objectForKey:@"state"] intValue];
    if (state > 0) {
        
        MyMessageModel *model = [[MyMessageModel alloc] init];
        model.dataID = [NSString stringWithFormat:@"%d", state];
        model.comment = self.tfSendMessage.text;
        model.userID = self.userID;
        model.userName = @"我自己";
        model.rrmark = @"[暂未回复]";
        model.userICO = @"";
        model.frImageLocalPath = [frImageDowload addTask:model.userID url:model.userICO showImage:nil defaultImg:nil indexInGroup:index Goup:1];
        [model setUserImageWithPath:model.frImageLocalPath Default:@"friendDefault.png"];
        
        NSDate *wk_currentTime = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
        model.dataTiem = [formatter stringFromDate:wk_currentTime];
        model.rDataTime = @"";
        //[wk_currentTime release];
        [formatter release];
        //[timeZone release];
        [self.messageArry insertObject:model atIndex:0];
        //[self.messageArry addObject:model];
        [model release];
        [self.tfSendMessage resignFirstResponder];
        self.tfSendMessage.text = @"";
        [self creatLabelArray];
        [self.tableView reloadData];
        [self scrollTableToFoot:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"消息发送失败，请稍后再试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark DrawaMessage
- (void)creatLabelArray
{
    
    if (self.m_labelArray.count > 0) {
        [self.m_labelArray removeAllObjects];
    }
    if (self.m_rowHeights.count > 0) {
        [self.m_rowHeights removeAllObjects];
    }
    for (int i = 0; i < [self.messageArry count]; i++) {
        #warning 家校需要提取的地方
        OHAttributedLabel *label1 = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        NSString *text1 = ((MyMessageModel *)[self.messageArry objectAtIndex:i]).rrmark;
        [self creatAttributedLabel:text1 Label:label1];
        NSNumber *heightNum1 = [[NSNumber alloc] initWithFloat:label1.frame.size.height];
        [self.m_labelArray addObject:label1];
        [CustomMethod drawImage:label1];
        [self.m_rowHeights addObject:heightNum1];

        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        NSString *text = ((MyMessageModel *)[self.messageArry objectAtIndex:i]).comment;
        [self creatAttributedLabel:text Label:label];
        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
        [self.m_labelArray addObject:label];
        [CustomMethod drawImage:label];
        [self.m_rowHeights addObject:heightNum];
        
        
    }
}

#warning 家校需要提取的地方
- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
    
    NSString *text = [CustomMethod transformString:o_text emojiDic:self.m_emojiDic];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAttString:attString withImages:wk_markupParser.images];
    
    NSString *string = attString.string;
    
    if ([emailArr count]) {
        for (NSString *emailStr in emailArr) {
            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
        }
    }
    
    if ([phoneNumArr count]) {
        for (NSString *phoneNum in phoneNumArr) {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
}

#pragma mark UITableView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tfSendMessage endEditing:YES];
    if ([self.messageArry count] > 0) {
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //int row = indexPath.row;
        
        //CGRect frame = self.tableView.frame;
        //CGSize size = self.tableView.contentSize;
        //CGPoint position = CGPointMake(0, frame.size.height - size.height);
       // NSIndexPath *index = [self.tableView indexPathForRowAtPoint:position];
        CGPoint point = [self.tableView contentOffset];
        //[self.tableView indexPathForRowAtPoint:<#(CGPoint)#>]
        //int row = index.row;
        //BOOL hiden = self.msgLoadCell.hidden;
        if (point.y > 6.0) {
            lastHiden = YES;
            return;
        }
        if (lastHiden && point.y < 5.0) {//隐藏到非隐藏
            lastHiden = NO;
            if ([self.msgLoadCell getType] == MSG_TYPE_LOAD_MORE_ORDERS) {
                pageIndex++;
                [self getMyMessage];
            }
            
        }else{
            
            //lastHiden = self.msgLoadCell.hidden;
        }
       /* if (frame.origin.y > 100 && page < total) {
            pageIndex++;
            [self getMyMessage];
        }*/
    }
    
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)longPress:(CustomLongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        currentLabel = gestureRecognizer.label;
        NSIndexPath *pressedIndexPath = [self.tableView indexPathForRowAtPoint:[gestureRecognizer locationInView:self.tableView]];
        currentIndexRow = pressedIndexPath.row;//长按手势在哪个Cell内
        UIAlertView *wk_alertView =  [[UIAlertView alloc] initWithTitle:@"确定复制该消息？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [wk_alertView setTag:100];
        [wk_alertView show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // if (indexPath.row % 3 == 0) {
    if (indexPath.row == 0) {
        return 50;
    }else{
        NSInteger row = [self.m_rowHeights count] - indexPath.row;
        return([[self.m_rowHeights objectAtIndex:row] floatValue] + 45);
    }
    
    /*}else{
        return([[self.m_rowHeights objectAtIndex:indexPath.row] floatValue] + 25);
    }*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = [self.messageArry count];
    if (count != 0) {
        count *= 2;
        count++;
    }
    return count;
    
    
}
//点击一行时的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    
    if (indexPath.row == 0) {
        return self.msgLoadCell;
    }
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil || cell == self.msgLoadCell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc] init];
        view.tag = 201;
        //添加背景图片imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 202;
        [view addSubview:imageView];
        
        //添加手势
        CustomLongPressGestureRecognizer *wk_longPressGestureRecognizer = [[CustomLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [wk_longPressGestureRecognizer setMinimumPressDuration:0.5];
        [view addGestureRecognizer:wk_longPressGestureRecognizer];
        [cell.contentView addSubview:view];
        
        [cell bringSubviewToFront:view];
    }
    
    //重用Cell的时候移除label
    UIView *view = (UIView *)[cell viewWithTag:201];
    NSInteger row = indexPath.row - 1;
    row = [self.m_rowHeights count] - row - 1;
    view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectAtIndex:row] floatValue]+20);
    
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[OHAttributedLabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSArray *wk_labelArray = [cell.contentView subviews];
    for (int i = 0; i < wk_labelArray.count; i++) {
        if ([[wk_labelArray objectAtIndex:i] isKindOfClass:[UILabel class]]) {
            [[wk_labelArray objectAtIndex:i] removeFromSuperview];
        };
    }
    
    NSArray *wk_headButtonArray = [cell.contentView subviews];
    for (int i = 0; i < wk_headButtonArray.count; i++) {
        if ([[wk_headButtonArray objectAtIndex:i] isKindOfClass:[UIButton class]]) {
            [[wk_headButtonArray objectAtIndex:i] removeFromSuperview];
        };
    }
    NSInteger index  = row / 2;
    //index = [self.messageArry count] - index - 1;
    MyMessageModel *model = [self.messageArry objectAtIndex:index];
    
    /*NSDate *wk_currentTime = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];*/
    
    if ([self.userID compare:model.userID] == NSOrderedSame) {
        model.userName = @"我自己";
    }
    
    UIButton *wk_button = [[UIButton alloc]init];
    [cell.contentView addSubview:wk_button];
    
    float sysVersion = [[[UIDevice currentDevice]systemVersion] floatValue];
    
    UIImage *image;//气泡图片
    if (sysVersion < 5.0) {
        if (row % 2 != 0) {
            UILabel *wk_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
            wk_timeLabel.text = [NSString stringWithFormat:@"[%@]发表于:%@", model.userName, model.dataTiem];
            wk_timeLabel.textColor = [UIColor lightGrayColor];
            wk_timeLabel.backgroundColor = [UIColor clearColor];
            wk_timeLabel.textAlignment = NSTextAlignmentCenter;
            wk_timeLabel.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:wk_timeLabel];
            
            [wk_button setFrame:CGRectMake(5, 25, 35, 35)];
            [wk_button setBackgroundImage:model.userImage forState:UIControlStateNormal];
            view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectAtIndex:row] floatValue]+40);
            image = [[UIImage imageNamed:@"message_send_box_other1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        }else {
            UILabel *wk_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
            wk_timeLabel.text = [NSString stringWithFormat:@"[花马巴黎]回复于:%@", model.rDataTime];
            wk_timeLabel.textColor = [UIColor lightGrayColor];
            wk_timeLabel.backgroundColor = [UIColor clearColor];
            wk_timeLabel.textAlignment = NSTextAlignmentCenter;
            wk_timeLabel.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:wk_timeLabel];
            
            [wk_button setFrame:CGRectMake(275, 25, 35, 35)];
            [wk_button setBackgroundImage:[UIImage imageNamed:@"Icon.png"] forState:UIControlStateNormal];
            view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectAtIndex:row] floatValue]+40);
            image = [[UIImage imageNamed:@"message_send_box_self1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        }
    }else {
        if (row % 2 != 0) {
            UILabel *wk_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
            wk_timeLabel.text = [NSString stringWithFormat:@"[%@]发表于:%@", model.userName, model.dataTiem];
            wk_timeLabel.textColor = [UIColor lightGrayColor];
            wk_timeLabel.backgroundColor = [UIColor clearColor];
            wk_timeLabel.textAlignment = NSTextAlignmentCenter;
            wk_timeLabel.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:wk_timeLabel];
            
            [wk_button setFrame:CGRectMake(5, 25, 35, 35)];
            [wk_button setBackgroundImage:model.userImage forState:UIControlStateNormal];
            view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectAtIndex:row] floatValue]+40);
            image = [[UIImage imageNamed:@"message_send_box_other1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20)];
        }else {
            UILabel *wk_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
            wk_timeLabel.text = [NSString stringWithFormat:@"[花马巴黎]回复于:%@", model.rDataTime];;
            wk_timeLabel.textColor = [UIColor lightGrayColor];
            wk_timeLabel.backgroundColor = [UIColor clearColor];
            wk_timeLabel.textAlignment = NSTextAlignmentCenter;
            wk_timeLabel.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:wk_timeLabel];
            
            [wk_button setFrame:CGRectMake(275, 25, 35, 35)];
            [wk_button setBackgroundImage:[UIImage imageNamed:@"Icon.png"] forState:UIControlStateNormal];
            view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectAtIndex:row] floatValue]+40);
            image = [[UIImage imageNamed:@"message_send_box_self1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20)];
        }
    }
    
    
    [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[view viewWithTag:202];
    imageView.image = image;
    imageView.frame = view.frame;
    
    CustomLongPressGestureRecognizer *recognizer = (CustomLongPressGestureRecognizer *)[view.gestureRecognizers objectAtIndex:0];
    //view内添加上label视图
    OHAttributedLabel *label = [self.m_labelArray objectAtIndex:row];
    [label setCenter:view.center];
    [recognizer setLabel:label];
    
    if (row % 2 != 0) {
        label.frame = CGRectMake(view.frame.origin.x+20, view.frame.origin.y+30, recognizer.label.frame.size.width, label.frame.size.height);
        imageView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+20, recognizer.label.frame.size.width+40, label.frame.size.height+20);
    }else{
        label.frame = CGRectMake(320-recognizer.label.frame.size.width-70-20, view.frame.origin.y+30, recognizer.label.frame.size.width, label.frame.size.height);
        
        imageView.frame = CGRectMake(label.frame.origin.x-20, view.frame.origin.y + 20, recognizer.label.frame.size.width+40, label.frame.size.height+20);
    }
    
    [view addSubview:label];
    
    return cell;
}

@end
