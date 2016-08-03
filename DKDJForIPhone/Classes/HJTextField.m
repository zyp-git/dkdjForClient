//
//  HJTextField.m
//  ShanShi
//
//  Created by ihangjing on 15/5/15.
//
//

#import "HJTextField.h"

@implementation HJTextField
@synthesize insets;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame leftImage:(UIImage *)img borderColor:(UIColor *)bColor
{
    self = [super initWithFrame:frame];
    if(self){
        
        CGSize size = img.size;
        float w = 0.0;
        float h = 0.0;
        if (10 > frame.size.width) {
            w = frame.size.width;
        }else{
            w = frame.size.width - 10.0;
        }
        if (10 > frame.size.height) {
            h = frame.size.height;
        }else{
            h = frame.size.height - 10.0;
        }
        float p = size.width / size.height;
        if (h * p >= w) {
            h = w / p;
        }else{
            w = h * p;
        }
        
        
        self.insets = UIEdgeInsetsMake(0.0, w + 3, 0, 0.0);
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0, (frame.size.height - h) / 2, w, h)];
        icon.image = img;
        [self addSubview:icon];
        [icon release];
        
        self.layer.backgroundColor = bColor.CGColor;
        self.layer.borderColor = bColor.CGColor;//[[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 15.0f;
        [self.layer setMasksToBounds:YES];
    }
    return self;
}
/*
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.insets)];
}
 */
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.insets)];
}
/*- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [super placeholderRectForBounds:bounds];
}*/
//在画  Label 的文本时分别设置文本与  Label 四个边的间隙，即画在 Label 内的一个小矩形内
-(void) drawTextInRect:(CGRect)rect
{
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    return [super drawPlaceholderInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

-(void)dealloc
{
    [leftImage release];
    [super dealloc];
}
@end
