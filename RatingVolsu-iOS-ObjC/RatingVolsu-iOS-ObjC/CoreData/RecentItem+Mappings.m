//
//  FavoritesItem+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RecentItem+Mappings.h"

@implementation RecentItem (Mappings)

+ (NSString *)primaryKey {
	
	return @"itemId";
}

- (NSString *)details {
	
	NSString * details = nil;
	
	if (self.student) {
		
		details = [NSString stringWithFormat:@"%@ %@ %@", self.student.group.name, self.student.number, self.semester];
	}
	
	return details;
}

@end
