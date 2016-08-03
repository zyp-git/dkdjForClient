//
//  HJPopViewNotice.m
//  ZNCZIPhone
//
//  Created by ihangjing on 15/7/29.
//
//

#import "HJPopViewNotice.h"
#define CellTableIdentifier @"TableViewCell"
@implementation HJPopViewNotice

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(HJPopViewNotice *)initWithView:(UIView *)view
{
    self = [super initWithView:view witchBackColor:[UIColor colorWithRed:142/255.0 green:149/255.0 blue:154/255.0 alpha:0.5]];
    if (self) {
        clickOtherClose = YES;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(210, 60, 100, 34)];
        iv.image = [UIImage imageNamed:@"prompt01_03.png"];
        [self addSubview:iv];
        [iv release];
        
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(110, 466, 100, 34)];
        iv.image = [UIImage imageNamed:@"prompt02_03"];
        [self addSubview:iv];
        [iv release];
    }
    return self;
}

-(void)btnClick:(UIButton *)btn
{
    [self close:(int)btn.tag];//关闭
}

-(void)close:(int)type
{
    if (type == 0) {
        return;
    }
    [super close:type];
}

-(void)dealloc
{
    [super dealloc];
}
-(void)checkDev:(UIButton *)btn
{
    
}
@end
