//
//  ProgressWindow.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressWindow : UIWindow {
    IBOutlet UIActivityIndicatorView*   indicator;
}

- (void) show;
- (void) hide;

@end

