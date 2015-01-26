//
//  RatingItem+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingItem+Mappings.h"
#import "RequestManager.h"
#import "NSArray+Extensions.h"

@implementation RatingItem (Mappings)

+ (NSDictionary *)mappings {
	return @{
			 
			 };
}

+ (NSURLSessionDataTask *)requestByStudent:(Semester *)semester withHandler:(RequestHandler)handler  errorBlock:(void (^)())errorHandler {
	
	NSDictionary *parameters = @{
								 @"Fak" : semester.student.group.faculty.facultyId,
								 @"Group" : semester.student.group.groupId,
								 @"Semestr" : semester.number,
								 @"Zach" : semester.student.studentId
								 };
	NSString *url = @"stud_rat.php";
	
	NSURLSessionDataTask *task;
	
	task = [RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries) {
		
		NSDictionary *dictionary = entries.first;
		
		NSDictionary *objects = [dictionary valueForKey:@"Predmet"];
		
		NSArray *ratingTable;
		
		if (objects.class != NSNull.class) {
			
			[objects each:^(id key, id value) {
				Subject *subject = [Subject findOrCreate:@{@"subjectId" : key}];
				[subject update:@{
								  @"name" : [value valueForKeyPath:@"Name"],
								  @"type" : [value valueForKeyPath:@"Type"],
								  }];
			}];
		}
		
		NSDictionary *ratings = [dictionary valueForKey:@"Table"];
		
		if (ratings.class != NSNull.class) {

			NSArray * ratingItems = [ratings map:^id(id key, NSArray *value) {
				
				NSString *identifier = [NSString stringWithFormat:@"%@%@", key, semester.semesterId];
				RatingItem *item = [RatingItem findOrCreate:@{@"ratingItemId" : identifier}];
				
				[item update:@{
							   @"subject" : [Subject findOrCreate:@{@"subjectId" : key}],
							   @"semester" : semester,
							   @"firstAttestation" : value[0],
							   @"secondAttestation" : value[1],
							   @"thirdAttestation" : value[2],
							   @"sum" : value[3],
							   @"exam" : value[4],
							   @"total": value[5]
							   }];
				return item;
			}];
			[[CoreDataManager sharedManager] saveContext];
		
			
			ratingTable = [ratingItems studentRatingTable];
			
		}
		
		if (handler) {
			handler(ratingTable);
		}
		
	} errorBlock:errorHandler];
	
	return task;
}

+ (NSURLSessionDataTask *)requestByGroup:(Semester *)semester withHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler{
	
	NSDictionary *parameters = @{
								 @"Fak" : semester.student.group.faculty.facultyId,
								 @"Group" : semester.student.group.groupId,
								 @"Semestr" : semester.number
								 };
	NSString *url = @"group_rat.php";
	
	NSURLSessionDataTask *task;
	
	task = [RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries) {
		
		NSDictionary *dictionary = entries.first;
		NSArray *subjects;
		NSArray *ratingTable;
		
		NSDictionary *objects = [dictionary valueForKey:@"Predmet"];
		
		if (objects.class != NSNull.class) {
			
			subjects = [objects map:^id(id key, id value) {
				Subject *subject = [Subject findOrCreate:@{@"subjectId" : key}];
				[subject update:@{
								  @"name" : [value valueForKeyPath:@"Name"],
								  @"type" : [value valueForKeyPath:@"Type"],
								  }];
				return subject;
			}];
		}
		
		NSDictionary *ratings = [dictionary valueForKey:@"Table"];
		
		if (ratings.class != NSNull.class) {
			
			NSArray * ratingItems = [ratings map:^id(id key, NSDictionary *value) {
				
				Student *student = [Student findOrCreate:@{@"studentId" : key}];
				
				NSNumber *semesterId = [[NSNumber alloc] initWithInt:student.studentId.intValue * 100 + [semester.number intValue]];
				
				[student update:@{
								  @"number" : [value valueForKeyPath:@"Name"],
								  @"group" : semester.student.group
								  }];
				Semester *studentsSemester =[Semester findOrCreate:@{
																	 @"semesterId" : semesterId,
																	 @"number" : semester.number
																	 }];
				[student addSemestersObject:studentsSemester];
				
				NSDictionary *marks = [value valueForKey:@"Predmet"];
				
				NSArray *subjectRatings = [subjects map:^id(Subject *subject) {
					
					NSString *identifier = [NSString stringWithFormat:@"%@%@", subject.subjectId, studentsSemester.semesterId];
					RatingItem *item = [RatingItem findOrCreate:@{@"ratingItemId" : identifier}];
					
					NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(.*\\)" options:NSRegularExpressionCaseInsensitive error:nil];
					
					NSString *subjectMark = [NSString stringWithFormat:@"%@", marks[subject.subjectId]];
					NSNumber *total;
					
					if (subjectMark) {
						NSString *value = [regex stringByReplacingMatchesInString:subjectMark options:0 range:NSMakeRange(0, subjectMark.length) withTemplate:@""];
						total = @([value integerValue]);
					}
					else
						total = @(0);
					
					[item update:@{
								   @"subject" : [Subject findOrCreate:@{@"subjectId" : subject.subjectId}],
								   @"semester" : studentsSemester,
								   @"total": total,
								   @"isNullSubject": @(!(subjectMark))
								   }];
					return item;
				}];
				
				return subjectRatings;
			}];
			
			ratingItems = [ratingItems sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
				RatingItem *item1 = obj1.first;
				RatingItem *item2 = obj2.first;
				
				return [item2.semester.student.number compare:item1.semester.student.number];
			}];
			
			ratingItems = [ratingItems sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
				
				NSNumber *sum1 = [[obj1 subarrayWithRange:NSMakeRange(0, obj1.count)] valueForKeyPath:@"@sum.total.intValue"];
				NSNumber *sum2 = [[obj2 subarrayWithRange:NSMakeRange(0, obj2.count)] valueForKeyPath:@"@sum.total.intValue"];
				
				return [sum2 compare:sum1];
			}];
			
			[ratingItems eachWithIndex:^(NSArray *array, NSUInteger index) {
				
				RatingItem *item = array.first;
				NSNumber *place = [[NSNumber alloc] initWithInteger:index + 1];
				item.semester.place = place;
				
			}];
			
			[[CoreDataManager sharedManager] saveContext];

			
			ratingTable = [ratingItems flatten];
			
		}
		
		if (handler) {
			handler(ratingTable);
		}
		
	} errorBlock:errorHandler];
	
	return task;
}

@end
