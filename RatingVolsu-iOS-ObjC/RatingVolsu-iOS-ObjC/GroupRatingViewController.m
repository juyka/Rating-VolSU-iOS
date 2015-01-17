//
//  GroupRatingViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingViewController.h"
#import "GroupRatingCollectionViewController.h"
#import "RatingItem+Mappings.h"
#import "GroupRatingTableView.h"
#import "NSArray+Extensions.h"
#import "MNRefreshControl.h"


@interface GroupRatingViewController ()
<
	UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet GroupRatingTableView *tableView;

@end


@implementation GroupRatingViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];	
	
	//[self addRefreshControl];
	[self addData];
	[self groupRequest];

}

- (void)addRefreshControl {
 
	self.tableView.addRefreshControlWithActionHandler(^{
		
		[self groupRequest];
	});

}


- (void)groupRequest {
	
	[RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
	//	[self.tableView.refreshControl endRefreshing];
		self.tableView.dataSource = dataList;
	}];
}

- (void)addData {
	
	NSArray *dataSource = [RatingItem where:@{@"semester.student.group.name" : self.semester.student.group.name,
													@"semester.number" : self.semester.number}];

	
	self.tableView.dataSource = [dataSource groupRatingTable];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"GroupRatingSegue"]) {
		
		GroupRatingCollectionViewController *controller = segue.destinationViewController;
		controller.semester = self.semester;
	}
}

@end
