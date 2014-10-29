//
//  GroupRating.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 27/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RatingObjectProtocol.h"

@interface GroupRating : NSObject<RatingObjectProtocol>

@property (nonatomic) Group *group;
@property (nonatomic) NSNumber *semester;

@end
