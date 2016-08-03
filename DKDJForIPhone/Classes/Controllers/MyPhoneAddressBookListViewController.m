//
//  MyPhoneAddressBook.m
//  HMBL
//
//  Created by ihangjing on 13-12-19.
//
//

#import "MyPhoneAddressBookListViewController.h"
#import "MyPhoneAddressBook.h"
@interface MyPhoneAddressBookListViewController ()

@end

@implementation MyPhoneAddressBookListViewController
@synthesize MyPhoneBookList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(MyPhoneAddressBookListViewController *)initWithUserid:(NSString *)userid
{
    self = [super init];
    if (self) {
        userID = userid;
        [userID retain];
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
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    self.MyPhoneBookList = [[NSMutableArray alloc] init];
    db = [[DBHelper alloc] initOpenDataBase];
    pageCount = -1;
    group = dispatch_group_create();
    theLock = [[NSConditionLock alloc] init];
    //taskLock =[[NSConditionLock alloc] init];
    
   // [taskLock unlockWithCondition:0];
    [self mainThreadKeep];
    runThread = YES;
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error); //ABAddressBookCreate();IOS6之前使用
    /*ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
     
     if (granted) {
     //查询所有
     [self filterContentForSearchText:@""];
     }
     
     });*/
    
    //dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 //
                                                 if (granted) {
                                                     //dispatch_semaphore_signal(sema);
                                                     [self filterContentForSearchText:@""];
                                                 }
                                             });
    //dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //dispatch_release(sema);
    
    
    
    CFRelease(addressBook);
    
    
}

-(void)mainThreadKeep{
    [theLock lock];
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
        // something
        [theLock lockWhenCondition:1];
        
        [theLock unlockWithCondition:1];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        //耗时操作
        
        //NSLog(@"Start dowload");
        dispatch_async(dispatch_get_main_queue(), ^{//回到ui线程，更新ui
            //更新ui
            if (runThread) {
                [self checkFriends];
            }
            
        });
        ///[group release];
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void) checkFriends
{
    //getfoodlistbyshopid.aspx?shopid=106
   // [taskLock lockWhenCondition:0];
    //[taskLock lock];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:userID, @"userid", checkValue, @"phones",[NSString stringWithFormat:@"%d", pageIndex], @"pageindex", nil];
    
    
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(checkfriendsDidReceive:obj:)];
    
    [twitterClient checkFriendsListByUserId:param];
    
    /*_progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"搜索中...";
    [_progressHUD show:YES];*/
    
    //loadCell = [[LoadCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"LoadCell"];
    
    // [loadCell setType:MSG_TYPE_LOAD_MORE_FOODS];
    
    [param release];
    if (runThread) {
        [self mainThreadKeep];
    }
    
    
}

