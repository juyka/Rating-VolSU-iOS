//
//  NSString+RubyLikeExtensions.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 31/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "NSString+RubyLikeExtensions.h"

@implementation NSString (RubyLikeExtensions)

- (id)xibView {
	return [NSBundle.mainBundle loadNibNamed:self owner:nil options:nil].firstObject;
}

- (NSString *)iconText {
	
	NSMutableString * firstCharacters = [NSMutableString string];
	NSArray * words = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	for (NSString * word in words) {
		if ([word length] > 0) {
			NSString * firstLetter = [word substringToIndex:1];
			if (firstCharacters.length < 2)
				[firstCharacters appendString:[firstLetter uppercaseString]];
		}
	}
	
	return firstCharacters;
}

@end
