//
//  RatingsViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 27/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingViewControllerProtocol.h"

@interface StudentRatingViewController : UIViewController<RatingViewControllerProtocol>

@property (nonatomic) Semester *semester;

- (NSURLSessionDataTask *)refresh:(void (^)())handler;

@end
