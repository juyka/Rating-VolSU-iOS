//
//  Student.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 28/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, RatingItem, RecentItem;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * studentId;
@property (nonatomic, retain) NSSet *recentItems;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSSet *ratingItems;
@property (nonatomic, retain) NSManagedObject *semesters;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addRecentItemsObject:(RecentItem *)value;
- (void)removeRecentItemsObject:(RecentItem *)value;
- (void)addRecentItems:(NSSet *)values;
- (void)removeRecentItems:(NSSet *)values;

- (void)addRatingItemsObject:(RatingItem *)value;
- (void)removeRatingItemsObject:(RatingItem *)value;
- (void)addRatingItems:(NSSet *)values;
- (void)removeRatingItems:(NSSet *)values;

@end
