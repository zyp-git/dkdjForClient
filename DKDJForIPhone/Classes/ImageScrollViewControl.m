//
//  ImageScrollViewControl.m
//  TSYP
//
//  Created by wulin on 13-6-3.
//
//

#import "ImageScrollViewControl.h"
#import "AdvView.h"
#import "FoodModel.h"
#import "PopAdvModel.h"
@implementation ImageScrollViewControl
@synthesize imageDowload;
@synthesize pages;
@synthesize twitterClient;
@synthesize progressView;//进度条
@synthesize startP;
@synthesize nowP;
//type = 0 网站广告 2， 3获取食品 4 商户首页广告
- (id)initWithFrame:(CGRect)frame type:(int)Type Delegate:(id)Delegate  data:(NSMutableArray *)arry  scoType:(int)scoType dataID:(NSString *)dataid
{
    self = [super initWithFrame:frame];
    delegate = Delegate;
    if(self != nil) {
        
        //Initial Background images
        
        self.backgroundColor = [UIColor blackColor];

        DataID = dataid;
        [DataID retain];
        advType = Type;
        //self.pages = [[NSMutableArray alloc] init];
        viewList = [[NSMutableArray alloc] init];
        backGroud = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (Type == 1) {
            [backGroud setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:204/255.0 alpha:1.0]];
            
        }else{
            [backGroud setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:1]];
        }
        
        [self addSubview:backGroud];
        
        imgClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoFoodDetail:)];
        imgClick.numberOfTapsRequired = 1;//tap次数
        imgClick.numberOfTouchesRequired = 1;//手指数量
        
        
        float with;
        float x;
        if(scoType == 0){//隐现模式
            backGroud1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [backGroud1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
            [self addGestureRecognizer:imgClick];
            
            backGroud2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [backGroud2 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
            
            switch (Type) {
                case 0:
                case 4:
                    imageDowload = [[CachedDownloadManager alloc] initWitchReadShopAdvDic:dataid Delegate:self];
                case 3:
                    if (Type == 0) {
                        imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:0 Delegate:self];
                    }
                    backgroundImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [backgroundImage1 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    
                    [backGroud1 addSubview:backgroundImage1];
                    
                    backgroundImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [backgroundImage2 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage2 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    [backGroud2 addSubview:backgroundImage2];
                    break;
                case 1:
                
                    imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
                    b1Img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 93, 70)];
                    [b1Img1 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img1];
                    
                    b1Img2 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 10, 93, 70)];
                    [b1Img2 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img2];
                    
                    b1Img3 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 10, 93, 70)];
                    [b1Img3 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img3];
                    
                    b1Img4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 93, 70)];
                    [b1Img4 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img4];
                    
                    b1Img5 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 90, 93, 70)];
                    [b1Img5 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img5];
                    
                    b1Img6 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 90, 93, 70)];
                    [b1Img6 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img6];
                    
                    b2Img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 93, 70)];
                    [b2Img1 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img1];
                    
                    b2Img2 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 10, 93, 70)];
                    [b2Img2 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img2];
                    
                    b2Img3 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 10, 93, 70)];
                    [b2Img3 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img3];
                    
                    b2Img4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 93, 70)];
                    [b2Img4 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img4];
                    
                    b2Img5 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 90, 93, 70)];
                    [b2Img5 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img5];
                    
                    b2Img6 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 90, 93, 70)];
                    [b2Img6 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img6];
                    break;
                case 2:
                    imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
                    if (self.frame.size.width < self.frame.size.height) {
                        with = self.frame.size.width;
                    }else{
                        with = self.frame.size.height;
                    }
                    x = (self.frame.size.width - with) / 2;
                    
                    
                    
                    backgroundImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, with, with)];
                    [backgroundImage1 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    
                    [backGroud1 addSubview:backgroundImage1];
                    name1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 5, self.frame.size.width, 20)];
                    name1.textColor = [UIColor redColor];
                    name1.textAlignment = NSTextAlignmentCenter;
                    name1.backgroundColor = [UIColor clearColor];
                    name1.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud addSubview:name1];
                    
                    price1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 30, self.frame.size.width, 15)];
                    price1.backgroundColor = [UIColor clearColor];
                    price1.textAlignment = NSTextAlignmentCenter;
                    price1.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud addSubview:price1];
                    
                    backgroundImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, with, with)];
                    [backgroundImage2 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage2 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    [backGroud2 addSubview:backgroundImage2];
                    name2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 5, self.frame.size.width, 20)];
                    name2.textAlignment = NSTextAlignmentCenter;
                    name2.textColor = [UIColor redColor];
                    name2.backgroundColor = [UIColor clearColor];
                    name2.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud2 addSubview:name2];
                    
                    price2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 30, self.frame.size.width, 15)];
                    price2.textAlignment = NSTextAlignmentCenter;
                    price2.backgroundColor = [UIColor clearColor];
                    price2.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud2 addSubview:price2];
                    
                    //CGRect frame = self.frame;
                    //frame.size.height = price2.frame.origin.y + price2.frame.size.height;
                    //self.frame = frame;
                    
                    backGroud1.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
                    backGroud2.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
                    
                    self.progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(5.0, with + 50, self.frame.size.width - 10, 0.0)];
                    [self.progressView setOuterColor:[UIColor colorWithRed:251/255.0 green:3/255.0 blue:51/255.0 alpha:1.0]];
                    [self.progressView setInnerColor:[UIColor colorWithRed:251/255.0 green:3/255.0 blue:51/255.0 alpha:1.0]];
                    self.progressView.backgroundColor = [UIColor clearColor];
                    self.nowP = 0.0;
                    [self addSubview:self.progressView];
                    
                    break;
                default:
                    break;
            }
            [self addSubview:backGroud1];
            
            
            [self addSubview:backGroud2];
        }else{
            backGroud3 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * -1, 0, self.frame.size.width, self.frame.size.height)];
            [backGroud3 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
            
            backGroud1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [backGroud1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
            [self addGestureRecognizer:imgClick];
            
            backGroud2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [backGroud2 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
            switch (Type) {
                case 0:
                    
                case 4:
                    imageDowload = [[CachedDownloadManager alloc] initWitchReadShopAdvDic:dataid Delegate:self];
                    
                case 3:
                    if (Type == 0) {
                        imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:0 Delegate:self];
                    }
                    backgroundImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [backgroundImage3 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    
                    [backGroud3 addSubview:backgroundImage3];

                    
                    
                    backgroundImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [backgroundImage1 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    
                    [backGroud1 addSubview:backgroundImage1];
                    
                    backgroundImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                    [backgroundImage2 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage2 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    [backGroud2 addSubview:backgroundImage2];
                    break;
                case 1:
                    imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
                    
                    b3Img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 93, 70)];
                    [b3Img1 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b3Img1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud3 addSubview:b3Img1];
                    
                    b3Img2 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 10, 93, 70)];
                    [b3Img2 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b3Img2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud3 addSubview:b3Img2];
                    
                    b3Img3 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 10, 93, 70)];
                    [b3Img3 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b3Img3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud3 addSubview:b3Img3];
                    
                    b3Img4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 93, 70)];
                    [b3Img4 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b3Img4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud3 addSubview:b3Img4];
                    
                    b3Img5 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 90, 93, 70)];
                    [b3Img5 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b3Img5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud3 addSubview:b3Img5];
                    
                    b3Img6 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 90, 93, 70)];
                    [b3Img6 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b3Img6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud3 addSubview:b3Img6];
                    
                    b1Img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 93, 70)];
                    [b1Img1 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img1];
                    
                    b1Img2 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 10, 93, 70)];
                    [b1Img2 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img2];
                    
                    b1Img3 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 10, 93, 70)];
                    [b1Img3 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img3];
                    
                    b1Img4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 93, 70)];
                    [b1Img4 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img4];
                    
                    b1Img5 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 90, 93, 70)];
                    [b1Img5 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img5];
                    
                    b1Img6 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 90, 93, 70)];
                    [b1Img6 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b1Img6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud1 addSubview:b1Img6];
                    
                    b2Img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 93, 70)];
                    [b2Img1 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img1];
                    
                    b2Img2 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 10, 93, 70)];
                    [b2Img2 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img2];
                    
                    b2Img3 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 10, 93, 70)];
                    [b2Img3 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img3];
                    
                    b2Img4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 93, 70)];
                    [b2Img4 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img4 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img4];
                    
                    b2Img5 = [[UIImageView alloc] initWithFrame:CGRectMake(113, 90, 93, 70)];
                    [b2Img5 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img5 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img5];
                    
                    b2Img6 = [[UIImageView alloc] initWithFrame:CGRectMake(216, 90, 93, 70)];
                    [b2Img6 setBackgroundColor:[[UIColor alloc] initWithRed:0 green:255 blue:255 alpha:0]];
                    [b2Img6 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    [backGroud2 addSubview:b2Img6];
                    break;
                case 2:
                    imageDowload = [[CachedDownloadManager alloc] initWitchReadDic:2 Delegate:self];
                    if (self.frame.size.width < self.frame.size.height) {
                        with = self.frame.size.width;
                    }else{
                        with = self.frame.size.height;
                    }
                    x = (self.frame.size.width - with) / 2;
                    
                    
                    backgroundImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, with, with)];
                    [backgroundImage3 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage3 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    
                    [backGroud3 addSubview:backgroundImage3];
                    name3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 5, self.frame.size.width, 20)];
                    name3.textColor = [UIColor redColor];
                    name3.textAlignment = NSTextAlignmentCenter;
                    name3.backgroundColor = [UIColor clearColor];
                    name3.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud3 addSubview:name3];
                    
                    price3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 30, self.frame.size.width, 15)];
                    price3.backgroundColor = [UIColor clearColor];
                    price3.textAlignment = NSTextAlignmentCenter;
                    price3.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud3 addSubview:price3];
                    
                    
                    backgroundImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, with, with)];
                    [backgroundImage1 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage1 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    
                    [backGroud1 addSubview:backgroundImage1];
                    name1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 5, self.frame.size.width, 20)];
                    name1.textColor = [UIColor redColor];
                    name1.textAlignment = NSTextAlignmentCenter;
                    name1.backgroundColor = [UIColor clearColor];
                    name1.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud1 addSubview:name1];
                    
                    price1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 30, self.frame.size.width, 15)];
                    price1.backgroundColor = [UIColor clearColor];
                    price1.textAlignment = NSTextAlignmentCenter;
                    price1.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud1 addSubview:price1];
                    
                    backgroundImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, with, with)];
                    [backgroundImage2 setContentMode:UIViewContentModeScaleToFill];
                    
                    [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
                    //[backgroundImage2 setBackgroundColor:[[UIColor alloc] initWithRed:255 green:255 blue:255 alpha:0]];
                    [backGroud2 addSubview:backgroundImage2];
                    name2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 5, self.frame.size.width, 20)];
                    name2.textAlignment = NSTextAlignmentCenter;
                    name2.textColor = [UIColor redColor];
                    name2.backgroundColor = [UIColor clearColor];
                    name2.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud2 addSubview:name2];
                    
                    price2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, with + 30, self.frame.size.width, 15)];
                    price2.textAlignment = NSTextAlignmentCenter;
                    price2.backgroundColor = [UIColor clearColor];
                    price2.font = [UIFont boldSystemFontOfSize:16];
                    [backGroud2 addSubview:price2];
                    
                    //CGRect frame = self.frame;
                    //frame.size.height = price2.frame.origin.y + price2.frame.size.height;
                    //self.frame = frame;
                    backGroud3.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
                    backGroud1.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
                    backGroud2.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
                    /*
                    self.progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(5.0, with + 50, self.frame.size.width - 10, 0.0)];
                    [self.progressView setOuterColor:[UIColor colorWithRed:251/255.0 green:3/255.0 blue:51/255.0 alpha:1.0]];
                    [self.progressView setInnerColor:[UIColor colorWithRed:251/255.0 green:3/255.0 blue:51/255.0 alpha:1.0]];
                    self.progressView.backgroundColor = [UIColor clearColor];
                    self.nowP = 0.0;
                    [self addSubview:self.progressView];
                    */
                    break;
                default:
                    break;
            }
            
        }
        rollType = scoType;
        showIndex = 1;
        //Initial shadow
        /*UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
        shadowImageView.contentMode = UIViewContentModeScaleToFill;
        shadowImageView.frame = CGRectMake(0, frame.size.height-300, frame.size.width, 300);
        [self addSubview:shadowImageView];*/
        
        
        
        
        
        
        
        //Create pages
        
        /*for (int i = 0; i < [pagesArray count]; i++) {
            AdvModel *model = (AdvModel *)[pagesArray objectAtIndex:i];
            [self.pages addObject:model];
        }*/
        //self.pages = pagesArray;
        //Initial ScrollView
        scrollView = [[HJScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (scoType == 1) {
            //scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);//[[HJScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3, self.frame.size.height)];
            [scrollView addSubview:backGroud3];
            [scrollView addSubview:backGroud1];
            
            
            [scrollView addSubview:backGroud2];
        }
        
        
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[UIPageControl alloc] init];
        
        [pageControl sizeToFit];
        [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-50)];
        if (Type == 3) {
            [self addSubview:pageControl];
        }
        
        //放到每次更换数据后更新
        /*scrollView.contentSize = CGSizeMake(self.pages.count * frame.size.width, frame.size.height);
         pageControl.numberOfPages = self.data.count;*/
        
        
        /*if (Type == 0) {
            UIImage *normalImage1 = [UIImage imageNamed:@"adv_left_n.png"];
            UIImage *highlightedImage1 = [UIImage imageNamed:@"adv_left_d.png"];
            
            UIImage *normalImage2 = [UIImage imageNamed:@"adv_right_n.png"];
            UIImage *highlightedImage2 = [UIImage imageNamed:@"adv_right_d.png"];
            
            //UIButton *Btn1 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            UIButton *Btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, self.frame.size.height / 2 - 15,30.0f, 30.0f)];
            //个人中心
            //Btn1.frame = CGRectMake(10.0f, self.frame.size.height / 2 - 15,30.0f, 30.0f);
            [Btn1  setBackgroundImage:normalImage1 forState:UIControlStateNormal];
            [Btn1 setBackgroundImage:highlightedImage1  forState:UIControlStateHighlighted];
            [Btn1 setBackgroundColor:[UIColor clearColor]];
            [Btn1 addTarget:self action:@selector(lastAdv:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:Btn1];
            //下一副
            //UIButton *Btn2 = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            UIButton *Btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40,self.frame.size.height / 2 - 15,30.0f, 30.0f)];
            //Btn2.frame = CGRectMake(self.frame.size.width - 40,self.frame.size.height / 2 - 15,30.0f, 30.0f);
            [Btn2  setBackgroundImage:normalImage2 forState:UIControlStateNormal];
            [Btn2 setBackgroundImage:highlightedImage2  forState:UIControlStateHighlighted];
            [Btn2 setBackgroundColor:[UIColor clearColor]];
            [Btn2 addTarget:self action:@selector(nextAdv:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:Btn2];
            [Btn1 release];
            [Btn2 release];
            //[normalImage1 release];//错误的做法哦 
            //[highlightedImage1 release];
            //[normalImage2 release];
            //[highlightedImage2 release];
        }*/
        //insert TextViews into ScrollView
        currentPhotoNum = -2;
        if (arry) {
            self.pages = arry;
            pageCount = (int)[self.pages count] + 1;
            self.startP = 1.0/pageCount;
            self.nowP = self.startP;
            scrollView.contentSize = CGSizeMake(pageCount * frame.size.width, frame.size.height);
            pageControl.numberOfPages = pageCount - 1;
        }else{
            [self readDataFromCache];
        }
        
        
        
        [self initShow:NO];
        currentPhotoNum = -1;
        
        //start timer
        if (advType == 0 || advType == 4 || advType == 3) {
            timer =  [NSTimer scheduledTimerWithTimeInterval:5.0
                                                      target:self
                                                    selector:@selector(tick)
                                                    userInfo:nil
                                                     repeats:YES];
        }
        
        if (arry == nil) {
            if ([self.pages count] == 0) {
                _progressHUD = [[MBProgressHUD alloc] initWithView:self];
                
                _progressHUD.dimBackground = YES;
                
                [self addSubview:_progressHUD];
                [self bringSubviewToFront:_progressHUD];
                _progressHUD.delegate = self;
                _progressHUD.labelText = @"加载中...";
                [_progressHUD show:YES];
            }
            [self getDataFormeNet];
        }else{
            
            [timer setFireDate:[NSDate distantFuture]];
        }
    }
    return self;
}

