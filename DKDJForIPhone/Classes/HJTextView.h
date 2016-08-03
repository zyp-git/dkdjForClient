//
//  HJTextView.h
//  ShanShi
//
//  Created by ihangjing on 15/3/11.
//
//

#import <UIKit/UIKit.h>

@interface HJTextView : UITextView
{
    UILabel *placeholderLabel;
}
-(id)initWithFrame:(CGRect)frame placeholder:(NSString *)value font:(UIFont *)font borderColor:(UIColor *)bColor;
-(void)setPlaceholderHiden:(BOOL)hiden;
@end
