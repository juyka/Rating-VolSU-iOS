//
//  RequestManager.h
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestHandler)(NSArray *dataList);

@interface RequestManager : NSObject

+ (instancetype)manager;

- (void)request:(NSString *)urlString parameters:(NSDictionary *)parameters withBlock:(RequestHandler)handler  errorBlock:(void (^)())errorHandler;
- (void)facultsWithHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler;
- (void)groups:(NSString *)facultId withHandler:(RequestHandler)handler;
- (void)students:(NSString *)groupId withHandler:(RequestHandler)handler;

@end
