//
//  StudentRatingTableView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 06/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "StudentRatingTableView.h"
#import "RatingTableView.h"
#import "RatingTableViewCell.h"

@implementation StudentRatingTableView 

- (void)reloadData {
	
	[self.cells each:^(NSMutableArray *row) {
		
		[row each:^(RatingTableViewCell *cell) {
			
			[cell removeFromSuperview];
		}];
	}];

	NSArray *widths = [self cellWidths];
	NSArray *heights = [self cellHeights:[widths.first floatValue]];

	CGFloat maxHeight = [self maxHeight:heights];
	
//	NSArray *heightOffesets = [self offsets:heights];
	NSArray *widthOffsets = [self offsets:widths];
	
	self.cells = @[].mutableCopy;
	[self.dataSource eachWithIndex:^(NSArray *dataRow, NSUInteger row) {
		
		NSMutableArray *cellsRow = @[].mutableCopy;
		[dataRow eachWithIndex:^(NSString *value, NSUInteger column) {
			
			CGPoint offset = CGPointMake([widthOffsets[column] floatValue] + self.contentInset.left,
										 //[heightOffesets[row] floatValue] + self.contentInset.top);
										 (row > 0) * (maxHeight * (row - 1) + self.cellHeight) + self.contentInset.top);
			CGRect cellFrame = CGRectMake(offset.x, offset.y,
										  [widths[column] floatValue],
										 // [heights[row] floatValue]);
										  (row > 0) ? maxHeight : self.cellHeight);
			RatingTableViewCell *cell = [[RatingTableViewCell alloc] initWithFrame:cellFrame];
			//cell.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 2 * (column < 1 || row < 1)];
			cell.value = value;
			cell.backgroundColor = row % 2 ? [UIColor whiteColor] : [UIColor colorWithWhite:0.92 alpha:1];
			[cellsRow addObject:cell];
			
			[self insertSubview:cell atIndex:0];
		}];
		[self.cells addObject:cellsRow];
	}];
	
	UIView *lastCell = [self.cells.lastObject lastObject];
	self.contentSize = CGSizeMake(CGRectGetMaxX(lastCell.frame) + self.contentInset.right,
								  CGRectGetMaxY(lastCell.frame) + self.contentInset.bottom);
}

- (CGFloat)maxHeight:(NSArray *)heights {
	
	__block CGFloat maxRowHeight = 0;
	[heights each:^(NSNumber *object) {
		
		maxRowHeight = MAX(maxRowHeight, [object floatValue]);
	}];
	
	return maxRowHeight;
}

- (NSArray *)offsets:(NSArray *)values {
	
	NSMutableArray *offsets = [NSMutableArray arrayWithCapacity:values.count];
	CGFloat offset = 0;
	
	for (NSNumber *value in values) {
		
		[offsets addObject:@(offset)];
		offset += [value floatValue];
	}
	
	return offsets;
}

- (NSArray *)cellWidths {
	
	CGFloat width = self.frame.size.width;
	NSArray *widths = @[ @(0.33 * width), @(0.12 * width), @(0.12 * width), @(0.12 * width), @(0.1 * width), @(0.13 * width), @(0.08 * width)];
//	NSArray *widths = @[ @(0.41 * width), @(0.11 * width), @(0.11 * width), @(0.11 * width), @(0.09 * width), @(0.10 * width), @(0.07 * width)];
	
	return widths;
}

- (NSArray *)cellHeights:(CGFloat)width {
	
	return [self.dataSource map:^id(NSArray *row) {

		NSString *value = row.firstObject;
		
//		UIEdgeInsets insets = UIEdgeInsetsMake(2, 8, 2, 8);
		UIEdgeInsets insets = UIEdgeInsetsMake(2, 4, 2, 4);

		CGRect rect = [value boundingRectWithSize:CGSizeMake(width, 100)
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:[RatingTableViewCell labelAttributes]
										  context:nil];
		
		return @(rect.size.height + insets.top + insets.bottom);
	}];
}

@end
