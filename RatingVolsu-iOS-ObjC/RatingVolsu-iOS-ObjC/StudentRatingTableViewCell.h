//
//  StudentRatingTableViewCell.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 12/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentRatingCellProtocol.h"

@class RatingScrollView;

@interface StudentRatingTableViewCell : UITableViewCell <StudentRatingCellProtocol>

@property (weak, nonatomic) IBOutlet RatingScrollView *scrollView;
@property (nonatomic) NSArray *numbers;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

- (void)scroll:(NSInteger)pageNumber;

@end
