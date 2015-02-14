//
//  GroupRatingTableViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingTableViewController.h"
#import "GroupRatingViewController.h"
#import "RubyLikeExtensions.h"
#import "GroupRatingCell.h"

@interface GroupRatingTableViewController()
<
NSFetchedResultsControllerDelegate,
UITableViewDataSource,
UITableViewDelegate
>


@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation GroupRatingTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
	
	[super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"GroupRatingCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
	self.tableView.rowHeight = 44.0f;
	self.tableView.tableFooterView = [UIView new];
	
}

- (void)reloadData {
	
	NSPredicate *predicate = [@[
								[NSPredicate predicateWithFormat:@"semester.student.group.name == %@", self.semester.student.group.name],
								[NSPredicate predicateWithFormat:@"semester.number == %@", self.semester.number],
								[NSPredicate predicateWithFormat:@"subject.subjectId == %@", self.subject.subjectId]
								] andPredicate];
	
	self.fetchedResultsController.fetchRequest.predicate = predicate;
	[self.fetchedResultsController performFetch:nil];
	[self.tableView reloadData];
}

- (void)configureCell:(GroupRatingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RatingItem *item = _fetchedResultsController.fetchedObjects[indexPath.row];
	cell.place.text = [NSString stringWithFormat:@"№%@", item.semester.place];
	cell.studentNumber.text = item.semester.student.number;
	cell.mark.text = [NSString stringWithFormat:@"%@", item.total];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	GroupRatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
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
			[self configureCell:(GroupRatingCell *)[tableView cellForRowAtIndexPath:indexPath]
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	[self.delegateObject scroll:scrollView.contentOffset];
}

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (!_fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"RatingItem" inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"semester.place" ascending:YES];
		NSArray *sortDescroptors = @[sort];
		[fetchRequest setSortDescriptors:sortDescroptors];

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
