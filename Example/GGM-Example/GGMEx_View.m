//
//  GGMEx_SquareView.m
//  GGM-Example
//
//  Created by Martin Grider on 4/7/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import "GGMEx_View.h"
#import "GGMEx_Model.h"


@implementation GGMEx_View


#pragma mark - drawing states

- (UIColor *)colorForGameState:(int)stateInt
{
	switch (stateInt) {
		case GGMEx_State_1:
			return [UIColor lightGrayColor];
		case GGMEx_State_2:
			return [UIColor darkGrayColor];
		case GGMEx_State_3:
			return [UIColor redColor];
		case GGMEx_State_4:
			return [UIColor blueColor];
		default:
		case GGMEx_State_none:
			return [UIColor clearColor];
	}
}

- (NSString *)textForGameState:(int)stateInt
{
	int x,y;
	y = stateInt / self.game.gridHeight;
	x = stateInt % self.game.gridWidth;
	return [NSString stringWithFormat:@"{%i,%i}", x, y];
}

- (void)setTextStateForX:(int)x andY:(int)y byAppendingString:(NSString*)stringToAppend
{
	int stateInt = [self.game stateAtX:x andY:y];
	NSString *stateStr = [self textForGameState:stateInt];
	stateStr = [stateStr stringByAppendingString:stringToAppend];
	UILabel *view = (UILabel*)[self viewForX:x andY:y];
	[view setText:stateStr];
}


#pragma mark - detect taps

- (void)handleTapAtX:(int)x andY:(int)y
{
//	GGMEx_State state = (GGMEx_State)[self.game stateAtX:x andY:y];
//	state = (state == GGMEx_State_3) ? GGMEx_State_none : state + 1;
//	[self.game setStateAtX:x andY:y toState:state];
	if (self.gridType == GGM_GRIDTYPE_TEXTLABEL) {
		[self setTextStateForX:x andY:y byAppendingString:@"\ntapped"];
	}
	else {
		[self.game setStateAtX:x andY:y toState:GGMEx_State_3];
		[self refreshViewForX:x andY:y];
	}
}


#pragma mark - detect drags

- (void)handleDragStart
{
	if (self.gridType == GGM_GRIDTYPE_TEXTLABEL) {
		[self setTextStateForX:self.dragX andY:self.dragY byAppendingString:@"\ndrag-started"];
	}
	else {
		[self setStateForDragXY];
	}
}

- (void)handleDragContinue
{
	if (self.gridType == GGM_GRIDTYPE_TEXTLABEL) {
		[self setTextStateForX:self.dragX andY:self.dragY byAppendingString:@"\ndrag-through"];
	}
	else {
		[self setStateForDragXY];
	}
}

- (void)handleDragEnd
{
	if (self.gridType == GGM_GRIDTYPE_TEXTLABEL) {
		[self setTextStateForX:self.dragX andY:self.dragY byAppendingString:@"\ndrag-ended"];
	}
	else {
		[self setStateForDragXY];
	}
}

- (void)setStateForDragXY
{
	[self.game setStateAtX:self.dragX andY:self.dragY toState:GGMEx_State_4];
	[self refreshViewForX:self.dragX andY:self.dragY];
}


@end
