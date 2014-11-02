//
//  Student.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Semester;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * studentId;
@property (nonatomic, retain) NSSet *semesters;
@property (nonatomic, retain) Group *group;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addSemestersObject:(Semester *)value;
- (void)removeSemestersObject:(Semester *)value;
- (void)addSemesters:(NSSet *)values;
- (void)removeSemesters:(NSSet *)values;

@end
