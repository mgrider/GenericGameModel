//
//  GGM_UIViewIsometric.m
//  Henchmen
//
//  Created by Martin Grider on 12/15/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIViewIsometric.h"


@interface GGM_UIViewIsometric ()

@property (assign) int currentDragX;
@property (assign) int currentDragY;

@end


@implementation GGM_UIViewIsometric

@synthesize viewDictInDrawOrderArray = viewDictInDrawOrderArray_;
@synthesize currentDragX = currentDragX_;
@synthesize currentDragY = currentDragY_;
@synthesize dragBeganAtX = dragBeganAtX_;
@synthesize dragBeganAtY = dragBeganAtY_;


#pragma mark - getting the closest point

- (NSDictionary *)closestDictToPoint:(CGPoint)point
{
	// loop through all the tiles to find the closest one
	int x, y;//, closestX, closestY;
	float distanceFromCenter, closestDistanceFromCenter = self.frame.size.width;
	float halfheight = self.gridPixelHeight / 2.0f;
	int dictCount = (int)[viewDictInDrawOrderArray_ count];
//	NSLog(@"halfheight = %f, dictCount = %i", halfheight, dictCount);
	NSDictionary *dict;
	NSDictionary *closestDict;
	UIView *view;
	for (int i=(dictCount-1); i>=0; i--) {
		dict = [viewDictInDrawOrderArray_ objectAtIndex:i];
		x = [[dict objectForKey:kGGM_IsoViewDict_x] intValue];
		y = [[dict objectForKey:kGGM_IsoViewDict_y] intValue];
		view = [self viewForX:x andY:y];
		distanceFromCenter = (fabs(view.center.x - point.x) / 2.0f) + fabs(view.center.y - point.y);
		if (distanceFromCenter < closestDistanceFromCenter) {
			NSLog(@"found a closer xy at %i,%i, distanceFromCenter was %f", x, y, distanceFromCenter);
//			closestX = x;
//			closestY = y;
			closestDistanceFromCenter = distanceFromCenter;
			closestDict = dict;
			if (distanceFromCenter < halfheight) {
				break;
			}
		}
	}
//	x = closestX;
//	y = closestY;
	return closestDict;
}

- (NSDictionary *)closestDictToPoint:(CGPoint)point fromX:(int)x andY:(int)y
{
	UIView *view;
	int closestY = 0, closestX = 0;
	float distanceFromCenter, closestDistance = self.frame.size.width;
	for (int py = y-1; py <= y+1; py++) {
		if (py < 0 || py >= self.game.gridHeight) {
			continue;
		}
		for (int px = x-1; px <= x+1; px++) {
			if (px < 0 || px >= self.game.gridWidth) {
				continue;
			}

			view = [self viewForX:px andY:py];
			distanceFromCenter = (fabs(view.center.x - point.x) / 2.0f) + fabs(view.center.y - point.y);
			if (distanceFromCenter < closestDistance) {
				closestDistance = distanceFromCenter;
				closestX = px;
				closestY = py;
			}
		}
	}
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt:closestX], kGGM_IsoViewDict_x,
			[NSNumber numberWithInt:closestY], kGGM_IsoViewDict_y,
			nil];
}


#pragma mark - taps

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	NSLog(@"self: %@", self.game);

	CGPoint tapPoint = [sender locationInView:self];

//	int x = tapPoint.y / self.gridPixelHeight + self.game.gridWidth / (2 * self.gridPixelWidth);
//	screenY/tileH + screenX / (2*tileW)
//	int y = self.game.gridHeight / self.gridPixelHeight - tapPoint.x / (2 * self.gridPixelHeight);
//	screenY / tileH - screenX / (2*tileW)

	// from tonypa: http://www.tonypa.pri.ee/tbw/tut18.html
//	int x,y;
//	float fy = ((tapPoint.y*2.0f)-tapPoint.x)/2.0f;
//	float fx = tapPoint.x + fy;
//	y = lroundf(fy / self.gridPixelWidth);
//	x = lroundf(fx / self.gridPixelWidth) - 1;

	// yet another try, found here: http://stackoverflow.com/a/13838164/18961
