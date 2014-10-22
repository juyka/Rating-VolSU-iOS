//
//  Faculty+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 14.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "Faculty+Mappings.h"
#import "Group.h"
#import "RequestManager.h"

typedef void (^RequestHandler)(NSArray *dataList);

@implementation Faculty (Mappings)

+ (NSDictionary *)mappings {
	return @{
			 @"Id": @"facultyId",
			 };
}

+ (NSString *)primaryKey {
	
	return @"facultyId";
}

+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{ @"get_lists": @"0"};
	NSString *url = @"facult_req.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries){
		[Faculty createArray:entries];
		[CoreDataManager.sharedManager saveContext];
		if (handler) {
			handler(entries);
		}
	}];
}

@end
