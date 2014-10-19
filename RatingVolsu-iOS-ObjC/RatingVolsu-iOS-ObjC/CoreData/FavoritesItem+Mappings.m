//
//  FavoritesItem+Mappings.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "FavoritesItem+Mappings.h"

@implementation FavoritesItem (Mappings)


- (NSString *)details {
	
	NSString * details = nil;
	
	if (self.student) {
		details = [NSString stringWithFormat:@"%@ %@ %@", self.student.group.name, self.student.number, self.semestr];
	}
	else {
		details = [NSString stringWithFormat:@"%@ %@", self.group.name, self.semestr];
	}
	
	return details;
}

@end
