//
//  ShopTypeViewController.h
//  Faneat4iPhone
//
//  Created by OS Mac on 12-6-29.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJViewController.h"

@interface ShopTypeViewController : HJViewController<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>
{
    UITableView         *tempTableView;
    
}

@property (nonatomic, retain) UITableView *tempTableView;

@end
