//
//  PopAdvViewController.m
//  HMBL
//
//  Created by ihangjing on 14-1-8.
//
//

#import "PopAdvViewController.h"

@interface PopAdvViewController ()

@end

@implementation PopAdvViewController
@synthesize advArry;
@synthesize ScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(PopAdvViewController *)initWitchArry:(NSMutableArray *)arry
{
    self = [super init];
    if (self) {
        self.advArry = arry;
    }
    return self;
}

-(void)dealloc
{
    
    [self.advArry release];
    [timer release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    
    self.wantsFullScreenLayout = YES;
    CGRect frame = self.view.frame;
    self.ScrollView = [[ImageScrollViewControl alloc] initWithFrame:frame type:3 Delegate:self data:advArry];
    [self.view addSubview:self.ScrollView];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*timer =  [NSTimer scheduledTimerWithTimeInterval:5.0
                                              target:self
                                            selector:@selector(tick)
                                            userInfo:nil
                                             repeats:YES];*/
    [self.ScrollView startPlay];
    
}

-(void)tick
{
    [self.ScrollView startPlay];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
