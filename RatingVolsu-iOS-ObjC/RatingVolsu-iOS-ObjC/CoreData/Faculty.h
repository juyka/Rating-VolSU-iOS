//
//  Faculty.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 02/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group;

@interface Faculty : NSManagedObject

@property (nonatomic, retain) NSNumber * facultyId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *groups;
@end

@interface Faculty (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

@end
