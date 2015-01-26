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

@property(nonatomic) UIViewController<RatingViewControllerProtocol> *currentViewController;
@property (nonatomic) NSURLSessionDataTask *task;

@end

@implementation RatingViewController

- (void)viewDidLoad {
	
	self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
    [super viewDidLoad];
	[self changeViewController:self.segmentedControl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh:(id)sender {
	
	NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
	
	if (netStatus == NotReachable) {
		
	//	UIImageView *imageView = [[UIImageView alloc] initWithImage:@"alert".image];
	//	imageView.frame =
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
		
		self.task = [self.currentViewController refresh:^{
			self.navigationItem.rightBarButtonItem = self.refreshItem;
		}];
	}
}

- (IBAction)changeViewController:(UISegmentedControl *)sender {
	
	[self.task cancel];
	
	NSInteger index = sender.selectedSegmentIndex;
	
	NSString *viewControllerID = @[@"StudentRating", @"GroupRating"][index];
	
	UIViewController<RatingViewControllerProtocol> *subViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:viewControllerID];
	
	[self.currentViewController removeFromParentViewController];
	self.currentViewController = subViewController;
	[self addChildViewController:self.currentViewController];
	
	[subViewController setValue:self.recentItem.semester forKey:@"semester"];
	subViewController.view.frame = self.containerView.bounds;
	
	[self.currentViewController.view removeFromSuperview];
	[self.containerView addSubview:subViewController.view];
	
	[self refresh:self];
	
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
