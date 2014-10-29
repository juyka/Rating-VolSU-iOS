//
//  RatingObjectProtocol.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 27/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RatingObjectProtocol <NSObject>

- (void)ratingWithBlock:(void (^)(NSArray *rating))handler;

@end
