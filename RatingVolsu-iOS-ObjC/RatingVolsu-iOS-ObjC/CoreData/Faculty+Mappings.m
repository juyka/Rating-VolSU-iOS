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

+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler {
	
	NSDictionary *parameters = @{ @"get_lists": @"0"};
	NSString *url = @"facult_req.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries){
		NSArray *objects = [Faculty createArray:entries];
		[objects each:^(Faculty *object) {
			NSString *name = object.name;
			NSRange range = [name rangeOfString:@"(" options:NSBackwardsSearch range:NSMakeRange(0, name.length)];
			NSString *substring = [name substringFromIndex:range.location];
			name = [name stringByReplacingOccurrencesOfString:substring withString:@""];
			object.name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		}];
		[CoreDataManager.sharedManager saveContext];
		if (handler) {
			handler(entries);
		}
	} errorBlock:errorHandler];
}

@end
