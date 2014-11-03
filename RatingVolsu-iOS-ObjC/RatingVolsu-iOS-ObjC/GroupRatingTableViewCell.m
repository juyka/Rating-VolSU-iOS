//
//  GroupRatingTableViewCell.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 03/11/14.
//  Copyright (c) 2014 VolSU. All rights reserved.
//

#import "GroupRatingTableViewCell.h"

@implementation GroupRatingTableViewCell {
	
	UILabel *_label;
}

+ (NSDictionary *)labelAttributes {
	
	NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
	style.alignment = NSTextAlignmentCenter;
	style.lineBreakMode = NSLineBreakByWordWrapping;
	
	return @{
			 NSParagraphStyleAttributeName: style,
			 NSFontAttributeName: [UIFont systemFontOfSize:UIFont.systemFontSize]
			 };
}

- (instancetype)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		
		NSDictionary *attributes = [self.class labelAttributes];
		
		_label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8, 0)];
		_label.font = attributes[NSFontAttributeName];
		_label.backgroundColor = [UIColor clearColor];
		_label.textAlignment = [attributes[NSParagraphStyleAttributeName] alignment];
		_label.numberOfLines = 0;
		_label.lineBreakMode = [attributes[NSParagraphStyleAttributeName] lineBreakMode];
		[self addSubview:_label];
		
		self.autoresizingMask = UIViewAutoresizingNone;
	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	
	[super setFrame:frame];
}

- (void)setValue:(NSString *)value {
	
	_label.text = value;
}

- (NSString *)value {
	
	return _label.text;
}

@end
