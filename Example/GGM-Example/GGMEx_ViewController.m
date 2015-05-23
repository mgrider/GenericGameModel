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

@property (weak, nonatomic) IBOutlet UILabel *gridSizeLabelX;
@property (weak, nonatomic) IBOutlet UILabel *gridSizeLabelY;
@property (weak, nonatomic) IBOutlet UISlider *gridSizeSliderX;
@property (weak, nonatomic) IBOutlet UISlider *gridSizeSliderY;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gridTypeSegmentedControl;

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
	int sizeX = self.gridSizeSliderX.value;
	int sizeY = self.gridSizeSliderY.value;
	self.gameModel = [GGMEx_Model instanceWithWidth:sizeX andHeight:sizeY];

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
	[self.gridSizeLabelX setText:[@((int)self.gridSizeSliderX.value) stringValue]];
	[self.gridSizeLabelY setText:[@((int)self.gridSizeSliderY.value) stringValue]];
}

- (IBAction)gridSizeSliderChanged:(UISlider *)sender
{
	[self updateGridSizeLabel];
}

- (IBAction)gridSizeSliderEndedChanging:(UISlider *)sender
{
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
		case 3: {
			// triangles
			self.viewType = GGM_GRIDTYPE_TRIANGLE;
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
