//
//  HJAppConfig.m
//  TSYP
//
//  Created by wulin on 13-6-12.
//
//

#import "HJAppConfig.h"
#import <QuartzCore/QuartzCore.h>
@implementation HJAppConfig
+(CGSize) GetScreen{//获取相应的分辨率
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    size_screen.height *= scale_screen;
    size_screen.width *= scale_screen;
    return size_screen;
}
@end
