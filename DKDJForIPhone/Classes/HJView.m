//
//  HJView.m
//  HMBL
//
//  Created by ihangjing on 13-11-27.
//
//

#import "HJView.h"

@implementation HJView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setClickDelegate:(id)delegate
{
    clickDelegate = delegate;
    //[clickDelegate retain];
}

-(void)SingClick
{
    if (clickDelegate != nil) {
        [clickDelegate clickView:self];
    }
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self setTextColor:[UIColor whiteColor]];
    int i = 0;
    i++;
}
// 还原label颜色,获取手指离开屏幕时的坐标点, 在label范围内的话就可以触发自定义的操作
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint points = [touch locationInView:self];
    if (points.x >= self.frame.origin.x && points.y >= self.frame.origin.x && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    {
        //[delegate myLabel:self touchesWtihTag:self.tag];
    }
}
*/
-(void)dealloc
{
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end










