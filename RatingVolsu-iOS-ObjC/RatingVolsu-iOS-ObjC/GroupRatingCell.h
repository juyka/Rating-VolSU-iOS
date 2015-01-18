//
//  GroupRatingCell.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 18/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupRatingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UILabel *studentNumber;
@property (weak, nonatomic) IBOutlet UILabel *mark;

@end
