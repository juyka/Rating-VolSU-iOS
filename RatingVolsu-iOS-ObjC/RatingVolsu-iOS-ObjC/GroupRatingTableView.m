//
//  GroupRatingTableView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingTableView.h"
#import "RatingTableViewCell.h"


@implementation GroupRatingTableView

- (void)reloadData {
	
	NSLog(@"%@", NSStringFromCGRect(self.frame));
	[self.cells each:^(NSMutableArray *row) {
		
		[row each:^(RatingTableViewCell *cell) {
			
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
	self.offsets = offsets;
	
	self.cells = @[].mutableCopy;
	[self.dataSource eachWithIndex:^(NSArray *dataRow, NSUInteger row) {
		
		NSMutableArray *cellsRow = @[].mutableCopy;
		[dataRow eachWithIndex:^(NSString *value, NSUInteger column) {

			CGPoint offset = CGPointMake([offsets[column] floatValue] + self.contentInset.left,
										 maxHeight * (row > 0) + self.cellHeight * (row - 1) * (row > 1) + self.contentInset.top);
			
//			CGPoint offset = CGPointMake(self.fixedColumnWidth * (column > 0) + self.cellSize.width * (column - 1) * (column > 1) + self.contentInset.left,
//										 fixedRowHeight * (row > 0) + self.cellSize.height * (row - 1) * (row > 1) + self.contentInset.top);
//			
			CGRect cellFrame = CGRectMake(offset.x, offset.y,
										  [sizes[column] CGSizeValue].width,
//										  column > 0 ? self.cellSize.width : self.fixedColumnWidth,
										  row > 0 ? self.cellHeight : maxHeight);
			
			RatingTableViewCell *cell = [[RatingTableViewCell alloc] initWithFrame:cellFrame];
			cell.label.adjustsFontSizeToFitWidth = (row > 0);
			cell.label.numberOfLines = (row > 0) ? 1 : 0;
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

- (CGFloat)maxHeight:(NSArray *)sizes {
	
	__block CGFloat fixedRowHeight = 0;
	[sizes each:^(NSValue *object) {
		
		fixedRowHeight = MAX(fixedRowHeight, object.CGSizeValue.height);
	}];
	
	return fixedRowHeight;
}

- (NSArray *)headerCellSizes {
	
	return [self.dataSource.firstObject map:^id(NSString *value) {
		
//		CGFloat maxWidth = value == [_dataSource.firstObject firstObject] ? 90 : 140;
		UIEdgeInsets insets = UIEdgeInsetsMake(2, 8, 2, 8);
		CGRect rect = [value boundingRectWithSize:CGSizeMake(140, 100)
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:[RatingTableViewCell labelAttributes]
										  context:nil];
		
		return [NSValue valueWithCGSize:CGSizeMake(ceil(rect.size.width + insets.left + insets.right), ceil(rect.size.height + insets.top + insets.bottom))];
	}];
}

@end
