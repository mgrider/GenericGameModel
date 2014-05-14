//
//  Generic_GameModel.m
//  puzalution
//
//  Created by Martin Grider on 8/24/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_BaseModel.h"
#import "BaseModel.h"


@implementation GGM_BaseModel

@synthesize gameIsOver = _gameIsOver;
@synthesize gameIsPaused = _gameIsPaused;
@synthesize gameDuration = _gameDuration;
@synthesize gameStartDate = _gameStartDate;


#pragma mark - creation / init

// note that this is a NEW instance, if you want to be able to save state "automagically", you'll want to use sharedInstanceWithWidth:andHeight:
+ (instancetype)instanceWithWidth:(int)width andHeight:(int)height
{
	// if you really don't care about saving, might as well skip the BaseModel parent entirely, change it to NSObject, and uncomment this line (and comment out the next, obviously)
//	GGM_BaseModel *model = [[self alloc] init];
	// Otherwise, this gives you all the benefits of BaseModel
	GGM_BaseModel *model = [self instance];
	model.gridHeight = height;
	model.gridWidth = width;
	[model setupGrid];

	[model setupForNewGame];

	return model;
}

// uses the shared instance, so you can call save
+ (instancetype)sharedInstanceWithWidth:(int)width andHeight:(int)height
{
	BOOL hasSharedInstance = [self hasSharedInstance];
	GGM_BaseModel *model = [self sharedInstance];
	model.gridHeight = height;
	model.gridWidth = width;
	[model setupGrid];

	if (hasSharedInstance) {
		// this is mostly so that time can be accurately calculated later
		if (! model.gameIsOver) {
			model.gameIsPaused = YES;
		}
	}
	else {
		[model setupForNewGame];
	}
	

	return model;
}

+ (instancetype)instanceWithMultidimensionalArray:(NSArray*)states
{
	GGM_BaseModel *model = [self instance];

	model.gridHeight = (int)[states count];
	model.gridWidth = (int)[[states objectAtIndex:0] count];

	[model setupGrid];

	for (int y=0; y < model.gridHeight; y++) {
		for (int x = 0; x < model.gridWidth; x++) {
			[model setStateAtX:x andY:y toState:[[[states objectAtIndex:y] objectAtIndex:x] intValue]];
		}
	}

	[model setupForNewGame];

	return model;
}

//- (void)setUp
//{
//	// this will get called after init (see BaseModel)
//}

- (void)setupGrid
{
	// this is a decent jumping off point for custom initialization if you want it.

	// init the gridElements
	self.gridElements = [[NSMutableArray alloc] initWithCapacity:self.gridHeight];
	NSMutableArray *subarray;
	for (int y=0; y < self.gridHeight; y++) {
		subarray = [[NSMutableArray alloc] initWithCapacity:self.gridWidth];
		for (int x = 0; x < self.gridWidth; x++) {
			[subarray insertObject:[NSNumber numberWithInt:0] atIndex:x];
		}
		[self.gridElements addObject:subarray];
	}
}

- (void)setupForNewGame
{
	// also a good candidate for customizing

	// new games start paused
	self.gameIsOver = NO;
	self.gameIsPaused = YES;
	// dealing with time
	self.gameStartDate = [NSDate date];
	self.gameDuration = 0;
	self.gameTimeFormatter = [[NSDateFormatter alloc] init];
//	[self.gameTimeFormatter setDateFormat:@"'Time: 'mm:ss"];
	[self.gameTimeFormatter setDateFormat:@"mm:ss"];
}


#pragma mark - getting / setting gameIsOver and gameIsPaused

- (BOOL)gameIsOver
{
	return _gameIsOver;
}

- (void)setGameIsOver:(BOOL)gameIsOver
{
	if (gameIsOver) {
		[self updateGameDuration];
	}
	else {
		[self updateGameStartDate];
	}
	_gameIsOver = gameIsOver;
}

- (BOOL)gameIsPaused
{
	return _gameIsPaused;
}

- (void)setGameIsPaused:(BOOL)gameIsPaused
{
	if (gameIsPaused) {
		[self updateGameDuration];
	}
	else {
		[self updateGameStartDate];
	}
	_gameIsPaused = gameIsPaused;
}


#pragma mark - getting a human-readable time (duration)

