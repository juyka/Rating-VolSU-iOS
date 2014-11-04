//
//  GroupRatingViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingViewController.h"
#import "RatingItem+Mappings.h"
#import "GroupRatingTableView.h"


@interface GroupRatingViewController ()
<
	UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet GroupRatingTableView *tableView;

@end


@implementation GroupRatingViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	[RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
		self.tableView.dataSource = dataList;
	}];
	
	self.tableView.fixedColumnWidth = 100;
	self.tableView.cellSize = CGSizeMake(140, 22);
//	self.tableView.dataSource = @[
//								  @[@"Номер зачетки", @"Математика", @"Информатика и природоведение", @"Биология", @"Обществознание", @"Труд", @"Английский язык"],
//								  @[@"10108", @"10", @"", @"", @"", @"", @""],
//								  @[@"10109", @"12", @"", @"", @"", @"", @""],
//								  @[@"10104", @"100", @"", @"", @"", @"", @""],
//								  @[@"10139", @"40", @"", @"", @"", @"", @""],
//								  @[@"10148", @"5", @"", @"", @"", @"", @""],
//								  @[@"10143", @"23", @"", @"", @"", @"", @""],
//								  ];
}

@end
