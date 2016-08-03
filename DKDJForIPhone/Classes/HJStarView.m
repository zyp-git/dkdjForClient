//
//  HJStarView.m
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "HJStarView.h"

@implementation HJStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(HJStarView *)initWithShowImgName:(NSString *)img1 hideImgName:(NSString *)img2 length:(float)leng start:(float)start Count:(int)count Frame:(CGRect)frame
{
    [super initWithFrame:frame];
    
    if (self != nil) {
        
        
        CGRect frame1 = self.frame;
        UIImage *imge1 = [UIImage imageNamed:img1];
        UIImage *imge2 = [UIImage imageNamed:img2];
        view1 = [[UIView alloc] initWithFrame:frame];
        view2 = [[UIView alloc] initWithFrame:frame];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = YES;
        
        view1.autoresizingMask = UIViewAutoresizingNone;
        view1.backgroundColor = [UIColor blackColor];
        view1.autoresizesSubviews = YES;
        
        
        view2.autoresizingMask = UIViewAutoresizingNone;
        view2.backgroundColor = [UIColor redColor];
        view2.autoresizesSubviews = YES;
        
        
        
        
        //计算每个UImageView的宽度
        int with = frame.size.width / count;
        int dis = 3;
        Multiple = with / leng;//求得倍数关系
        
        float len = start * Multiple;
        frame.origin.x += 10.5;
        frame.size.width -= len;
        view2.frame = frame;
        
        CGRect imgFrame = CGRectMake(0, 0, with - dis, frame.size.height);
        for (int i = 0; i < count; i++) {
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:imgFrame];
            imageView1.image = imge1;
            imageView1.autoresizingMask = UIViewAutoresizingNone;
            imageView1.autoresizesSubviews = YES;
            
            [view1 addSubview:imageView1];
            [imageView1 release];
            
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:imgFrame];
            imageView2.image = imge2;
            imageView2.autoresizingMask = UIViewAutoresizingNone;
            imageView2.autoresizesSubviews = YES;

            [view2 addSubview:imageView2];
            [imageView2 release];
            
            imgFrame.origin.x += with;
        }
        
        [self addSubview:view1];
        [self addSubview:view2];
        
        
        
        CGRect frame2 = self.frame;
        
        frame1 = view2.frame;
        frame2 = view1.frame;
        //int i = 0;
        
    }
    
    return self;
}



-(void)dealloc
{
    [view1 release];
    [view2 release];
    [super dealloc];
}
@end
