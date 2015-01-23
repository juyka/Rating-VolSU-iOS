//
//  GroupRatingCollectionViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewControllerProtocol.h"

@interface GroupRatingViewController : UIViewController<RatingViewControllerProtocol>

@property(nonatomic) Semester *semester;

- (void)scroll:(CGPoint)offset;
- (NSURLSessionDataTask *)refresh:(void (^)())handler;
@end
