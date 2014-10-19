//
//  Semester.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RatingItem, Student;

@interface Semester : NSManagedObject

@property (nonatomic, retain) NSNumber * semesterId;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *ratings;
@property (nonatomic, retain) Student *student;
@end

@interface Semester (CoreDataGeneratedAccessors)

- (void)addRatingsObject:(RatingItem *)value;
- (void)removeRatingsObject:(RatingItem *)value;
- (void)addRatings:(NSSet *)values;
- (void)removeRatings:(NSSet *)values;

@end
