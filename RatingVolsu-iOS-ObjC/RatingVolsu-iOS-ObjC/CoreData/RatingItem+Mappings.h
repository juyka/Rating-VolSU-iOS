//
//  RatingItem+Mappings.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingItem.h"

@interface RatingItem (Mappings)

+ (NSURLSessionDataTask *)requestByStudent:(Semester *)semester withHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler;
+ (NSURLSessionDataTask *)requestByGroup:(Semester *)semester withHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler;
@end
