//
//  StudentRatingLandscapeTableViewCell.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentRatingCellProtocol.h"

@interface StudentRatingLandscapeTableViewCell : UITableViewCell<StudentRatingCellProtocol>

@property (nonatomic) NSArray *numbers;
@property (weak, nonatomic) IBOutlet UILabel *titleText;

@end
