//
//  RatingsViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 27/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "StudentRatingViewController.h"
#import "RatingItem+Mappings.h"
#import "GroupRatingViewController.h"
#import "StudentRatingTableView.h"

@interface StudentRatingViewController()
<
UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate
>

@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *dataList;
@end

@implementation StudentRatingViewController {
	
	IBOutlet UIView *_portraitView;
	IBOutlet UIView *_landscapeView;
	IBOutlet StudentRatingTableView *ratingTableView;
	UIView *_currentView;
}

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_tableView.tableFooterView = UIView.new;
	[[self fetchedResultsController] performFetch:nil];
	[_tableView reloadData];
	[RatingItem requestByStudent:self.recentItem.semester withHandler:^(NSArray *dataList) {
		ratingTableView.dataSource = dataList;
	}];
	
	ratingTableView.cellHeight = 30;
	
	
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
	 {
		 UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		 if(UIInterfaceOrientationIsLandscape(orientation))
		 {
			 _landscapeView.hidden = NO;
			 _portraitView.hidden = YES;
			 [ratingTableView reloadData];
		 }
		 else
		 {
			 _portraitView.hidden = NO;
			 _landscapeView.hidden = YES;
		 }
		 
	 } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {    }];
	
	[super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RatingItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", item.subject.name, item.total];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[_tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = _tableView;
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath]
					atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[_tableView endUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (!_fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"RatingItem"inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		fetchRequest.sortDescriptors = @[@"total".descending];
		
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"semester.semesterId = %@", self.recentItem.semester.semesterId ];
		
		NSFetchedResultsController *theFetchedResultsController =
		[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											managedObjectContext:NSManagedObjectContext.defaultContext
											  sectionNameKeyPath:nil
													   cacheName:nil];
		self.fetchedResultsController = theFetchedResultsController;
		_fetchedResultsController.delegate = self;
	}
	return _fetchedResultsController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"GroupRatingSegue"]) {
		
		GroupRatingViewController *controller = segue.destinationViewController;
		controller.semester = self.recentItem.semester;
	}
}


@end
