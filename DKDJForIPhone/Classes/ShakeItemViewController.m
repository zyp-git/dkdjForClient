//
//  ShakeItemViewController.m
//  IBogu
//
//  Created by ihangjing on 13-10-18.
//
//

#import "ShakeItemViewController.h"

@interface ShakeItemViewController ()

@end

@implementation ShakeItemViewController
@synthesize namLable;
@synthesize pricLable;
@synthesize imageView;

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
    UIImageView *bak = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 168.0f, 240.0f, 92.0f)];//408 156
    bak.image = [UIImage imageNamed:@"goldtree_shake_result_bg"];
    //UITapGestureRecognizer* singleRecognizer;
    /*singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [bak addGestureRecognizer:singleRecognizer];
    
    //[self.view addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];*/
    self.view = bak;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 66, 67)];
    imageView.image = [UIImage imageNamed:@"icon.png"];
    

    
    [self.view addSubview:imageView];
    
        
    namLable = [[UILabel alloc] initWithFrame:CGRectMake(86, 10, 149, 36)];
    [namLable setBackgroundColor:[UIColor clearColor]];
    //namLable setFont:[UIFont i]
    [self.view addSubview:namLable];
    
    pricLable = [[UILabel alloc] initWithFrame:CGRectMake(86, 47, 149, 18)];
    [pricLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pricLable];
	// Do any additional setup after loading the view.
}



- (void)dealloc {
    [imageView release];
    [namLable release];
    [pricLable release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
