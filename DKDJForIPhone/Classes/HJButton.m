//
//  HJLabel.m
//  ShanShi
//
//  Created by ihangjing on 15/3/2.
//
//

#import "HJButton.h"

@implementation HJButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame leftImage:(UIImage *)lImg  rightImage:(UIImage *)rImg
{
    self = [super initWithFrame:frame];
    if(self){
        CGSize size;
        float w = 0.0;
        float h = 0.0;
        float p;
        if (lImg) {
            CGSize size = lImg.size;
            float w = 0.0;
            float h = 0.0;
            if (10 > frame.size.width) {
                w = frame.size.width;
            }else{
                w = frame.size.width - 5.0;
            }
            if (10 > frame.size.height) {
                h = frame.size.height;
            }else{
                h = frame.size.height - 5.0;
            }
            p = size.width / size.height;
            if (h * p >= w) {
                h = w / p;
            }else{
                w = h * p;
            }
            if (size.width < w) {
                w = size.width;
                h = w / p;
            }
            leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, (frame.size.height - h) / 2, w, h)];
            leftImage.image = lImg;
            [self addSubview:leftImage];
        }
        if (rImg) {
            size = rImg.size;
            w = 0.0;
            h = 0.0;
            if (10 > frame.size.width) {
                w = frame.size.width;
            }else{
                w = frame.size.width - 5.0;
            }
            if (10 > frame.size.height) {
                h = frame.size.height;
            }else{
                h = frame.size.height - 5.0;
            }
            p = size.width / size.height;
            
            if (h * p >= w) {
                h = w / p;
            }else{
                w = h * p;
            }
            if (size.width < w) {
                w = size.width;
                h = w / p;
            }
            
            self.insets = UIEdgeInsetsMake(0.0, w, 0, 0.0);
            rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - w, (frame.size.height - h) / 2, w, h)];
            rightImage.image = rImg;
            [self addSubview:rightImage];
        }
        
        
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame borderColor:(UIColor *)bColor
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.backgroundColor = bColor.CGColor;
        self.layer.borderColor = bColor.CGColor;//[[UIColor colorWithRed:255/255.0 green:64/255.0 blue:76/255.0 alpha:1.0]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 15.0f;
        [self.layer setMasksToBounds:YES];
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}
-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect textRect = self.titleLabel.frame;
    if (leftImage) {
        if (leftImage.frame.size.width == 0) {
            CGSize size = leftImage.image.size;
            float w = 0.0;
            float h = 0.0;
            float p;
            CGRect frame = rect;
            if (20 > frame.size.width) {
                w = frame.size.width;
            }else{
                w = frame.size.width - 5.0;
            }
            if (20 > frame.size.height) {
                h = frame.size.height;
            }else{
                h = frame.size.height - 5.0;
            }
            p = size.width / size.height;
            if (h * p >= w) {
                h = w / p;
            }else{
                w = h * p;
            }
            textRect = self.titleLabel.frame;
            //leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(textRect.origin.x - leftImage.frame.size.width - 3, (frame.size.height - h) / 2, w, h)];
            
        }
        [leftImage setFrame:CGRectMake(textRect.origin.x - leftImage.frame.size.width - 3, leftImage.frame.origin.y, leftImage.frame.size.width, leftImage.frame.size.height)];
        
        
    }
    if (rightImage) {
        [rightImage setFrame:CGRectMake(textRect.origin.x + textRect.size.width + 3, rightImage.frame.origin.y, rightImage.frame.size.width, rightImage.frame.size.height)];
    }
    
}

-(void)setLeftImage:(UIImage *)lImg
{
    if (leftImage == nil) {
        if (lImg) {
            CGSize size = lImg.size;
            float w = 0.0;
            float h = 0.0;
            float p;
            CGRect frame = self.frame;
            if (20 > frame.size.width) {
                w = frame.size.width;
            }else{
                w = frame.size.width - 5.0;
            }
            if (20 > frame.size.height) {
                h = frame.size.height;
            }else{
                h = frame.size.height - 5.0;
            }
            p = size.width / size.height;
            if (h * p >= w) {
                h = w / p;
            }else{
                w = h * p;
            }
            CGRect textRect = self.titleLabel.frame;
            leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(textRect.origin.x - leftImage.frame.size.width - 3, (frame.size.height - h) / 2, w, h)];
            leftImage.image = lImg;
            [self addSubview:leftImage];
        }
    }else{
        leftImage.image = lImg;
    }
    
    
    
}
-(void)setRightImage:(UIImage *)rImg
{
    if (rightImage == nil) {
        if (rImg) {
            CGSize size = rImg.size;
            float w = 0.0;
            float h = 0.0;
            float p;
            CGRect frame = self.frame;
            
            w = 0.0;
            h = 0.0;
            if (10 > frame.size.width) {
                w = frame.size.width;
            }else{
                w = frame.size.width - 5.0;
            }
            if (10 > frame.size.height) {
                h = frame.size.height;
            }else{
                h = frame.size.height - 5.0;
            }
            p = size.width / size.height;
            if (h * p >= w) {
                h = w / p;
            }else{
                w = h * p;
            }
            
            CGRect textRect = self.titleLabel.frame;
            rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(textRect.origin.x + textRect.size.width + 3, (frame.size.height - h) / 2, w, h)];
            rightImage.image = rImg;
            [self addSubview:rightImage];
        }
    }else{
        rightImage.image = rImg;
    }
    
    
    
    
    
}

-(void)dealloc
{
    [leftImage release];
    [rightImage release];
    [super dealloc];
}

@end
