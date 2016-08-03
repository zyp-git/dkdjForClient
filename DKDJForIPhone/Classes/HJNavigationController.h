//
//  HJNavigationController.h
//  HMBL
//
//  Created by ihangjing on 14-1-15.
//
//

#import <UIKit/UIKit.h>

@interface HJNavigationController : UINavigationController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, weak) UIViewController *currentShowVC;
@end
