//
//  SubjectCollectionViewCell.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "SubjectCollectionViewCell.h"
#import "GroupRatingTableViewController.h"

@implementation SubjectCollectionViewCell

- (void)awakeFromNib {
	
	self.controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GroupRatingTableView"];
	self.controller.view.frame = self.frame;
	[self addSubview:self.controller.view];
	
}

@end
