//
//  GroupRatingTableViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingTableViewController.h"
#import "GroupRatingCollectionViewController.h"
#import "RubyLikeExtensions.h"

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

- (void)setHeaderHeight:(CGFloat)headerHeight {
	
	_headerHeight = headerHeight;
	NSDictionary *attributes = [self labelAttributes];
	self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, headerHeight)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(self.tableView.tableHeaderView.bounds, 8, 0)];
	label.font = attributes[NSFontAttributeName];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = [attributes[NSParagraphStyleAttributeName] alignment];
	label.numberOfLines = 0;
	label.minimumScaleFactor = 0.3;
	label.lineBreakMode = [attributes[NSParagraphStyleAttributeName] lineBreakMode];
	label.text = self.subject.name;
	[self.tableView.tableHeaderView addSubview:label];
	
}

- (NSDictionary *)labelAttributes {
	
	NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
	style.alignment = NSTextAlignmentCenter;
	style.lineBreakMode = NSLineBreakByWordWrapping;
	
	return @{
			 NSParagraphStyleAttributeName: style,
			 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]
			 };
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RatingItem *item = _fetchedResultsController.fetchedObjects[indexPath.row];
	cell.textLabel.text = item.semester.student.number;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ б.", item.total];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	[self.delegateObject scroll:scrollView.contentOffset];
}

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (!_fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"RatingItem" inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"semester.place" ascending:YES];
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


@end
