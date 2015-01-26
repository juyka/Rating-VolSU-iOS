//
//  NewRecentTableViewCell.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 26/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "RecentTableViewCell.h"
#import "RecentItem+Mappings.h"
#import "UIImage+Extensions.h"

@implementation RecentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecentItem:(RecentItem *)item {
	
	self.titleText.text = item.name;
	self.descriptionText.text = [item details];
	NSString *title = item.name.iconText;
	self.recentImage.image = [UIImage cellImage:title];
	
}

@end
