//
//  FavoritesViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentItem+Mappings.h"
#import "RatingsViewController.h"

@interface RecentViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecentViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if ([RecentItem all].count) {
		[_tableView reloadData];
	}
	else {
		[self performSegueWithIdentifier:@"RatingSelectorSegue" sender:nil];
	}
	
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RecentItem *recentItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = recentItem.name;
	cell.detailTextLabel.text = [recentItem details];
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
	
	RecentItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self showRating:item];
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
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentItem" inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		NSSortDescriptor *sort = [[NSSortDescriptor alloc]
								  initWithKey:@"name" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		
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

- (void)showRating:(RecentItem *)item {
	
	
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
//	if (sender) {
//		RatingsViewController *controller = segue.destinationViewController;
//	}
}

- (IBAction)unwind:(UIStoryboardSegue *)unwindSegue {
	
	if ([unwindSegue.identifier isEqualToString:@"UnwindToRecentController"]) {
		
		[self showRating:[unwindSegue.sourceViewController valueForKey:@"selectedItem"]];
	}
}

@end
