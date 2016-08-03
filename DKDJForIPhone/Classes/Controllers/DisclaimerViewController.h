//
//  DisclaimerViewController.h
//  EasyEat4iPhone
//
//  Created by OS Mac on 12-4-1.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJViewController.h"

@interface DisclaimerViewController : HJViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView         *tempTableView;
    
}

@property (nonatomic, retain) UITableView *tempTableView;

- (id)initWithSomething:(NSString*)Something;

@end
