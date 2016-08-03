//
//  ShakeViewController.m
//  IBogu
//
//  Created by ihangjing on 13-10-18.
//
//

#import "ShakeViewController.h"

@interface ShakeViewController ()

@end

@implementation ShakeViewController
@synthesize shopID;

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
	// Do any additional setup after loading the view.
    start = [[ShakeItemViewController alloc] init];
    // 单击的 Recognizer
    
    
    
    [self.view addSubview:start.view];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    //[self.view addGestureRecognizer:singleRecognizer];
    [singleRecognizer release];
    
    //[self.view ]
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 260)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(70, 40, 180, 180)];
    iv1.image = [UIImage imageNamed:@"goldtree_shake.png"];
    [view addSubview:iv1];
    [iv1 release];
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(70, 220, 200, 30)];
    lable.text = @"摇一摇看看大家在吃什么";
    [view addSubview:lable];
    
    
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 250, 240, 10)];
    iv2.image = [UIImage imageNamed:@"goldtree_tucao.png"];
    [view addSubview:iv2];
    [iv2 release];
    
    [self.view addSubview:view];
    [view release];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 350, 320, 100)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    [view2 release];
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    
    accelerometer.delegate = self;
    
    accelerometer.updateInterval = 1.0/30.0f;
    shakeCount = 0;
    [self getInitData];
    
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    if (isShow) {
        
        CGPoint point = [recognizer locationInView:self.view];
        if (point.x < 280 && point.x > 40 && point.y < 352 && point.y > 260) {
            if ([self.shopID intValue] == 0) {
                return;
            }
            if(app.mShopModel == nil){
                app.mShopModel = [[FShop4ListModel alloc] init];
                
            }
            app.mShopModel.mBUpdate = NO;
            app.mShopModel.shopid = self.shopID;
            [app SetTab:1];
        }
        
    }
    
}

-(void)getInitData
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shakeInitData:obj:)];
    
    [twitterClient getShakeInitData];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    _progressHUD.labelText = @"初始化中...";
    [_progressHUD show:YES];
}
- (void)shakeInitData:(TwitterClient*)client obj:(NSObject*)obj
{
    [twitterClient release];
    twitterClient = nil;
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    if (client.hasError) {
        [client alert];
        return;
    }
    NSDictionary* dic = (NSDictionary*)obj;
    NSString *value = [dic objectForKey:@"value"];
    if (value != nil && [value compare:@""] != NSOrderedSame) {
        lable.text = value;
    }
}

-(void)getShakeData
{
    twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shakeData:obj:)];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:app.Area.aID, @"secid", nil];
    [twitterClient getShakeData:param];
    
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    _progressHUD.dimBackground = YES;
    
    [self.view addSubview:_progressHUD];
    [self.view bringSubviewToFront:_progressHUD];
    _progressHUD.delegate = self;
    [_progressHUD show:YES];
}
- (void)shakeData:(TwitterClient*)client obj:(NSObject*)obj
{
    [twitterClient release];
    twitterClient = nil;
    
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
    
    if (client.hasError) {
        [client alert];
        return;
    }
    NSDictionary* dic = (NSDictionary*)obj;
    [self.shopID release];
    self.shopID = [dic objectForKey:@"shopid"];
    [self.shopID retain];
    if ([self.shopID intValue] == 0) {
        [start.namLable setText:@"什么也没摇到哦！"];
        [start.pricLable setText:@"换个区域试试！"];
        [self showShake];
    }else{
        NSString *name = [dic objectForKey:@"foodname"];
        NSString *price = [dic objectForKey:@"newprice"];
        [start.namLable setText:name];
        [start.pricLable setText:[NSString stringWithFormat:@"现在特价：%@", price]];
        [self showShake];
    }
}

-(void)showShake
{
    isShow = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
    // UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 12.0f, 13.0f)];
    //view.frame = CGRectMake(40, 260, 240, 92);
    start.view.frame = CGRectMake(40, 260, 240, 92);
    
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    //[UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)hideShake
{
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.6];//动画时间长度，单位秒，浮点数
        // UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 12.0f, 13.0f)];
        //view.frame = CGRectMake(40, 260, 240, 92);
        start.view.frame = CGRectMake(40, 351, 240, 92);
        
        [UIView setAnimationDelegate:self];
        // 动画完毕后调用animationFinished
        [UIView setAnimationDidStopSelector:@selector(animationFinished)];
        [UIView commitAnimations];
    
    
}

-(void)animationFinished
{
    start.view.frame = CGRectMake(40.0f, 168.0f, 240.0f, 92.0f);
    isShow = NO;
    [self getShakeData];
}

- (void)dealloc {
    [start release];
    [lable release];
    accelerometer.delegate = nil;
    accelerometer = nil;
    [shakeStart release];
    [self.shopID release];
    [super dealloc];
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration

{
    
    
    
    
    NSDate *now = [[NSDate alloc]init];
    
    NSDate *checkDate = [[NSDate alloc]initWithTimeInterval:1.5f sinceDate:shakeStart];
    
    if ([now compare:checkDate] == NSOrderedDescending || shakeStart == nil) {
        
        shakeCount = 0;
        
        [shakeStart release];
        
        shakeStart = [[NSDate alloc]init];
        [shakeStart retain];
        
    }
    
    [now release];
    
    [checkDate release];
    
    
    
    if (fabs(acceleration.x)>1.7||
        
        fabs(acceleration.y)>1.7||
        
        fabs(acceleration.z)>1.7) {
        
        shakeCount ++;
        
        if (shakeCount > 4) {
            if (isShow) {
                [self hideShake];
            }else{
                [self getShakeData];
            }
            shakeCount = 0;
            
            [shakeStart release];
            
            shakeStart = [[NSDate alloc]init];
            [shakeStart retain];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