-(void)getDataFormeNet
{
    if (advType == 0) {
        self.twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(advDidReceive:obj:)];
        [self.twitterClient getAdvList];
    }else if(advType == 4){
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:DataID,@"shopid", nil];
        self.twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(shopAdvDidReceive:obj:)];
        
        [twitterClient getShopAdvList:param];
    }else{
        NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:@"18",@"pagesize", @" ReveInt4", @"sortname", nil];
        self.twitterClient = [[TwitterClient alloc] initWithTarget:self action:@selector(foodsDidReceive:obj:)];
        
        [twitterClient getFoodListByShopId:param];
        
    }
}

-(void)startPlay
{
    
    [self initShow:NO];
    
    [timer setFireDate:[NSDate date]];
}

-(void)gotoFoodDetail:(id)sender
{
    /*UIImageView * image = (UIImageView *)sender;
    int foodid = image.tag;
    foodid++;*/
   // NSLog(@"\r\ngotoFooDetail");
    if (delegate == nil) {
        return;
    }
    if (advType == 0) {
        [delegate clickViewGetModel:(currentPhotoNum < [self.pages count] ? [self.pages objectAtIndex:currentPhotoNum]:nil) Type:advType];
    }else{
        UITapGestureRecognizer *click = (UITapGestureRecognizer *)sender;
        CGPoint pt = [click locationInView:self];
        CGRect rt = b1Img1.frame;
        if (advType == 1) {
            int num = currentPhotoNum * 6;
            if (pt.x > rt.origin.x && pt.x < (rt.origin.x + rt.size.width) && pt.y > rt.origin.y && pt.y < (rt.origin.y + rt.size.height)) {
                
//                NSLog(@"\r\nb1Img1");
                [delegate clickViewGetModel:(num < [self.pages count] ? [self.pages objectAtIndex:num]:nil) Type:advType];
                return;
            }
            
            rt = b1Img2.frame;
            if (pt.x > rt.origin.x && pt.x < (rt.origin.x + rt.size.width) && pt.y > rt.origin.y && pt.y < (rt.origin.y + rt.size.height)) {
//                NSLog(@"\r\nb1Img2");
                [delegate clickViewGetModel:(num + 1 < [self.pages count] ? [self.pages objectAtIndex:num + 1]:nil) Type:advType];
                return;
            }
            
            rt = b1Img3.frame;
            if (pt.x > rt.origin.x && pt.x < (rt.origin.x + rt.size.width) && pt.y > rt.origin.y && pt.y < (rt.origin.y + rt.size.height)) {
                NSLog(@"\r\nb1Img3");
                [delegate clickViewGetModel:(num + 2 < [self.pages count] ? [self.pages objectAtIndex:num + 2]:nil) Type:advType];
                return;
            }
            
            rt = b1Img4.frame;
            if (pt.x > rt.origin.x && pt.x < (rt.origin.x + rt.size.width) && pt.y > rt.origin.y && pt.y < (rt.origin.y + rt.size.height)) {
                NSLog(@"\r\nb1Img4");
                [delegate clickViewGetModel:(num + 3 < [self.pages count] ? [self.pages objectAtIndex:num + 3]:nil) Type:advType];
                return;
            }
            
            rt = b1Img5.frame;
            if (pt.x > rt.origin.x && pt.x < (rt.origin.x + rt.size.width) && pt.y > rt.origin.y && pt.y < (rt.origin.y + rt.size.height)) {
                NSLog(@"\r\nb1Img5");
                [delegate clickViewGetModel:(num + 4 < [self.pages count] ? [self.pages objectAtIndex:num + 4]:nil) Type:advType];
                return;
            }
            
            rt = b1Img6.frame;
            if (pt.x > rt.origin.x && pt.x < (rt.origin.x + rt.size.width) && pt.y > rt.origin.y && pt.y < (rt.origin.y + rt.size.height)) {
                NSLog(@"\r\nb1Img6");
                [delegate clickViewGetModel:(num + 5 < [self.pages count] ? [self.pages objectAtIndex:num + 5]:nil) Type:advType];
                return;
            }
        }else if(advType == 2){
            int num = currentPhotoNum;
            [delegate clickViewGetModel:(num < [self.pages count] ? [self.pages objectAtIndex:num]:nil) Type:advType];
            return;
        }else{
            
        }
        
    }
}

