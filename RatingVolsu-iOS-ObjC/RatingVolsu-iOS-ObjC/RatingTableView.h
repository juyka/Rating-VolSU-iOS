//
//  RatingTableView.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 06/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingTableView : UIScrollView {

	NSArray *_offsets;
	CGFloat _maxHeight;
	NSMutableArray *_cells;
}

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) int fixedRowsCount;
@property (nonatomic) int fixedColumnsCount;

@property (nonatomic, readonly) CGFloat fixedRowHeight;
@property (nonatomic, readonly) NSArray *cells;

@property (nonatomic, readonly) NSArray *offsets;
@property (nonatomic, readonly) CGFloat maxHeight;

- (void)layoutCells;
- (void)offsetFixedCells;

@end
