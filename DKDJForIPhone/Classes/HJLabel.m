//
//  HJLabel.m
//  ShanShi
//
//  Created by ihangjing on 15/3/2.
//
//

#import "HJLabel.h"

@implementation HJLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize insets=_insets;

-(id)init
{
    self = [super init];
    if (self) {
        backType = 0;
        
        
    }
    return self;
}

-(id)initWithBackType:(int)type lineColor:(UIColor *)lcolor backColor:(UIColor *)bcolor
{
    self = [super init];
    if (self) {
        backType = type;
        lineColor = lcolor;
        [lineColor retain];
        backColor = bcolor;
        [backColor retain];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initleftImage:(UIImage *)img
{
    self = [super init];
    if(self){
        
        leftImage = img;
        [leftImage retain];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame leftImage:(UIImage *)img
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
        
        
        self.insets = UIEdgeInsetsMake(0.0, w, 0, 0.0);
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, (frame.size.height - h) / 2, w, h)];
        icon.image = img;
        [self addSubview:icon];
        [icon release];
    }
    return self;
}
- (void)alignTop
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
    
}
- (void)alignBottom
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    
}
-(void)setLeftImage:(UIImage *)lImg
{
    
    leftImage = lImg;
    [leftImage retain];
    
    
    
}

// 点击该label的时候, 来个高亮显示
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:[UIColor whiteColor]];
}
// 还原label颜色,获取手指离开屏幕时的坐标点, 在label范围内的话就可以触发自定义的操作
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint points = [touch locationInView:self];
    if (points.x >= self.frame.origin.x && points.y >= self.frame.origin.x && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    {
        //[delegate myLabel:self touchesWtihTag:self.tag];
    }
}*/
/*
-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //[super drawRect:rect];
    switch (backType) {
        case 0:
            
            break;
        case 1://椭圆
            CGContextSetLineWidth(context, 2.0);
            
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            CGContextSetFillColorSpace(context, backColor);
            
            CGRect rectangle = CGRectMake(rect.origin.x + 1,rect.origin.y + 1,rect.size.width - 2,rect.size.height - 2);
            
            CGContextAddEllipseInRect(context, rectangle);
            
            CGContextStrokePath(context);
            break;
        default:
            break;
    }
    
}
*/
-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
//在画  Label 的文本时分别设置文本与  Label 四个边的间隙，即画在 Label 内的一个小矩形内
-(void) drawTextInRect:(CGRect)rect {
    if (leftImage) {
        CGSize size = leftImage.size;
        CGRect frame = self.frame;
        float w = 0.0;
        float h = 0.0;
        if (20 > frame.size.width) {
            w = frame.size.width;
        }else{
            w = frame.size.width - 10.0;
        }
        if (20 > frame.size.height) {
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
        
        
        self.insets = UIEdgeInsetsMake(0.0, w, 0, 0.0);
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, (frame.size.height - h) / 2, w, h)];
        icon.image = leftImage;
        [self addSubview:icon];
        [icon release];
        /*frame.size.width = frame.size.width + 20 + w;
        self.frame = frame;
        
        rect.size.width = frame.size.width + 20 + w;*/
        
        rect.size.width = frame.size.width + 20 + w;
    }
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

-(void)dealloc
{
    [leftImage release];
    [lineColor release];
    [backColor release];
    [super dealloc];
}

@end
