//
//  HJStarView.h
//  HMBL
//
//  Created by ihangjing on 13-11-26.
//
//

#import <UIKit/UIKit.h>

@interface HJStarView : UIView
{
    UIView *view1;
    UIView *view2;
    int startCount;
    float Multiple;//实际长度和步长的背书关系
}

-(HJStarView *)initWithShowImgName:(NSString *)img1 hideImgName:(NSString *)img2 length:(float)leng start:(float)start Count:(int)count Frame:(CGRect)frame;

@end
