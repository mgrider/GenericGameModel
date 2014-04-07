//
//  GGMEx_SquareView.m
//  GGM-Example
//
//  Created by Martin Grider on 4/7/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import "GGMEx_SquareView.h"
#import "GGMEx_Model.h"


@implementation GGMEx_SquareView


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


#pragma mark - detect taps

- (void)handleTapAtX:(int)x andY:(int)y
{
//	GGMEx_State state = (GGMEx_State)[self.game stateAtX:x andY:y];
//	state = (state == GGMEx_State_3) ? GGMEx_State_none : state + 1;
//	[self.game setStateAtX:x andY:y toState:state];
	[self.game setStateAtX:x andY:y toState:GGMEx_State_3];
	[self refreshViewForX:x andY:y];
}


#pragma mark - detect drags

- (void)handleDragContinue
{
	[self.game setStateAtX:self.dragX andY:self.dragY toState:GGMEx_State_4];
	[self refreshViewForX:self.dragX andY:self.dragY];
}


@end
