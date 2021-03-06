//
//  FacultySelectorViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 19/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "FacultiesViewController.h"
#import "RatingSelectorViewController.h"
#import "GroupsViewController.h"


@interface FacultiesViewController () <RatingSelectorDelegate>
@end


@implementation FacultiesViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	if (![RecentItem all].count) {
		
		self.navigationItem.leftBarButtonItem = nil;
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"FacultiesTable"]) {
		
		RatingSelectorViewController *controller = segue.destinationViewController;
		controller.delegate = self;
		controller.entityClass = Faculty.class;
		controller.titleKey = @"name";
		controller.descriptionKey = @"owner";
		controller.cellId = @"FacultyCell";
	}
	else if ([segue.identifier isEqualToString:@"GroupsController"]) {
		
		GroupsViewController *controller = segue.destinationViewController;
		controller.faculty = sender;
	}
}

- (void)ratingSelector:(RatingSelectorViewController *)controller didPickObject:(NSManagedObject *)object {
	
	if ([object isKindOfClass:Faculty.class]) {
		
		[self performSegueWithIdentifier:@"GroupsController" sender:object];
	}
}

@end
