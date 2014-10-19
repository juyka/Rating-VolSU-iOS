//
//  Student.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FavoritesItem, Group, Semester;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * studentId;
@property (nonatomic, retain) NSSet *favoritesItems;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSSet *semesters;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addFavoritesItemsObject:(FavoritesItem *)value;
- (void)removeFavoritesItemsObject:(FavoritesItem *)value;
- (void)addFavoritesItems:(NSSet *)values;
- (void)removeFavoritesItems:(NSSet *)values;

- (void)addSemestersObject:(Semester *)value;
- (void)removeSemestersObject:(Semester *)value;
- (void)addSemesters:(NSSet *)values;
- (void)removeSemesters:(NSSet *)values;

@end
