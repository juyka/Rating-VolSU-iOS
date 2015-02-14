//
//  NSLocale+KeyboardFix.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Konstantin Sukharev on 14/02/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR


#import "NSLocale+KeyboardFix.h"
@import ObjectiveC.runtime;


@implementation NSLocale (KeyboardFix)

+ (void)load {
	Method originalMethod = class_getClassMethod(self, @selector(currentLocale));
	Method swizzledMethod = class_getClassMethod(self, @selector(swizzled_currentLocale));
	method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (NSLocale *)swizzled_currentLocale {
	return [NSLocale localeWithLocaleIdentifier:@"ru_RU"];
}

@end


#endif
