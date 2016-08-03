//
//  HJTextView.m
//  ShanShi
//
//  Created by ihangjing on 15/3/11.
//
//

#import "HJTextView.h"

@implementation HJTextView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame placeholder:(NSString *)value font:(UIFont *)font borderColor:(UIColor *)bColor
{
    self = [super initWithFrame:frame];
    if (self) {
        /*self.layer.cornerRadius = 6;
         self.layer.masksToBounds = YES;*/
        
        self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        self.layer.borderColor = bColor.CGColor;//[[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 8.0f;
        [self.layer setMasksToBounds:YES];
        
        placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 3.0, frame.size.width - 5, /*frame.size.height - 3*/15)];
        //placeholderLabel.
        placeholderLabel.text = value;
        placeholderLabel.font = font;
        self.font = font;
        self.scrollEnabled = NO;//禁止滚动，要在设置font之后，否则设置font时候会设置为YES
        placeholderLabel.textColor = [UIColor grayColor];
        placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeholderLabel.numberOfLines = 10;//最多行数
        [self addSubview:placeholderLabel];
        
        //注册一个通知中心，监听文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

-(void)setPlaceholderHiden:(BOOL)hiden
{
    [placeholderLabel setHidden:hiden];
}
/*-(void) drawRect:(CGRect)rect {
 if (self.text.length > 0) {
 [placeholderLabel setHidden:YES];
 }else{
 [placeholderLabel setHidden:NO];
 }
 [super drawRect:rect];
 }*/
#pragma mark Setter/Getters
-(void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

#pragma mark-监听文字的改变
-(void)textDidChange
{
    if (self.text.length > 0) {
        [placeholderLabel setHidden:YES];
    }else{
        [placeholderLabel setHidden:NO];
    }
}

-(void)dealloc
{
    [placeholderLabel release];
    [super dealloc];
}

@end
