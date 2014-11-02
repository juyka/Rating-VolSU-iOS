//
//  GroupRatingViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingViewController.h"
#import "RatingItem+Mappings.h"

@implementation GroupRatingViewController

- (void)viewDidLoad {
	
	[RatingItem requestByGroup:self.semester withHandler:nil];
}

@end
