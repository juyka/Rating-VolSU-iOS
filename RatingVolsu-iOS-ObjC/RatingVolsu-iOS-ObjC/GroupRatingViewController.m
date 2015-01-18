//
//  GroupRatingCollectionViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingViewController.h"
#import "SubjectCollectionViewCell.h"
#import "SubjectCollectionView.h"
#import "RatingItem+Mappings.h"
#import "CollectionViewFlowLayout.h"
#import "FXPageControl/FXPageControl.h"

@interface GroupRatingViewController()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
FXPageControlDelegate
>

@property (weak, nonatomic) IBOutlet SubjectCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;

@end

@implementation GroupRatingViewController {
	
	NSArray *dataSource;
	CGPoint contentOffset;
	CGFloat cellWidth;
	CGFloat maxHeight;
	CGFloat inset;
	BOOL scrolled;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	cellWidth = self.collectionView.frame.size.width * 0.7;
	CollectionViewFlowLayout *layout = (CollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	[layout setContentSize:CGSizeMake(cellWidth, self.collectionView.frame.size.height - 10)];
	
	inset = (self.collectionView.frame.size.width - cellWidth) / 2;
	[self addData];
	[self groupRequest];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGFloat contentOffsetX = scrollView.contentOffset.x;
	
	scrolled = YES;
	self.pageControl.currentPage = ((NSInteger)round(contentOffsetX /(cellWidth + 10)) % dataSource.count);
}

- (void)pageControl:(FXPageControl *)pageControl changedCurrentPage:(NSInteger)currentPage {
	
	if (!scrolled) {
		NSInteger page = ((NSInteger)round(self.collectionView.contentOffset.x /(cellWidth + 10)) % dataSource.count);
		NSInteger pageCount;
		
		if (page == dataSource.count - 1 && currentPage == 0) {
			pageCount = 1;
		} else if (page == 0 && currentPage == dataSource.count - 1) {
			pageCount = -1;
		} else
			pageCount = currentPage - page;
		
		CGFloat offsetX = self.collectionView.contentOffset.x + pageCount * (cellWidth + 10);
		[self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
	}
	scrolled = NO;
	Subject *item = dataSource[currentPage];
	self.subjectName.text = [NSString stringWithFormat:@"%@ %@", item.name, item.type ? @"экзамен": @"зачет"];
}

- (void)addData {
	
	NSArray *items = [RatingItem where:@{@"semester.student.group.groupId" : self.semester.student.group.groupId,
										  @"semester.number" : self.semester.number}];
	
	dataSource = [items valueForKeyPath:@"@distinctUnionOfObjects.subject"];
	
	dataSource = [dataSource sortedArrayUsingComparator:^NSComparisonResult(Subject *s1, Subject *s2){
		NSNumber *count1 = [[items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"subject.subjectId == %@", s1.subjectId]] valueForKeyPath:@"@count"];
		NSNumber *count2 = [[items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"subject.subjectId == %@", s2.subjectId]] valueForKeyPath:@"@count"];
		
		return [count2 compare:count1];
	}];
	
	self.pageControl.numberOfPages = dataSource.count;
	self.pageControl.delegate = self;
	self.pageControl.dotSpacing = 5;
	self.pageControl.dotSize = 4;
	self.pageControl.dotColor = @(0xC2C1BF).rgbColor;
	self.pageControl.selectedDotColor = @(0x9B9A99).rgbColor;
	self.pageControl.backgroundColor = [UIColor clearColor];
	
	Subject *item = dataSource[self.pageControl.currentPage];
	self.subjectName.text = [NSString stringWithFormat:@"%@ %@", item.name, item.type ? @"экзамен": @"зачет"];
	
	self.collectionView.cycledPaging = dataSource.count > 1;
	
	[self.collectionView reloadData];
}
	 

- (void)groupRequest {
	
	[RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
		[self addData];
	}];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger path = indexPath.row % dataSource.count;
	SubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
	Subject *subject = dataSource[path];
	
	cell.controller.subject = subject;
	cell.controller.semester = self.semester;
	cell.controller.delegateObject = self;
	cell.controller.tableView.contentOffset = contentOffset;
	[cell.controller reloadData];
	
	return cell;
	
}


- (void)scroll:(CGPoint)offset {
	
	contentOffset = offset;
	
	[self.collectionView.visibleCells each:^(SubjectCollectionViewCell *cell) {
		cell.controller.tableView.contentOffset = contentOffset;
	}];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return self.collectionView.cycledPaging ? dataSource.count * 3 : dataSource.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	
	return UIEdgeInsetsMake(0, inset, 0, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat height = collectionView.frame.size.height;
	CGFloat width = cellWidth;
	
	return CGSizeMake(width, height);
}


@end
