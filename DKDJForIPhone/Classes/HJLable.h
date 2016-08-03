//
//  HJLable.h
//  HMBL
//
//  Created by ihangjing on 14-1-7.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface HJLable : UILabel
{
    VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment;
@end
