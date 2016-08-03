//
//  PopDialogBase.m
//  GZGJ
//
//  Created by ihangjing on 14-10-13.
//
//

#import "HJPopViewBase.h"

@implementation HJPopViewBase

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize delegate;

-(HJPopViewBase *)initWithView:(UIView *)view
{
    parentView = view;
    [self initWithFrame:view.bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:view.bounds];
        //backView.backgroundColor = [UIColor colorWithRed:142/255.0 green:149/255.0 blue:154/255.0 alpha:0.5];
        [self addSubview:backView];
        closeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherClick:)];
        [backView addGestureRecognizer:closeClick];
        [backView release];
    }
    return self;
}

-(HJPopViewBase *)initWithView:(UIView *)view witchBackColor:(UIColor *)color
{
    parentView = view;
//    CGRect frame = view.bounds;
    [self initWithFrame:view.bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:view.bounds];
        backView.backgroundColor = color;//[UIColor colorWithRed:142/255.0 green:149/255.0 blue:154/255.0 alpha:0.5];
        [self addSubview:backView];
        closeClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherClick:)];
        [backView addGestureRecognizer:closeClick];
        [backView release];
    }
    return self;
}

-(void)otherClick:(id)sender{
    
    [self close:-1];
}

-(void)showDialog
{
    [parentView addSubview:self];
    [parentView bringSubviewToFront:self];
}

-(void)closeDialog
{
    [self close:-1];
}

-(void)close:(int)type
{
    [self _close:type index:0];
    /*[self.delegate HJPopViewBaseClose:type index:0 popType:popType];
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];*/
}

-(void)_close:(int)type index:(int)index
{
    BOOL isClose = NO;
    if (self.delegate) {
        isClose = [self.delegate HJPopViewBaseClose:type index:index popType:popType];
    }
    if (isClose || clickOtherClose) {
        for(UIView *view in [self subviews])
        {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }
    
}

-(void)dealloc{
    self.delegate = nil;
    [closeClick release];
    [super dealloc];
}

@end
