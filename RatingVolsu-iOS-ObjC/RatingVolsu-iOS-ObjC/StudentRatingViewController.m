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
#import "StudentRatingTableViewCell.h"
#import "StudentRatingTableHeader.h"
#import "SectionHeaderView.h"
#import "FXPageControl/FXPageControl.h"
#import "RatingScrollView.h"
#import "NSNumber+Extensions.h"
#import "StudentRatingCellProtocol.h"

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
@property (nonatomic) BOOL pageOrientationIsPortrait;
@end

@implementation StudentRatingViewController {
	
	NSInteger currentPage;
}

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
	[super viewDidLoad];
	currentPage = 5;
	UITapGestureRecognizer *tapRecognizer;
	
	tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
	[[self view] addGestureRecognizer:tapRecognizer];
	
	UISwipeGestureRecognizer *leftSwipe, *rightSwipe;
	
	leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
	[leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
	[[self view] addGestureRecognizer:leftSwipe];
	
	rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
	[rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
	[[self view] addGestureRecognizer:rightSwipe];
	
	self.tableView.tableFooterView = [UIView new];
	[self.tableView registerNib:[UINib nibWithNibName:@"StudentRatingLandscapeTableViewCell" bundle:nil] forCellReuseIdentifier:@"landscapeCell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"StudentRatingTableViewCell" bundle:nil] forCellReuseIdentifier:@"portraintCell"];
	
	[[self fetchedResultsController] performFetch:nil];
	[_tableView reloadData];
	
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)sender {
	
	currentPage = (currentPage == 0) ? 5 : currentPage - 1;
	[self changedCurrentPage];
	
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)sender {
	
	currentPage = (currentPage == 5) ? 0 : currentPage + 1;
	[self changedCurrentPage];
}

- (void)changedCurrentPage {
	
	self.headerView.pageControl.currentPage = currentPage;
	
	[self.tableView.visibleCells each:^(StudentRatingTableViewCell *cell) {
		[cell scroll:currentPage];
	}];
	
	self.headerView.title.text = @[@"1 модуль", @"2 модуль", @"3 модуль", @"Сумма", @"Экзамен", @"Всего"][currentPage];
}

- (BOOL)pageOrientationIsPortrait {
	
	return ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait);
}

- (NSURLSessionDataTask *)studentRating:(void (^)())handler  {
	
	NSURLSessionDataTask *task;
	
	task = [RatingItem requestByStudent:self.semester withHandler:^(NSArray *dataList) {
		
		handler();
	}
	errorBlock:^{
		
		handler();
	}];
	
	return task;
}

- (NSURLSessionDataTask *)refresh:(void (^)())handler {
	
	return [self studentRating:handler];
	
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
	
	if (self.pageOrientationIsPortrait) {

		CGPoint location = [recognizer locationInView:self.view];
		
		if (location.x > self.view.frame.size.width / 2) {
			currentPage = (currentPage == 5) ? 0 : currentPage + 1;
		}
		else {
			currentPage = (currentPage == 0) ? 5 : currentPage - 1;
		}
		
		[self changedCurrentPage];
	}
}

- (void)configureCell:(id<StudentRatingCellProtocol>)cell atIndexPath:(NSIndexPath *)indexPath {
	
	RatingItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.titleText.text = [NSString stringWithFormat:@"%@", item.subject.name];
	cell.subjectType.text = item.subject.type.subjectType;
	cell.numbers = @[item.firstAttestation, item.secondAttestation, item.thirdAttestation, item.sum, item.exam, item.total];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *cellId = self.pageOrientationIsPortrait ? @"portraintCell" : @"landscapeCell";
	
	UITableViewCell<StudentRatingCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	StudentRatingTableHeader *view = [StudentRatingTableHeader headerWithOrientation:self.pageOrientationIsPortrait];
	
	self.headerView = view;
	
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
	
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
		[[self navigationController] setNavigationBarHidden:!self.pageOrientationIsPortrait animated:YES];
		[self.tableView reloadData];
	}];
	
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
