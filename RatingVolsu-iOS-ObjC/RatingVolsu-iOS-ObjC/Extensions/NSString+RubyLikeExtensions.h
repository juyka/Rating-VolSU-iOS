//
//  NSString+RubyLikeExtensions.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 31/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

@import UIKit;

@interface NSString (RubyLikeExtensions)

@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) NSSortDescriptor *ascending;
@property (nonatomic, readonly) NSSortDescriptor *descending;

@end
