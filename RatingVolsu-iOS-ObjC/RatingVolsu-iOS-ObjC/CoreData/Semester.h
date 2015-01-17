//
//  Semester.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RatingItem, RecentItem, Student;

@interface Semester : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * semesterId;
@property (nonatomic, retain) NSSet *ratings;
@property (nonatomic, retain) NSNumber *place;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) RecentItem *recentItem;
@end

@interface Semester (CoreDataGeneratedAccessors)

- (void)addRatingsObject:(RatingItem *)value;
- (void)removeRatingsObject:(RatingItem *)value;
- (void)addRatings:(NSSet *)values;
- (void)removeRatings:(NSSet *)values;

@end
