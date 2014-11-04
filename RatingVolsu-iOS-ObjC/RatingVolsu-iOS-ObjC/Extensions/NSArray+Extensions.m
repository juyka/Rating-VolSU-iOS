//
//  NSArray+Extensions.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 04/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (NSArray *)ratingTable {
	
	NSArray *subjects = [self valueForKeyPath:@"@distinctUnionOfObjects.subject"];
	NSArray *students = [self valueForKeyPath:@"@distinctUnionOfObjects.semester.student"];
	__block int counter = 1;
	
	NSMutableArray *ratingTable = [students map:^id(Student *student) {
		
		NSMutableArray *subjectsTable = [subjects map:^id(Subject *subject) {
			
			RatingItem *item = [self find:^BOOL(RatingItem *item) {
				
				return (item.semester.student.studentId == student.studentId && item.subject.subjectId == subject.subjectId);
			}];
			
			return item.total.description;
		}].mutableCopy;
		
		[subjectsTable insertObject:student.number atIndex:0];
		[subjectsTable insertObject:@(counter++).description atIndex:0];
		return subjectsTable;
		
	}].mutableCopy;
	
	NSArray *subjectNames = [@[@"    ", @"Номер\nзачетной\nкнижки"] arrayByAddingObjectsFromArray:[subjects valueForKeyPath:@"name"]];
	[ratingTable insertObject:subjectNames atIndex:0];
	
	return ratingTable;
}

@end
