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
#import "Reachability.h"

@interface RatingViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) IBOutlet UIBarButtonItem *refreshItem;
@property (nonatomic) Reachability *internetReachability;

@property (nonatomic) UIViewController<RatingViewControllerProtocol> *currentViewController;
@property (nonatomic) NSURLSessionDataTask *task;

@end

@implementation RatingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	RVAppDelegate.shouldShowRateUs = YES;
	self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
    [super viewDidLoad];
	[self changeViewController:self.segmentedControl];
}

- (IBAction)refresh:(id)sender {
	
	NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
	
	if (netStatus == NotReachable) {
		
		UIBarButtonItem *accessWarning = [[UIBarButtonItem alloc]
										  initWithImage:@"alert".image style:UIBarButtonItemStyleDone target:nil action:nil];
		
		
		self.navigationItem.rightBarButtonItem = accessWarning;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		
	}
	else {
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
													  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		
		UIBarButtonItem *progressIndicator = [[UIBarButtonItem alloc]
											  initWithCustomView:activityIndicator];
		
		self.navigationItem.rightBarButtonItem = progressIndicator;
		
		[activityIndicator startAnimating];
		
		__weak typeof(self) weakSelf = self;
		
		self.task = [self.currentViewController refresh:^{
			weakSelf.navigationItem.rightBarButtonItem = weakSelf.refreshItem;
		}];
	}
}

- (IBAction)changeViewController:(UISegmentedControl *)sender {
	
	[self.task cancel];
	
	NSString *viewControllerID = @[@"StudentRating", @"GroupRating"][sender.selectedSegmentIndex];
	
	UIViewController<RatingViewControllerProtocol> *subViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewControllerID];
	
	[self.currentViewController removeFromParentViewController];
	[self.currentViewController.view removeFromSuperview];
	self.currentViewController = subViewController;
	[self addChildViewController:self.currentViewController];
	
	[subViewController setValue:self.recentItem.semester forKey:@"semester"];
	subViewController.view.frame = self.containerView.bounds;
	[self.containerView addSubview:subViewController.view];
	
	[self refresh:self];
}

- (BOOL)canRotate {
	
	return !self.segmentedControl.selectedSegmentIndex;
}

@end
