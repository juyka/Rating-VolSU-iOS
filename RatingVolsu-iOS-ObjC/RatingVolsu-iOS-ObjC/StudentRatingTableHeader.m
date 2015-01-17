//
//  StudentRatingTableHeader.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 13/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "StudentRatingTableHeader.h"
#import "FXPageControl.h"

@implementation StudentRatingTableHeader


- (instancetype)initWithOrientation:(UIDeviceOrientation)orientation {
	
	self = [super init];
	if (self) {
		NSString *xibId = (UIDeviceOrientationIsPortrait([[UIDevice currentDevice]orientation])) ? @"StudentRatingTableHeader" : @"StudentRatingLandscapeHeader";

		self = xibId.xibView;
	}
	
	return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
