//
//  UIImage+Extensions.m
//  RatingVolsu-iOS-ObjC
//
//  Created by Настя on 14/01/15.
//  Copyright (c) 2015 VolSU. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

+ (UIImage *)cellImage:(NSString *)title {

	UIImage *image;
	UIColor *orangeColor = @(0xFF8F27).rgbColor;
	CGSize size = CGSizeMake(38, 38);
	NSMutableAttributedString *attributedTitle = title.mutableAttributedString;
	UIFont *font = @(16).ptFont;
	attributedTitle.font = font;
	attributedTitle.textColor = orangeColor;
	attributedTitle.alignment = NSTextAlignmentCenter;
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.5, 0.5, size.width - 1, size.height - 1) cornerRadius:size.width / 2];
	[orangeColor setStroke];
	path.lineWidth = 1;
	[path stroke];
	
	[attributedTitle drawInRect:CGRectMake(0, size.height / 2 - font.lineHeight / 2, size.width, size.height)];
	
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