//	int x,y;
//	float fy = ((tapPoint.y*2.0f)-(((self.game.gridHeight-1)*self.gridPixelWidth)/2.0f)+tapPoint.x)/2.0f;
//	float fx = tapPoint.x - fy;
//	y = (fy / self.gridPixelWidth) *2;
//	x = (fx / self.gridPixelWidth) *2;

	// my own attempt
//	int x,y;
//	float halfHeight = self.frame.size.height / 2.0f;
//	float halfWidth = self.frame.size.width / 2.0f;
//	float xOffset = (tapPoint.y < halfHeight) ? (halfWidth / halfHeight) * (halfHeight - tapPoint.y) : (halfWidth / halfHeight) * (tapPoint.y - halfHeight);
//	float realX = tapPoint.x - xOffset;
//	int almostX = realX / self.gridPixelWidth;
//	float leftover = realX - (self.gridPixelWidth * almostX);
//	float almostY = tapPoint.y / self.gridPixelHeight
//
//	NSLog(@"xOffset is %f for frame: %@", xOffset, NSStringFromCGRect(self.frame));

	NSDictionary *closestDict = [self closestDictToPoint:tapPoint];

	int x = [[closestDict objectForKey:kGGM_IsoViewDict_x] intValue];
	int y = [[closestDict objectForKey:kGGM_IsoViewDict_y] intValue];

	int state = [self.game stateAtX:x andY:y];

	NSLog(@"ISOMETRIC tap discovered at: %@, coords: {%i, %i} with state: %i", NSStringFromCGPoint(tapPoint), x, y, state);

	[self handleTapAtX:x andY:y];
}


#pragma mark - drags

- (void)handleDrag:(UIPanGestureRecognizer*)sender
{
	CGPoint dragPoint = [sender locationInView:self];

	if (sender.state == UIGestureRecognizerStateBegan) {
		self.dragPointBegan = dragPoint;
		self.isDragging = YES;

		NSDictionary *closestDict = [self closestDictToPoint:dragPoint];

		int x = [[closestDict objectForKey:kGGM_IsoViewDict_x] intValue];
		int y = [[closestDict objectForKey:kGGM_IsoViewDict_y] intValue];
		self.currentDragX = x;
		self.currentDragY = y;

		self.dragBeganAtX = x;
		self.dragBeganAtY = y;

		[self handleDragAtX:x andY:y];

		NSLog(@"drag started at: %@, coords are: {%i, %i}", NSStringFromCGPoint(dragPoint), x, y);
	}
	else if (sender.state == UIGestureRecognizerStateEnded) {
		self.dragPointEnded = dragPoint;
		self.isDragging = NO;

//		NSLog(@"drag ended at: %@, coords are: {%i, %i}", NSStringFromCGPoint(dragPoint), x, y);
		[self handleDragEnd];
	}
	else {
		self.dragPointCurrent = dragPoint;

		NSDictionary *closestDict = [self closestDictToPoint:dragPoint fromX:self.currentDragX andY:self.currentDragY];
		int x = [[closestDict objectForKey:kGGM_IsoViewDict_x] intValue];
		int y = [[closestDict objectForKey:kGGM_IsoViewDict_y] intValue];

		if (x != self.currentDragX || y != self.currentDragY) {
			self.currentDragX = x;
			self.currentDragY = y;
			[self handleDragAtX:x andY:y];
		}

	}
}

- (void)handleDragAtX:(int)x andY:(int)y
{
	// reverse the state
	int state = [self.game stateAtX:x andY:y];
	int newState = (state == 0) ? 1 : 0;
	[self.game setStateAtX:x andY:y toState:newState];
	[self refreshViewPositionsAndStates];
}


#pragma mark - board drawing and setup