- (void)foodsDidReceive:(TwitterClient*)client obj:(NSObject*)obj
{
    NSLog(@"foodsDidReceive");
    
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
    [self getFoodModelDataFromDic:dic type:1];
    
}


-(void)getFoodModelDataFromDic:(NSDictionary *)dic type:(int)cacheType{
    NSArray *ary = [dic objectForKey:@"foodlist"];
    if ([ary count] == 0) {
        return;
    }
    if (cacheType == 1) {
        [self saveDataToCache:dic];
    }
    
    
    
    NSMutableArray *food = [[NSMutableArray alloc] init];
    int add = [ary count] - [self.pages count];
    int start = [self.pages count];
    
    //特别注意：此处如果设置false时 则最后一页会报错 因为原先比如是8个数据+1个loadcell  9行数据 最后一页5个数 没有loadcell 则少了一行表格滚动出错
    // 将获取到的数据进行处理 形成列表
    FoodModel *model;
    for (int i = 0; i < [ary count]; i++) {
        NSDictionary *dic = (NSDictionary*)[ary objectAtIndex:i];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        model = [[FoodModel alloc] initWithJsonDictionary:dic];
        model.picPath = [imageDowload addTask:[NSString stringWithFormat:@"%d", model.foodid] url:model.ico showImage:nil defaultImg:@"" indexInGroup:i Goup:1];
        [model setImg:model.picPath Default:@"暂无图片"];
        [food addObject:model];
        [model release];
    }
    
    CGFloat width;
    CGFloat height;
    if (add > 0) {//增加新增的
        width = add * self.frame.size.width;
        height = self.frame.size.height;
        scrollView.contentSize = CGSizeMake(width, height);
        
        for(int i = 0; i <  add; i++) {
            AdvView *view = [[AdvView alloc] initWithFrame:self.frame model:[self.pages objectAtIndex:i]];
            width = start*self.frame.size.width;
            view.frame = CGRectOffset(view.frame, width, 0);
            
            
        }
        if (cacheType == 1) {
            [self initShow:NO];
        }
    }else if(add < 0){
        add *= -1;
        width = add * self.frame.size.width;
        height = self.frame.size.height;
        scrollView.contentSize = CGSizeMake(width, height);
        if (cacheType == 1) {
            [self initShow:NO];
        }
    }
    //[self.pages release];//不需要 ，因为retain，所以下面的等式会自动release 和retain
    self.pages = food;
    if (advType == 1) {//每页显示6个
        pageCount = [self.pages count] / 6;
        if ((float)([self.pages count] % 6) > 0.0f) {
            pageCount++;
        }
    }else{//每页一个
        pageCount = [self.pages count];
    }
    scrollView.contentSize = CGSizeMake(pageCount * self.frame.size.width, self.frame.size.height);
    pageControl.numberOfPages = pageCount;
    
    self.startP = 1.0/pageCount;
    self.nowP = 0;
    [imageDowload startTask];
}

