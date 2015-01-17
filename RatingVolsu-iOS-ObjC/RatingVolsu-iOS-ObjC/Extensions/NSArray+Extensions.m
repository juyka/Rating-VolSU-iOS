//
//  NSArray+Extensions.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 04/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (NSArray *)groupRatingTable {
	
	NSArray *subjects = [self valueForKeyPath:@"@distinctUnionOfObjects.subject"];
	NSArray *students = [self valueForKeyPath:@"@distinctUnionOfObjects.semester.student"];
	__block int counter = 1;
	
	NSArray *ratingTable = [students map:^id(Student *student) {
		
		NSMutableArray *subjectsTable = [subjects map:^id(Subject *subject) {
			
			RatingItem *item = [self find:^BOOL(RatingItem *item) {
				
				return (item.semester.student.studentId == student.studentId && item.subject.subjectId == subject.subjectId);
			}];
			
			return item.total.description;
		}].mutableCopy;

		[subjectsTable insertObject:student.number atIndex:0];

		return subjectsTable;
		
	}];
	
	NSMutableArray *sortedTable = [ratingTable sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
		
		NSNumber *sum1 = [[obj1 subarrayWithRange:NSMakeRange(1, obj1.count - 1)] valueForKeyPath:@"@sum.intValue"];
		NSNumber *sum2 = [[obj2 subarrayWithRange:NSMakeRange(1, obj2.count - 1)] valueForKeyPath:@"@sum.intValue"];
		
		return [sum2 compare:sum1];
	}].mutableCopy;
	
	
	[sortedTable each:^(NSMutableArray *subjectsTable) {
		[subjectsTable insertObject:@(counter++).description atIndex:0];
	}];
	
	NSArray *subjectNames = [@[@"    ", @"Номер\nзачетной\nкнижки"] arrayByAddingObjectsFromArray:[subjects valueForKeyPath:@"name"]];
	[sortedTable insertObject:subjectNames atIndex:0];
	
	return sortedTable;
}

- (NSArray *)studentRatingTable {
	
	NSMutableArray *subjectsTable = [self map:^id(RatingItem *item) {
	
		NSArray *subject = @[item.subject.name, item.firstAttestation.description, item.secondAttestation.description, item.thirdAttestation.description, item.sum.description, item.exam.description, item.total.description];
		
		return subject;
		
	}].mutableCopy;
	
	NSArray *subjectNames = @[@"Предмет", @"1 модуль", @"2 модуль", @"3 модуль", @"Сумма", @"Экзамен", @"Итог"];
	
	[subjectsTable insertObject:subjectNames atIndex:0];
	
	return subjectsTable;
}

@end
