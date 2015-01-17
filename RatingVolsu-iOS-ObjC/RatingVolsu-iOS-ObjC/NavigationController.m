//
//  NavigationController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

- (BOOL)shouldAutorotate
{
	return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
