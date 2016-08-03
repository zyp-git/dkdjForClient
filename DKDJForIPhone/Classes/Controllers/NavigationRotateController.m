//
//  NavigationRotateController.m
//  EasyEat4iPhone
//
//  Created by dev on 11-12-30.
//  Copyright 2011 Ihangjing.com. All rights reserved.
//

#import "NavigationRotateController.h"

@implementation NavigationRotateController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if([self.parentViewController class] == [UITabBarController class] && 
	   ((UITabBarController*)self.parentViewController).selectedViewController != self)
		return YES;
	return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithRootViewController:rootViewController];
	if(self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanged:) name:@"AccountChanged" object:nil];
	}
	
	return self;
}

- (void)accountChanged:(NSNotification*)notification
{
	[self popToRootViewControllerAnimated:NO];
}


@end

@implementation TabBarRotateController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end
