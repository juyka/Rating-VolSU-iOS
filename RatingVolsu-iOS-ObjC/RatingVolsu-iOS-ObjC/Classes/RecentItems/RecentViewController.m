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
#import "Reachability.h"
#import <Appirater.h>

@interface RecentViewController ()
<
UIGestureRecognizerDelegate,
UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate
>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Reachability *internetReachability;


@end

@implementation RecentViewController {
	
	NSIndexPath *selectedCellPath;
}

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	item.title = @" ";
	self.navigationItem.backBarButtonItem = item;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide)
												 name:UIKeyboardWillHideNotification
											   object:nil];

	
	self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	
	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleLongPress:)];
	lpgr.minimumPressDuration = 0.7;
	lpgr.delegate = self;
	
	[self.tableView addGestureRecognizer:lpgr];
	self.tableView.tableFooterView = [UIView new];
	self.tableView.separatorInset = UIEdgeInsetsZero;
	[self.tableView registerNib:[UINib nibWithNibName:@"RecentTableViewCell" bundle:nil] forCellReuseIdentifier:@"recentCell"];

	[[self fetchedResultsController] performFetch:nil];

	[self.tableView reloadData];
	
	if (!self.fetchedResultsController.fetchedObjects.count) {
		
		[self addItem];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	if (RVAppDelegate.shouldShowRateUs) {
		[Appirater userDidSignificantEvent:YES];
		RVAppDelegate.shouldShowRateUs = NO;
	}
}

- (void)keyboardWillShow {
	
	CGFloat keyboardOffset = 293;
	
	UIEdgeInsets insets = self.tableView.contentInset;
	
	self.tableView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, keyboardOffset, insets.right);
	
}

- (void)keyboardWillHide {
	
	CGFloat keyboardOffset = 293;
	
	UIEdgeInsets insets = self.tableView.contentInset;
	
	self.tableView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom - keyboardOffset, insets.right);
}


- (IBAction)addItem {
	
	NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
	
	if (netStatus == NotReachable) {
		
		[[[UIAlertView alloc] initWithTitle:@"Нет соединения с Интернет"
									message:nil
								   delegate:nil
						  cancelButtonTitle:@"Ok"
						  otherButtonTitles:nil] show];
		
	} else {
		
		[self performSegueWithIdentifier:@"RatingSelectorSegue" sender:nil];
		
	}

}

- (void)configureCell:(RecentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RecentItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	if (item.isFavorite.boolValue) {
		
		UIView *checkView = [[UIImageView alloc] initWithImage:@"edit".image];
		checkView.contentMode = UIViewContentModeCenter;
		UIColor *blueColor = @(0x162A52).rgbColor;
		
		[cell setSwipeGestureWithView:checkView color:blueColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
			
			RecentTableViewCell *viewCell = (RecentTableViewCell *)cell;
			NSIndexPath *path = [self.tableView indexPathForCell:viewCell];
			viewCell.editText.hidden = NO;
			[viewCell.editText becomeFirstResponder];
			[viewCell.editText selectAll:nil];
			viewCell.titleText.hidden = YES;
			selectedCellPath = path;
			
		}];
	}
	
	cell.defaultColor = self.tableView.backgroundColor;
	cell.editText.delegate = self;
	[cell setRecentItem:item];
	
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
	CGPoint p = [gestureRecognizer locationInView:self.tableView];
	
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan && indexPath.section == 0) {
		
		RecentTableViewCell *cell = (RecentTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
		cell.editText.hidden = NO;
		[cell.editText becomeFirstResponder];
		[cell.editText selectAll:nil];
		cell.titleText.hidden = YES;
		selectedCellPath = indexPath;
		
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	RecentTableViewCell *cell = (RecentTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedCellPath];
	RecentItem *item = [self.fetchedResultsController objectAtIndexPath:selectedCellPath];
	
	[item rename:cell.editText.text];
	
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	RecentTableViewCell *cell = (RecentTableViewCell *)[self.tableView cellForRowAtIndexPath:selectedCellPath];
	cell.editText.hidden = YES;
	cell.titleText.hidden = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return [self.fetchedResultsController.sections count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSNumber *key = self.fetchedResultsController.sectionIndexTitles[section];
	SectionHeaderView *view = [SectionHeaderView headerForSection:key.intValue];
	view.backgroundColor = tableView.backgroundColor;
	
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
		fetchRequest.fetchLimit = 10;
		
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

	[self.view.window endEditing:YES];
	
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
