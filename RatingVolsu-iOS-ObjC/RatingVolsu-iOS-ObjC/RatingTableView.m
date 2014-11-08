//
//  GroupRatingTableView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingTableView.h"
#import "RatingTableViewCell.h"


@interface RatingTableView () <UIScrollViewDelegate>

@end


@implementation RatingTableView 

- (instancetype)initWithCoder:(NSCoder *)coder {
	
	self = [super initWithCoder:coder];
	if (self) {
		
		self.delegate = self;
		self.bounces = NO;
		self.autoresizesSubviews = NO;
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		
		self.delegate = self;
		self.bounces = NO;
		self.autoresizesSubviews = NO;
	}
	return self;
}

- (void)setDataSource:(NSArray *)dataSource {
	
	_dataSource = dataSource;
	[self reloadData];
}

- (void)setCellHeight:(CGFloat)cellHeight {
	
	_cellHeight = cellHeight;
	[self reloadData];
}


- (void)reloadData {
	
	
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

	if (scrollView.contentOffset.y >= 0) {

		for (UIView *cell in _cells.firstObject) {
			
			CGRect frame = cell.frame;
			frame.origin.y = scrollView.contentOffset.y + scrollView.contentInset.top;
			cell.frame = frame;
		}

		for (NSArray *row in _cells) {
			
			UIView *cell = row.firstObject;
			CGRect frame = cell.frame;
			frame.origin.x = scrollView.contentOffset.x + scrollView.contentInset.left;
			cell.frame = frame;
			
			if (row.count > 1) {
				
				CGFloat offset = frame.size.width;
				cell = row[1];
				frame = cell.frame;
				frame.origin.x = scrollView.contentOffset.x + scrollView.contentInset.left + offset;
				cell.frame = frame;
			}
		}
	}
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//
//	CGFloat targetX = targetContentOffset->x;
//
//	NSInteger index = [_offsets indexOfObjectPassingTest:^BOOL(NSNumber *offset, NSUInteger idx, BOOL *stop) {
//
//		return targetX < offset.floatValue;
//	}];
//
//	targetContentOffset->x = [_offsets[MIN(MAX(index, 0), _offsets.count - 1)] floatValue] - [_offsets[1] floatValue];
//}

@end

