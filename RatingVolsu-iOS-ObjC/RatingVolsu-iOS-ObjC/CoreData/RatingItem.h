//
//  RatingItem.h
//  Pods
//
//  Created by Настя on 14/12/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Semester, Subject;

@interface RatingItem : NSManagedObject

@property (nonatomic, retain) NSNumber * exam;
@property (nonatomic, retain) NSNumber * firstAttestation;
@property (nonatomic, retain) NSString * ratingItemId;
@property (nonatomic, retain) NSNumber * secondAttestation;
@property (nonatomic, retain) NSNumber * sum;
@property (nonatomic, retain) NSNumber * thirdAttestation;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) Semester *semester;
@property (nonatomic, retain) Subject *subject;

@end
