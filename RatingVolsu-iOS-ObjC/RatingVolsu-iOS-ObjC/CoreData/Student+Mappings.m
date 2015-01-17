//
//  Student+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 15.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "Student+Mappings.h"
#import "Semester.h"
#import "RequestManager.h"

@implementation Student (Mappings)

+ (NSDictionary *)mappings {
	return @{
			 @"Id": @"studentId",
			 };
}

+ (NSString *)primaryKey {
	
	return @"studentId";
}

+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler{
	
	NSDictionary *parameters = @{@"group_id": parameter};
	NSString *url = @"stud_req.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries) {
		Group *group = [Group findOrCreate:@{@"groupId": parameter}];
		NSArray *objects = [Student createArray:entries];
		[objects setValue:group forKey:@"Group"];
		[CoreDataManager.sharedManager saveContext];
		if (handler) {
			handler(objects);
		}
	} errorBlock:errorHandler];
}

@end
