//
//  RecentTableViewCell.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 18/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface RecentTableViewCell : MCSwipeTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *recentImage;

- (void)setRecentItem:(RecentItem *)item;

@end
