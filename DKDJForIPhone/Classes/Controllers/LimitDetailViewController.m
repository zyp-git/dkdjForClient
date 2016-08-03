//
//  FoodDetailViewController.m
//  HMBL
//
//  Created by ihangjing on 13-11-24.
//
//

#import "LimitDetailViewController.h"
#import "NewsViewController.h"
#import "UserCommentTalbeViewController.h"
#import "ShopDetailViewController.h"
#import "FShop4ListModel.h"
#import "HJLable.h"
#import "ShopCartViewController.h"
@interface LimitDetailViewController ()

@end

@implementation LimitDetailViewController
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

-(LimitDetailViewController *)initWithFood:(LimitModel *)Food  ShowGoToShop:(BOOL)ShowGoToShop
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
#pragma mark UITextFiled

-(void)startInPut:(id)sender{
    UITextField *textField = sender;
    int tag = (int)textField.tag;
    [self checkBarButton:tag];
    [self animateView:tag];
}

-(void)endInPut:(id)sender{
    UITextField *btn = (UITextField *)sender;
    NSInteger n = btn.tag - startNumberTag;
    UITextField *number = (UITextField *)[numViewList objectAtIndex:n];
    int num = [number.text intValue];
    number.text = [NSString stringWithFormat:@"%d", num];//];
    //[app.shopCart setFoodAttr:self.food index:n Count:num];
    //price.text = [NSString stringWithFormat:@"合计：￥%.2f元", [app.shopCart getFoodPrice:self.food.foodid]];
    UIViewController *tController = [self.tabBarController.viewControllers objectAtIndex:2];
    tController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",app.shopCart.foodCount];
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
    
    self.title = @"限时购详情";
    UIImageView *order = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_ico.png"]];
    gotoShopCartClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoShopCart:)];
    //imageDowloader = [[CachedDownloadManager alloc] ]
    [order addGestureRecognizer:gotoShopCartClick];
    
    
    //[singleTap release];
    UIBarButtonItem *orderButton = [[UIBarButtonItem alloc] initWithCustomView:order];
    
    
    self.navigationItem.rightBarButtonItem = orderButton;
    [orderButton release];
    [order release];
    
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
    /*UIImageView *imagBG = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 120, 120)];
    imagBG.image = [UIImage imageNamed:@"index_food_img.png"];
    [self.view addSubview:imagBG];*/
    myscroll.userInteractionEnabled = YES;
    img = [[UIImageView alloc] initWithFrame:CGRectMake(0, heigth, 320, 320)];
    if (self.food.image == nil) {
        imageDowloader = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
        self.food.picPath = [imageDowloader addTask:[NSString stringWithFormat:@"%d", self.food.Foodid] url:self.food.icon showImage:nil defaultImg:@"" indexInGroup:index Goup:1];
        [self.food setImg:food.picPath Default:@"暂无图片"];
        [imageDowloader startTask];
    }
    img.image = self.food.image;
    [myscroll addSubview:img];
    
    TImg = [[UIImageView alloc] initWithFrame:CGRectMake(220, 0.0, 100, 100)];
    TImg.image = [UIImage imageNamed:@"timelimit_label_03.png"];
    [myscroll addSubview:TImg];
    [TImg setHidden:YES];
    //[imagBG release];
    heigth += 320.0;
    heigth += 15;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10.0, heigth, 320, 15)];
    name.textColor = [UIColor blackColor];
    name.textAlignment = NSTextAlignmentLeft;
    //nameLabel.text = shopmodel.shopname;
    name.font = [UIFont boldSystemFontOfSize:16];
    name.text = self.food.limitName;
    [myscroll addSubview:name];
    [name release];
    
    heigth += 20;
    
    
   // backgroundImage = [[UIImage imageNamed:@"v_black.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 2,10,2)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 2;
    
    UILabel *lb;
        heigth += 5;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 80, 15)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    lb.text = @"截止时间  ";
    [myscroll addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(65.0, heigth, 200, 15)];
    lb.textColor = [UIColor redColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = self.food.EndTime1;
    [myscroll addSubview:lb];
    [lb release];
    heigth += 20;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 300, 15)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    lb.text = [NSString stringWithFormat:@"原价  ￥%.2f", self.food.oPrice];
    
    [myscroll addSubview:lb];
    [lb release];
    heigth += 20;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 80, 15)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    lb.text = @"现价  ";
    [myscroll addSubview:lb];
    [lb release];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(45.0, heigth, 200, 15)];
    lb.textColor = [UIColor redColor];
    lb.font = [UIFont boldSystemFontOfSize:16];
    lb.text = [NSString stringWithFormat:@"￥%.2f", self.food.nPrice ];
    [myscroll addSubview:lb];
    [lb release];
    
    
    heigth += 20;
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(15.0, heigth, 310, 15)];
    lb.font = [UIFont boldSystemFontOfSize:12];
    lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    lb.text = [NSString stringWithFormat:@"剩余数量  %d件", self.food.cNum];
    [myscroll addSubview:lb];
    [lb release];
    
    
    
    
    
    heigth += 27;
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
    imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
    [myscroll addSubview:imageView1];
    [imageView1 release];
    heigth += 5;
    
    /*if (isShowGoToShop) {
        UIButton *btnShopDetail = [[UIButton alloc] initWithFrame:CGRectMake(10.0, heigth, 310, 15)];
        btnShopDetail.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btnShopDetail setTitle:@"进入店铺" forState:UIControlStateNormal];
        [btnShopDetail setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        btnShopDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [btnShopDetail addTarget:self action:@selector(gotoShopDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [myscroll addSubview:btnShopDetail];
        [btnShopDetail release];
        
        imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(290.0, heigth - 1, 18, 18)];
        imageView1.image = [UIImage imageNamed:@"detail_ico.png"];
        [myscroll addSubview:imageView1];
        [imageView1 release];
        
        heigth += 19;
        
        imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, heigth, 310, 1.0)];
        imageView1.image = [UIImage imageNamed:@"horizontal_line.png"];
        [myscroll addSubview:imageView1];
        [imageView1 release];
        heigth += 5;
    }*/
    
    
   
    
    
    
    
    
    
    //float viewHeight = 0.0f;
    numViewList = [[NSMutableArray alloc] init];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, heigth, 320, 30.0)];
    [myscroll addSubview:view];
    UILabel *name1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 190, 15)];
    name1.font = [UIFont boldSystemFontOfSize:14];
    name1.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    name1.text = @"选择数量";//[NSString stringWithFormat:@"%@ [￥%.2f元]", model.name, model.price];
    [view addSubview:name1];
    [name1 release];
    
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
    numValue.font = [UIFont boldSystemFontOfSize:12];
    numValue.textColor = [UIColor blackColor];
    numValue.tag = startNumberTag;
    
    [numValue addTarget:self action:@selector(startInPut:) forControlEvents:UIControlEventEditingDidBegin];
    [numValue addTarget:self action:@selector(endInPut:) forControlEvents:UIControlEventEditingDidEnd];
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
    heigth += 5;
    
   /* UIButton *btnAddCart = [[UIButton alloc] initWithFrame:CGRectMake(50, heigth, 100, 35)];
    btnAddCart.backgroundColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
    [btnAddCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [btnAddCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnAddCart addTarget:self action:@selector(addShopCart:) forControlEvents:UIControlEventTouchDown];
    [myscroll addSubview:btnAddCart];
    [btnAddCart release];
    
    UIButton *btnGoShopCartNow = [[UIButton alloc] initWithFrame:CGRectMake(170, heigth, 100, 35)];
    btnGoShopCartNow.backgroundColor = [UIColor colorWithRed:251/255.0 green:89/255.0 blue:75/255.0 alpha:1.0];
    [btnGoShopCartNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [btnGoShopCartNow setTitle:@"马上支付" forState:UIControlStateNormal];
    [btnGoShopCartNow addTarget:self action:@selector(goShopCartNow:) forControlEvents:UIControlEventTouchDown];
    [myscroll addSubview:btnGoShopCartNow];
    [btnGoShopCartNow release];
    
    heigth += 40;*/
    
    
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
}

