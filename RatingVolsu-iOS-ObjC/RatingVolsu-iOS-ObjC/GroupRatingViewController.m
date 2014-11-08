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
#import "NSArray+Extensions.h"


@interface GroupRatingViewController ()
<
	UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet GroupRatingTableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;

@end


@implementation GroupRatingViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	_tableView.bounces = YES;
	_tableView.alwaysBounceVertical = YES;
	self.tableView.cellHeight = 22;
	
	
	[self addRefreshControl];
	[self addData];
	[_refreshControl beginRefreshing];
	[self groupRequest];

}

- (void)addRefreshControl {
 
 _refreshControl = [UIRefreshControl new];
 [_refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
 [self.tableView insertSubview:_refreshControl atIndex:0];
 self.refreshControl = _refreshControl;
}

- (void)refreshControlAction {
 
	[self groupRequest];
}

- (void)groupRequest {
	
	[RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
		NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
		[_refreshControl endRefreshing];
		self.tableView.dataSource = dataList;
	}];
}

- (void)addData {
	
	NSArray *dataSource = [RatingItem where:@{@"semester.student.group.name" : self.semester.student.group.name,
													@"semester.number" : self.semester.number}];

	
	self.tableView.dataSource = [dataSource groupRatingTable];
}

@end
