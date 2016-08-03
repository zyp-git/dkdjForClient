//
//  HJScrollView.m
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import "HJScrollView.h"
#import "HJView.h"
#import "HJLabel.h"
@implementation HJScrollView

/*
 
 UIScrollView的工作原理，当手指touch的时候，UIScrollView会拦截Event,会等待一段时间，在这段时间内，如果没有手指没有移动，当时间结束时，UIScrollView会发送tracking events到子视图上。在时间结束前，手指发生了移动，那么UIScrollView就会进行移动，从而取消发送tracking。
 
 那么，UIScrollView的子类想要接受touch事件，就是用户点击UIScrollView上的视图时，要先处理视图上的touch，而不发生滚动。这时候就需要UIScrollView的子类重载touchesShouldBegin:withEvent:inContentView: ，从而决定自己是否接受子视图中的touch事件。
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    //用户点击了scroll上的视图%@,是否开始滚动scroll",;
   // [event touchesForView:]
   // [view pointInside:CGPointMake(0.0, 0.0) withEvent:event];
    UIView *v = (UIView *)view;//这里应该判断是单击还是双击，这里就简单处理了
    if ([v isKindOfClass:[HJView class]]) {
        HJView *h = (HJView *)v;
        [h SingClick];
        return YES;
    }else if([v isKindOfClass:[HJLabel class]]){
//        HJLabel *h = (HJLabel *)v;
        return YES;
    }
    //返回yes 是不滚动 scroll 返回no 是滚动scroll
    return YES;
}

-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    //NO scroll不可以滚动 YES scroll可以滚动
    return NO;
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
