//
//  ProgressWindow.m
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-21.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ProgressWindow.h"

@implementation ProgressWindow

- (void) show
{
    self.windowLevel = UIWindowLevelAlert;
    
    [indicator startAnimating];
    self.hidden = false;
    [self makeKeyAndVisible];
}

- (void) hide
{
    self.hidden = true;
    [self resignKeyWindow];
    [indicator stopAnimating];
}

@end