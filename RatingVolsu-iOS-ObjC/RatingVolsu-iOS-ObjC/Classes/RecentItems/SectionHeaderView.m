//
//  SectionHeaderView.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

+ (instancetype)headerForSection:(NSInteger)section  {
	
	SectionHeaderView *view = @"SectionHeaderView".xibView;
	
	view.label.text = [@[@"последнее", @"избранное"][section] uppercaseString];
	
	return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
