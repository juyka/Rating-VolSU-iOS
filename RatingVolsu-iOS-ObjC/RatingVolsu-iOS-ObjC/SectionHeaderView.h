//
//  SectionHeaderView.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;

+ (instancetype)headerForSection:(NSInteger)section;

@end
