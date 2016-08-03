

#import "FoodDetailViewController.h"
#import "NewsViewController.h"
#import "UserCommentTalbeViewController.h"
#import "ShopDetailViewController.h"
#import "FShop4ListModel.h"
#import "HJLable.h"
#import "ShopCartViewController.h"
#import "LoginNewViewController.h"
#import "UIImage+WebP.h"
#import "UIImageView+WebCache.h"
@interface FoodDetailViewController ()

@end

@implementation FoodDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(FoodDetailViewController *)initWithFood:(FoodModel *)Food  ShowGoToShop:(BOOL)ShowGoToShop shopType:(int)shoptype
{

    if (self= [super init]) {
        isShowGoToShop = ShowGoToShop;
        self.food = Food;
        shoptype = shoptype;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshFields];
    
    UIBarButtonItem * backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    backBtn.tintColor=app.sysTitleColor;
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    float heigth = 0.0f;
    
    myscroll = [[UIScrollView alloc] initWithFrame:RectMake_LFL(0, 0, 375, 667)];
    myscroll.userInteractionEnabled = YES;
    img = [[UIImageView alloc] initWithFrame:RectMake_LFL(0, 0, 375, 300)];
    if (self.food.image == nil) {
        [img sd_setImageWithURL:[NSURL URLWithString:self.food.ico] placeholderImage:[UIImage imageNamed:@"暂无图片"]];
    }else{
        img.image = self.food.image;
    }
    
    [myscroll addSubview:img];
    
    heigth += 300.0;
    heigth += 15;
    
    
    UILabel *name = [[UILabel alloc] initWithFrame:RectMake_LFL(10.0, heigth, 320, 15)];
    name.textColor = [UIColor blackColor];
    name.textAlignment = NSTextAlignmentLeft;
    name.text = self.food.foodname;
    [myscroll addSubview:name];
    heigth += 25;
    
    UILabel *lb;
    
    lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10.0, heigth, 310, 15)];
    lb.textColor = [UIColor lightGrayColor];
    lb.text = [NSString stringWithFormat:@"已售：%d", self.food.sale];
    lb.font=[UIFont systemFontOfSize:16];
    [myscroll addSubview:lb];
    
    
    heigth += 25;
    
    if (self.food.isJoin == 1) {
        heigth += 5;
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10.0, heigth, 300, 15)];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        lb.text = [NSString stringWithFormat:@"市场价  ￥%.2f", ((FoodAttrModel *)[self.food.attr objectAtIndex:0]).oldPrice];
        
        [myscroll addSubview:lb];
        heigth += 20;
        
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10.0, heigth, 80, 15)];
        lb.font = [UIFont boldSystemFontOfSize:12];
        lb.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        lb.text = @"促销价  ";
        [myscroll addSubview:lb];
        
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10.0, heigth, 200, 15)];
        lb.textColor = [UIColor redColor];
        lb.font = [UIFont boldSystemFontOfSize:16];
        lb.text = [NSString stringWithFormat:@"￥%.2f", ((FoodAttrModel *)[self.food.attr objectAtIndex:0]).price];
        [myscroll addSubview:lb];
        
    }else{
        [TImg setHidden:YES];
        
        lb = [[UILabel alloc] initWithFrame:RectMake_LFL(10.0, heigth, 200, 15)];
        lb.textColor = [UIColor redColor];
        lb.font=[UIFont systemFontOfSize:18];
        lb.text = [NSString stringWithFormat:@"￥%.2f", ((FoodAttrModel *)[self.food.attr objectAtIndex:0]).price];
        [myscroll addSubview:lb];
    }
    heigth += 25;
    
    UIView * line=[[UIView alloc]initWithFrame:RectMake_LFL(0, heigth, 375, 0.6)];
    line.backgroundColor=[UIColor lightGrayColor];
    [myscroll addSubview:line];
    heigth+=10;
    
    lb=[[UILabel alloc]initWithFrame:RectMake_LFL(10, heigth, 200, 15)];
    lb.text=@"商品详情";
    lb.textColor=[UIColor grayColor];
    [myscroll addSubview:lb];
    heigth +=25;
    
    
    NSDictionary * attr = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
    CGFloat H =[self.food.Disc boundingRectWithSize:SizeMake_LFL(355, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    lb=[[UILabel alloc]initWithFrame:RectMake_LFL(10, heigth, 355, H)];
    lb.font=[UIFont systemFontOfSize:18];
    lb.text=self.food.Disc;
    [myscroll addSubview:lb];
    
    [myscroll setContentSize:SizeMake_LFL(320, heigth+10)];

  
    [self.view addSubview:myscroll];

}
-(void)gotoShopDetail:(id)sender
{
    UIViewController *viewController = [[ShopDetailViewController alloc] initWithShopId:[NSString stringWithFormat:@"%d", _food.tid] shopType:0];
    
    [self.navigationController pushViewController:viewController animated:true];
}
-(void)gotoDis
{
    UIViewController *viewController = [[NewsViewController alloc] initWitchName:_food.foodname content:_food.Disc];
    
    [self.navigationController pushViewController:viewController animated:true];
}
-(void)gotoNotice
{
    UIViewController *viewController = [[NewsViewController alloc] initWitchName:_food.foodname content:_food.notice];
    
    [self.navigationController pushViewController:viewController animated:true];
}



- (void)viewDidDisappear:(BOOL)animated
{
    if (twitterClient) {
        [twitterClient cancel];
        twitterClient = nil;
    }
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        _progressHUD = nil;
    }
}

#pragma mark CheckLogin
- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.uduserid = [defaults objectForKey:@"userid"];
}

-(BOOL)Logined
{
    [self refreshFields];
    NSLog(@"islogin userid:%@", self.uduserid);
    
    if([self.uduserid intValue]  > 0 ) {
        return YES;
    }
    return NO;
}

-(void)updataView{
    FoodAttrModel *model;
    UILabel *number;
    for (int i = 0; i < [self.food.attr count]; i++) {
        model = [self.food.attr objectAtIndex:i];
        number = (UILabel *)[numViewList objectAtIndex:i];
        number.text = [NSString stringWithFormat:@"%d", [app.shopCart getFoodCountInAttrWitchShopID:self.food.tid foodID:self.food.foodid attrId:model.cid]];
    }

    price.text = [NSString stringWithFormat:@"合计：￥2元"];
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


-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
