//
//  RatingItem.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Semester, Subject;

@interface RatingItem : NSManagedObject

@property (nonatomic, retain) NSNumber * exam;
@property (nonatomic, retain) NSNumber * firstAttestation;
@property (nonatomic, retain) NSString * ratingItemId;
@property (nonatomic, retain) NSNumber * secondAttestation;
@property (nonatomic, retain) NSNumber * sum;
@property (nonatomic, retain) NSNumber * thirdAttestation;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) Subject *subject;
@property (nonatomic, retain) Semester *semester;

@end