- (NSString*)gameTime
{
	NSString *dateTimeString;
	if ( ! (self.gameIsOver || self.gameIsPaused)) {
		[self updateGameDuration];
	}
	dateTimeString = [_gameTimeFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:-self.gameDuration]];
	return dateTimeString;
}


#pragma mark - dealing with gameDuration and gameStartDate

- (void)updateGameDuration
{
	_gameDuration = [self.gameStartDate timeIntervalSinceNow];
}

- (void)updateGameStartDate
{
	_gameStartDate = [NSDate dateWithTimeIntervalSinceNow:self.gameDuration];
}

- (NSTimeInterval)gameDuration
{
	if (_gameIsPaused || _gameIsOver) {
		return _gameDuration;
	}
	else {
		[self updateGameDuration];
		return _gameDuration;
	}
}

- (void)setGameDuration:(NSTimeInterval)gameDuration
{
	_gameDuration = gameDuration;
}

- (NSDate*)gameStartDate
{
	if (_gameIsPaused || _gameIsOver) {
		[self updateGameStartDate];
	}
	return _gameStartDate;
}

- (void)setGameStartDate:(NSDate *)gameStartDate
{
	_gameStartDate = gameStartDate;
}


#pragma mark - setting game state

- (void)setStateAtX:(int)x andY:(int)y toState:(int)newState
{
	if (x < 0 ||
		y < 0 ||
		x >= _gridWidth ||
		y >= _gridHeight) {
		NSLog(@"THIS IS A FAIL at x:%i andy:%i.", x, y );
		return;
	}
	[[self.gridElements objectAtIndex:y] replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:newState]];
}

- (int)randomStateInt
{
	return arc4random() % (_gridMaxStateInt + 1);
}

- (void)randomizeGridFromMaxPossibleState
{
	NSNumber *state;
	for (int y=0; y < self.gridHeight; y++) {
		for (int x=0; x < self.gridWidth; x++) {
			state = [NSNumber numberWithInt:[self randomStateInt]];
			[[self.gridElements objectAtIndex:y] replaceObjectAtIndex:x withObject:state];
		}
	}
}

- (void)setAllStatesTo:(int)stateInt
{
	NSNumber *state;
	for (int y=0; y < self.gridHeight; y++) {
//		NSLog(@"y is %i", y);
		for (int x=0; x < self.gridWidth; x++) {
			state = [NSNumber numberWithInt:stateInt];
			[[self.gridElements objectAtIndex:y] replaceObjectAtIndex:x withObject:state];
		}
	}
}


#pragma mark - querrying game state

- (int)stateAtX:(int)x andY:(int)y
{
	if (x < 0 ||
		y < 0 ||
		x >= _gridWidth ||
		y >= _gridHeight) {
		return -1;
	}
	return [[[self.gridElements objectAtIndex:y] objectAtIndex:x] intValue];
}

- (int)stateAtDirection:(GGM_MoveDirection)direction fromX:(int)x andY:(int)y
{
	switch (direction) {
		case GGM_MOVE_DIRECTION_NONE:
			return [self stateAtX:x andY:y];
		case GGM_MOVE_DIRECTION_UP:
			return [self stateAtX:x andY:y-1];
		case GGM_MOVE_DIRECTION_DOWN:
			return [self stateAtX:x andY:y+1];
		case GGM_MOVE_DIRECTION_LEFT:
			return [self stateAtX:x-1 andY:y];
		case GGM_MOVE_DIRECTION_RIGHT:
			return [self stateAtX:x+1 andY:y];
	}
}


#pragma mark - score

- (void)scoreIncrement
{
	self.score = self.score + 1;
}

- (void)scoreAddValue:(int)value
{
	self.score = self.score + value;
}


#pragma mark - desc

- (NSString *)description
{
	NSString *desc = @"Game Model:\n";
	for (int i=0; i<self.gridHeight; i++) {
		desc = [desc stringByAppendingString:@"[ "];
		for (int x=0; x < self.gridWidth; x++) {
			desc = [desc stringByAppendingFormat:@"%@, ", [[self.gridElements objectAtIndex:i] objectAtIndex:x]];
		}
		desc = [desc stringByAppendingFormat:@"]\n"];
	}
	desc = [desc stringByAppendingFormat:@"Game Over: %@, Paused: %@, Duration: %@, Score: %i", @(_gameIsOver), @(_gameIsPaused), [self gameTime], self.score];
	return desc;
}


@end
