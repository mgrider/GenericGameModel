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


@property (strong) GGM_BaseModel *game;

// taps
@property (assign) BOOL recognizesTaps;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

// drags
@property (assign) BOOL recognizesDrags;
@property (strong, nonatomic) UIPanGestureRecognizer *dragGestureRecognizer;
@property (assign) CGPoint dragPointBegan;
@property (assign) CGPoint dragPointEnded;
@property (assign) CGPoint dragPointCurrent;
@property (assign) int dragX;
@property (assign) int dragY;
@property (assign) BOOL isDragging;
@property (assign) BOOL shouldDragContinuous;

// long press
@property (assign) BOOL recognizesLongPress;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (assign) CGPoint longPressPointBegan;
@property (assign) CGPoint longPressPointCurrent;
@property (assign) CGPoint longPressPointEnded;
@property (assign) BOOL isLongPressing;

// grid
@property (assign) float gridPixelWidth;
@property (assign) float gridPixelHeight;
@property (strong) NSMutableArray *gridViewArray;
@property (assign) GGM_GridType gridType;

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
