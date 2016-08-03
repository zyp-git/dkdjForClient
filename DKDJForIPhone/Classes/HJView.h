//
//  HJView.h
//  HMBL
//
//  Created by ihangjing on 13-11-27.
//
//

#import <UIKit/UIKit.h>
@protocol HJViewControlDelegate <NSObject>
-(void)clickView:(id)model;
@end
@interface HJView : UIView
{
    id clickDelegate;
}
-(void)setClickDelegate:(id)delegate;

-(void)SingClick;
@end
