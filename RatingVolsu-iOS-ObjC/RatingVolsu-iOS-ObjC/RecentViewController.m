//
//  FavoritesViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentItem+Mappings.h"
#import "RatingViewController.h"
#import "SectionHeaderView.h"
#import "UIImage+Extensions.h"
#import "RecentTableViewCell.h"

@interface RecentViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate
>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RecentViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	item.title = @" ";
	self.navigationItem.backBarButtonItem = item;
	
	[self.tableView registerNib:[UINib nibWithNibName:@"RecentTableViewCell" bundle:nil] forCellReuseIdentifier:@"recentCell"];
	self.tableView.tableFooterView = [UIView new];
	self.tableView.separatorInset = UIEdgeInsetsZero;
	
	[[self fetchedResultsController] performFetch:nil];

	[self.tableView reloadData];
	
	if (!self.fetchedResultsController.fetchedObjects.count) {
		
		[self addItem];
	}
	
}
- (IBAction)addItem {
	
	[self performSegueWithIdentifier:@"RatingSelectorSegue" sender:nil];
}

- (void)configureCell:(RecentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RecentItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.separatorInset = UIEdgeInsetsZero;
	cell.defaultColor = self.tableView.backgroundView.backgroundColor;
	
	UIView *checkView = [[UIImageView alloc] initWithImage:@"check".image];
	checkView.contentMode = UIViewContentModeCenter;
	UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
	
	UIView *listView = [[UIImageView alloc] initWithImage:@"list".image];
	listView.contentMode = UIViewContentModeCenter;
	UIColor *yellowColor = [UIColor colorWithRed:195.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
	
	UIView *crossView = [[UIImageView alloc] initWithImage:@"cross".image];
	crossView.contentMode = UIViewContentModeCenter;
	UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
	
	UIView *view = item.isFavorite.boolValue ? listView : checkView;
	UIColor *color = item.isFavorite.boolValue ? yellowColor : greenColor;
	MCSwipeTableViewCellState state = item.isFavorite.boolValue ? MCSwipeTableViewCellState3 : MCSwipeTableViewCellState1;
	
	[cell setSwipeGestureWithView:view color:color mode:MCSwipeTableViewCellModeExit state:state completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
		
		item.date = [NSDate date];
		item.isFavorite = @(state == MCSwipeTableViewCellState1);
		[[CoreDataManager sharedManager] saveContext];
	}];
	
	MCSwipeTableViewCellState deleteState = item.isFavorite.boolValue ? MCSwipeTableViewCellState4 : MCSwipeTableViewCellState3;
	
	[cell setSwipeGestureWithView:crossView color:redColor mode:MCSwipeTableViewCellModeExit state:deleteState completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
		
		[item delete];
		[[CoreDataManager sharedManager] saveContext];
	}];
	
	RecentItem *recentItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.titleText.text = recentItem.name;
	cell.descriptionText.text = [recentItem details];
	NSString *title = recentItem.name.iconText;
	cell.recentImage.image = [UIImage cellImage:title];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return [self.fetchedResultsController.sections count];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
	
	NSDictionary *headers = @{
							  @"1" : @"избранное",
							  @"0" : @"последнее"
							  };
	
	NSString *key = self.fetchedResultsController.sectionIndexTitles[section];
	
	return headers[key];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	SectionHeaderView *view = @"SectionHeaderView".xibView;
	view.backgroundColor = tableView.backgroundView.backgroundColor;
	NSString *text = [self titleForHeaderInSection:section];
	view.label.text = text.uppercaseString;
	
	return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentCell" forIndexPath:indexPath];
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	RecentItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[self showRating:item];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
	
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
			[self configureCell:(id)[tableView cellForRowAtIndexPath:indexPath]
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

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					   withRowAnimation:UITableViewRowAnimationFade];
			break;
		 
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
					   withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeMove:
		case NSFetchedResultsChangeUpdate:
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (!_fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentItem" inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		
		[fetchRequest setSortDescriptors:@[@"isFavorite".descending, @"date".descending]];
		
		NSFetchedResultsController *theFetchedResultsController =
		[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											managedObjectContext:NSManagedObjectContext.defaultContext
											  sectionNameKeyPath:@"isFavorite"
													   cacheName:nil];
		self.fetchedResultsController = theFetchedResultsController;
		_fetchedResultsController.delegate = self;
		
	}
	return _fetchedResultsController;
}

- (void)showRating:(RecentItem *)item {
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[self performSegueWithIdentifier:@"RatingSegue"sender:item];
	});
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	if ([segue.identifier isEqualToString:@"RatingSegue"]) {
		
		RatingViewController *controller = segue.destinationViewController;
		
		controller.recentItem = sender;
	}
}

- (IBAction)unwind:(UIStoryboardSegue *)unwindSegue {
	
	if ([unwindSegue.identifier isEqualToString:@"UnwindToRecentController"]) {
		
		[self showRating:[unwindSegue.sourceViewController valueForKey:@"selectedItem"]];
		[self.tableView reloadData];
	}
}


@end
