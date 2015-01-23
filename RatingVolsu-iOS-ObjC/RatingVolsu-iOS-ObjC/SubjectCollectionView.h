//
//  SubjectCollectionView.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewFlowLayout.h"

@interface SubjectCollectionView : UICollectionView

@property (nonatomic) CollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic) BOOL cycledPaging;

@end
