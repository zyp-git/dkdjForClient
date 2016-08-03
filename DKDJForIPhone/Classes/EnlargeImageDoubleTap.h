//
//  EnlargeImageDoubleTap.h
//  TSYP
//
//  Created by wulin on 13-6-24.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 

@interface EnlargeImageDoubleTap : UIImageView
{
    UIView *parentview;         //父窗口，即用将UIImageEx所加到的UIView
    UIImageView *imageBackground;  //放大图片后的背景
    UIView* imageBackView;         //单独查看时的背景
    
    UIView* maskView;              //遮罩层
    CGRect frameRect;
    BOOL isShow;
}
@property (nonatomic,retain) UIView *parentview;
@property (nonatomic,retain) UIImageView *imageBackground;
@property (nonatomic,retain) UIView* imageBackView;
@property (nonatomic,retain) UIView* maskView;



- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;

//必须设置的
- (void)setDoubleTap:(UIView*)imageView;
@end
