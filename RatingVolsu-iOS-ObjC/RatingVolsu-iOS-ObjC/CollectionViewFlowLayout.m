//
//  CollectionViewFlowLayout.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (void)awakeFromNib {

	self.minimumInteritemSpacing = 10.0;
	self.minimumLineSpacing = 7;
	self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
	
	CGPoint targetContentOffset;
	
	if (proposedContentOffset.x > self.collectionView.contentOffset.x) {
		proposedContentOffset.x = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.;
	}
	else if (proposedContentOffset.x < self.collectionView.contentOffset.x) {
		proposedContentOffset.x = self.collectionView.contentOffset.x - self.collectionView.bounds.size.width / 2.;
	}
	
	CGFloat offsetAdjustment = MAXFLOAT;
	CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2.;
	CGRect targetRect = CGRectMake(proposedContentOffset.x, 0., self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
	
	NSArray *attributes = [self layoutAttributesForElementsInRect:targetRect];
	for (UICollectionViewLayoutAttributes *a in attributes) {
		CGFloat itemHorizontalCenter = a.center.x;
		if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
			offsetAdjustment = itemHorizontalCenter - horizontalCenter;
		}
	}
	
	targetContentOffset = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
	
	return targetContentOffset;
}

@end