-(void)lastAdv:(id)senser
{
    if (currentPhotoNum < -1) {
        return;
    }
    int n = 0;
    n = currentPhotoNum - 1 == -1 ? -1 : currentPhotoNum-1;
    if (n == - 1) {
        n = 0;
    }
    [self scrollToView:n];
        
    
}

-(void)nextAdv:(id)senser
{
    if (currentPhotoNum < -1) {
        return;
    }
    int n = 0;
        
    n = currentPhotoNum+1 == self.pages.count ? self.pages.count : currentPhotoNum+1;
    if (n == self.pages.count) {
        n = self.pages.count - 1;
    }
    [self scrollToView:n];
        
    
}

//获取程序文档路径
- (NSString *) documentsDirectoryWithTrailingSlash:(BOOL)paramWithTrailingSlash{
    
    NSString *result = nil;
    NSArray *documents =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([documents count] > 0){
        result = [documents objectAtIndex:0];
        if (paramWithTrailingSlash == YES){
            result = [result stringByAppendingString:@"/"];
        }
    }
    return(result);
    
}

-(void)readDataFromCache
{
    NSString *documentsDirectory = [self documentsDirectoryWithTrailingSlash:YES];
    NSString *cacheDictionaryPath;
    if (advType == 0) {
        cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"AdvCached.dic"] retain];//广告缓存json
    }else if(advType == 4){
        cacheDictionaryPath = [[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"ShopAdv%@.dic", DataID]] retain];//广告缓存json
    }else{
        cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"FoodCached.dic"] retain];//广告缓存json
    }
    //self.data = [[NSMutableArray alloc] init];
    [self readCache:cacheDictionaryPath];
    
}

-(void)readCache:(NSString *)cacheDictionaryPath
{
    
    //创建一个NSFileManager实例
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //判断是否存在缓存字典的数据
    if ([fileManager fileExistsAtPath:cacheDictionaryPath] == YES){
        //NSLog(self.cacheDictionaryPath);
        //加载缓存字典中的数据
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:cacheDictionaryPath];
        if (advType == 0) {
            [self getAdvModelFromDic:dictionary type:0];
        }else if(advType == 4){
            [self getShopAdvModelFromDic:dictionary type:0];
        }else{
            [self getFoodModelDataFromDic:dictionary type:0];
        }
        [dictionary release];
        
    } else {
        //创建一个新的缓存字典
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        [dictionary release];
    }
    [fileManager release];
}

