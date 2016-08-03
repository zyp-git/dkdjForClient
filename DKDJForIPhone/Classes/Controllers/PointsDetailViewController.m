//
//  FoodDetailViewController.m
//  HMBL
//
//  Created by ihangjing on 13-11-24.
//
//

#import "PointsDetailViewController.h"
#import "NewsViewController.h"
#import "UserCommentTalbeViewController.h"
#import "ShopDetailViewController.h"
#import "FShop4ListModel.h"
#import "HJLable.h"
#import "AddOrderToServerNewViewController.h"
@interface PointsDetailViewController ()

@end

@implementation PointsDetailViewController
@synthesize food;
@synthesize keyboardToolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(PointsDetailViewController *)initWithFood:(CouponModel *)Food  ShowGoToShop:(BOOL)ShowGoToShop
{
    [super init];
    
    if (self != nil) {
        isShowGoToShop = ShowGoToShop;
        self.food = Food;
    }
    
    return self;
}

#pragma mark UIToolBar

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == startNumberTag ? NO : YES];
    [nextBarItem setEnabled:tag == startNumberTag + AttrCount - 1 ? NO : YES];
}



- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == startNumberTag ? startNumberTag : tag - 1;
        [firstResponder resignFirstResponder];
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        //[firstResponder resignFirstResponder];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
       
    }
}

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == startNumberTag + AttrCount - 1 ? startNumberTag + AttrCount - 1 : tag + 1;
        [firstResponder resignFirstResponder];
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = startNumberTag;
    int endTag = startNumberTag + AttrCount;
    while (index <= endTag) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return NO;
}
- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag >= startNumberTag) {
        CGPoint position = CGPointMake(0, 0);
        [myscroll setContentOffset:position animated:YES];
        rect.origin.y = -25.0f * (tag - startNumberTag);
        rect.origin.y -= 300;
    } else {
        CGPoint position = CGPointMake(0, 40);
        [myscroll setContentOffset:position animated:YES];
        rect.origin.y = 0;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect.origin.y += 64;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        NSTimeInterval animationDuration = 0.30f;
        
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        
        [UIView setAnimationDuration:animationDuration];
        
        CGRect rect;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
            self.view.frame = rect;
        }else{
            rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
            self.view.frame = rect;
        }
        [self animateView:0];
        //[self resetLabelsColors];
    }
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    if (is_iPhone5) {
        viewHeight = 500;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=17;
        }
    }else{
        viewHeight = 420;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            viewHeight+=8;
        }
    }
    userHavePoint = -1;
    [self getUserInfo];
    
    self.title = @"礼品详情";
    
    
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
    float heigth = 0.0f;
    
    myscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320, viewHeight)];
    
    myscroll.userInteractionEnabled = YES;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(0, heigth, 320, 320)];
    /*if (self.food.image == nil) {
        imageDowloader = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
        self.food.picPath = [imageDowloader addTask:[NSString stringWithFormat:@"%d", self.food.dataID] url:self.food.ico showImage:nil defaultImg:@"" indexInGroup:index Goup:1];
        [self.food setImg:food.picPath Default:@"暂无图片"];
        [imageDowloader startTask];
    }*/
    img.image = self.food.image;
    [myscroll addSubview:img];
    
    
    //[imagBG release];
    heigth += 320.0;
    heigth += 15;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10.0, heigth, 320, 15)];
    name.textColor = [UIColor blackColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.text = self.food.giftName;
    name.font = [UIFont boldSystemFontOfSize:16];
    
    [myscroll addSubview:name];
    [name release];
    
    heigth += 20;
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 2;
    
    
    heigth += 5;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 300, 50)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
    lb.numberOfLines = 4;
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    
    
    
    heigth += 55;
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 80, 15)];
    lb1.font = [UIFont boldSystemFontOfSize:12];
    lb1.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    
    
    
    
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(80.0, heigth, 200, 15)];
    lb2.textColor = [UIColor redColor];
    lb2.font = [UIFont boldSystemFontOfSize:16];
    
    
    
    
    
   
    heigth += 20;
    
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 310, 15)];
    lb3.font = [UIFont boldSystemFontOfSize:12];
    lb3.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    lb.text = [NSString stringWithFormat:@"兑换说明：%@", self.food.des];
    lb1.text = @"兑换积分 ";
        
    lb2.text = [NSString stringWithFormat:@"%ld", (long)self.food.NeedIntegral];
    lb3.text = [NSString stringWithFormat:@"已兑换  %d件", self.food.GiftsPrice];
    
    
    
    
    
    [myscroll addSubview:lb];
    [lb release];
    [myscroll addSubview:lb1];
    [lb1 release];
    [myscroll addSubview:lb2];
    [lb2 release];
    [myscroll addSubview:lb3];
    [lb3 release];
    
    
    

    
    
    heigth += 17;
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 5;
    
    
    numViewList = [[NSMutableArray alloc] init];
    
    /*UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, heigth, 320, 30.0)];
    [myscroll addSubview:view];
    UILabel *value = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 190, 15)];
    value.font = [UIFont boldSystemFontOfSize:14];
    value.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    value.text = @"选择数量";//[NSString stringWithFormat:@"%@ [￥%.2f元]", model.name, model.price];
    [view addSubview:value];
    [value release];
    
    //3. -
    UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake(205, 0, 30, 25)];
    //minusButton.frame = CGRectMake(235, 0, 30, 25);
    minusButton.tag = startMinTag;
    [minusButton setBackgroundImage: [UIImage imageNamed:@"number_minus.png"] forState:UIControlStateNormal];
    [minusButton setBackgroundImage:[UIImage imageNamed:@"number_minus.png"] forState:UIControlStateSelected];//设置选择状态
    
    //[minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:minusButton];
    
    
    //4.
    UITextField *numValue = [[UITextField alloc] initWithFrame:CGRectMake(235, 0, 50, 25)];
    numValue.keyboardType = UIKeyboardTypeNumberPad;
    numValue.inputAccessoryView = self.keyboardToolbar;
    numValue.textAlignment = NSTextAlignmentCenter;
    numValue.backgroundColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0];
    //numValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //numValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    numValue.text = @"0";
    numValue.font = [UIFont boldSystemFontOfSize:12];
    numValue.textColor = [UIColor blackColor];
    numValue.tag = startNumberTag;
    
    //[numValue addTarget:self action:@selector(startInPut:) forControlEvents:UIControlEventEditingDidBegin];
    //[numValue addTarget:self action:@selector(endInPut:) forControlEvents:UIControlEventEditingDidEnd];
    //numValue.text = [NSString stringWithFormat:@"%d", [app.shopCart getFoodCountInAttr:food.foodid attId:model.cid]];
    
    //[numValue setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"number_bg.png"]]];
    
    [view addSubview:numValue];
    [numViewList addObject:numValue];
    
    //5. +
    UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 0, 30, 25)];;
    //plusButton.frame = CGRectMake(290, 0, 30, 25);
    plusButton.tag = startPlushTag;
    //[plusButton setTitle:@"+" forState:UIControlStateNormal];
    
    [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus.png"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"number_plus.png"] forState:UIControlStateSelected];//设置选择状态
    
    [plusButton addTarget:self action:@selector(plusFoodToOrder:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:plusButton];
    
    
    //[minusButton set:numValue forKey:@"num"];
    [minusButton release];
    
    //[plusButton setValue:numValue forKey:@"num"];
    [plusButton release];
    
    [numValue release];
    
    
    
    heigth += 30.0f;
    
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 5;*/
    
    UIButton *btnAddCart = [[UIButton alloc] initWithFrame:CGRectMake(110, heigth, 100, 35)];
    btnAddCart.backgroundColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
    [btnAddCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;

    [btnAddCart setTitle:@"立即兑换" forState:UIControlStateNormal];
    
    [btnAddCart addTarget:self action:@selector(addShopCart:) forControlEvents:UIControlEventTouchDown];
    [myscroll addSubview:btnAddCart];
    [btnAddCart release];
    
    
    
    heigth += 40;
    
    
    [myscroll setContentSize:CGSizeMake(320, heigth + 5)];//高度多像素实现可以滚动
    
    //[myscroll addSubview:view];
    
    
    
    
  
    [self.view addSubview:myscroll];
    //[view release];
    
    
    
	// Do any additional setup after loading the view.
}



