//
//  ShowShopOnMapViewController.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-3.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#import "ShowShopOnMapViewController.h"
#import "EasyEat4iPhoneAppDelegate.h"

@implementation ShowShopOnMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"商家位置";
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.tintColor = nil;
    //视图将要消失 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
