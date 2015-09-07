//
//  GGM_UIView.h
//  puzalution
//
//  Created by Martin Grider on 8/26/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGM_BaseModel.h"
#import "GGM_UIConstants.h"


@interface GGM_UIView : UIView


@property (nonatomic) GGM_BaseModel *game;

// taps
@property (nonatomic) BOOL recognizesTaps;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

// drags
@property (nonatomic) BOOL recognizesDrags;
@property (nonatomic) UIPanGestureRecognizer *dragGestureRecognizer;
@property (nonatomic) CGPoint dragPointBegan;
@property (nonatomic) CGPoint dragPointEnded;
@property (nonatomic) CGPoint dragPointCurrent;
@property (nonatomic) int dragX;
@property (nonatomic) int dragY;
@property (nonatomic) int dragCurrentX;
@property (nonatomic) int dragCurrentY;
@property (nonatomic) BOOL isDragging;
@property (nonatomic) BOOL shouldDragContinuous;

// long press
@property (nonatomic) BOOL recognizesLongPress;
@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic) CGPoint longPressPointBegan;
@property (nonatomic) CGPoint longPressPointCurrent;
@property (nonatomic) CGPoint longPressPointEnded;
@property (nonatomic) BOOL isLongPressing;

// grid
@property (nonatomic) float gridPixelWidth;
@property (nonatomic) float gridPixelHeight;
@property (nonatomic) NSMutableArray *gridViewArray;
@property (nonatomic) GGM_GridType gridType;

// used for gridType GGM_GRIDTYPE_HEX_SQUARE
@property (nonatomic) float hexPixelMultiplierHeight; // 1/4 of a hex (*3 to get y)
@property (nonatomic) float hexPixelMultiplierWidth;  // 1/2 of a hex

// used for gridType GGM_GRIDTYPE_TRIANGLES
@property (nonatomic) NSArray *triangleCoordinates;
@property (nonatomic) BOOL allowIrregularTriangles;


// gesture related
// taps
- (void)handleTapAtX:(int)x andY:(int)y;
// drags
- (void)handleDrag:(UIPanGestureRecognizer*)sender;
- (void)handleDragStart;
- (void)handleDragEnd;
- (void)handleDragContinue;
- (void)handleDragContinuous;
- (GGM_Direction)dragDirection;
- (BOOL)dragAllowedInDirection:(GGM_Direction)direction fromX:(int)x andY:(int)y;
// long pressing
- (void)handleLongPressStartedAtX:(int)x andY:(int)y;
- (void)handleLongPressEndedAtX:(int)x andY:(int)y;
- (void)handleLongPressContinuedAtX:(int)x andY:(int)y;

- (CGPoint)coordinatePointForPixelPoint:(CGPoint)pixelPoint;

- (UIView*)viewForX:(int)x andY:(int)y;

- (void)refreshViewForX:(int)x andY:(int)y;
- (void)refreshViewPositionsAndStates;
- (void)refreshView:(UIView*)view positionAtX:(int)x andY:(int)y;
- (void)refreshView:(UIView*)view stateAtX:(int)x andY:(int)y;

- (UIImage*)imageForGameState:(int)stateInt;
- (UIColor *)colorForGameState:(int)stateInt;
- (NSString *)textForGameState:(int)stateInt;

- (UIView *)newSubviewForGameState:(int)state;

- (void)setupInitialGridViewArray;


@end
