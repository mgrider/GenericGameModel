//
//  GGM_UIView.m
//  puzalution
//
//  Created by Martin Grider on 8/26/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView.h"

#import "GGM_BaseModel.h"
#import "GGM_HexView.h"
#import "GGM_TriangleView.h"
#import "GGM_UIConstants.h"
#import "GGM_UIView+Triangles.h"
#import <QuartzCore/QuartzCore.h>


@implementation GGM_UIView

@synthesize game = _game;
@synthesize recognizesTaps = _recognizesTaps;
@synthesize recognizesDrags = _recognizesDrags;
@synthesize recognizesLongPress = _recognizesLongPress;


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
	CGPoint xyPoint = [self coordinatePointForPixelPoint:tapPoint];
	int x = (int)xyPoint.x;
	int y = (int)xyPoint.y;
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
	CGPoint xyPoint = [self coordinatePointForPixelPoint:dragPoint];
	int x = (int)xyPoint.x;
	int y = (int)xyPoint.y;
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
		// TODO: fix this so that subclasses get notified about dragContinue continuously if they want
		if (self.shouldDragContinuous || x != self.dragX || y != self.dragY) {
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

- (GGM_Direction)dragDirection
{
	GGM_Direction direction = GGM_DIRECTION_NONE;
	float verticalOffset = self.dragPointCurrent.y - self.dragPointBegan.y;
	float horizontalOffset = self.dragPointCurrent.x - self.dragPointBegan.x;
	if (fabsf(verticalOffset) > fabsf(horizontalOffset)) {
		// moving vertically
		if (verticalOffset > 0) {
			direction = GGM_DIRECTION_DOWN;
		}
		else {
			direction = GGM_DIRECTION_UP;
		}
	}
	else {
		// moving horizontally
		if (horizontalOffset > 0) {
			direction = GGM_DIRECTION_RIGHT;
		}
		else {
			direction = GGM_DIRECTION_LEFT;
		}
	}
	return direction;
}

- (BOOL)dragAllowedInDirection:(GGM_Direction)direction fromX:(int)x andY:(int)y
{
	// implementin subclasses
	return YES;
}


#pragma mark - long press

- (BOOL)recognizesLongPress
{
	return _recognizesLongPress;
}

- (void)setRecognizesLongPress:(BOOL)recognizesLongPress
{
	_recognizesLongPress = recognizesLongPress;
	if (recognizesLongPress) {
		self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
		if (self.recognizesTaps) {
			[self.longPressGestureRecognizer requireGestureRecognizerToFail:self.tapGestureRecognizer];
		}
		[self addGestureRecognizer:self.longPressGestureRecognizer];
		self.longPressPointBegan = CGPointZero;
	}
	else if (self.longPressGestureRecognizer != nil) {
		[self removeGestureRecognizer:self.longPressGestureRecognizer];
		self.longPressGestureRecognizer = nil;
	}
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender
{
	CGPoint point = [sender locationInView:self];
	CGPoint xyPoint = [self coordinatePointForPixelPoint:point];
	int x = (int)xyPoint.x;
	int y = (int)xyPoint.y;
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		self.isLongPressing = NO;
		self.longPressPointEnded = point;
		[self handleLongPressEndedAtX:x andY:y];
	}
	else if (sender.state == UIGestureRecognizerStateBegan) {
		self.isLongPressing = YES;
		self.longPressPointBegan = point;
		[self handleLongPressStartedAtX:x andY:y];
	}
	else {
		self.longPressPointCurrent = point;
		[self handleLongPressContinuedAtX:x andY:y];
	}
}

- (void)handleLongPressStartedAtX:(int)x andY:(int)y
{
	// to implement in subclasses
	NSLog(@"in GGM_UIView.m ... handleLongPressStartedAtX:%i andY:%i", x, y);
}

- (void)handleLongPressEndedAtX:(int)x andY:(int)y
{
	// to implement in subclasses
	NSLog(@"in GGM_UIView.m ... handleLongPressEndedAtX:%i andY:%i", x, y);
}

- (void)handleLongPressContinuedAtX:(int)x andY:(int)y
{
	// to implement in subclasses
	NSLog(@"in GGM_UIView.m ... handleLongPressContinuedAtX:%i andY:%i", x, y);
}


#pragma mark - getting X and Y from points

- (CGPoint)coordinatePointForPixelPoint:(CGPoint)pixelPoint
{
	if ( ! CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height), pixelPoint))
	{
		return CGPointMake(-1, -1);
	}
	int x,y;
	switch (self.gridType) {
		case GGM_GRIDTYPE_HEX: {
			y = pixelPoint.y / self.gridPixelHeight;
			int pixelOffset = (self.gridPixelWidth / 2.0f) * (y - (self.game.gridWidth / 2));
			x = (pixelPoint.x - pixelOffset) / self.gridPixelWidth;
			break;
		}
		case GGM_GRIDTYPE_HEX_SQUARE: {
			// this breaks down on the corners, unfortunately, but it's a pretty decent approximation
			y = pixelPoint.y / self.gridPixelHeight;
			int numberOfHalves = (self.game.gridWidth * 2) + 1;
			float halfWidth = self.frame.size.width / numberOfHalves;
			int pixelXOffset = (y % 2 == 0) ? halfWidth : 0.0f;
			x = (pixelPoint.x - pixelXOffset) / self.gridPixelWidth;
			break;
		}
		case GGM_GRIDTYPE_TRIANGLE: {
			return [self triangleXYPointForPixelPoint:pixelPoint];
		}
		default: {
			x = pixelPoint.x / self.gridPixelWidth;
			y = pixelPoint.y / self.gridPixelHeight;
			break;
		}
	}
	return CGPointMake(x, y);
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
	if (view == nil) {
		return;
	}
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
	switch (self.gridType) {
		case GGM_GRIDTYPE_HEX: {
			// was used for Catchup, you probably want GGM_GRIDTYPE_HEX_SQUARE tho.
			int numberOfFourths = (self.game.gridHeight * 3) + 1;
			float fourthHeight = self.frame.size.height / numberOfFourths;
			float pWidth = self.gridPixelWidth - 1.0f;
			float pHeight = (fourthHeight * 4.0f) - 1.0f;
			float pixelXOffset = (self.gridPixelWidth / 2.0f) * (y - (self.game.gridWidth / 2));
			float startY = (fourthHeight * 3.0f) * y;
			float startX = (self.gridPixelWidth * x) + pixelXOffset;
			[view setFrame:CGRectMake(startX, startY, pWidth, pHeight)];
			break;
		}
		case GGM_GRIDTYPE_HEX_SQUARE:
		{
			int numberOfFourths = (self.game.gridHeight * 3) + 1;
			float fourthHeight = self.frame.size.height / numberOfFourths;
			float pHeight = (fourthHeight * 4.0f) - 1.0f;
			int numberOfHalves = (self.game.gridWidth * 2) + 1;
			float halfWidth = self.frame.size.width / numberOfHalves;
			float pWidth = (halfWidth * 2.0f) - 1.0f;
			float pixelXOffset = (y % 2 == 0) ? halfWidth : 0.0f;
			float startY = (fourthHeight * 3.0f) * y;
			float startX = ((halfWidth * 2.0f) * x) + pixelXOffset;
			[view setFrame:CGRectMake(startX, startY, pWidth, pHeight)];
			break;
		}
		case GGM_GRIDTYPE_TRIANGLE: {
			CGRect frame = [self triangleContainingRectForX:x andY:y];
			[view setFrame:frame];
			break;
		}
		default: {
			[view setFrame:CGRectMake((self.gridPixelWidth*x), (self.gridPixelHeight*y), self.gridPixelWidth, self.gridPixelHeight)];
			break;
		}
	}
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
		case GGM_GRIDTYPE_HEX_SQUARE:
		case GGM_GRIDTYPE_HEX: {
			[(GGM_HexView*)view setHexColor:[self colorForGameState:gameState]];
			break;
		}
		case GGM_GRIDTYPE_TRIANGLE: {
			[(GGM_TriangleView*)view setTrianglePointDirection:[self triangleDirectionForX:x andY:y]];
			[(GGM_TriangleView*)view setTriangleColor:[self colorForGameState:gameState]];
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

		case GGM_GRIDTYPE_HEX_SQUARE:
		case GGM_GRIDTYPE_HEX: {
			return [[GGM_HexView alloc] init];
		}

		case GGM_GRIDTYPE_TRIANGLE: {
			return [[GGM_TriangleView alloc] init];
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
			[self addSubview:view];
			[self refreshView:view positionAtX:x andY:y];
			[subarray insertObject:view atIndex:x];
		}
		[self.gridViewArray insertObject:subarray atIndex:y];
	}

	if (self.gridType == GGM_GRIDTYPE_TRIANGLE) {
		[self setupGridViewArrayForTriangles];
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
