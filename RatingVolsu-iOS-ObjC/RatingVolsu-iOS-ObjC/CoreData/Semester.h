//
//  Semester.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 28/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RatingItem, Student;

@interface Semester : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * semesterId;
@property (nonatomic, retain) RatingItem *ratings;
@property (nonatomic, retain) Student *students;

@end
