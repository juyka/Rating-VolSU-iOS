//
//  ViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 10.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RatingSelectorViewController.h"
#import "RequestManager.h"
#import "CoreData/CoreDataModel.h"
#import "ObjectiveRecord.h"
#import "Student+Mappings.h"
#import "SemestersViewController.h"


@interface RatingSelectorViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation RatingSelectorViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (Class)entityClass {
	return _entityClass ?: Faculty.class;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[self fetchedResultsController] performFetch:nil];
	[_tableView reloadData];
	[self.entityClass primaryKey];
	[self.entityClass request:self.parentId withHandler:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	cell.textLabel.text = [[self.fetchedResultsController objectAtIndexPath:indexPath] valueForKey:[self.entityClass descriptionKey]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
	CGRect rect = [[[self.fetchedResultsController objectAtIndexPath:indexPath] valueForKey:[self.entityClass descriptionKey]]
				   boundingRectWithSize:CGSizeMake(290, CGFLOAT_MAX)
				   options:NSStringDrawingUsesLineFragmentOrigin
				   attributes:attributes
				   context:nil];
	
	return 8 + rect.size.height + 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.entityClass cellId] forIndexPath:indexPath];
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
		NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self.entityClass) inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		NSSortDescriptor *sort = [[NSSortDescriptor alloc]
								  initWithKey:[self.entityClass descriptionKey] ascending:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"StudentSemesterSegue"] || [segue.identifier isEqualToString:@"GroupSemesterSegue"])
	{
		SemestersViewController *viewController = segue.destinationViewController;
		viewController.groupId = self.parentId;
	}
	else
	{
		RatingSelectorViewController *viewController = segue.destinationViewController;
		NSIndexPath *indexPath = [_tableView indexPathForCell:sender];
		NSString *key = [self.entityClass primaryKey];
		if (key)
		{
			viewController.parentId = [[self.fetchedResultsController objectAtIndexPath:indexPath] valueForKey:key];
		}
		viewController.entityClass = [self.entityClass childEntity];
	}
		
}

@end
