//
//  DismissSegue.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 29/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
	UIViewController *sourceViewController = self.sourceViewController;
	[sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
