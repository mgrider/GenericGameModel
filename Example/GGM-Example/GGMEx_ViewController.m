//
//  GGMEx_ViewController.m
//  GGM-Example
//
//  Created by Martin Grider on 4/7/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import "GGMEx_ViewController.h"
#import "GGMEx_Model.h"
#import "GGMEx_View.h"


@interface GGMEx_ViewController ()
@property (nonatomic, strong) GGMEx_Model *gameModel;
@property (nonatomic, strong) GGMEx_View *gameView;
@property (nonatomic, assign) GGM_GridType viewType;
@end


@implementation GGMEx_ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

	// setup our GGM_BaseModel and GGM_View subclasses here
	// default type is color
	self.viewType = GGM_GRIDTYPE_COLOR;
	[self setupGameModelAndViewFromGridSize];
}


#pragma mark - gameView

- (void)setupGameModelAndViewFromGridSize
{
	// new model
	int size = self.gridSizeSlider.value;
	self.gameModel = [GGMEx_Model instanceWithWidth:size andHeight:size];

	switch (self.viewType) {
		case GGM_GRIDTYPE_TEXTLABEL: {
			[self.gameModel setStatesForTextViews];
			break;
		}
		default: {
			[self.gameModel setStatesToCheckerboard];
			break;
		}
	}

	// remove any existing gameView
	if (self.gameView != nil) {
		// if we have an old one, let's clean it up
		[self.gameView removeFromSuperview];
	}
	// init the new gameView (hard-coding this centered)
	self.gameView = [[GGMEx_View alloc] initWithFrame:CGRectMake(0.0f, ((1024.0f-768.0f) / 2.0f), 768.0f, 768.0f)];
	[self.view addSubview:self.gameView];

	// set the type of subviews
	[self.gameView setGridType:self.viewType];

	// setup the views
	[self.gameView setGame:self.gameModel];

	// tell it to recognize taps
	[self.gameView setRecognizesTaps:YES];

	// tell it to recognize drags
	[self.gameView setRecognizesDrags:YES];

	// refresh the views
	[self.gameView refreshViewPositionsAndStates];
}


#pragma mark - dealing with the gridSize

- (void)updateGridSizeLabel
{
	[self.gridSizeLabel setText:[@((int)self.gridSizeSlider.value) stringValue]];
}

- (IBAction)gridSizeSliderChanged:(UISlider *)sender
{
	// just update the label
	[self updateGridSizeLabel];
}

- (IBAction)gridSizeSliderEndedChanging:(UISlider *)sender
{
	// update the game view
	[self setupGameModelAndViewFromGridSize];
}


#pragma mark - dealing with grid type

- (IBAction)typeSegmentedControlValueChanged:(UISegmentedControl *)sender
{
	switch (sender.selectedSegmentIndex) {
		case 1: {
			// hex
			self.viewType = GGM_GRIDTYPE_HEX;
			break;
		}
		case 2: {
			// label
			self.viewType = GGM_GRIDTYPE_TEXTLABEL;
			break;
		}
		default:
		case 0: {
			// grid
			self.viewType = GGM_GRIDTYPE_COLOR;
			break;
		}
	}
	[self setupGameModelAndViewFromGridSize];
}


@end
