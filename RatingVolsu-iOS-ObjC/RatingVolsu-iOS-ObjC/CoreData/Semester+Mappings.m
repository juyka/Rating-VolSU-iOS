//
//  Semester+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "Semester+Mappings.h"
#import "RequestManager.h"

@implementation Semester (Mappings)

+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{@"gr_id": parameter};
	NSString *url = @"sem_req.php";
	
	[RequestManager.manager request:url parameters:parameters withBlock:^(NSArray *entries){
		if (handler) {
			handler(entries);
		}
	}];
}

@end
