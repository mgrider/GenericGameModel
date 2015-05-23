//
//  Generic_GameModel.h
//  puzalution
//
//  Created by Martin Grider on 8/24/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "GGM_UIConstants.h"


@interface GGM_BaseModel : BaseModel


// grid size
@property (assign) int gridWidth;
@property (assign) int gridHeight;

// gridElements contains MutableArrays for each row,
// in turn containing NSNumbers representing each element's "state"
@property (nonatomic, strong) NSMutableArray *gridElements;

// game states are between 0 and gridMaxStateInt
@property (assign) int gridMaxStateInt;

// is the game over or paused?
@property (assign) BOOL gameIsOver;
@property (assign) BOOL gameIsPaused;

// Calculating how long the current game has been in progress - Note that, if the game is paused or over, it makes more sense to get the interval, but if it's in progress, the NSDate makes more sense
// gameStartDate will be relative to the amount of time spent in the game while it was not paused or over
@property (strong) NSDate *gameStartDate;
// this is the corresponding time interval for how long the game has been going
@property (assign) NSTimeInterval gameDuration;
@property (strong) NSDateFormatter *gameTimeFormatter;

// score support
@property (assign) int score;


+ (instancetype)instanceWithWidth:(int)width andHeight:(int)height;
+ (instancetype)sharedInstanceWithWidth:(int)width andHeight:(int)height;
+ (instancetype)instanceWithMultidimensionalArray:(NSArray*)states;

// various methods to override as needed/wanted
- (void)setupForNewGame;
- (void)setupGrid;

// getting the game time in a readable format
- (NSString*)gameTime;

// state int setting
- (void)setStateAtX:(int)x andY:(int)y toState:(int)newState;
- (int)randomStateInt;
- (void)randomizeGridFromMaxPossibleState;
- (void)setAllStatesTo:(int)stateInt;

// state int getting
- (int)stateAtX:(int)x andY:(int)y;
- (int)stateAtDirection:(GGM_Direction)direction fromX:(int)x andY:(int)y;

// dealing with the score
- (void)scoreIncrement;
- (void)scoreAddValue:(int)value;


@end
