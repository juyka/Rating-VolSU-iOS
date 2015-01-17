//
//  StudentRatingLandscapeTableViewCell.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 17/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "StudentRatingLandscapeTableViewCell.h"
@interface StudentRatingLandscapeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *firstA;
@property (weak, nonatomic) IBOutlet UILabel *secondA;
@property (weak, nonatomic) IBOutlet UILabel *thirdA;
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *exam;
@property (weak, nonatomic) IBOutlet UILabel *total;

@end

@implementation StudentRatingLandscapeTableViewCell

//- (id)initWithCoder:(NSCoder *)aDecoder {
//	
//	self = [super initWithCoder:aDecoder];
//	if (self) {
//		
//		
//	}
//	
//	return self;
//}

-(void)setNumbers:(NSArray *)numbers {
	
	NSArray *labels = @[_firstA, _secondA, _thirdA, _sum, _exam, _total];
	_numbers = numbers;
	[labels eachWithIndex:^(UILabel *label, NSUInteger index) {
		label.text = [NSString stringWithFormat:@"%@", numbers[index]];
	}];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
