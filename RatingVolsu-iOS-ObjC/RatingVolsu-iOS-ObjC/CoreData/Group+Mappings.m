//
//  Group+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 15.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "Group+Mappings.h"
#import "Student.h"
#import "RequestManager.h"

@implementation Group (Mappings)

+ (NSDictionary *)mappings {
	return @{
			 @"Id": @"groupId",
			};
}

+ (NSString *)primaryKey {
	
	return @"groupId";
}

+ (Class)childEntity {
	
	return Student.class;
}

+ (NSString *)descriptionKey {
	
	return @"name";
}

+ (NSString *)cellId {
	
	return @"GroupCell";
}

+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{@"fak_id": parameter};
	NSString *url = @"group_req.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries) {
		
		Faculty *faculty = [Faculty find:@"facultyId == %@", parameter];
		NSArray *objects = [Group createArray:entries];
		//[objects setValue:faculty forKey:@"faculty"];
		
		if (handler) {
			handler(objects);
		}		
	}];
	
}

@end
