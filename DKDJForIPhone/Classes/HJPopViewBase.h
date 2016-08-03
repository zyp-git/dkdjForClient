//
//  PopDialogBase.h
//  GZGJ
//
//  Created by ihangjing on 14-10-13.
//
//

#import <UIKit/UIKit.h>

@protocol HJPopViewBaseDelegate
- (BOOL) HJPopViewBaseClose:(int)type index:(int)index popType:(int)pType;
@end


@interface HJPopViewBase : UIView
{
    UIView *parentView;
    UITapGestureRecognizer *closeClick;
    int showType;//0 一级 1 二级
    int popType;//给每个弹出界面标识，方便代理处理
    BOOL clickOtherClose;//点击其他地方是否关闭
}

@property(assign,nonatomic)id<HJPopViewBaseDelegate> delegate;

-(HJPopViewBase *)initWithView:(UIView *)view;
-(HJPopViewBase *)initWithView:(UIView *)view witchBackColor:(UIColor *)color;
-(void)closeDialog;
-(void)showDialog;
-(void)close:(int)type;
-(void)_close:(int)type index:(int)index;

@end
