//
//  RatingViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 12/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingViewController : UIViewController

@property (nonatomic) RecentItem *recentItem;

- (BOOL)canRotate;

@end
