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
#import "NSNumber+Extensions.h"

@interface GroupRatingViewController()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
FXPageControlDelegate
>

@property (weak, nonatomic) IBOutlet SubjectCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *subjectType;
@property (nonatomic) NSArray *dataSource;
@end

@implementation GroupRatingViewController {
	
	CGPoint contentOffset;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.pageControl.backgroundColor = [UIColor clearColor];
	[self addData];
	
}

- (void)viewDidLayoutSubviews {
	
	self.collectionView.collectionViewLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width * 0.6, self.collectionView.frame.size.height - 20);
}

- (void)setPageControl:(FXPageControl *)pageControl {
	
	_pageControl = pageControl;
	self.pageControl.dotSpacing = 5;
	self.pageControl.dotSize = 4;
	self.pageControl.dotColor = @(0xC2C1BF).rgbColor;
	self.pageControl.selectedDotColor = @(0x9B9A99).rgbColor;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGFloat contentOffsetX = scrollView.contentOffset.x;
	CGFloat width = self.collectionView.collectionViewLayout.itemSize.width;
	
	self.pageControl.currentPage = ((NSInteger)round(contentOffsetX /(width + 10)) % self.dataSource.count);
	
	Subject *subject = self.dataSource[self.pageControl.currentPage];
	self.subjectName.text = subject.name;
	self.subjectType.text = subject.type.subjectType;
}

- (void)addData {
	
	Subject *currentSubject = self.dataSource[self.pageControl.currentPage];
	
	NSArray *items = [RatingItem where:@{@"semester.student.group.groupId" : self.semester.student.group.groupId,
										 @"semester.number" : self.semester.number}];
	
	RatingItem *ratingItem = [items find:^BOOL(RatingItem *object) {
		return (![object.semester.place isEqualToNumber:@(0)]);
	}];
	self.dataSource = (ratingItem) ? [items valueForKeyPath:@"@distinctUnionOfObjects.subject"] : nil;
	
	if (self.dataSource) {
		
		self.dataSource = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(Subject *s1, Subject *s2){
			NSNumber *count1 = [[items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"subject.subjectId == %@", s1.subjectId]] valueForKeyPath:@"@sum.total.intValue"];
			NSNumber *count2 = [[items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"subject.subjectId == %@", s2.subjectId]] valueForKeyPath:@"@sum.total.intValue"];
			
			return [count2 compare:count1];
		}];
		
		self.collectionView.cycledPaging = self.dataSource.count > 1;
		self.pageControl.numberOfPages = self.dataSource.count;
		NSInteger index = [self.dataSource containsObject:currentSubject] ? [self.dataSource indexOfObject:currentSubject] : 0;
		
		self.pageControl.currentPage = index;
		self.collectionView.contentOffset = CGPointMake(index * (self.collectionView.collectionViewLayout.itemSize.width + self.collectionView.collectionViewLayout.minimumInteritemSpacing) + self.collectionView.contentInset.left, 0);
		
		Subject *item = self.dataSource[self.pageControl.currentPage];
		self.subjectName.text = item.name;
		self.subjectType.text = item.type.subjectType;
		
		[self.collectionView reloadData];
	}
}


- (NSURLSessionDataTask *)groupRequest:(void (^)())handler  {
	
	NSURLSessionDataTask *task;
	
	task = [RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
		handler();
		[self addData];
	}
						   errorBlock:^{
							   handler();
						   }];
	
	return task;
}

- (NSURLSessionDataTask *)refresh:(void (^)())handler {
	
	return [self groupRequest:handler];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger path = indexPath.row % self.dataSource.count;
	SubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
	Subject *subject = self.dataSource[path];
	
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
	
	return self.collectionView.cycledPaging ? self.dataSource.count * 3 : self.dataSource.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	
	CGFloat cellWidth = self.collectionView.collectionViewLayout.itemSize.width;
	CGFloat frameWidth = self.collectionView.frame.size.width;
	
	CGFloat inset = (frameWidth - cellWidth) / 2;
	
	return UIEdgeInsetsMake(0, inset, 0, 0);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//	CGFloat height = self.collectionView.collectionViewLayout.itemSize.height;
//	CGFloat width = self.collectionView.collectionViewLayout.itemSize.width;
//
//	return CGSizeMake(width, height);
//}


@end
