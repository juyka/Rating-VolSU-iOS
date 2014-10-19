//
//  ViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 10.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

@import UIKit;


@class RatingSelectorViewController;


@protocol RatingSelectorDelegate <NSObject>
- (void)ratingSelector:(RatingSelectorViewController *)controller didPickObject:(NSManagedObject *)object;
@end


@interface RatingSelectorViewController : UIViewController

@property(nonatomic, weak) id<RatingSelectorDelegate> delegate;

@property(nonatomic) Class entityClass;
@property(nonatomic) NSString *descriptionKey;
@property(nonatomic) NSString *parentKey;
@property(nonatomic) NSString *cellId;
@property(nonatomic) NSNumber *parentId;

@end

