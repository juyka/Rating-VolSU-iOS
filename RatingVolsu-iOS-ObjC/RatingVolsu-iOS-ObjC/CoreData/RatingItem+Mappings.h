//
//  RatingItem+Mappings.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingItem.h"

@interface RatingItem (Mappings)

+ (void)requestByStudent:(Semester *)semester withHandler:(RequestHandler)handler;
+ (void)requestByGroup:(Semester *)semester withHandler:(RequestHandler)handler;
@end
