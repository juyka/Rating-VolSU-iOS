//
//  GroupRatingTableView.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupRatingTableView : UIScrollView

@property (nonatomic) NSArray *dataSource;
@property (nonatomic) CGFloat fixedColumnWidth;
@property (nonatomic) CGSize cellSize;

@end
