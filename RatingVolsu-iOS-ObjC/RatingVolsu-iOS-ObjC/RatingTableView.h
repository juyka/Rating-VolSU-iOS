//
//  RatingTableView.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 06/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingTableView : UIScrollView

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) CGFloat cellHeight;

@property (nonatomic, readonly) CGFloat fixedRowHeight;
@property (nonatomic) NSMutableArray *cells;
@property (nonatomic) NSArray *offsets;

@end
