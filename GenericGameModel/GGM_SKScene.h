//
//  GGM_SKScene.h
//  GGM-SpriteKit
//
//  Created by Martin Grider on 5/5/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GGM_UIConstants.h"


@interface GGM_SKScene : SKScene


// grid
@property (assign) float gridPixelWidth;
@property (assign) float gridPixelHeight;
@property (strong) NSMutableArray *gridViewArray;
@property (assign) GGM_GridType gridType;

// touch handling
@property (assign) BOOL recognizesTaps;


// setup
- (void)setupForBaseModel:(id)model;
- (void)setupInitialGridViewArray;

// refreshing
- (void)refreshNodeForX:(int)x andY:(int)y;
- (void)refreshNodePositionsAndStates;

// color grid type
- (UIColor *)colorForGameState:(int)stateInt;

// get the individual nodes
- (SKNode*)nodeForX:(int)x andY:(int)y;


@end
