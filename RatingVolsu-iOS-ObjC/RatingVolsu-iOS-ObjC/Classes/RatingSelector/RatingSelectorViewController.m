//
//  ViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 10.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingSelectorViewController.h"
#import "RequestManager.h"
#import "CoreDataModel.h"
#import "ObjectiveRecord.h"
#import "Student+Mappings.h"
#import "SemestersViewController.h"
#import "RatingSelectorTableViewCell.h"


@interface RatingSelectorViewController ()
<
	UITableViewDataSource,
	UITableViewDelegate,
	NSFetchedResultsControllerDelegate
>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation RatingSelectorViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 60.0f;
	[[self fetchedResultsController] performFetch:nil];

	dispatch_async (dispatch_get_main_queue (), ^{
		[self.tableView reloadData];
	});
	[self.entityClass request:self.parentId withHandler:^(NSArray *entities){
		[self.tableView reloadData];
	} errorBlock:^(){
		[self.tableView reloadData];
	}];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)configureCell:(RatingSelectorTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	cell.title.text = [[self.fetchedResultsController objectAtIndexPath:indexPath] valueForKey:self.titleKey];
	cell.descriptionText.text = (self.descriptionKey) ? [[self.fetchedResultsController objectAtIndexPath:indexPath] valueForKey:self.descriptionKey] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	RatingSelectorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self.delegate ratingSelector:self didPickObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[_tableView endUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (!_fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self.entityClass) inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:self.titleKey ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
		
		if (self.parentId && self.parentKey) {
			
			fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", self.parentKey, self.parentId];
		}
		
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

@end
