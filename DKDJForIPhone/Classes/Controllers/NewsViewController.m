//
//  NewsViewController.m
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize name;
@synthesize content;

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
    viewHeight = 310;
    if (is_iPhone5) {
        viewHeight = 400;
    }
    UIImageView *foodType = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_ico.png"]];
    backClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    
    [foodType addGestureRecognizer:backClick];
    
    //[singleTap release];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:foodType];
    
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    [foodType release];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:236/255.0 blue:208/255.0 alpha:1.0];
    titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titleLable1.textAlignment = NSTextAlignmentCenter;
    titleLable1.font = [UIFont boldSystemFontOfSize:16];
    titleLable1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLable1];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 320, 2)];
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    float lengths[] = {10,5};//表示先绘制10个点，再跳过10个点 如果把lengths值改为｛10, 20, 10｝，则表示先绘制10个点，跳过20个点，绘制10个点，跳过10个点，再绘制20个点，如此反复
    CGContextRef line1 = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line1, [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1.0].CGColor);
    
    CGContextSetLineDash(line1, 0, lengths, 2);  //画虚线 设置虚线的样式
    CGContextMoveToPoint(line1, 0.0, 0);    //开始画线 将路径绘制的起点移动到一个位置，即设置线条的起点
    CGContextAddLineToPoint(line1, 320.0, 0);//在图形上下文移动你的笔画来指定线条的重点
    CGContextStrokePath(line1);//创建你已经设定好的路径。此过程将使用图形上下文已经设置好的颜色来绘制路径。
    
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClosePath(line1);
    [self.view addSubview:imageView1];
    [imageView1 release];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 42, 320, viewHeight)];
    
    contentFond = [UIFont boldSystemFontOfSize:14];
    contentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    contentLable.font = contentFond;
    contentLable.textColor = [UIColor colorWithRed:108/255.0 green:34/255.0 blue:1/255.0 alpha:1.0];
    contentLable.backgroundColor = [UIColor clearColor];
    contentLable.lineBreakMode = NSLineBreakByWordWrapping;//自动换行
    contentLable.numberOfLines = 0;
    [scrollView addSubview:contentLable];
    [self.view addSubview:scrollView];
    
}

-(NewsViewController *)initWitchName:(NSString *)title content:(NSString *)Content
{
    [super init];
    if (self != nil) {
        self.name = title;
        self.content = Content;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //自适应高度
    // 列寬
    CGFloat contentWidth = contentLable.frame.size.width;
    
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [self.content sizeWithFont:contentFond constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = contentLable.frame;
    frame.size.height = size.height;
    contentLable.frame = frame;
    titleLable1.text = self.name;
    contentLable.text = self.content;
    if (frame.size.height > viewHeight) {
        [scrollView setContentSize:CGSizeMake(320, frame.size.height + 10)];
    }
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [titleLable1 release];
    [contentLable release];
    [backClick release];
    [self.name release];
    [self.content release];
    [scrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
