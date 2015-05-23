//
//  GGM_SKScene.m
//  GGM-SpriteKit
//
//  Created by Martin Grider on 5/5/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import "GGM_SKScene.h"
#import "GGM_BaseModel.h"


@interface GGM_SKScene ()
@property (strong) GGM_BaseModel *game;
@end


@implementation GGM_SKScene


#pragma mark - touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
	if ( ! self.recognizesTaps)
	{
		return;
	}

	for (UITouch *touch in touches) {
		CGPoint location = [touch locationInNode:self];
		[self handleTapAtPoint:location];
	}
}

- (void)handleTapAtPoint:(CGPoint)tapPoint
{
	CGPoint coordinate = [self coordinatePointForPixelPoint:tapPoint];

	//	int state = [self.game stateAtX:x andY:y];
	//
	//	NSLog(@"tap discovered at: %@, coords: {%i, %i} with state: %i", NSStringFromCGPoint(tapPoint), coordinate.x, coordinate.y, state);

	[self handleTapAtX:coordinate.x andY:coordinate.y];
}

- (void)handleTapAtX:(int)x andY:(int)y
{
	// to implement in subclasses
	NSLog(@"in GGM_SKScene ... handleTapAtX:andY: (%i, %i)", x, y);
}


#pragma mark - responding to current time...

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}


#pragma mark - setup

- (void)setupForBaseModel:(id)model
{
	// this serves the same function as setting the game object on the original GGM_UIView
	self.game = model;

	// setup the grid
	[self setupInitialGridViewArray];
}

- (void)setupInitialGridViewArray
{
	NSLog(@"setting up initial grid view array");
	self.gridPixelWidth = self.frame.size.width / self.game.gridWidth;
	self.gridPixelHeight =  self.frame.size.height / self.game.gridHeight;

	self.gridViewArray = [NSMutableArray arrayWithCapacity:self.game.gridHeight];

	NSMutableArray *subarray;
	int gameState = 0;
	SKNode *node;
	for (int y = 0; y < self.game.gridHeight; y++)
	{
		subarray = [NSMutableArray arrayWithCapacity:self.game.gridWidth];

		for (int x = 0; x < self.game.gridWidth; x++)
		{
			gameState = [self.game stateAtX:x andY:y];
			node = [self nodeForGameState:gameState];
			[self addChild:node];
			[subarray insertObject:node atIndex:x];
			[self refreshNode:node positionAtX:x andY:y];
		}
		[self.gridViewArray insertObject:subarray atIndex:y];
	}
}

- (SKNode*)nodeForGameState:(int)gameState
{
	SKNode *node;
	switch (self.gridType) {
		case GGM_GRIDTYPE_COLOR: {
			node = [SKSpriteNode spriteNodeWithColor:[self colorForGameState:gameState] size:CGSizeMake(self.gridPixelWidth, self.gridPixelHeight)];
//			[(SKShapeNode*)node setFillColor:[self colorForGameState:gameState]];
			return node;
		}

		default:
			return nil;
	}
}


#pragma mark - getting X and Y from points

- (CGPoint)coordinatePointForPixelPoint:(CGPoint)pixelPoint
{
	int x,y;
	pixelPoint = [self convertPointToView:pixelPoint];
	switch (self.gridType) {
		case GGM_GRIDTYPE_HEX: {
			y = pixelPoint.y / self.gridPixelHeight;
			int pixelOffset = (self.gridPixelWidth / 2.0f) * (y - (self.game.gridWidth / 2));
			x = (pixelPoint.x - pixelOffset) / self.gridPixelWidth;
			break;
		}
		default: {
			x = pixelPoint.x / self.gridPixelWidth;
			y = pixelPoint.y / self.gridPixelHeight;
			break;
		}
	}
	return CGPointMake(x, y);
}


#pragma mark - drawing

- (void)refreshNodeForX:(int)x andY:(int)y
{
	SKNode *node = [self nodeForX:x andY:y];
	[self refreshNode:node positionAtX:x andY:y];
	[self refreshNode:node stateAtX:x andY:y];
}

