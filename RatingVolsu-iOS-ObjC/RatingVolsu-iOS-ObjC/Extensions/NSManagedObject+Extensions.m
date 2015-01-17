//
//  NSManagedObject+CustomActiveRecord.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 15.10.14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "NSManagedObject+Extensions.h"
#import "ObjectiveRecord.h"


#define UNDEFINED_EXCEPTION() @throw [NSException exceptionWithName:NSStringWithFormat(@"%@ undefined in %@", NSStringFromSelector(_cmd), self.class) \
										reason:NSStringWithFormat(@"You need to override %s", __PRETTY_FUNCTION__) \
										userInfo:nil]


@implementation NSManagedObject (Extensions)

+ (id)createArray:(NSArray *)entries {
	
	return [entries map:^id(id object) {
		
		return [self findByPrymaryKeyOrCreate:object];
	}];
}

+ (instancetype)findByPrymaryKeyOrCreate:(NSDictionary *)properties {
	
	NSManagedObject *object = nil;
	NSString *primaryKey = self.primaryKey;
	
	NSString *remoteKey = [self.mappings keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
		return *stop = [primaryKey isEqualToString:obj];
	}].anyObject ?: primaryKey;
	
	id value = properties[remoteKey];
	
	if (remoteKey && value) {
		
		object = [self findOrCreate:@{remoteKey: value}];
		[object update:properties];
	}
	
	return object;
}

+ (Class)childEntity {
	
	UNDEFINED_EXCEPTION();
}

+ (NSString *)descriptionKey {
	
	UNDEFINED_EXCEPTION();
}

+ (void)request:(NSNumber *)parameter withHandler:(RequestHandler)handler errorBlock:(void (^)())errorHandler
{
	
}

+ (NSString *)cellId {
	
	UNDEFINED_EXCEPTION();
}

@end
