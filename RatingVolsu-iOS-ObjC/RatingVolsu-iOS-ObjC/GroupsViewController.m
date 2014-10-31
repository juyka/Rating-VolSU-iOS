//
//  GroupsViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 19/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupsViewController.h"
#import "StudentsViewController.h"
#import "RatingSelectorViewController.h"


@interface GroupsViewController () <RatingSelectorDelegate>
@end


@implementation GroupsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"GroupsTable"]) {
		
		RatingSelectorViewController *controller = segue.destinationViewController;
		controller.delegate = self;
		controller.entityClass = Group.class;
		controller.parentId = self.faculty.facultyId;
		controller.parentKey = @"faculty.facultyId";
		controller.descriptionKey = @"name";
		controller.cellId = @"GroupCell";
	}
	else if ([segue.identifier isEqualToString:@"StudentsController"]) {
		
		StudentsViewController *controller = segue.destinationViewController;
		controller.group = sender;
	}
}

- (void)ratingSelector:(RatingSelectorViewController *)controller didPickObject:(NSManagedObject *)object {
	
	if ([object isKindOfClass:Group.class]) {
		
		[self performSegueWithIdentifier:@"StudentsController" sender:object];
	}
}

@end