-(void)saveDataToCache:(NSDictionary *)dic
{
    NSString *documentsDirectory = [self documentsDirectoryWithTrailingSlash:YES];
    NSString *cacheDictionaryPath;
    if (advType == 0) {
        cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"AdvCached.dic"] retain];//广告缓存json
    }else if(advType == 4){
        cacheDictionaryPath = [[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"ShopAdv%@.dic", DataID]] retain];//广告缓存json
    }else{
        cacheDictionaryPath = [[documentsDirectory stringByAppendingString:@"FoodCached.dic"] retain];//广告缓存json
    }
    NSMutableArray *table = [dic mutableCopy];
    [self saveCacheDictionary:cacheDictionaryPath data:table];
    [table release];
}

//保存字典
-(BOOL) saveCacheDictionary:(NSString *)cacheDictionaryPath data:(NSMutableArray *)cacheDictionary{
    
    BOOL result = NO;
    if ([cacheDictionaryPath length] == 0 ||
        cacheDictionary == nil){
        return(NO);
    }
    result = [cacheDictionary writeToFile:cacheDictionaryPath atomically:YES];
    return(result);
}

- (void) shopAdvDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    twitterClient = nil;
    
    if (client.hasError) {
        [client alert];
        return;
    }
    NSDictionary* dic = (NSDictionary*)obj;
    
    [self getShopAdvModelFromDic:dic type:1];
    //[ary release];
    //[dic release];
}

- (void) advDidReceive:(TwitterClient*)client obj:(NSObject*)obj{
    twitterClient = nil;
    
    if (client.hasError) {
        [client alert];
        return;
    }
    NSDictionary* dic = (NSDictionary*)obj;
    
    [self getAdvModelFromDic:dic type:1];

}
//cacheType 0 缓存， 1 net
-(void)getShopAdvModelFromDic:(NSDictionary *)dic type:(int)cacheType{
    NSArray *ary = nil;
    ary = [dic objectForKey:@"datalist"];
    if ([ary count] == 0) {
        return;
    }
    if (cacheType == 1) {
        [self saveDataToCache:dic];
    }
    
    //int j = 1;
    AdvModel *model1;
    int add = [ary count] - [self.pages count];
    int start = [self.pages count];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    //[self.pages removeAllObjects];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dict = (NSDictionary*)[ary objectAtIndex:i];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        model1 = [[AdvModel alloc] initWithShopAdvDic:dict];
        model1.imageLocalPath = [imageDowload addTask:[NSString stringWithFormat:@"%d-%d", model1.advType, model1.dataID] url:model1.imageNetPath showImage:nil defaultImg:@"" indexInGroup:i Goup:1];
        [model1 setImg:model1.imageLocalPath Default:@"mindex.png"];
        [data addObject:model1];
        [model1 release];
        
        
        //j++;
    }
    //[timer fire];//貌似用这个方法无效
    CGFloat width;
    CGFloat height;
    if (add > 0) {//增加新增的
        width = add * self.frame.size.width;
        height = self.frame.size.height;
        scrollView.contentSize = CGSizeMake(width, height);
        
        for(int i = 0; i <  add; i++) {
            AdvView *view = [[AdvView alloc] initWithFrame:self.frame model:[self.pages objectAtIndex:i]];
            width = start*self.frame.size.width;
            view.frame = CGRectOffset(view.frame, width, 0);
            
            
        }
        if (cacheType == 1) {
            [self initShow:NO];
        }
    }else if(add < 0){
        add *= -1;
        width = add * self.frame.size.width;
        height = self.frame.size.height;
        scrollView.contentSize = CGSizeMake(width, height);
        if (cacheType == 1) {
            [self initShow:NO];
        }
    }
    //[self.pages release];//不需要 ，因为retain，所以下面的等式会自动release 和retain
    self.pages = data;
    pageCount = (int)[self.pages count];
    
    scrollView.contentSize = CGSizeMake(pageCount * self.frame.size.width, self.frame.size.height);
    pageControl.numberOfPages = pageCount;
    //[self.pages retain];
    self.startP = 1.0/pageCount;
    self.nowP = self.startP;
    [imageDowload startTask];
    
    
}
//cacheType 0 缓存， 1 net
-(void)getAdvModelFromDic:(NSDictionary *)dic type:(int)cacheType{
    NSArray *ary = nil;
    ary = [dic objectForKey:@"foodtypelist"];
    if ([ary count] == 0) {
        return;
    }
    if (cacheType == 1) {
        [self saveDataToCache:dic];
    }

    AdvModel *model1;
    int add = [ary count] - [self.pages count];
    int start = [self.pages count];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    //[self.pages removeAllObjects];
    for (int i = 0; i < [ary count]; ++i) {
        NSDictionary *dict = (NSDictionary*)[ary objectAtIndex:i];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        model1 = [[AdvModel alloc] initWithDic:dict];
        model1.imageLocalPath = [imageDowload addTask:[NSString stringWithFormat:@"%d-%d", model1.advType, model1.dataID] url:model1.imageNetPath showImage:nil defaultImg:@"" indexInGroup:i Goup:1];
        [model1 setImg:model1.imageLocalPath Default:@"mindex.png"];
        [data addObject:model1];
        [model1 release];
        
        
        //j++;
    }
    //[timer fire];//貌似用这个方法无效
    CGFloat width;
    CGFloat height;
    if (add > 0) {//增加新增的
        width = add * self.frame.size.width;
        height = self.frame.size.height;
        scrollView.contentSize = CGSizeMake(width, height);
       
        for(int i = 0; i <  add; i++) {
            AdvView *view = [[AdvView alloc] initWithFrame:self.frame model:[self.pages objectAtIndex:i]];
            width = start*self.frame.size.width;
            view.frame = CGRectOffset(view.frame, width, 0);
            
            
        }
        if (cacheType == 1) {
            [self initShow:NO];
        }
    }else if(add < 0){
        add *= -1;
        width = add * self.frame.size.width;
        height = self.frame.size.height;
        scrollView.contentSize = CGSizeMake(width, height);
        if (cacheType == 1) {
            [self initShow:NO];
        }
    }
    //[self.pages release];//不需要 ，因为retain，所以下面的等式会自动release 和retain
    self.pages = data;
    pageCount = [self.pages count];
    
    scrollView.contentSize = CGSizeMake(pageCount * self.frame.size.width, self.frame.size.height);
    pageControl.numberOfPages = pageCount;
    //[self.pages retain];
    self.startP = 1.0/pageCount;
    self.nowP = self.startP;
    [imageDowload startTask];
    
    
}

