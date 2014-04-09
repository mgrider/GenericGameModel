//
//  GGMEx_Model.m
//  GGM-Example
//
//  Created by Martin Grider on 4/7/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import "GGMEx_Model.h"


@implementation GGMEx_Model


- (void)setStatesToCheckerboard
{
	// alternate between GGMEx_State_1 and GGMEx_State_2
	GGMEx_State state = GGMEx_State_1;
	for (int y = 0; y < self.gridHeight; y++) {
		for (int x = 0; x < self.gridWidth; x++) {

			state = (state == GGMEx_State_1) ? GGMEx_State_2 : GGMEx_State_1;

			[self setStateAtX:x andY:y toState:state];
		}
		if (self.gridWidth % 2 == 0) {
			state = (state == GGMEx_State_1) ? GGMEx_State_2 : GGMEx_State_1;
		}
	}
}

- (void)setStatesForTextViews
{
	int state;
	for (int y = 0; y < self.gridHeight; y++) {
		for (int x = 0; x < self.gridWidth; x++) {
			state = (y*self.gridHeight) + x;
			[self setStateAtX:x andY:y toState:state];
		}
	}
}


@end
