//
//  GroupRatingTableViewCell.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupRatingTableViewCell : UIView

@property (nonatomic) NSString *value;

+ (NSDictionary *)labelAttributes;

@end
