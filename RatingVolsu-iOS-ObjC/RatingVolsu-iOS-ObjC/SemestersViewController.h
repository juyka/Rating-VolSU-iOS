//
//  SemestersViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 16.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingObjectProtocol.h"

@interface SemestersViewController : UIViewController

@property (nonatomic) Student *student;
@property (nonatomic, readonly) RecentItem *selectedItem;

@end
