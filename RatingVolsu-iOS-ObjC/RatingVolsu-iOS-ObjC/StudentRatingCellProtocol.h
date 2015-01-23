//
//  StudentRatingCellProtocol.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StudentRatingCellProtocol <NSObject>

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *subjectType;
@property (nonatomic) NSArray *numbers;

@end
