//
//  GGM_UIView+Triangles.m
//  GGM-Example
//
//  Created by Martin Grider on 5/20/15.
//  Copyright (c) 2015 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView+Triangles.h"


static NSString * const kAX = @"kax";
static NSString * const kAY = @"kay";
static NSString * const kBX = @"kbx";
static NSString * const kBY = @"kby";
static NSString * const kCX = @"kcx";
static NSString * const kCY = @"kcy";


@implementation GGM_UIView (Triangles)


#pragma mark - setup

- (void)setupGridViewArrayForTriangles
{
	// deliberately do not call super here

	if (self.allowIrregularTriangles)
	{
		self.gridPixelWidth = (self.frame.size.width / (self.game.gridWidth + 1)) * 2.0f;
		self.gridPixelHeight =  self.frame.size.height / self.game.gridHeight;
	}
	else
	{
		self.gridPixelWidth = (self.frame.size.width / (self.game.gridWidth + 1)) * 2.0f;
		self.gridPixelHeight =  sqrt(3) / 2 * self.gridPixelWidth;

		// if we are taller than wide, do this instead
		if ((self.gridPixelHeight * self.game.gridHeight) > self.frame.size.height)
		{
			self.gridPixelHeight = self.frame.size.height / self.game.gridHeight;
			self.gridPixelWidth = self.gridPixelHeight * 1.1547;
		}
	}

	[self setupTriangleCoordinates];
}

- (void)setupTriangleCoordinates
{
	NSMutableArray *yArray = [NSMutableArray arrayWithCapacity:self.game.gridHeight];
	NSMutableArray *xArray = [NSMutableArray arrayWithCapacity:self.game.gridWidth];

	// if pointsUp, ax,ay is the top point
	// if not points up, ax,ay is the upper-left point
	// a,b,c proceeds clockwise
	BOOL pointsUp;
	float topXOffset, bottomXOffset;
	float halfX = self.gridPixelWidth / 2.0f;
	float ax = 0, ay = 0, bx = 0, by = 0, cx = 0, cy = 0;
	for (int y = 0; y < self.game.gridHeight; y++)
	{
		if ( y % 2 == 0 )
		{
			NSLog(@"top = halfX, y=%i", y);
			topXOffset = halfX;
			bottomXOffset = 0.0f;
		}
		else
		{
			NSLog(@"bottom = halfX, y=%i", y);
			topXOffset = 0.0f;
			bottomXOffset = halfX;
		}
		for (int x = 0; x < self.game.gridWidth; x++)
		{
			pointsUp = [self trianglePointsUpForX:x andY:y];
			if (x == 0)
			{
				if (pointsUp)
				{
					ax = topXOffset;
					ay = self.gridPixelHeight * y;
					bx = bottomXOffset + self.gridPixelWidth;
					by = self.gridPixelHeight * (y + 1);
					cx = bottomXOffset;
					cy = self.gridPixelHeight * (y + 1);
				}
				else
				{
					ax = topXOffset;
					ay = self.gridPixelHeight * y;
					bx = topXOffset + self.gridPixelWidth;
					by = self.gridPixelHeight * y;
					cx = bottomXOffset;
					cy = self.gridPixelHeight * (y + 1);
				}
			}
			else if (pointsUp)
			{
				ax = bx;
				ay = by;
				bx = cx + self.gridPixelWidth;
				by = cy;
				cx = cx;
				cy = cy;
			}
			else if ( ! pointsUp)
			{
				//ax; these should be the same
				//ay;
				cx = bx;
				cy = by;
				bx = ax + self.gridPixelWidth;
				by = ay;
			}
			[xArray addObject:@{
								kAX: @(ax),
								kAY: @(ay),
								kBX: @(bx),
								kBY: @(by),
								kCX: @(cx),
								kCY: @(cy),
								}];
		}
		[yArray addObject:[NSArray arrayWithArray:xArray]];
		xArray = [NSMutableArray arrayWithCapacity:self.game.gridWidth];
	}
	self.triangleCoordinates = [NSArray arrayWithArray:yArray];
}

- (BOOL)trianglePointsUpForX:(int)x andY:(int)y
{
	return ((y % 2 == 0) && (x % 2 == 0)) || ((y % 2 != 0) && (x % 2 != 0));
}

- (GGM_Direction)triangleDirectionForX:(int)x andY:(int)y
{
	BOOL pointsUp = [self trianglePointsUpForX:x andY:y];
	return (pointsUp) ? GGM_DIRECTION_UP : GGM_DIRECTION_DOWN;
}

- (CGPoint)triangleXYPointForPixelPoint:(CGPoint)pixelPoint
{
	int y = pixelPoint.y / self.gridPixelHeight;
	if (y >= self.game.gridHeight)
	{
		return CGPointMake(-1, -1);
	}
	for (int x = 0; x < self.game.gridWidth; x++)
	{
		if ([self pixelPoint:pixelPoint isInsideX:x andY:y])
		{
			return CGPointMake(x, y);
		}
	}
	return CGPointMake(-1, -1);
}

- (float)signForPoint1:(CGPoint)p1 point2:(CGPoint)p2 andPoint3:(CGPoint)p3
{
	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

//bool PointInTriangle (fPoint pt, fPoint v1, fPoint v2, fPoint v3)
//{
//	bool b1, b2, b3;
//
//	b1 = sign(pt, v1, v2) < 0.0f;
//	b2 = sign(pt, v2, v3) < 0.0f;
//	b3 = sign(pt, v3, v1) < 0.0f;
//
//	return ((b1 == b2) && (b2 == b3));
//}

- (BOOL)pixelPoint:(CGPoint)point isInsideX:(int)x andY:(int)y
{
	CGPoint a, b, c;
	NSDictionary *coords = [[self.triangleCoordinates objectAtIndex:y] objectAtIndex:x];
	a.x = [coords[kAX] floatValue];
	a.y = [coords[kAY] floatValue];
	b.x = [coords[kBX] floatValue];
	b.y = [coords[kBY] floatValue];
	c.x = [coords[kCX] floatValue];
	c.y = [coords[kCY] floatValue];

	BOOL b1, b2, b3;
	b1 = [self signForPoint1:point point2:a andPoint3:b] < 0.0f;
	b2 = [self signForPoint1:point point2:b andPoint3:c] < 0.0f;
	b3 = [self signForPoint1:point point2:c andPoint3:a] < 0.0f;
	BOOL is = ((b1 == b2) && (b2 == b3));
	return is;

	// other way
//	float A = 1/2 * (-b.y * c.x + a.y * (-b.x + c.x) + a.x * (b.y - c.y) + b.x * c.y);
//	int sign = A < 0 ? -1 : 1;
//	float s = (a.y * c.x - a.x * c.y + (c.y - a.y) * point.x + (a.x - c.x) * point.y) * sign;
//	float t = (a.x * b.y - a.y * b.x + (a.y - b.y) * point.x + (b.x - a.x) * point.y) * sign;
//	BOOL is = (s > 0 && t > 0 && (1- s - t) > 0);
//	return is;
}

- (CGRect)triangleContainingRectForX:(int)x andY:(int)y
{
	BOOL pointsUp = [self trianglePointsUpForX:x andY:y];
	NSDictionary *c = [[self.triangleCoordinates objectAtIndex:y] objectAtIndex:x];
	if (pointsUp) {
		return CGRectMake([c[kCX] floatValue], [c[kAY] floatValue], self.gridPixelWidth, self.gridPixelHeight);
	}
	else {
		return CGRectMake([c[kAX] floatValue], [c[kAY] floatValue], self.gridPixelWidth, self.gridPixelHeight);
	}
}


@end