- (void)refreshNodePositionsAndStates
{
	SKNode *node;
	int height = self.game.gridHeight;
	int width = self.game.gridWidth;
	for (int y = 0; y < height; y++)
	{
		for (int x = 0; x < width; x++)
		{
			node = [self nodeForX:x andY:y];
			[self refreshNode:node positionAtX:x andY:y];
			[self refreshNode:node stateAtX:x andY:y];
		}
	}
}

- (void)refreshNode:(SKNode*)node positionAtX:(int)x andY:(int)y
{
	// note that pixel coordinates are calculated with 0,0 in the upper-left
	// but of course SK assumes 0,0 is the lower left
	// so we need to translate before posititioning our nodes
	switch (self.gridType) {
//		case GGM_GRIDTYPE_HEX: {
//			int numberOfFourths = (self.game.gridHeight * 3) + 1;
//			float fourthHeight = self.frame.size.height / numberOfFourths;
//			float pWidth = self.gridPixelWidth - 1.0f;
//			float pHeight = (fourthHeight * 4.0f) - 1.0f;
//			float pixelXOffset = (self.gridPixelWidth / 2.0f) * (y - (self.game.gridWidth / 2));
//			float startY = (fourthHeight * 3.0f) * y;
//			float startX = (self.gridPixelWidth * x) + pixelXOffset;
//			[view setFrame:CGRectMake(startX, startY, pWidth, pHeight)];
//			
//			//			float pixelOffset = (self.gridPixelWidth / 2.0f) * (y - (self.game.gridWidth / 2));
//			//			[view setFrame:CGRectMake((self.gridPixelWidth*x)+pixelOffset, (self.gridPixelHeight*y), self.gridPixelWidth, self.gridPixelHeight)];
//			break;
//		}
		default: {
			CGRect frame = CGRectMake((self.gridPixelWidth*x), (self.gridPixelHeight*y), self.gridPixelWidth, self.gridPixelHeight);
//			NSLog(@"frame is %@", NSStringFromCGRect(frame));
			CGPoint centerPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
//			NSLog(@"centerPoint is %@", NSStringFromCGPoint(centerPoint));
			centerPoint = [self convertPointFromView:centerPoint];
			[node setPosition:centerPoint];
//			frame.origin.x = -(self.gridPixelWidth / 2.0f);
//			frame.origin.y = -(self.gridPixelHeight / 2.0f);
//			CGPathRef path = CGPathCreateWithRect(frame, &CGAffineTransformIdentity);
//			[(SKShapeNode*)node setPath:path];
			break;
		}
	}
}

- (void)refreshNode:(SKNode*)node stateAtX:(int)x andY:(int)y
{
	int gameState = [self.game stateAtX:x andY:y];
	switch (self.gridType) {
//		case GGM_GRIDTYPE_IMAGE: {
//			UIImage *image = [self imageForGameState:gameState];
//			[(UIImageView*)view setImage:image];
//			break;
//		}
//		case GGM_GRIDTYPE_TEXTLABEL: {
//			[(UILabel *)view setText:[self textForGameState:gameState]];
//			break;
//		}
//		case GGM_GRIDTYPE_HEX: {
//			[(GGM_HexView*)view setHexColor:[self colorForGameState:gameState]];
//			break;
//		}
//		case GGM_GRIDTYPE_CUSTOM: {
//			// implement in subclass
//			break;
//		}
		default:
		case GGM_GRIDTYPE_COLOR: {
			[(SKSpriteNode*)node setColor:[self colorForGameState:gameState]];
//			[(SKShapeNode*)node setFillColor:[self colorForGameState:gameState]];
			break;
		}
	}
}

- (UIColor *)colorForGameState:(int)stateInt
{
	// This method should be implemented in your subclass
	switch (stateInt) {
			// for example...
		case 1:
			return [UIColor redColor];
		case 2:
			return [UIColor blueColor];
		case 3:
			return [UIColor yellowColor];

		case 0:
		default:
			return [UIColor clearColor];
	}
}


#pragma mark - convenience

- (SKNode*)nodeForX:(int)x andY:(int)y
{
	if (x < 0 ||
		y < 0 ||
		x >= self.game.gridWidth ||
		y >= self.game.gridHeight)
	{
		NSLog(@"trying to find a node beyond the bounds of our node array.");
		return nil;
	}
	return [[self.gridViewArray objectAtIndex:y] objectAtIndex:x];
}


@end
