//
//  RecentTableViewCell.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 18/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "RecentTableViewCell.h"
#import "RecentItem+Mappings.h"
#import "UIImage+Extensions.h"

@implementation RecentTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		
		
	}
	
	return self;
}

- (void)setRecentItem:(RecentItem *)item {
	
	UIView *checkView = [[UIImageView alloc] initWithImage:@"check".image];
	checkView.contentMode = UIViewContentModeCenter;
	UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
	
	UIView *listView = [[UIImageView alloc] initWithImage:@"list".image];
	listView.contentMode = UIViewContentModeCenter;
	UIColor *yellowColor = [UIColor colorWithRed:195.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
	
	UIView *crossView = [[UIImageView alloc] initWithImage:@"cross".image];
	crossView.contentMode = UIViewContentModeCenter;
	UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
	
	UIView *view = item.isFavorite.boolValue ? listView : checkView;
	UIColor *color = item.isFavorite.boolValue ? yellowColor : greenColor;
	
	MCSwipeTableViewCellState state = item.isFavorite.boolValue ? MCSwipeTableViewCellState3 : MCSwipeTableViewCellState1;
	
	[self setSwipeGestureWithView:view color:color mode:MCSwipeTableViewCellModeExit state:state completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
		
		item.date = [NSDate date];
		item.isFavorite = @(state == MCSwipeTableViewCellState1);
		[[CoreDataManager sharedManager] saveContext];
	}];
	
	MCSwipeTableViewCellState deleteState = item.isFavorite.boolValue ? MCSwipeTableViewCellState4 : MCSwipeTableViewCellState3;
	
	[self setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:deleteState completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
		
		[item delete];
		[[CoreDataManager sharedManager] saveContext];
	}];
	
	self.titleText.text = item.name;
	self.descriptionText.text = [item details];
	NSString *title = item.name.iconText;
	self.recentImage.image = [UIImage cellImage:title];

}

@end
