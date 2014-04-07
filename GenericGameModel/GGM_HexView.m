//
//  GGM_HexView.m
//  Ketchup
//
//  Created by Martin Grider on 12/29/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_HexView.h"


@implementation GGM_HexView


#pragma mark - handling tap gestures

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	CGPoint tapPoint = [sender locationInView:self];

	int y = tapPoint.y / self.gridPixelHeight;

	int pixelOffset = (self.gridPixelWidth / 2.0f) * (y - (self.game.gridWidth / 2));
	int x = (tapPoint.x - pixelOffset) / self.gridPixelWidth;

	int state = [self.game stateAtX:x andY:y];

	NSLog(@"tap discovered at: %@, coords: {%i, %i} with state: %i", NSStringFromCGPoint(tapPoint), x, y, state);

	[self handleTapAtX:x andY:y];
}

- (void)handleTapAtX:(int)x andY:(int)y
{
	// implement in subclasses
}


#pragma mark - drawing the hex grid

- (void)setupInitialGridViewArray
{
	self.gridPixelWidth = self.frame.size.width / self.game.gridWidth;
	self.gridPixelHeight =  self.frame.size.height / self.game.gridHeight;
	float pWidth = self.gridPixelWidth;
	float pHeight = self.gridPixelHeight;

	self.gridViewArray = [NSMutableArray arrayWithCapacity:self.game.gridHeight];

	NSMutableArray *subarray;
	int gameState = 0;
	UIView *view;
	float pixelOffset;
	for (int y = 0; y < self.game.gridHeight; y++) {

		subarray = [NSMutableArray arrayWithCapacity:self.game.gridWidth];
		pixelOffset = (pWidth / 2.0f) * (y - (self.game.gridWidth / 2));
//		NSLog(@"pixelOffset is %f for y%i", pixelOffset, y);

		for (int x = 0; x < self.game.gridWidth; x++) {

			gameState = [self.game stateAtX:x andY:y];
			view = (UIView*)[self newSubviewForGameState:gameState];
			[view setFrame:CGRectMake((pWidth*x)+pixelOffset, (pHeight*y), pWidth, pHeight)];

			[self addSubview:view];
			[subarray insertObject:view atIndex:x];
		}
		[self.gridViewArray insertObject:subarray atIndex:y];
	}
}

// essentially, right now, this doesn't refresh view positions
// (and that is the only way it differs from its superclass implementation)
- (void)refreshViewPositionsAndStates
{
	int gameState = 0;
	UIView *view;
	UIImage *image;
	for (int y = 0; y < self.game.gridHeight; y++)
	{
		for (int x = 0; x < self.game.gridWidth; x++)
		{
			gameState = [self.game stateAtX:x andY:y];
			view = [[self.gridViewArray objectAtIndex:y] objectAtIndex:x];

			switch (self.gridType) {
				case GGM_GRIDTYPE_COLOR: {
					[view setBackgroundColor:[self colorForGameState:gameState]];
					break;
				}
				case GGM_GRIDTYPE_IMAGE: {
					image = [self imageForGameState:gameState];
					[(UIImageView*)view setImage:image];
					break;
				}
				case GGM_GRIDTYPE_TEXTLABEL: {
					[(UILabel *)view setText:[self textForGameState:gameState]];
					break;
				}
				default: {
					break;
				}
			}
		}
	}
}



@end
