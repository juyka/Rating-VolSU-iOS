//
//  GroupRatingTableView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingTableView.h"
#import "RatingTableViewCell.h"
#import "MNRefreshControl.h"


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

- (void)setContentInset:(UIEdgeInsets)contentInset {
	[super setContentInset:contentInset];
	[self layoutCells];
}

- (void)reloadData {
	
	
}

#pragma mark -

- (void)layoutSubviews {
	
	[self insertSubview:self.refreshControl atIndex:0];
}

- (void)layoutCells {}

- (void)offsetFixedCells {
	
	if (self.contentOffset.y >= 0) {
		
		for (int row = 0; row < self.fixedRowsCount; row++) {
			
			for (UIView *cell in _cells[row]) {
				
				CGRect frame = cell.frame;
				frame.origin.y = self.contentOffset.y;
				cell.frame = frame;
			}
			
		}
		
	}
	
	if (self.contentOffset.x >= 0) {
		
		CGFloat offset = 0;
		
		for (int column = 0; column < self.fixedColumnsCount; column++) {
			
			NSArray *columnCells = [_cells map:^id(NSArray *object) {
				
				return object[column];
			}];
			
			for (UIView *cell in columnCells) {
				
				CGRect frame = cell.frame;
				frame.origin.x = offset + self.contentOffset.x;
				cell.frame = frame;
			}
			
			UIView *cell = _cells.firstObject[column];
			offset += cell.frame.size.width;
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (scrollView.contentOffset.x < 0) {
		
		scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
	}
	else if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width) {
		
		scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, scrollView.contentOffset.y);
	}
	if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
		
		scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height);
	}
	
	[self offsetFixedCells];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

//	if (scrollView.contentOffset.y > 0) {
//
//		for (UIView *cell in _cells.firstObject) {
//			
//			CGRect frame = cell.frame;
//			frame.origin.y = scrollView.contentOffset.y + scrollView.contentInset.top;
//			cell.frame = frame;
//		}
//
//		for (NSArray *row in _cells) {
//			
//			UIView *cell = row.firstObject;
//			CGRect frame = cell.frame;
//			frame.origin.x = scrollView.contentOffset.x + scrollView.contentInset.left;
//			cell.frame = frame;
//			
//			if (row.count > 1) {
//				
//				CGFloat offset = frame.size.width;
//				cell = row[1];
//				frame = cell.frame;
//				frame.origin.x = scrollView.contentOffset.x + scrollView.contentInset.left + offset;
//				cell.frame = frame;
//			}
//		}
//	}
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	
	CGFloat fixedWidth = [_offsets[self.fixedColumnsCount] floatValue];
	CGFloat targetX = targetContentOffset->x + fixedWidth;

	NSInteger index = [_offsets indexOfObjectPassingTest:^BOOL(NSNumber *offset, NSUInteger idx, BOOL *stop) {

		CGFloat halfCellWidth = idx + 1 < _offsets.count ? ([_offsets[idx + 1] floatValue] - offset.floatValue) / 2 : 0;
		return targetX <= offset.floatValue + halfCellWidth;
	}];

	CGFloat x = [_offsets[MIN(MAX(index, 0), _offsets.count - 1)] floatValue] - fixedWidth;
	x = MIN(MAX(x, 0), self.contentSize.width - self.frame.size.width);
	
	targetContentOffset->x = scrollView.contentOffset.x;
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[self setContentOffset:CGPointMake(x, targetContentOffset->y) animated:YES];
	});
}

@end

