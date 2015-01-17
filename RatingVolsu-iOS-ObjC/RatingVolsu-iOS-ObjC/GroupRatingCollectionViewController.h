//
//  GroupRatingCollectionViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupRatingCollectionViewController : UIViewController

@property(nonatomic) Semester *semester;

- (void)scroll:(CGPoint)offset;

@end
