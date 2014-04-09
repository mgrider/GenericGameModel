//
//  GGMEx_ViewController.h
//  GGM-Example
//
//  Created by Martin Grider on 4/7/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GGMEx_ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *gridSizeLabel;
@property (weak, nonatomic) IBOutlet UISlider *gridSizeSlider;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gridTypeSegmentedControl;

- (IBAction)gridSizeSliderChanged:(UISlider *)sender;
- (IBAction)gridSizeSliderEndedChanging:(UISlider *)sender;

- (IBAction)typeSegmentedControlValueChanged:(UISegmentedControl *)sender;



@end
