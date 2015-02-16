//
//  RatingScrollView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "RatingScrollView.h"

@implementation RatingScrollView

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (self) {
		
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 44)];
		self.labels = @[].mutableCopy;
		
		for (int index = 0; index < 6; ++index) {
			
			UILabel *label = UILabel.new;
			CGFloat height = self.frame.size.height;
			CGFloat width = self.frame.size.width;
			label.frame = CGRectMake(index * width, 0, width, height);
			label.textAlignment = NSTextAlignmentCenter;
			label.text = @"–";
			label.textColor = @(0x252B36).rgbColor;
			label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
			[view addSubview:label];
			[self.labels addObject:label];
		}
		
		[self addSubview:view];
		self.contentSize = CGSizeMake(self.frame.size.width * 6, self.frame.size.height);
		self.contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width, 0);
	}

	return self;
}

@end