-(void)shareFood:(id)sender{
    //点赞接口
}

-(void)favFood:(id)sender{
    //收藏菜品接口
}
-(void)addShopCart:(id)sender{
    //加入购物车
    if(self.food.cNum < 1){//没有库存了
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"该礼品已经兑换完了！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [alert release];
        return;
    }
    if(userHavePoint > -1 && userHavePoint < self.food.NeedIntegral){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"您的积分：%d不够兑换该礼品", userHavePoint] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [alert release];
        return;
    }
    app.shopCart.buyType = 5;
    app.shopCart.cAllPrice = self.food.NeedIntegral;//积分
    app.shopCart.payType = 0;
    app.shopCart.activityID = [NSString stringWithFormat:@"%ld", (long)self.food.giftID];
    app.shopCart.activityName = self.food.giftName;
    AddOrderToServerNewViewController *addorderView = [[[AddOrderToServerNewViewController alloc] init ] autorelease];
    
    [self.navigationController pushViewController:addorderView animated:YES];
}

-(void)goShopCartNow:(id)sender{
    //马上结算
}

#pragma mark GetUserInfo
-(void)getUserInfo{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(getUserInfo:obj:)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uduserid = [defaults objectForKey:@"userid"];
    [twitterClient getUserInfoByUserId:uduserid];
    
    //connection = twitterClient;
}

