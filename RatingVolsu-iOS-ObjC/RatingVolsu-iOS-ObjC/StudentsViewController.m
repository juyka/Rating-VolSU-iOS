//
//  StudentsViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 19/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "StudentsViewController.h"
#import "SemestersViewController.h"
#import "RatingSelectorViewController.h"


@interface StudentsViewController () <RatingSelectorDelegate>

@end


@implementation StudentsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"StudentsTable"]) {
		
		RatingSelectorViewController *controller = segue.destinationViewController;
		controller.delegate = self;
		controller.entityClass = Student.class;
		controller.titleKey = @"number";
		controller.parentId = self.group.groupId;
		controller.parentKey = @"group.groupId";
		controller.cellId = @"StudentCell";
	}
	else if ([segue.identifier isEqualToString:@"SemesterSegue"]) {
		
		SemestersViewController *controller = segue.destinationViewController;
		controller.student = sender;
		
	}
}

- (void)ratingSelector:(RatingSelectorViewController *)controller didPickObject:(NSManagedObject *)object {
	
	if ([object isKindOfClass:Student.class]) {
		
		[self performSegueWithIdentifier:@"SemesterSegue" sender:object];
	}
}

@end
