//
//  StudentRatingTableViewCell.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 12/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "StudentRatingTableViewCell.h"
#import "RatingScrollView.h"

@implementation StudentRatingTableViewCell

- (void)reloadData {
	
	[self.numbers eachWithIndex:^(NSNumber *number, NSUInteger index) {
		
		UILabel *label = self.scrollView.labels[index];
		label.text = [NSString stringWithFormat:@"%@", number];
	}];
	
}

- (void)setNumbers:(NSArray *)numbers {
	
	_numbers = numbers;
	[self reloadData];
}

- (void)scroll:(NSInteger)pageNumber {
	
	[self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * pageNumber, 0) animated:YES];
	
}

@end