-(void)cachedDownloadFinish:(NSMutableArray *)arry start:(int)index dowType:(int)type{
    
    [timer setFireDate:[NSDate distantFuture]];
    
    ImageDowloadTask *task;
    if (advType == 0 || advType == 4) {
        AdvModel *model1;
        for (int i = index; i < [arry count]; i++) {
            task = [arry objectAtIndex:i];
            if (task.locURL.length == 0) {
                task.locURL = @"mindex.png";
            }
            if (task.index < [self.pages count]) {
                model1 = (AdvModel *)[self.pages objectAtIndex:task.index];
                model1.imageLocalPath = task.locURL;
                [model1 setImg:model1.imageLocalPath Default:@"mindex.png"];
            }
            
        }
    }else{
        FoodModel *model1;
        for (int i = index; i < [arry count]; i++) {
            task = [arry objectAtIndex:i];
            if (task.locURL.length == 0) {
                task.locURL = @"Icon.png";
            }
            if (task.index < [self.pages count]) {
                model1 = (FoodModel *)[self.pages objectAtIndex:task.index];
                model1.picPath = task.locURL;
                [model1 setImg:model1.picPath Default:@"暂无图片"];
            }
            
        }
    }
    
    
    if (currentPhotoNum < 0) {
        currentPhotoNum = -1;
    }
    [self initShow:NO];
    
    [timer setFireDate:[NSDate date]];
}

-(void)updataUI:(int)type{
    if (_progressHUD)
    {
        [_progressHUD removeFromSuperview];
        [_progressHUD release];
        _progressHUD = nil;
    }
}

- (void) tick {
    //NSLog(@"next adv");
    
    if (currentPhotoNum < -1) {
        return;
    }
    if (!isStartTick) {
        isStartTick = YES;
        return;
    }
    
    int n = 0;
    if (leftOrRight) {
        n = currentPhotoNum - 1 == -1 ? -1 : currentPhotoNum-1;
        if (n == - 1) {
            leftOrRight = NO;
            n = 1;
        }
        
    }else{
        
        n = currentPhotoNum+1 >= pageCount ? pageCount : currentPhotoNum+1;
        if (n == pageCount) {
            leftOrRight = YES;
            n = pageCount - 2;
        }
        
    }
    
    
    
    [self scrollToView:n];
    
}

-(void)scrollToView:(int)n
{
    
    [scrollView setContentOffset:CGPointMake(n*self.frame.size.width, 0) animated:YES];
}

