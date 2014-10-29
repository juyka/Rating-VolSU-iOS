//
//  GroupsViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 19/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingObjectProtocol.h"

@interface GroupsViewController : UIViewController

@property(nonatomic) Faculty *faculty;
@property (nonatomic, copy) void (^callBack)(id <RatingObjectProtocol> object);

@end
