//
//  Group.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Faculty, FavoritesItem, Student;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) id semesters;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Faculty *faculty;
@property (nonatomic, retain) NSSet *favoritesItems;
@property (nonatomic, retain) NSSet *students;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addFavoritesItemsObject:(FavoritesItem *)value;
- (void)removeFavoritesItemsObject:(FavoritesItem *)value;
- (void)addFavoritesItems:(NSSet *)values;
- (void)removeFavoritesItems:(NSSet *)values;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