- (void)refreshViewPositionsAndStates
{
	int gameState = 0;
	int x, y;
	UIView *view;
	UIImage *image;
	for (NSDictionary *dict in self.viewDictInDrawOrderArray) {
		x = [[dict objectForKey:kGGM_IsoViewDict_x] intValue];
		y = [[dict objectForKey:kGGM_IsoViewDict_y] intValue];
		view = [[self.gridViewArray objectAtIndex:y] objectAtIndex:x];
		gameState = [self.game stateAtX:x andY:y];
		image = [self imageForGameState:gameState];
		[(UIImageView*)view setImage:image];
	}
}

- (void)setupInitialGridViewArray
{
	// note, this only works with "square" grids
	int gridHeightWidth = self.game.gridWidth;
	self.gridPixelWidth = self.frame.size.width / gridHeightWidth;
	self.gridPixelHeight =  self.frame.size.height / gridHeightWidth;
//	NSLog(@"gridPixelWidth = %f, gridPixelHeight = %f", self.gridPixelWidth, self.gridPixelHeight);

	self.gridViewArray = [NSMutableArray arrayWithCapacity:gridHeightWidth];

	NSMutableArray *subarray;
	int gameState = 0;
	UIView *view;
	float posX, posY;
	float startY = (self.frame.size.height / 2.0f) - (self.gridPixelHeight / 2.0f);
	float startX = 0.0f;
	for (int y = 0; y < gridHeightWidth; y++) {

		subarray = [NSMutableArray arrayWithCapacity:self.game.gridWidth];

		for (int x = 0; x < gridHeightWidth; x++) {

			gameState = [self.game stateAtX:x andY:y];
			view = (UIView*)[self newSubviewForGameState:gameState];

			posX = startX + (x * 0.5f * self.gridPixelWidth);
			posY = startY - (x * 0.5f * self.gridPixelHeight);
//			NSLog(@"posX: %f, posY: %f, ", posX, posY);

			[view setFrame:CGRectMake(posX, posY, self.gridPixelWidth, self.gridPixelHeight)];

			[self addSubview:view];
			[subarray insertObject:view atIndex:x];
		}

		// add the subarray to our gridViewArray
		[self.gridViewArray insertObject:subarray atIndex:y];

		// increment startY
		startY = startY + (self.gridPixelHeight / 2.0f);
		// increment startX
		startX = startX + (self.gridPixelWidth / 2.0f);
	}

	// lets also create a convenience array for updating the view
	// 7,0
	// 6,0 7,1
	// 5,0 6,1, 7,2
	// ...
	// 0,0 1,1 2,2 3,3 4,4 5,5 6,6 7,7
	// 0,1 1,2 2,3 3,4 4,5 5,6 6,7
	// ...
	// 0,5 1,6 2,7
	// 0,6 1,7
	// 0,7
	int totalRows = gridHeightWidth * 2;
	NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:(gridHeightWidth*gridHeightWidth)];
	NSDictionary *dict;
	int maxX = gridHeightWidth - 1;
	int x = maxX;
	int y = 0;
	int tempX, tempY;
	int toDo = 1;
	for (int row = 0; row < totalRows; row++) {

		NSLog(@"setting up row %i (width %i) starting from x,y: %i,%i", row, toDo, x, y);

		for (int i = 0; i < toDo; i++) {
			tempX = x + i;
			tempY = y + i;
			dict = [NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithInt:tempX], kGGM_IsoViewDict_x,
					[NSNumber numberWithInt:tempY], kGGM_IsoViewDict_y,
//					[[self.gridViewArray objectAtIndex:y] objectAtIndex:x], kGGM_IsoViewDict_view,
					nil];
			[tempArr addObject:dict];
		}

		// change ToDo
		if (row < gridHeightWidth -1) {
			x = x - 1;
			toDo = toDo + 1;
		}
		else {
			x = 0;
			y = y + 1;
			toDo = toDo - 1;
		}
	}
	viewDictInDrawOrderArray_ = [NSArray arrayWithArray:tempArr];
}


@end
