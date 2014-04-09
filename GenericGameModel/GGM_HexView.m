//
//  GGM_HexView.m
//  Ketchup
//
//  Created by Martin Grider on 12/29/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_HexView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GGM_HexView


#pragma mark - property setting

- (void)setHexColor:(UIColor *)hexColor
{
	_hexColor = hexColor;
	[self setBackgroundColor:[UIColor clearColor]];
	[self setNeedsDisplay];
}


#pragma mark - drawing

- (void)drawRect:(CGRect)rect
{
	CGRect frame = self.frame;

	//	NSLog(@"in drawRect... self.frame is %@", NSStringFromCGRect(frame));
	//	CGContextRef context = UIGraphicsGetCurrentContext();

	UIBezierPath *polyPath = [UIBezierPath bezierPath];
	[polyPath setLineWidth:0.0f];

	//// Shadow Declarations
	//	UIColor* shadow = [UIColor blackColor];
	//	CGSize shadowOffset = CGSizeMake(0.1, -0.1);
	CGFloat shadowBlurRadius;

	if (_verticalPoints) {
		shadowBlurRadius = frame.size.height / 10.0f;
		float centerX = (frame.size.width/2.0f);
		float firstThirdY = (frame.size.height/4.0f);
		float secondThirdY = ((frame.size.height/4.0f)*3.0f);
		[polyPath moveToPoint:CGPointMake(centerX, 0.0f)];
		[polyPath addLineToPoint:CGPointMake(frame.size.width, firstThirdY)];
		[polyPath addLineToPoint:CGPointMake(frame.size.width, secondThirdY)];
		[polyPath addLineToPoint:CGPointMake(centerX, frame.size.height)];
		[polyPath addLineToPoint:CGPointMake(0.0f, secondThirdY)];
		[polyPath addLineToPoint:CGPointMake(0.0f, firstThirdY)];
		[polyPath addLineToPoint:CGPointMake(centerX, 0.0f)];
	}
	else {
		shadowBlurRadius = frame.size.width / 10.0f;
		float centerY = (frame.size.height/2.0f);
		float firstThirdX = (frame.size.width/4.0f);
		float secondThirdX = ((frame.size.width/4.0f)*3.0f);
		[polyPath moveToPoint:CGPointMake(0.0f, centerY)];
		[polyPath addLineToPoint:CGPointMake(firstThirdX, 0.0f)];
		[polyPath addLineToPoint:CGPointMake(secondThirdX, 0.0f)];
		[polyPath addLineToPoint:CGPointMake(frame.size.width, centerY)];
		[polyPath addLineToPoint:CGPointMake(secondThirdX, self.frame.size.height)];
		[polyPath addLineToPoint:CGPointMake(firstThirdX, self.frame.size.height)];
		[polyPath addLineToPoint:CGPointMake(0.0f, centerY)];
	}

	[polyPath closePath];

	//	CGContextSaveGState(context);
	//	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);

	[_hexColor setFill];
	[polyPath fill];

	//	CGContextRestoreGState(context);
}


#pragma mark - init

- (void)setup
{
	// Initialization code
	_hexColor = [UIColor blackColor];
	_verticalPoints = YES;
	self.backgroundColor = [UIColor clearColor];
	[self setClipsToBounds:NO];
}

- (void)awakeFromNib
{
	[self setup];
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}


@end
