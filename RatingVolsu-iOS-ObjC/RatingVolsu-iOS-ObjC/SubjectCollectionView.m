//
//  SubjectCollectionView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "SubjectCollectionView.h"
#import "CollectionViewFlowLayout.h"

@interface SubjectCollectionView()

@end

@implementation SubjectCollectionView

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	if (self.cycledPaging) {
		
		CollectionViewFlowLayout *layout = (CollectionViewFlowLayout *) self.collectionViewLayout;
		NSInteger numberOfItems = [self numberOfItemsInSection:0] / 3;
		CGFloat sectionWidth = (layout.itemSize.width + layout.minimumInteritemSpacing) * numberOfItems;
		CGFloat distanceFromCenterX = self.contentOffset.x + self.bounds.size.width / 2 - self.contentSize.width / 2;
		
		if (fabsf(distanceFromCenterX) > sectionWidth / 2) {
			
			CGFloat targetOffset = self.contentOffset.x;
			if (distanceFromCenterX > 0) {
				targetOffset -= sectionWidth;
			} else {
				targetOffset += sectionWidth;
			}
			self.contentOffset = CGPointMake(targetOffset, 0);
		}
	}
}

@end
