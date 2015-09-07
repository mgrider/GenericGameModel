//
//  GGM_UIView+Hexagons.m
//  GGM-Example
//
//  Created by Martin Grider on 9/7/15.
//  Copyright (c) 2015 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView+Hexagons.h"


@implementation GGM_UIView (Hexagons)


- (CGPoint)hexCoordinatePointForPixelPoint:(CGPoint)pixelPoint
{
	// this breaks down on the corners, unfortunately, but it's a pretty decent approximation
	int y = pixelPoint.y / (self.frame.size.height / self.game.gridHeight);
	int pixelXOffset = (y % 2 == 0) ? self.hexPixelMultiplierWidth : 0.0f;
	int x = (pixelPoint.x - pixelXOffset) / self.gridPixelWidth;
	return CGPointMake(x, y);
}

- (CGPoint)hexPixelPointForX:(int)x andY:(int)y
{
	CGPoint point;
	float pixelXOffset = (y % 2 == 0) ? self.hexPixelMultiplierWidth : 0.0f;
	point.y = (self.hexPixelMultiplierHeight * 3.0f) * y;
	point.x = ((self.hexPixelMultiplierWidth * 2.0f) * x) + pixelXOffset;
	return point;
}


#pragma mark - setup

- (void)setupPixelSizesHexGrid
{
	int numberOfFourths = (self.game.gridHeight * 3) + 1;
	float fourthHeight = self.frame.size.height / numberOfFourths;
	self.hexPixelMultiplierHeight = fourthHeight;
	self.gridPixelHeight = (self.hexPixelMultiplierHeight * 4.0f) - 1.0f;

	int numberOfHalves = (self.game.gridWidth * 2) + 1;
	self.hexPixelMultiplierWidth = self.frame.size.width / numberOfHalves;
	self.gridPixelWidth = (self.hexPixelMultiplierWidth * 2.0f) - 1.0f;
}

@end
