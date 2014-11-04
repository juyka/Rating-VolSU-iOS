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

+ (void)requestByStudent:(Semester *)semester withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{
								 @"Fak" : semester.student.group.faculty.facultyId,
								 @"Group" : semester.student.group.groupId,
								 @"Semestr" : semester.number,
								 @"Zach" : semester.student.studentId
								 };
	NSString *url = @"stud_rat.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries) {
		
		NSDictionary *dictionary = entries.first;
		
		NSDictionary *objects = [dictionary valueForKey:@"Predmet"];
		
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
							   @"total": @100
							   }];
				return item;
			}];
			[[CoreDataManager sharedManager] saveContext];
		
			if (handler) {
				handler(ratingItems);
			}
		}
		
	}];
}

+ (void)requestByGroup:(Semester *)semester withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{
								 @"Fak" : semester.student.group.faculty.facultyId,
								 @"Group" : semester.student.group.groupId,
								 @"Semestr" : semester.number
								 };
	NSString *url = @"group_rat.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries) {
		
		NSDictionary *dictionary = entries.first;
		NSArray *subjects;
		
		NSDictionary *objects = [dictionary valueForKey:@"Predmet"];
		
		if (objects.class != NSNull.class) {
			
			subjects = [objects map:^id(id key, id value) {
				Subject *subject = [Subject findOrCreate:@{@"subjectId" : key}];
				[subject update:@{
								  @"name" : [value valueForKeyPath:@"Name"],
								  @"type" : [value valueForKeyPath:@"Type"],
								  }];
				return subject.name;
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
				
				NSArray *subjectRatings = [marks map:^id(id key, id value) {
					
					NSString *identifier = [NSString stringWithFormat:@"%@%@", key, studentsSemester.semesterId];
					RatingItem *item = [RatingItem findOrCreate:@{@"ratingItemId" : identifier}];
					
					[item update:@{
								   @"subject" : [Subject findOrCreate:@{@"subjectId" : key}],
								   @"semester" : studentsSemester,
								   @"total": value
								   }];
					return item;
				}];
				
				return subjectRatings;
			}];
			[[CoreDataManager sharedManager] saveContext];
			
			NSArray *ratingTable = [[ratingItems flatten] ratingTable];
			
			if (handler) {
				handler(ratingTable);
			}
		}
		
	}];

}

@end
