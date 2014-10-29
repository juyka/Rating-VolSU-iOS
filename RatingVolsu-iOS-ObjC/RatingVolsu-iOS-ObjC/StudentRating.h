//
//  StudentRating.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 27/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingObjectProtocol.h"

@interface StudentRating : NSObject<RatingObjectProtocol>

@property (nonatomic) Student *student;
@property (nonatomic) NSNumber *semester;

@end
