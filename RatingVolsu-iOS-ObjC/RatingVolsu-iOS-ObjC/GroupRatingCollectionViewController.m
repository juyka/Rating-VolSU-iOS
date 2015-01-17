//
//  GroupRatingCollectionViewController.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingCollectionViewController.h"
#import "SubjectCollectionViewCell.h"
#import "RatingItem+Mappings.h"

@interface GroupRatingCollectionViewController()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GroupRatingCollectionViewController {
	
	NSArray *dataSource;
	CGPoint contentOffset;
	CGFloat cellWidth;
	CGFloat maxHeight;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	cellWidth = 270;
	
	[self addData];
	[self groupRequest];

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
	
	
	NSArray * heights = [dataSource map:^id(Subject *subject) {
		CGFloat height = [subject.name boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX)
										  options:NSStringDrawingUsesLineFragmentOrigin
									   attributes:[self labelAttributes]
										  context:nil].size.height;
		return @(height);
	}];
	
	maxHeight = [[heights valueForKeyPath:@"@max.floatValue"] floatValue];
	
	[self.collectionView reloadData];
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
	 
	 

- (void)groupRequest {
	
	[RatingItem requestByGroup:self.semester withHandler:^(NSArray *dataList) {
		[self addData];
	}];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	SubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
	Subject *subject = dataSource[indexPath.row];
	
	cell.controller.semester = self.semester;
	cell.controller.subject = subject;
	cell.controller.delegateObject = self;
	cell.controller.headerHeight = maxHeight;
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
	
	return dataSource.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	
	CGFloat inset = (collectionView.frame.size.width - cellWidth) / 2;
	return UIEdgeInsetsMake(10, inset, 10, inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat height = collectionView.frame.size.height - 20;
	CGFloat width = cellWidth;
	
	return CGSizeMake(width, height);
}


@end
