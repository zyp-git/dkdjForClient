//
//  HJTextField.h
//  ShanShi
//
//  Created by ihangjing on 15/5/15.
//
//

#import <UIKit/UIKit.h>

@interface HJTextField : UITextField
{
    UIImage *leftImage;
}
@property(nonatomic) UIEdgeInsets insets;
-(id)initWithFrame:(CGRect)frame leftImage:(UIImage *)img borderColor:(UIColor *)bColor;
@end