-(void)getUserInfo:(TwitterClient*)sender obj:(NSObject*)obj
{
    [twitterClient release];
    twitterClient = nil;
    if (sender.hasError) {
        [sender alert];
        return;
    }
    NSDictionary *dic = (NSDictionary*)obj;
    userHavePoint = [[dic objectForKey:@"Point"] intValue];
    
}





- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    ImageDowloadTask *task = [arry objectAtIndex:index];
    if (task.locURL.length == 0) {
        task.locURL = @"Icon.png";
    }
    self.food.picPath = task.locURL;
    [self.food setImg:self.food.picPath  Default:@"暂无图片"];
    
}
-(void)updataUI:(int)type{
    img.image = nil;
    img.image = self.food.image;
    [img updateConstraints];
}

-(void)updataView{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (app.foodID != 0) {
        [self goBack];
    }else{
        [self updataView];
    }
    [super viewDidAppear:animated];
    
    
}

-(void)minusFoodToOrder:(id)sender
{//减去
    
    UITextField *number = [numViewList objectAtIndex:0];
    if (buyCount > 0) {
        buyCount--;
    }
    
    number.text = [NSString stringWithFormat:@"%d", buyCount];
}

-(void)plusFoodToOrder:(id)sender
{//加入购物车
    //app.mShopModel
   
    UITextField *number = (UITextField *)[numViewList objectAtIndex:0];
    buyCount++;
    number.text = [NSString stringWithFormat:@"%d", buyCount];
    
    
    
    
    //number.text = [NSString stringWithFormat:@"%d", [app.shopCart  addFoodAttr:app.mShopModel food:self.food attrIndex:n]];
}

- (void)gotoShopCart:(id)senser
{
    
    [app SetTab:2];
        
    
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (imageDowloader != nil) {
        [imageDowloader stopTask];
        [imageDowloader release];
    }
    [backClick release];
    [numViewList release];
    [img release];
    [self.food release];
    [myscroll release];
    [super dealloc];
}

@end
