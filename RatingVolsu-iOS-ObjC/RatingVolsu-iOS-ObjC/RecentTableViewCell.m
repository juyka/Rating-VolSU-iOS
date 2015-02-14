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
	
	UIView *checkView = [[UIImageView alloc] initWithImage:@"favorites".image];
	checkView.contentMode = UIViewContentModeCenter;
	UIColor *blueColor = @(0xFF8F27).rgbColor;
	
	UIView *listView = [[UIImageView alloc] initWithImage:@"cross".image];
	listView.contentMode = UIViewContentModeCenter;
	UIColor *turquoiseColor = @(0x4CDAC2).rgbColor;
	
	UIView *crossView = [[UIImageView alloc] initWithImage:@"cross".image];
	crossView.contentMode = UIViewContentModeCenter;
	UIColor *redColor = @(0xD13838).rgbColor;
	
	UIView *view = item.isFavorite.boolValue ? listView : checkView;
	UIColor *color = item.isFavorite.boolValue ? turquoiseColor : blueColor;
	
	MCSwipeTableViewCellState state = item.isFavorite.boolValue ? MCSwipeTableViewCellState3 : MCSwipeTableViewCellState1;
	
	[self setSwipeGestureWithView:view color:color mode:MCSwipeTableViewCellModeExit state:state completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
		
		item.date = [NSDate date];
		item.isFavorite = @(state == MCSwipeTableViewCellState1);
		[RecentItem clean];
		[[CoreDataManager sharedManager] saveContext];
	}];
	
	MCSwipeTableViewCellState deleteState = item.isFavorite.boolValue ? MCSwipeTableViewCellState4 : MCSwipeTableViewCellState3;
	
	[self setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:deleteState completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
		
		[item delete];
		[[CoreDataManager sharedManager] saveContext];
	}];

	self.titleText.text = item.name;
	self.editText.text = item.name;
	self.descriptionText.text = [item details];
	NSString *title = item.name.iconText;
	self.recentImage.image = [UIImage cellImage:title];
	
}

@end
