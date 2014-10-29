//
//  Subject.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 28/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RatingItem;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * subjectId;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *ratingItems;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addRatingItemsObject:(RatingItem *)value;
- (void)removeRatingItemsObject:(RatingItem *)value;
- (void)addRatingItems:(NSSet *)values;
- (void)removeRatingItems:(NSSet *)values;

@end
