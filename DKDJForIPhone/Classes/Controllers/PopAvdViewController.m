//
//  PopAvdViewController.m
//  IBogu
//
//  Created by ihangjing on 13-10-19.
//
//

#import "PopAvdViewController.h"

@interface PopAvdViewController ()

@end

@implementation PopAvdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithPopAvdName:(NSString *)title picture:(NSString *)picturePath content:(NSString *)des time:(int)timesec
{
    Title = title;
    Content = des;
    Picture = picturePath;
    Time = timesec;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.translucent = YES;
    
    self.wantsFullScreenLayout = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 15.0f, 320.0f, 480.0f)];
    [scrollView setContentSize:CGSizeMake(320, 800)];//高度多一个像素实现可以滚动
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 30, 30)];
    [close  setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [close setBackgroundImage:[UIImage imageNamed:@"close.png"]  forState:UIControlStateHighlighted];
    [close setBackgroundColor:[UIColor clearColor]];
    [close addTarget:self action:@selector(Quit:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:close];
    [close release];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 290, 30)];
    [title setText:Title];
    [scrollView addSubview:title];
    [title release];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 30, 320, 400)];
    UIImage *image = [[UIImage alloc] init];
    [img setImage:[image initWithContentsOfFile:Picture]];
    [scrollView addSubview:img];
    [image release];
    [img release];
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 431, 320, 40)];
    CGFloat contentWidth = 320;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:13];
    
    
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [Content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    [content setText:Content];
    CGRect frame = content.frame;
    frame.size.height = size.height;
    content.frame = frame;
    [scrollView addSubview:content];
    [content release];
    [self.view addSubview:scrollView];
    [scrollView release];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [timer fire];
	// Do any additional setup after loading the view.
}

-(void) timerFired:(id)senser
{
    Time--;
    if (Time < 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)Quit:(id)senser
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [timer invalidate];
    [timer release];
    [super dealloc];
}

@end
