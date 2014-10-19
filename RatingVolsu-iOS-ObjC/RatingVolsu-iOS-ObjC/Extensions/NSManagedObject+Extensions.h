//
//  NSManagedObject+CustomActiveRecord.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 15.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^RequestHandler)(NSArray *dataList);

@interface NSManagedObject (CustomActiveRecord)

+ (id)createArray:(NSArray *)entries;
+ (instancetype)findByPrymaryKeyOrCreate:(NSDictionary *)properties;
+ (Class)childEntity;
+ (NSString *)descriptionKey;
+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler;
+ (NSString *)cellId;
@end