-(void)goShopCartNow:(id)sender{
    //马上结算
}


-(void)gotoShopDetail:(id)sender
{
    /*UIViewController *viewController = [[[ShopDetailViewController alloc] initWithShopId:[NSString stringWithFormat:@"%d", food.tid] shopType:0] autorelease];
    
    [self.navigationController pushViewController:viewController animated:true];*/
}



- (void)viewDidDisappear:(BOOL)animated
{
    if (twitterClient) {
        [twitterClient cancel];
        [twitterClient release];
        twitterClient = nil;
    }
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
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
    UILabel *number;
    
    number = (UILabel *)[numViewList objectAtIndex:0];
    number.text = [NSString stringWithFormat:@"%d", [app.shopCart getFoodCountInAttrWitchShopID:self.food.shopid foodID:self.food.Foodid attrId:self.food.Foodid]];
    
    //price.text = [NSString stringWithFormat:@"合计：￥%.2f元", [app.shopCart getFoodPrice:self.food.foodid]];
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
    UIButton *btn = (UIButton *)sender;
    NSInteger n = btn.tag - startMinTag;
    UITextField *number = [numViewList objectAtIndex:n];
    
    FoodModel *foodModel = [[FoodModel alloc] init];
    
    foodModel.foodid = self.food.Foodid;
    foodModel.foodname = self.food.limitName;
    foodModel.price = self.food.nPrice;
    foodModel.tid = self.food.shopid;
    FoodAttrModel *model = [[FoodAttrModel alloc] init];
    model.pactFee = 0.0;
    model.price = self.food.nPrice;
    model.oldPrice = self.food.oPrice;
    model.isSelect = NO;
    
    [foodModel.attr addObject:model];
    
    [model release];
    number.text = [NSString stringWithFormat:@"%d", [app.shopCart delFoodAttr:foodModel attrIndex:n]];
   [foodModel release];
}

