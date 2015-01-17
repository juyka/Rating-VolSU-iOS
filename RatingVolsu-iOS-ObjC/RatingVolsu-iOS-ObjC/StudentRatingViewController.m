//
//  RatingsViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 27/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "StudentRatingViewController.h"
#import "RatingItem+Mappings.h"
#import "GroupRatingCollectionViewController.h"
#import "StudentRatingTableView.h"
#import "StudentRatingTableViewCell.h"
#import "StudentRatingTableHeader.h"
#import "SectionHeaderView.h"
#import "FXPageControl/FXPageControl.h"
#import "RatingScrollView.h"

@interface StudentRatingViewController()
<
UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate,
FXPageControlDelegate
>

@property(nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) StudentRatingTableHeader *headerView;
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
	
	UISwipeGestureRecognizer *leftSwipe, *rightSwipe;
	
	leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
	[leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
	[[self view] addGestureRecognizer:leftSwipe];
	
	rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
	[rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
	[[self view] addGestureRecognizer:rightSwipe];
	
	self.tableView.tableFooterView = [UIView new];
	self.tableView.separatorInset = UIEdgeInsetsZero;
	[self.tableView registerNib:[UINib nibWithNibName:@"StudentRatingTableViewCell" bundle:nil] forCellReuseIdentifier:@"nibCell"];
	
	[[self fetchedResultsController] performFetch:nil];
	[_tableView reloadData];
	
	[RatingItem requestByStudent:self.semester withHandler:^(NSArray *dataList) {
		ratingTableView.dataSource = dataList;
	}];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)sender {
	
	self.headerView.pageControl.currentPage--;
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)sender {
	
	self.headerView.pageControl.currentPage++;
}

- (void)pageControl:(FXPageControl *)pageControl changedCurrentPage:(NSInteger)currentPage {
	
	[self.tableView.visibleCells each:^(StudentRatingTableViewCell *cell) {
		[cell scroll:currentPage];
	}];
	
	self.headerView.title.text = @[@"1 модуль", @"2 модуль", @"3 модуль", @"Сумма", @"Экзамен", @"Всего"][currentPage];
}

- (void)configureCell:(StudentRatingTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RatingItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.titleText.text = [NSString stringWithFormat:@"%@ ", item.subject.name];
	cell.numbers = @[item.firstAttestation, item.secondAttestation, item.thirdAttestation, item.sum, item.exam, item.total];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	StudentRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nibCell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	StudentRatingTableHeader *view = @"StudentRatingTableHeader".xibView;
	self.headerView = view;
	self.headerView.backgroundColor = @(0xE0E0E0).rgbColor;
	view.pageControl.numberOfPages = 6;
	view.pageControl.delegate = self;
	view.pageControl.currentPage = 5;
	view.pageControl.dotSpacing = 5;
	view.pageControl.dotSize = 4;
	view.pageControl.dotColor = @(0xC2C1BF).rgbColor;
	view.pageControl.selectedDotColor = @(0x9B9A99).rgbColor;
	view.pageControl.backgroundColor = [UIColor clearColor];

	return view;
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
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

- (NSFetchedResultsController *)fetchedResultsController {
	
	if (!_fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"RatingItem"inManagedObjectContext:NSManagedObjectContext.defaultContext];
		
		[fetchRequest setEntity:entity];
		fetchRequest.sortDescriptors = @[@"total".descending];
		
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"semester.semesterId = %@", self.semester.semesterId ];
		
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
