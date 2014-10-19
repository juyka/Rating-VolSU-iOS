//
//  FavoritesItem.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 15.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Student;

@interface FavoritesItem : NSManagedObject

@property (nonatomic, retain) NSNumber * favoritesItemId;
@property (nonatomic, retain) NSNumber * semestr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Student *student;

@end
