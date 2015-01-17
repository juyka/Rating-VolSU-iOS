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
	
	if (self.semester) {
		
		details = [NSString stringWithFormat:@"%@ %@ семестр %@", self.semester.student.group.name, self.semester.number, self.semester.student.number];
	}
	
	return details;
}

@end
