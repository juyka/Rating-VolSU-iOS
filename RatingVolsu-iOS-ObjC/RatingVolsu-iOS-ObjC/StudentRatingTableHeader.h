//
//  StudentRatingTableHeader.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 13/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXPageControl;

@interface StudentRatingTableHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControl;

@end