-(void)plusFoodToOrder:(id)sender
{//加入购物车
    //app.mShopModel
    app.shopCart.buyType = 0;
    UIButton *btn = (UIButton *)sender;
    int n = btn.tag - startPlushTag;
    UITextField *number = (UITextField *)[numViewList objectAtIndex:n];
    
    
    if (app.mShopModel == nil) {
        app.mShopModel = [[FShop4ListModel alloc] init];
    }
    
    FoodModel *foodModel = [[FoodModel alloc] init];
    
    foodModel.foodid = self.food.Foodid;
    foodModel.foodname = self.food.limitName;
    foodModel.price = self.food.nPrice;
    foodModel.tid = self.food.shopid;
    FoodAttrModel *model = [[FoodAttrModel alloc] init];
    model.pactFee = 0.0;
    model.price = self.food.nPrice;
    model.oldPrice = self.food.oPrice;
    model.isSelect = NO;
    model.cid = self.food.Foodid;
    [foodModel.attr addObject:model];
    
    [model release];
    
    if (app.mShopModel == nil) {
        app.mShopModel = [[FShop4ListModel alloc] init];
    }
    app.mShopModel.shopid = self.food.shopid;
    
    
    number.text = [NSString stringWithFormat:@"%d", [app.shopCart  addFoodAttr:app.mShopModel food:foodModel attrIndex:n]];
    [foodModel release];
}

- (void)gotoShopCart:(id)senser
{
    
    if (app.shopCart.foodCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[[NSString alloc] initWithFormat:@"购物车为空"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        ShopCartViewController *viewController = [[[ShopCartViewController alloc] init] autorelease];
        [self.navigationController pushViewController:viewController animated:true];
    }
        
    
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
    if (imageDowloader != nil) {
        [imageDowloader stopTask];
        [imageDowloader release];
    }
    [backClick release];
    [gotoShopCartClick release];
    [numViewList release];
    [img release];
    [TImg release];
    [self.food release];
    [myscroll release];
    [DiscClick release];//产品描述单击
    [noticeClick release];//产品提示单击
    [userCommentClick release];//用户评论
    [super dealloc];
}

@end
