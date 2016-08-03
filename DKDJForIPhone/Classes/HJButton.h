//
//  HJLabel.h
//  ShanShi
//
//  Created by ihangjing on 15/3/2.
//
//

#import <UIKit/UIKit.h>

@interface HJButton : UIButton
{
    UIImageView *leftImage;
    UIImageView *rightImage;
    int backType;//背景形状 0默认不做修改
}

@property(nonatomic) UIEdgeInsets insets;
-(id)initWithBackType:(int)type lineColor:(UIColor *)lcolor backColor:(UIColor *)bcolor;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithFrame:(CGRect)frame leftImage:(UIImage *)lImg  rightImage:(UIImage *)rImg;
-(id) initWithInsets: (UIEdgeInsets) insets;
-(id)initWithFrame:(CGRect)frame borderColor:(UIColor *)bColor;
-(void)setLeftImage:(UIImage *)lImg;
-(void)setRightImage:(UIImage *)rImg;
@end
