//
//  GGM_UIView+Hexagons.h
//  GGM-Example
//
//  Created by Martin Grider on 9/7/15.
//  Copyright (c) 2015 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView.h"


@interface GGM_UIView (Hexagons)


- (CGPoint)hexCoordinatePointForPixelPoint:(CGPoint)pixelPoint;
- (CGPoint)hexPixelPointForX:(int)x andY:(int)y;

- (void)setupPixelSizesHexGrid;


@end
