//
//  RatingViewControllerProtocol.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 22/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RatingViewControllerProtocol

- (NSURLSessionDataTask *)refresh:(void (^)())handler;

@end
