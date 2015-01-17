//
//  StudentRatingTableViewCell.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 12/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingScrollView;

@interface StudentRatingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet RatingScrollView *scrollView;
@property (nonatomic) NSArray *numbers;


- (void)scroll:(NSInteger)pageNumber;

@end