- (void)checkfriendsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
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
        //twitterClient = nil;
        return;
    }
    //NSInteger prevCount = [self.MyPhoneBookList count];
    NSDictionary* dic = (NSDictionary*)obj;
    NSArray *ary = [dic objectForKey:@"datalist"];
    int page = [[dic objectForKey:@"page"] intValue];
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        MyPhoneAddressBook *model = [self.MyPhoneBookList objectAtIndex:prevCount + i];
        model.friendTye = [[dic objectForKey:@"state"] intValue];
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
    /*if (pageCount == page) {
        
    }*/
    //[theLock unlockWithCondition:1];
    pageIndex++;
    
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    //如果没有授权则退出
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        return ;
    }
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    int n = 0;
    int start = 0;
    int page = 1;//
    if([searchText length]==0)
    {
        //查询所有
        NSArray *listContacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));//既然不能release，
        //int i = 1;
        for(int j = 0; j < [listContacts count] && runThread; j++)
        {
            id person = [listContacts objectAtIndex:j];
            NSString *firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            NSString *name;
            if (firstName != nil && lastName != nil) {
                name = [NSString stringWithFormat:@"%@%@",firstName, lastName];
            }else if(lastName != nil){
                name = [NSString stringWithFormat:@"%@", lastName];
            }else{
                name = [NSString stringWithFormat:@"%@",firstName];
            }
            
            
            ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            int phoneCount =(int) ABMultiValueGetCount(phones);
            for(int i = 0 ;i < phoneCount && runThread; i++)
            {
                NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                if (phone.length < 11) {
                    continue;
                }
                MyPhoneAddressBook *model = [[MyPhoneAddressBook alloc] initWitchId:0 name:name phone:phone];
                [self.MyPhoneBookList addObject:model];
                [model release];
                n++;
                if (n - start >= 9 || (j + 1 >= [listContacts count] && i +1 >= phoneCount) ) {
                    prevCount = start;
                    if (j + 1 >= [listContacts count] && i +1 >= phoneCount) {//最后一个
                        pageCount = page;
                    }
                    [checkValue release];
                    NSString *value = @"";
                    for (; start < n && runThread; start++) {
                        MyPhoneAddressBook *model1 = [self.MyPhoneBookList objectAtIndex:start];
                        if (start + 1 < n) {
                            value = [value stringByAppendingFormat:@"%@,", model1.friendPhone];
                        }else{
                            value = [value stringByAppendingFormat:@"%@", model1.friendPhone];
                        }
                        
                    }
                    
                    checkValue = value;
                    [checkValue retain];
                    pageIndex = page++;
                    [theLock unlockWithCondition:1];
                    
                    while (pageIndex < page) {
                        sleep(1);
                    }
                    
                }
            }
            
            
        }
        
        //[listContacts release];
        
    } else {
        //条件查询
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
//        NSArray *listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        CFRelease(cfSearchText);
        //[listContacts release];
    }
    CFRelease(addressBook);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack
{
    runThread = NO;
    [theLock unlockWithCondition:0];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    runThread = NO;
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
    [userID release];
    
    
    //[taskLock release];
    [theLock release];
    //[listContacts release];
    [super dealloc];
}
#pragma mark UITalbeView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
        
    return [self.MyPhoneBookList count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellTableIdentifier] autorelease];
        
        
            
            //1. 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 180, 15)];
        nameLabel.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        nameLabel.tag = 1;
        
        [cell.contentView addSubview: nameLabel];
        [nameLabel release];
        
        UILabel *phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 180, 15)];
        phoneLable.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
        phoneLable.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        phoneLable.font = [UIFont boldSystemFontOfSize:14];
        phoneLable.tag = 2;
        
        [cell.contentView addSubview: phoneLable];
        [phoneLable release];
        
        /*UIButton *addFriend = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 35)];
        [addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        addFriend.tag = 3;
        addFriend.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [addFriend setTitle:@"加为好友" forState:UIControlStateNormal];
        addFriend.backgroundColor=[UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
        [addFriend addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchDown];
        [addFriend setHidden:YES];
        [cell.contentView addSubview:addFriend];
        
        
        [addFriend release];*/
        
        UILabel *stateLable = [[UILabel alloc] initWithFrame:CGRectMake(220, 25, 100, 30)];
        
        stateLable.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = shopmodel.shopname;
        stateLable.font = [UIFont boldSystemFontOfSize:14];
        stateLable.tag = 3;
        //stateLable.backgroundColor = [UIColor colorWithRed:131/255.0 green:21/255.0 blue:0/255.0 alpha:1.0];
        [cell.contentView addSubview: stateLable];
        [stateLable release];
        
    }
    MyPhoneAddressBook *model = [self.MyPhoneBookList objectAtIndex:indexPath.row];
    if(model == nil)
    {
        return nil;
    }
    
    
    
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:1];
    nameLabel.text = model.friendName;
    
    UILabel *phoneLable = (UILabel *)[cell.contentView viewWithTag:2];
    phoneLable.text = model.friendPhone;
    
    UILabel *stateLable = (UILabel *)[cell.contentView viewWithTag:3];
    
    switch (model.friendTye) {//-1表示不能加自己为好友,-2表示已经是好友,-3用户未注册,1表示添加成好友
        case -3:
            stateLable.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
            stateLable.text = @"未注册";
            break;
        case -2:
            stateLable.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            stateLable.text = @"已经是好友";
            
            break;
        case -1:
            stateLable.textColor = [UIColor colorWithRed:117/255.0 green:89/255.0 blue:149/255.0 alpha:1.0];
            stateLable.text = @"不能添加自己";
            break;
        case 1:
            stateLable.textColor = [UIColor colorWithRed:117/255.0 green:189/255.0 blue:49/255.0 alpha:1.0];
            stateLable.text = @"添加成好友";
            break;
        default:
            stateLable.textColor = [UIColor colorWithRed:97/255.0 green:89/255.0 blue:49/255.0 alpha:1.0];
            stateLable.text = @"未注册";
            break;
    }
    
    
    
    
    return cell;
}

@end
