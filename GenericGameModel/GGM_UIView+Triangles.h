//
//  GGM_UIView+Triangles.h
//  GGM-Example
//
//  Created by Martin Grider on 5/20/15.
//  Copyright (c) 2015 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView.h"

#import "GGM_UIConstants.h"


@interface GGM_UIView (Triangles)


- (void)setupGridViewArrayForTriangles;
- (void)setupTriangleCoordinates;

- (BOOL)trianglePointsUpForX:(int)x andY:(int)y;
- (GGM_Direction)triangleDirectionForX:(int)x andY:(int)y;

- (CGPoint)triangleXYPointForPixelPoint:(CGPoint)pixelPoint;
- (CGRect)triangleContainingRectForX:(int)x andY:(int)y;


@end
