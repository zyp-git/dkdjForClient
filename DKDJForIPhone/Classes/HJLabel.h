//
//  HJLabel.h
//  ShanShi
//
//  Created by ihangjing on 15/3/2.
//
//

#import <UIKit/UIKit.h>

@interface HJLabel : UILabel
{
    UIImage *leftImage;
    int backType;//背景形状 0默认不做修改
    UIColor *lineColor;
    UIColor *backColor;
}

@property(nonatomic) UIEdgeInsets insets;
-(id)initWithBackType:(int)type lineColor:(UIColor *)lcolor backColor:(UIColor *)bcolor;
-(id) initleftImage:(UIImage *)img;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithFrame:(CGRect)frame leftImage:(UIImage *)img;
-(id) initWithInsets: (UIEdgeInsets) insets;
-(void)setLeftImage:(UIImage *)lImg;
- (void)alignTop ;
- (void)alignBottom;

@end