- (void) initShow:(BOOL)isStop {
    int scrollPhotoNumber = MAX(0, MIN(pageCount-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
    
    if(scrollPhotoNumber != currentPhotoNum && pageCount > 0) {
        
        
        currentPhotoNum = scrollPhotoNumber;
        
        if (advType == 3 && currentPhotoNum == pageCount - 1) {
            [delegate dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        AdvModel * model;
        int num;
        FoodModel *model1;
        PopAdvModel *model2;
        if(rollType == 1){
            switch (showIndex) {
                case 1:
                    [backGroud3 setFrame:CGRectMake(self.frame.size.width * (currentPhotoNum -1), 0, self.frame.size.width, self.frame.size.height)];
                    [backGroud1 setFrame:CGRectMake(self.frame.size.width * currentPhotoNum, 0, self.frame.size.width, self.frame.size.height)];
                    [backGroud2 setFrame:CGRectMake(self.frame.size.width * (currentPhotoNum + 1), 0, self.frame.size.width, self.frame.size.height)];
                    break;
                case 2:
                    
                    [backGroud1 setFrame:CGRectMake(self.frame.size.width * (currentPhotoNum -1), 0, self.frame.size.width, self.frame.size.height)];
                    [backGroud2 setFrame:CGRectMake(self.frame.size.width * currentPhotoNum, 0, self.frame.size.width, self.frame.size.height)];
                    [backGroud3 setFrame:CGRectMake(self.frame.size.width * (currentPhotoNum + 1), 0, self.frame.size.width, self.frame.size.height)];
                    break;
                case 3:
                    
                    [backGroud2 setFrame:CGRectMake(self.frame.size.width * (currentPhotoNum -1), 0, self.frame.size.width, self.frame.size.height)];
                    [backGroud3 setFrame:CGRectMake(self.frame.size.width * currentPhotoNum, 0, self.frame.size.width, self.frame.size.height)];
                    [backGroud1 setFrame:CGRectMake(self.frame.size.width * (currentPhotoNum + 1), 0, self.frame.size.width, self.frame.size.height)];
                    break;
            }
            switch (advType) {
                case 0:
                case 4:
                    
                    model = (AdvModel * )[self.pages objectAtIndex:currentPhotoNum];
                    switch (showIndex) {
                        case 1:
                            backgroundImage3.image = nil;
                            backgroundImage3.image = currentPhotoNum-1 >= 0 ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum-1] image] : nil;
                            backgroundImage1.image = nil;
                            backgroundImage1.image = [model image];
                            backgroundImage2.image = nil;
                            backgroundImage2.image = currentPhotoNum+1 < [self.pages count] ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : nil;
                            showIndex = 2;
                            break;
                        case 2:
                            backgroundImage1.image = nil;
                            backgroundImage1.image = currentPhotoNum-1 >= 0 ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum-1] image] : nil;
                            backgroundImage2.image = nil;
                            backgroundImage2.image = [model image];
                            backgroundImage3.image = nil;
                            backgroundImage3.image = currentPhotoNum+1 < [self.pages count] ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : nil;
                            showIndex = 3;
                            break;
                        case 3:
                            backgroundImage2.image = nil;
                            backgroundImage2.image = currentPhotoNum-1 >= 0 ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum-1] image] : nil;
                            backgroundImage3.image = nil;
                            backgroundImage3.image = [model image];
                            backgroundImage1.image = nil;
                            backgroundImage1.image = currentPhotoNum+1 < [self.pages count] ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : nil;
                            showIndex = 1;
                            break;
                    }
                    
                    break;
                case 1:
                    num = currentPhotoNum * 6;
                    
                    switch (showIndex) {
                        case 1:
                            b3Img1.image = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] image] : nil;
                            b3Img1.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b3Img2.image = num-2 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-2] image] : nil;
                            b3Img2.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b3Img3.image = num-3 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-3] image] : nil;
                            b3Img3.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b3Img4.image = num-4 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-4] image] : nil;
                            b3Img4.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b3Img5.image = num-5 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-5] image] : nil;
                            b3Img5.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b3Img6.image = num-6 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-6] image] : nil;
                            b3Img6.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b1Img1.image = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] image] : nil;
                            b1Img1.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b1Img2.image = num+1 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+1] image] : nil;
                            b1Img2.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b1Img3.image = num+2 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+2] image] : nil;
                            b1Img3.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b1Img4.image = num+3 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+3] image] : nil;
                            b1Img4.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b1Img5.image = num+4 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+4] image] : nil;
                            b1Img5.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b1Img6.image = num+5 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+5] image] : nil;
                            b1Img6.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            
                            b2Img1.image = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] image] : nil;
                            b2Img1.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b2Img2.image = num+7 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+7] image] : nil;
                            b2Img2.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b2Img3.image = num+8 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+8] image] : nil;
                            b2Img3.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b2Img4.image = num+9 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+9] image] : nil;
                            b2Img4.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b2Img5.image = num+10 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+10] image] : nil;
                            b2Img5.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b2Img6.image = num+11 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+11] image] : nil;
                            b2Img6.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            
                            
                            showIndex = 2;
                            break;
                        case 2:
                            b1Img1.image = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] image] : nil;
                            b1Img1.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b1Img2.image = num-2 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-2] image] : nil;
                            b1Img2.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b1Img3.image = num-3 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-3] image] : nil;
                            b1Img3.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b1Img4.image = num-4 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-4] image] : nil;
                            b1Img4.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b1Img5.image = num-5 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-5] image] : nil;
                            b1Img5.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b1Img6.image = num-6 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-6] image] : nil;
                            b1Img6.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b2Img1.image = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] image] : nil;
                            b2Img1.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b2Img2.image = num+1 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+1] image] : nil;
                            b2Img2.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b2Img3.image = num+2 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+2] image] : nil;
                            b2Img3.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b2Img4.image = num+3 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+3] image] : nil;
                            b2Img4.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b2Img5.image = num+4 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+4] image] : nil;
                            b2Img5.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b2Img6.image = num+5 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+5] image] : nil;
                            b2Img6.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            
                            b3Img1.image = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] image] : nil;
                            b3Img1.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b3Img2.image = num+7 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+7] image] : nil;
                            b3Img2.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b3Img3.image = num+8 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+8] image] : nil;
                            b3Img3.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b3Img4.image = num+9 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+9] image] : nil;
                            b3Img4.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b3Img5.image = num+10 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+10] image] : nil;
                            b3Img5.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b3Img6.image = num+11 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+11] image] : nil;
                            b3Img6.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            
                            showIndex = 3;
                            break;
                        case 3:
                            b2Img1.image = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] image] : nil;
                            b2Img1.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b2Img2.image = num-2 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-2] image] : nil;
                            b2Img2.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b2Img3.image = num-3 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-3] image] : nil;
                            b2Img3.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b2Img4.image = num-4 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-4] image] : nil;
                            b2Img4.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b2Img5.image = num-5 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-5] image] : nil;
                            b3Img5.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b2Img6.image = num-6 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-6] image] : nil;
                            b2Img6.tag = num-1 >= 0 ? [(FoodModel*)[self.pages objectAtIndex:num-1] foodid] : 0;
                            
                            b3Img1.image = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] image] : nil;
                            b3Img1.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b3Img2.image = num+1 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+1] image] : nil;
                            b3Img2.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b3Img3.image = num+2 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+2] image] : nil;
                            b3Img3.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b3Img4.image = num+3 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+3] image] : nil;
                            b3Img4.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b3Img5.image = num+4 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+4] image] : nil;
                            b3Img5.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            b3Img6.image = num+5 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+5] image] : nil;
                            b3Img6.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                            
                            
                            b1Img1.image = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] image] : nil;
                            b1Img1.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b1Img2.image = num+7 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+7] image] : nil;
                            b1Img2.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b1Img3.image = num+8 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+8] image] : nil;
                            b1Img3.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b1Img4.image = num+9 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+9] image] : nil;
                            b1Img4.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b1Img5.image = num+10 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+10] image] : nil;
                            b1Img5.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            
                            b1Img6.image = num+11 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+11] image] : nil;
                            b1Img6.tag = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] foodid] : 0;
                            showIndex = 1;
                            break;
                    }
                    
                    
                    break;
                case 2:
                    switch (showIndex) {
                        case 1:
                            model1 = currentPhotoNum-1  >= 0 ? [self.pages objectAtIndex:currentPhotoNum-1] : nil;
                            if (model1) {
                                backgroundImage3.image = [model1 image];
                                name3.text = model1.foodname;
                                price3.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            }
                            
                            model1 = (FoodModel * )[self.pages objectAtIndex:currentPhotoNum];
                            backgroundImage1.image = [model1 image];
                            name1.text = model1.foodname;
                            price1.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            
                            model1 = currentPhotoNum+1 < [self.pages count] ? [self.pages objectAtIndex:currentPhotoNum+1] : nil;
                            if (model1) {
                                backgroundImage2.image = [model1 image];
                                name2.text = model1.foodname;
                                price2.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            }
                            showIndex = 2;
                            
                            
                            break;
                        case 2:
                            model1 = currentPhotoNum-1  >= 0 ? [self.pages objectAtIndex:currentPhotoNum-1] : nil;
                            if (model1) {
                                backgroundImage1.image = [model1 image];
                                name1.text = model1.foodname;
                                price1.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            }
                            
                            model1 = (FoodModel * )[self.pages objectAtIndex:currentPhotoNum];
                            backgroundImage2.image = [model1 image];
                            name2.text = model1.foodname;
                            price2.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            
                            model1 = currentPhotoNum+1 < [self.pages count] ? [self.pages objectAtIndex:currentPhotoNum+1] : nil;
                            if (model1) {
                                backgroundImage3.image = [model1 image];
                                name3.text = model1.foodname;
                                price3.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            }
                            showIndex = 3;
                            break;
                        case 3:
                            model1 = currentPhotoNum-1  >= 0 ? [self.pages objectAtIndex:currentPhotoNum-1] : nil;
                            if (model1) {
                                backgroundImage2.image = [model1 image];
                                name2.text = model1.foodname;
                                price2.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            }
                            
                            model1 = (FoodModel * )[self.pages objectAtIndex:currentPhotoNum];
                            backgroundImage3.image = [model1 image];
                            name3.text = model1.foodname;
                            price3.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            
                            model1 = currentPhotoNum+1 < [self.pages count] ? [self.pages objectAtIndex:currentPhotoNum+1] : nil;
                            if (model1) {
                                backgroundImage1.image = [model1 image];
                                name1.text = model1.foodname;
                                price1.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                            }
                            showIndex = 1;
                            break;
                    }
                    
                    
                    
                    break;
                case 3:
                    switch (showIndex) {
                        case 1:
                            model2 = (PopAdvModel * )[self.pages objectAtIndex:currentPhotoNum];
                            backgroundImage1.image = nil;
                            backgroundImage1.image = [model2 image];
                            backgroundImage2.image = nil;
                            backgroundImage2.image = currentPhotoNum+1 < [self.pages count] ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : model2.image;
                            backgroundImage3.image = nil;
                            backgroundImage3.image = currentPhotoNum-1  >= 0 ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum-1] image] : model2.image;
                            showIndex = 2;
                            break;
                        case 2:
                            
                            
                            model2 = (PopAdvModel * )[self.pages objectAtIndex:currentPhotoNum];
                            backgroundImage2.image = nil;
                            backgroundImage2.image = [model2 image];
                            backgroundImage3.image = nil;
                            backgroundImage3.image = currentPhotoNum+1 < [self.pages count] ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : model2.image;
                            backgroundImage1.image = nil;
                            backgroundImage1.image = currentPhotoNum-1  >= 0 ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum-1] image] : model2.image;
                            showIndex = 3;
                            break;
                        case 3:
                            
                            model2 = (PopAdvModel * )[self.pages objectAtIndex:currentPhotoNum];
                            backgroundImage3.image = nil;
                            backgroundImage3.image = [model2 image];
                            backgroundImage1.image = nil;
                            backgroundImage1.image = currentPhotoNum+1 < [self.pages count] ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : model2.image;
                            backgroundImage2.image = nil;
                            backgroundImage2.image = currentPhotoNum-1  >= 0 ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum-1] image] : model2.image;
                            
                            
                            showIndex = 1;
                            break;
                    }
                    
                    break;
                default:
                    break;
            }
        }else{
            switch (advType) {
                case 0:
                case 4:
                    model = (AdvModel * )[self.pages objectAtIndex:currentPhotoNum];
                    backgroundImage1.image = nil;
                    backgroundImage1.image = [model image];
                    backgroundImage2.image = nil;
                    backgroundImage2.image = currentPhotoNum+1 < [self.pages count] ? [(AdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : nil;
                    break;
                case 1:
                    num = currentPhotoNum * 6;
                    
                    b1Img1.image = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] image] : nil;
                    b1Img1.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                    
                    b1Img2.image = num+1 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+1] image] : nil;
                    b1Img2.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                    
                    b1Img3.image = num+2 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+2] image] : nil;
                    b1Img3.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                    
                    b1Img4.image = num+3 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+3] image] : nil;
                    b1Img4.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                    
                    b1Img5.image = num+4 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+4] image] : nil;
                    b1Img5.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                    
                    b1Img6.image = num+5 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+5] image] : nil;
                    b1Img6.tag = num < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num] foodid] : 0;
                    
                    
                    b2Img1.image = num+6 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+6] image] : nil;
                    
                    b2Img2.image = num+7 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+7] image] : nil;
                    
                    b2Img3.image = num+8 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+8] image] : nil;
                    
                    b2Img4.image = num+9 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+9] image] : nil;
                    
                    b2Img5.image = num+10 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+10] image] : nil;
                    
                    b2Img6.image = num+11 < [self.pages count] ? [(FoodModel*)[self.pages objectAtIndex:num+11] image] : nil;
                    break;
                case 2:
                    model1 = (FoodModel * )[self.pages objectAtIndex:currentPhotoNum];
                    backgroundImage1.image = [model1 image];
                    name1.text = model1.foodname;
                    price1.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                    
                    model1 = currentPhotoNum+1 < [self.pages count] ? [self.pages objectAtIndex:currentPhotoNum+1] : nil;
                    if (model1) {
                        backgroundImage2.image = [model1 image];
                        name2.text = model1.foodname;
                        price2.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                    }
                    
                    model1 = currentPhotoNum-1 >= 0 ? [self.pages objectAtIndex:currentPhotoNum-1] : nil;
                    if (model1) {
                        backgroundImage3.image = [model1 image];
                        name3.text = model1.foodname;
                        price3.text = [NSString stringWithFormat:@"￥%.2f/%@", ((FoodAttrModel *)[model1.attr objectAtIndex:0]).price, ((FoodAttrModel *)[model1.attr objectAtIndex:0]).name];
                    }
                    
                    break;
                case 3:
                    model2 = (PopAdvModel * )[self.pages objectAtIndex:currentPhotoNum];
                    backgroundImage1.image = nil;
                    backgroundImage1.image = [model2 image];
                    backgroundImage2.image = nil;
                    backgroundImage2.image = currentPhotoNum+1 < [self.pages count] ? [(PopAdvModel*)[self.pages objectAtIndex:currentPhotoNum+1] image] : model2.image;
                    break;
                default:
                    break;
            }
            
            
            if (self.progressView) {
                self.nowP = self.startP * (currentPhotoNum + 1);
                if (self.nowP > 1.0) {
                    self.nowP = self.startP;
                }
                [self.progressView setProgress:self.nowP];
            }
            float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
            
            
            //left
            if(offset < 0) {
                
                pageControl.currentPage = 0;
                
                offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
                backGroud2.alpha = 0;
                backGroud1.alpha = (offset / self.frame.size.width);
                
                //other
            } else if(offset != 0) {
                
                //last
                if(scrollPhotoNumber == pageCount-1) {
                    pageControl.currentPage = pageCount-1;
                    
                    backGroud1.alpha = 1.0 - (offset / self.frame.size.width);
                } else {
                    
                    pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
                    
                    backGroud2.alpha = offset / self.frame.size.width;
                    backGroud1.alpha = 1.0 - backGroud2.alpha;
                }
                //stable
            } else {
                
                pageControl.currentPage = currentPhotoNum;
                backGroud1.alpha = 1;
                backGroud2.alpha = 0;
            }
        }
        
    
    
    }else{
        /*if (advType == 3) {
         [delegate dismissViewControllerAnimated:YES completion:nil];
         return;
         }*/
    }
}



#pragma mark UIScrollView

//已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

//将要开始拖拽，手指已经放在view上并准备拖动的那一刻
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

//开始滚动 只要view有滚动（不管是拖、拉、放大、缩小等导致）都会执行此函数
- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    [self initShow:NO];
}
//滚动结束时
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    /**/
    [self initShow:YES];
}

- (void)dealloc {
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
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    if (self.pages != nil) {
        [self.pages release];
        self.pages = nil;
    }
    if (imageDowload != nil) {
        [imageDowload stopTask];
        [imageDowload release];
    }
    [self.progressView release];
    [DataID release];
    [imgClick release];
    [bgClick release];
    [name1 release];
    [price1 release];
    [name2 release];
    [price2 release];
    [super dealloc];
}

@end
