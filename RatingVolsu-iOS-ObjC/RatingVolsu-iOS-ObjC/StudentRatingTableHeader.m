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


+ (instancetype)headerWithOrientation:(BOOL)portraitOrientation {
	
	StudentRatingTableHeader *header;
	NSString *xibId = portraitOrientation ? @"StudentRatingTableHeader" : @"StudentRatingLandscapeHeader";

	header = xibId.xibView;
	header.pageControl.numberOfPages = 6;
	header.pageControl.currentPage = 5;
	header.pageControl.dotSpacing = 5;
	header.pageControl.dotSize = 4;
	header.pageControl.dotColor = @(0xC2C1BF).rgbColor;
	header.pageControl.selectedDotColor = @(0x9B9A99).rgbColor;
	header.pageControl.backgroundColor = [UIColor clearColor];
	
	return header;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
