//
//  RatingViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 12/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "RatingViewController.h"
#import "GroupRatingViewController.h"
#import "StudentRatingViewController.h"

@interface RatingViewController ()

@property(weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property(nonatomic) UIViewController *currentViewController;


@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self changeViewController:self.segmentedControl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	
	
}

- (IBAction)changeViewController:(UISegmentedControl *)sender {
	
	NSInteger index = sender.selectedSegmentIndex;
	
	NSString *viewControllerID = @[@"StudentRating", @"GroupRating"][index];
	
	UIViewController *subViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:viewControllerID];
	
	[subViewController setValue:self.recentItem.semester forKey:@"semester"];
	subViewController.view.frame = self.containerView.bounds;
	
	[self.currentViewController.view removeFromSuperview];
	[self.containerView addSubview:subViewController.view];
	
	[self.currentViewController removeFromParentViewController];
	self.currentViewController = subViewController;
	[self addChildViewController:self.currentViewController];
	
}

- (BOOL)canRotate {
	
	return !self.segmentedControl.selectedSegmentIndex;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
