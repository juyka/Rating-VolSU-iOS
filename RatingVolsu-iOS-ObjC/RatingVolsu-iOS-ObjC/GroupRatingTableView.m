//
//  GroupRatingTableView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingTableView.h"
#import "GroupRatingTableViewCell.h"


@interface GroupRatingTableView () <UIScrollViewDelegate>
@property (nonatomic, readonly) CGFloat fixedRowHeight;
@end


@implementation GroupRatingTableView {
	
	NSMutableArray *_cells;
	NSArray *_offsets;
}


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

- (void)setCellSize:(CGSize)cellSize {
	
	_cellSize = cellSize;
	[self reloadData];
}

- (void)setFixedColumnWidth:(CGFloat)fixedColumnWidth {
	
	_fixedColumnWidth = fixedColumnWidth;
	[self reloadData];
}

- (void)reloadData {
	
	[_cells each:^(NSMutableArray *row) {
		
		[row each:^(GroupRatingTableViewCell *cell) {
			
			[cell removeFromSuperview];
		}];
	}];
	
//	CGFloat fixedRowHeight = self.fixedRowHeight;
	NSArray *sizes = [self headerCellSizes];
	CGFloat maxHeight = [self maxHeight:sizes];
	
	NSMutableArray *offsets = [NSMutableArray arrayWithCapacity:sizes.count];
	CGFloat offset = 0;
	for (NSValue *size in sizes) {
		
		[offsets addObject:@(offset)];
		offset += size.CGSizeValue.width;
	}
	_offsets = offsets;
	
	_cells = @[].mutableCopy;
	[_dataSource eachWithIndex:^(NSArray *dataRow, NSUInteger row) {
		
		NSMutableArray *cellsRow = @[].mutableCopy;
		[dataRow eachWithIndex:^(NSString *value, NSUInteger column) {

			CGPoint offset = CGPointMake([offsets[column] floatValue] + self.contentInset.left,
										 maxHeight * (row > 0) + self.cellSize.height * (row - 1) * (row > 1) + self.contentInset.top);
			
//			CGPoint offset = CGPointMake(self.fixedColumnWidth * (column > 0) + self.cellSize.width * (column - 1) * (column > 1) + self.contentInset.left,
//										 fixedRowHeight * (row > 0) + self.cellSize.height * (row - 1) * (row > 1) + self.contentInset.top);
//			
			CGRect cellFrame = CGRectMake(offset.x, offset.y,
										  [sizes[column] CGSizeValue].width,
//										  column > 0 ? self.cellSize.width : self.fixedColumnWidth,
										  row > 0 ? self.cellSize.height : maxHeight);
			
			GroupRatingTableViewCell *cell = [[GroupRatingTableViewCell alloc] initWithFrame:cellFrame];
			cell.value = value;
			cell.backgroundColor = row % 2 ? [UIColor whiteColor] : [UIColor colorWithWhite:0.92 alpha:1];
			[cellsRow addObject:cell];
			
			[self insertSubview:cell atIndex:0];
		}];
		[_cells addObject:cellsRow];
	}];
	
	UIView *lastCell = [_cells.lastObject lastObject];
	self.contentSize = CGSizeMake(CGRectGetMaxX(lastCell.frame) + self.contentInset.right,
								  CGRectGetMaxY(lastCell.frame) + self.contentInset.bottom);
}

- (CGFloat)fixedRowHeight {
	
	__block CGFloat fixedRowHeight = 0;
	[_dataSource.firstObject eachWithIndex:^(NSString *value, NSUInteger index) {
		
		UIEdgeInsets insets = UIEdgeInsetsMake(2, 4, 2, 4);
		CGFloat cellWidth = (index == 0 ? self.fixedColumnWidth : self.cellSize.width) - insets.left - insets.right;
		CGRect rect = [value boundingRectWithSize:CGSizeMake(cellWidth, CGFLOAT_MAX)
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:[GroupRatingTableViewCell labelAttributes]
										  context:nil];
		
		fixedRowHeight = MAX(fixedRowHeight, ceil(rect.size.height + insets.top + insets.bottom));
	}];
	
	return fixedRowHeight;
}

- (CGFloat)maxHeight:(NSArray *)sizes {
	
	__block CGFloat fixedRowHeight = 0;
	[sizes each:^(NSValue *object) {
		
		fixedRowHeight = MAX(fixedRowHeight, object.CGSizeValue.height);
	}];
	
	return fixedRowHeight;
}

- (NSArray *)headerCellSizes {
	
	return [_dataSource.firstObject map:^id(NSString *value) {
		
//		CGFloat maxWidth = value == [_dataSource.firstObject firstObject] ? 90 : 140;
		UIEdgeInsets insets = UIEdgeInsetsMake(2, 8, 2, 8);
		CGRect rect = [value boundingRectWithSize:CGSizeMake(140, 100)
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:[GroupRatingTableViewCell labelAttributes]
										  context:nil];
		
		return [NSValue valueWithCGSize:CGSizeMake(ceil(rect.size.width + insets.left + insets.right), ceil(rect.size.height + insets.top + insets.bottom))];
	}];
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
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
