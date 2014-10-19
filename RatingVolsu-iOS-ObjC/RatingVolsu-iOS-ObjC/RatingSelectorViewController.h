//
//  ViewController.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 10.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

@import UIKit;

@interface RatingSelectorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) Class entityClass;
@property (nonatomic) NSNumber *parentId;

@end

