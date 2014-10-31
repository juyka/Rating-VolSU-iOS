//
//  NSString+RubyLikeExtensions.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 31/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "NSString+RubyLikeExtensions.h"

@implementation NSString (RubyLikeExtensions)

- (UIImage *)image {
	
	return [UIImage imageNamed:self];
}

- (NSSortDescriptor *)ascending {
 
 return [NSSortDescriptor sortDescriptorWithKey:self ascending:YES];
}

- (NSSortDescriptor *)descending {
 
 return [NSSortDescriptor sortDescriptorWithKey:self ascending:NO];
}

@end
