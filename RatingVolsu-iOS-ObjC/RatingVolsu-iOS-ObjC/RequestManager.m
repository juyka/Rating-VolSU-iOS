//
//  RequestManager.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 11.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking/AFNetworking.h"
#import "NSManagedObject+Extensions.h"

@import Foundation;

@implementation RequestManager

NSString *baseURLString = @"http://umka.volsu.ru/newumka3/viewdoc/service_selector/";
NSURL *baseURL;

+ (instancetype)manager {
	
	static RequestManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		manager = [[self alloc] init];
		baseURL = [NSURL URLWithString:baseURLString];
	});
	
	return manager;
}

- (NSURLSessionDataTask *)request:(NSString *)urlString parameters:(NSDictionary *)parameters
	  withBlock:(RequestHandler)handler
	 errorBlock:(void (^)())errorHandler {
	
	AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
	
	sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	sessionManager.responseSerializer.stringEncoding = 4;
	
	NSURLSessionDataTask *task;
	
	task = [sessionManager POST:urlString
			  parameters:parameters
				 success:^(NSURLSessionDataTask *task, id responseObject) {
					 
					 if ([responseObject isKindOfClass:NSArray.class]) {
						 
						 NSArray *entries = responseObject;
						 handler(entries);
					 }
					 else
						 if ([responseObject isKindOfClass:NSDictionary.class]) {
							 
							 NSArray *entries = @[responseObject];
							 handler(entries);
						 }
					 else
					 {
						 if (errorHandler) {
							 errorHandler();
						 }
					 }
					 
				 }
				 failure:^(NSURLSessionDataTask *task, NSError *error) {
					 if (errorHandler) {
						 errorHandler();
					 }
					 else {
						 
						 [[[UIAlertView alloc] initWithTitle:@"Ошибка подключения к серверу"
												 message:[error localizedDescription]
												delegate:nil
									   cancelButtonTitle:@"Ok"
									   otherButtonTitles:nil] show];
					 }
				 }];
	return task;
	
}

- (void)facultsWithHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler {
	
	NSDictionary *parameters = @{ @"get_lists": @"0"};
	NSString *url = @"facult_req.php";
	
	[self request:url parameters:parameters withBlock:^(NSArray *entries){
		[Faculty createArray:entries];
		[CoreDataManager.sharedManager saveContext];
		if (handler) {
			handler(entries);
		}
	} errorBlock:errorHandler];
}

- (void)groups:(NSString *)facultId withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{ @"fak_id": facultId};
	NSString *url = @"group_req.php";
	
	[self request:url parameters:parameters withBlock:^(NSArray *entries){
		handler([Group createArray:entries]);
	} errorBlock:nil];
	
}


- (void)students:(NSString *)groupId withHandler:(RequestHandler)handler {
	
	NSDictionary *parameters = @{ @"group_id": groupId};
	NSString *url = @"student_req.php";
	
	[self request:url parameters:parameters withBlock:^(NSArray *entries){
		handler([Student createArray:entries]);
	} errorBlock:nil];
}



@end
