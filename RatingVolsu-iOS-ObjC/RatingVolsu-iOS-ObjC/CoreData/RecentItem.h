//
//  RecentItem.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 29/10/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface RecentItem : NSManagedObject

@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * semester;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Student *student;

@end
