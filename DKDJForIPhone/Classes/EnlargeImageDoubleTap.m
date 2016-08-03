//
//  EnlargeImageDoubleTap.m
//  TSYP
//
//  Created by wulin on 13-6-24.
//
//

#import "EnlargeImageDoubleTap.h"
@interface EnlargeImageDoubleTap (private)
- (void)fadeIn;
- (void)fadeOut;
- (void)closeImage;
@end

@implementation EnlargeImageDoubleTap
@synthesize parentview;
@synthesize imageBackground,imageBackView,maskView;

- (id)initWithFrame:(CGRect)frame
{
    isShow = NO;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



/*
 * setDoubleTap 初始化图片
 * @parent UIView 父窗口
 */
- (void)setDoubleTap:(UIView*) parent
{
    isShow = NO;
    parentview=parent;
    parentview.userInteractionEnabled=YES;
    self.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *doubleTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognize.numberOfTapsRequired = 1;
    [doubleTapRecognize setEnabled :YES];
    [doubleTapRecognize delaysTouchesBegan];
    [doubleTapRecognize cancelsTouchesInView];
    
    
    [self addGestureRecognizer:doubleTapRecognize];
    
}


#pragma UIGestureRecognizer Handles

-(void) handleCloseTap:(UITapGestureRecognizer *)recognizer
{
    if (isShow) {
        [self closeImage];
        isShow = NO;
        return;
    }
}
/*
 * handleDoubleTap 双击图片弹出单独浏览图片层
 * recognizer 双击手势
 */
-(void) handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (imageBackView==nil) {
        isShow = YES;
        if( [[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeLeft||[[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeRight)
        {
            frameRect = CGRectMake(0, 0, parentview.frame.size.height+20, parentview.frame.size.width);
        }else
        {
            frameRect = CGRectMake(0, 0, parentview.frame.size.width, parentview.frame.size.height+20);
        }
        
        imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.image.size.width+20, self.image.size.height+60)];
        imageBackView.backgroundColor = [UIColor grayColor];
        imageBackView.layer.cornerRadius = 10.0; //根据需要调整
        self.userInteractionEnabled=YES;
        
        imageBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *doubleTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleCloseTap:)];
        doubleTapRecognize.numberOfTapsRequired = 1;
        [doubleTapRecognize setEnabled :YES];
        [doubleTapRecognize delaysTouchesBegan];
        [doubleTapRecognize cancelsTouchesInView];
        
        
        [imageBackView addGestureRecognizer:doubleTapRecognize];
        
        [[imageBackView layer] setShadowOffset:CGSizeMake(10, 10)];
        [[imageBackView layer] setShadowRadius:5];
        [[imageBackView layer] setShadowOpacity:0.7];
        [[imageBackView layer] setShadowColor:[UIColor blackColor].CGColor];
        
        maskView = [[UIView alloc]initWithFrame:frameRect];
        maskView.backgroundColor = [UIColor grayColor];
        maskView.alpha=0.7;
        
        UIImage *imagepic = self.image;
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, self.image.size.width, self.image.size.height)];
        [view setImage:imagepic];
        /*UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *closeimg = [UIImage imageNamed:@"closeImage.png"];
        btn.frame = CGRectMake(self.image.size.width-30,0, closeimg.size.width,closeimg.size.height);
        [btn setBackgroundImage:closeimg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeImage:) forControlEvents:UIControlEventTouchUpInside];*/
        
        [imageBackView addSubview:view];
        [parentview addSubview:maskView];
        imageBackView.center= CGPointMake((frameRect.origin.x+frameRect.size.width)/2
                                          ,(frameRect.origin.y+frameRect.size.height)/2);
        [parentview addSubview:imageBackView];
        //[imageBackView addSubview:btn];
        [parentview bringSubviewToFront:imageBackView];
        
        [self fadeIn];
        
        
    }
}

/*
 * fadeIn 图片渐入动画
 */
-(void)fadeIn
{
    imageBackView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    imageBackView.alpha = 0;
    [UIView animateWithDuration:.55 animations:^{
        imageBackView.alpha = 1;
        imageBackView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

/*
 * fadeOut 图片逐渐消失动画
 */
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        imageBackView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        imageBackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [imageBackView removeFromSuperview];
        }
    }];
}

/*
 * closeImage 关闭弹出图片层
 */
-(void)closeImage
{
    [self fadeOut];
    imageBackView=nil;
    [maskView removeFromSuperview];
    maskView=nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
