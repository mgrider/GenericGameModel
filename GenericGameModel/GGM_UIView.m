//
//  GGM_UIView.m
//  puzalution
//
//  Created by Martin Grider on 8/26/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView.h"
#import "GGM_BaseModel.h"
#import <QuartzCore/QuartzCore.h>


@implementation GGM_UIView

@synthesize game = _game;
@synthesize recognizesTaps = _recognizesTaps;
@synthesize recognizesDrags = _recognizesDrags;


#pragma mark - tap touch detection

- (BOOL)recognizesTaps
{
	return _recognizesTaps;
}

- (void)setRecognizesTaps:(BOOL)recognizesTaps
{
	_recognizesTaps = recognizesTaps;
	if (recognizesTaps) {
		self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[self.tapGestureRecognizer setNumberOfTapsRequired:1];
		[self.tapGestureRecognizer setNumberOfTouchesRequired:1];
		[self.tapGestureRecognizer setEnabled:YES];
//		[self.tapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
		[self addGestureRecognizer:self.tapGestureRecognizer];
	}
	else if (self.tapGestureRecognizer != nil) {
		[self removeGestureRecognizer:self.tapGestureRecognizer];
		self.tapGestureRecognizer = nil;
	}
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	CGPoint tapPoint = [sender locationInView:self];
	[self handleTapAtPoint:tapPoint];
}

- (void)handleTapAtPoint:(CGPoint)tapPoint
{
	int x = tapPoint.x / self.gridPixelWidth;
	int y = tapPoint.y / self.gridPixelHeight;

//	int state = [self.game stateAtX:x andY:y];
//
//	NSLog(@"tap discovered at: %@, coords: {%i, %i} with state: %i", NSStringFromCGPoint(tapPoint), x, y, state);

	[self handleTapAtX:x andY:y];
}

- (void)handleTapAtX:(int)x andY:(int)y
{
	// to implement in subclasses
	NSLog(@"in GGM_UIView.m ... handleTapAtX");
}


#pragma mark - drag touch detection

- (BOOL)recognizesDrags
{
	return _recognizesDrags;
}

- (void)setRecognizesDrags:(BOOL)recognizesDrags
{
	NSLog(@"recognizes drags is %d", recognizesDrags);
	_recognizesDrags = recognizesDrags;
	if (recognizesDrags) {
		self.dragGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
		[self addGestureRecognizer:self.dragGestureRecognizer];
	}
	else if (self.dragGestureRecognizer != nil) {
		[self removeGestureRecognizer:self.dragGestureRecognizer];
		self.dragGestureRecognizer = nil;
	}
}

- (void)handleDrag:(UIPanGestureRecognizer*)sender
{
	CGPoint dragPoint = [sender locationInView:self];
	int x = dragPoint.x / self.gridPixelWidth;
	int y = dragPoint.y / self.gridPixelHeight;
	if (sender.state == UIGestureRecognizerStateBegan) {
		self.dragPointBegan = dragPoint;
		self.isDragging = YES;
		self.dragX = x;
		self.dragY = y;
		NSLog(@"pan started at: %@, coords are: {%i, %i}", NSStringFromCGPoint(dragPoint), x, y);
		[self handleDragStart];
	}
	else if (sender.state == UIGestureRecognizerStateEnded) {
		self.dragPointEnded = dragPoint;
		self.isDragging = NO;
		self.dragX = x;
		self.dragY = y;
		NSLog(@"pan ended at: %@, coords are: {%i, %i}", NSStringFromCGPoint(dragPoint), x, y);
		[self handleDragEnd];
	}
	else {
		self.dragPointCurrent = dragPoint;
		if (x != self.dragX || y != self.dragY) {
			self.dragX = x;
			self.dragY = y;
			[self handleDragContinue];
		}
	}
}

- (void)handleDragStart
{
	// implement in subclass
}

- (void)handleDragEnd
{
	// implement in subclasses
}

- (void)handleDragContinue
{
	// implement in subclass
}

- (BOOL)dragAllowedInDirection:(GGM_MoveDirection)direction fromX:(int)x andY:(int)y
{
	// implementin subclasses
	return YES;
}


#pragma mark - convenience

- (UIView*)viewForX:(int)x andY:(int)y
{
	if (x < 0 ||
		y < 0 ||
		x >= self.game.gridWidth ||
		y >= self.game.gridHeight) {
		NSLog(@"trying to find a view beyond the bounds of our view array.");
		return nil;
	}
	return [[self.gridViewArray objectAtIndex:y] objectAtIndex:x];
}


#pragma mark - drawing

- (void)refreshViewForX:(int)x andY:(int)y
{
	UIView *view = [self viewForX:x andY:y];
	[self refreshView:view positionAtX:x andY:y];
	[self refreshView:view stateAtX:x andY:y];
}

- (void)refreshViewPositionsAndStates
{
	UIView *view;
	int height = self.game.gridHeight;
	int width = self.game.gridWidth;
	for (int y = 0; y < height; y++)
	{
		for (int x = 0; x < width; x++)
		{
			view = [[self.gridViewArray objectAtIndex:y] objectAtIndex:x];
			[self refreshView:view positionAtX:x andY:y];
			[self refreshView:view stateAtX:x andY:y];
		}
	}
}

