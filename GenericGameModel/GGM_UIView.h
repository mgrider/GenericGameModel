//
//  GGM_UIView.h
//  puzalution
//
//  Created by Martin Grider on 8/26/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGM_BaseModel.h"


typedef enum {
	GGM_GRIDTYPE_IMAGE,
	GGM_GRIDTYPE_COLOR,
	GGM_GRIDTYPE_TEXTLABEL,
	GGM_GRIDTYPE_HEX,
	GGM_GRIDTYPE_CUSTOM
} GGM_GridType;

typedef enum {
	GGM_DRAG_DIRECTION_HORIZONTAL,
	GGM_DRAG_DIRECTION_VERTICAL,
	GGM_DRAG_DIRECTION_NONE
} GGM_DragDirection;

typedef enum {
	GGM_MOVE_DIRECTION_UP,
	GGM_MOVE_DIRECTION_DOWN,
	GGM_MOVE_DIRECTION_LEFT,
	GGM_MOVE_DIRECTION_RIGHT
} GGM_MoveDirection;


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

// grid
@property (assign) float gridPixelWidth;
@property (assign) float gridPixelHeight;
@property (strong) NSMutableArray *gridViewArray;
@property (assign) GGM_GridType gridType;


- (void)handleTapAtX:(int)x andY:(int)y;
- (void)handleDrag:(UIPanGestureRecognizer*)sender;
- (void)handleDragStart;
- (void)handleDragEnd;
- (void)handleDragContinue;
- (BOOL)dragAllowedInDirection:(GGM_MoveDirection)direction fromX:(int)x andY:(int)y;

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
