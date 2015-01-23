//
//  NSNumber+Extensions.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 23/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "NSNumber+Extensions.h"

@implementation NSNumber (Extensions)

- (NSString *)subjectType {
	
	NSString *type = @"";
	
	switch (self.integerValue) {
		case 1:
			type = @"экзамен";
			break;
		case 2:
			type = @"зачет";
			break;
		case 3:
			type = @"экзамен c защитой";
			break;
		default:
			break;
	}
	
	return type;
	
}

@end
