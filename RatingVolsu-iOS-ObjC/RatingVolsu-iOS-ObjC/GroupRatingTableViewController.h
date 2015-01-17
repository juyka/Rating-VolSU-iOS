//
//  GroupRatingTableViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11/12/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupRatingTableViewController : UIViewController

@property(nonatomic) Semester *semester;
@property(nonatomic) Subject *subject;
@property(nonatomic) CGFloat headerHeight;
@property(nonatomic) id delegateObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)reloadData;

@end