- (void)refreshView:(UIView*)view positionAtX:(int)x andY:(int)y
{
	[view setFrame:CGRectMake((self.gridPixelWidth*x), (self.gridPixelHeight*y), self.gridPixelWidth, self.gridPixelHeight)];
}

- (void)refreshView:(UIView*)view stateAtX:(int)x andY:(int)y
{
	int gameState = [self.game stateAtX:x andY:y];
	switch (self.gridType) {
		case GGM_GRIDTYPE_COLOR: {
			[view setBackgroundColor:[self colorForGameState:gameState]];
			break;
		}
		case GGM_GRIDTYPE_IMAGE: {
			UIImage *image = [self imageForGameState:gameState];
			[(UIImageView*)view setImage:image];
			break;
		}
		case GGM_GRIDTYPE_TEXTLABEL: {
			[(UILabel *)view setText:[self textForGameState:gameState]];
			break;
		}
		case GGM_GRIDTYPE_CUSTOM: {
			// implement in subclass
			break;
		}
	}
}

- (UIImage*)imageForGameState:(int)stateInt
{
	// implement in your subclass.
	switch (stateInt) {
//		case 1:
//			return [UIImage imageNamed:@"blue.png"];
//		case 2:
//			return [UIImage imageNamed:@"green.png"];
//		case 3:
//			return [UIImage imageNamed:@"red.png"];
		case 0:
		default:
			return nil;
	}
}

- (UIColor *)colorForGameState:(int)stateInt
{
	switch (stateInt) {
//		case 1:
//			return [UIColor redColor];
//		case 2:
//			return [UIColor greenColor];
//		case 3:
//			return [UIColor blueColor];

		case 0:
		default:
			return [UIColor clearColor];
	}
}

- (NSString *)textForGameState:(int)stateInt
{
	// implement in subclasses
	return @"";
}

- (UIView *)newSubviewForGameState:(int)state
{
	switch (self.gridType)
	{
		case GGM_GRIDTYPE_COLOR: {
			UIView *view = [[UIView alloc] init];
			[view setBackgroundColor:[self colorForGameState:state]];
			return view;
		}

		case GGM_GRIDTYPE_IMAGE: {
			UIImage *image;
			UIImageView *imageView;
			image = [self imageForGameState:state];
			imageView = [[UIImageView alloc] initWithImage:image];
			return imageView;
		}

		case GGM_GRIDTYPE_TEXTLABEL: {
			UILabel *label = [[UILabel alloc] init];
			[label setNumberOfLines:3];
			[label setAdjustsFontSizeToFitWidth:YES];
			[label setLineBreakMode:NSLineBreakByWordWrapping];
			[label setTextAlignment:NSTextAlignmentCenter];
			[label setMinimumScaleFactor:0.5f];
			[label setFont:[UIFont systemFontOfSize:11.0f]];
			[label setText:[self textForGameState:state]];
			[label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
			[label.layer setBorderWidth:3.0f];
			return label;
		}

		case GGM_GRIDTYPE_CUSTOM: {
			return [[UIView alloc] init];
		}

	}
	return [[UIView alloc] init];
}


#pragma mark - dealing with the gameModel

- (GGM_BaseModel *)game
{
	return _game;
}

- (void)setGame:(GGM_BaseModel *)game
{
	// for most purposes, this is our init
	_game = game;
	[self setupInitialGridViewArray];
}

- (void)setupInitialGridViewArray
{
	self.gridPixelWidth = self.frame.size.width / self.game.gridWidth;
	self.gridPixelHeight =  self.frame.size.height / self.game.gridHeight;

	self.gridViewArray = [NSMutableArray arrayWithCapacity:self.game.gridHeight];

	NSMutableArray *subarray;
	int gameState = 0;
	UIView *view;
	for (int y = 0; y < self.game.gridHeight; y++) {

		subarray = [NSMutableArray arrayWithCapacity:self.game.gridWidth];

		for (int x = 0; x < self.game.gridWidth; x++) {

			gameState = [self.game stateAtX:x andY:y];
			view = (UIView*)[self newSubviewForGameState:gameState];
			[view setFrame:CGRectMake((self.gridPixelWidth*x), (self.gridPixelHeight*y), self.gridPixelWidth, self.gridPixelHeight)];

			[self addSubview:view];
			[subarray insertObject:view atIndex:x];
		}
		[self.gridViewArray insertObject:subarray atIndex:y];
	}
}


#pragma mark - description

- (NSString *)description
{
	NSString *superString = [super description];
	return [superString stringByAppendingFormat:@"\nGGM_UIView %@, taps:%@, drags:%@, gridPixelWidth:%f, gridPixelHeight:%f",
			NSStringFromCGRect(self.frame),
			(self.recognizesTaps)?@"YES":@"NO",
			(self.recognizesDrags)?@"YES":@"NO",
			self.gridPixelWidth,
			self.gridPixelHeight];
}


@end