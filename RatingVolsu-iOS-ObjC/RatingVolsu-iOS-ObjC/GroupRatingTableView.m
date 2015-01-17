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

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (self) {
		
		self.cellHeight = 22;
		self.fixedRowsCount = 1;
		self.fixedColumnsCount = 2;
	}
	
	return self;
}

- (void)reloadData {
	
	//NSLog(@"%@", NSStringFromCGRect(self.frame));
	[self.cells each:^(NSMutableArray *row) {
		
		[row each:^(RatingTableViewCell *cell) {
			
			[cell removeFromSuperview];
		}];
	}];
	
	NSArray *sizes = [self headerCellSizes];
	_maxHeight = [self maxHeight:sizes];
	
	NSMutableArray *offsets = [NSMutableArray arrayWithCapacity:sizes.count];
	CGFloat offset = 0;
	for (NSValue *size in sizes) {
		
		[offsets addObject:@(offset)];
		offset += size.CGSizeValue.width;
	}
	_offsets = offsets;
	
	_cells = @[].mutableCopy;
	[self.dataSource eachWithIndex:^(NSArray *dataRow, NSUInteger row) {
		
		NSMutableArray *cellsRow = @[].mutableCopy;
		[dataRow eachWithIndex:^(NSString *value, NSUInteger column) {

			CGRect cellFrame = CGRectMake(0, 0,
										  [sizes[column] CGSizeValue].width,
										  row > 0 ? self.cellHeight : self.maxHeight);
			
			RatingTableViewCell *cell = [[RatingTableViewCell alloc] initWithFrame:cellFrame];
			cell.label.adjustsFontSizeToFitWidth = (row > 0);
			cell.label.numberOfLines = (row > 0) ? 1 : 0;
			cell.value = value;
			cell.backgroundColor = row % 2 ? [UIColor whiteColor] : [UIColor colorWithWhite:0.92 alpha:1];
			[cellsRow addObject:cell];
			
			[self insertSubview:cell atIndex:0];
		}];
		[_cells addObject:cellsRow];
	}];
	
	[self layoutCells];
	[self offsetFixedCells];
	
	UIView *lastCell = [self.cells.lastObject lastObject];
	self.contentSize = CGSizeMake(CGRectGetMaxX(lastCell.frame) + self.contentInset.right,
								  CGRectGetMaxY(lastCell.frame) + self.contentInset.bottom);
}

- (void)layoutCells {
	
	[super layoutCells];
	
	[self.cells eachWithIndex:^(NSArray *cells, NSUInteger row) {
		[cells eachWithIndex:^(UIView *cell, NSUInteger column) {
			
			CGPoint offset = CGPointMake([self.offsets[column] floatValue] + self.contentInset.left,
										 self.maxHeight * (row > 0) + self.cellHeight * (row - 1) * (row > 1));
			cell.frame = (CGRect){.origin = offset, .size = cell.frame.size};
		}];
	}];
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
