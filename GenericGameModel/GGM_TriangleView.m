//
//  GGM_TriangleView.m
//  GGM-Example
//
//  Created by Martin Grider on 5/21/15.
//  Copyright (c) 2015 Abstract Puzzle. All rights reserved.
//

#import "GGM_TriangleView.h"


@implementation GGM_TriangleView

#pragma mark - property setting

- (void)setTriangleColor:(UIColor *)triangleColor
{
	_triangleColor = triangleColor;
	[self setBackgroundColor:[UIColor clearColor]];
	[self setNeedsDisplay];
}


#pragma mark - drawing

- (void)drawRect:(CGRect)rect
{
	float ax, ay, bx, by, cx, cy;
	switch (self.trianglePointDirection) {
		case GGM_DIRECTION_LEFT: {
			float halfHeight = self.frame.size.height / 2.0f;
			ax = 0.0f;
			ay = halfHeight;
			bx = self.frame.size.width;
			by = 0.0f;
			cx = bx;
			cy = self.frame.size.height;
			break;
		}
		case GGM_DIRECTION_RIGHT: {
			float halfHeight = self.frame.size.height / 2.0f;
			ax = 0.0f;
			ay = 0.0f;
			bx = self.frame.size.width;
			by = halfHeight;
			cx = 0.0f;
			cy = self.frame.size.height;
			break;
		}
		case GGM_DIRECTION_UP: {
			float halfWidth = self.frame.size.width / 2.0f;
			ax = halfWidth;
			ay = 0.0f;
			bx = self.frame.size.width;
			by = self.frame.size.height;
			cx = 0.0f;
			cy = self.frame.size.height;
			break;
		}
		default:
		case GGM_DIRECTION_DOWN: {
			float halfWidth = self.frame.size.width / 2.0f;
			ax = 0.0f;
			ay = 0.0f;
			bx = self.frame.size.width;
			by = 0.0f;
			cx = halfWidth;
			cy = self.frame.size.height;
			break;
		}
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextMoveToPoint(context, ax, ay);
	CGContextAddLineToPoint(context, bx, by);
	CGContextAddLineToPoint(context, cx, cy);
	CGContextClosePath(context);
	CGContextSetFillColorWithColor(context, self.triangleColor.CGColor);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
}


#pragma mark - init

- (void)setup
{
	// Initialization code
	_triangleColor = [UIColor blackColor];
	_trianglePointDirection = GGM_DIRECTION_UP;
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
