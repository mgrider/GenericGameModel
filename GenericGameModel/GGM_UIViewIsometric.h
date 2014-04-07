//
//  GGM_UIViewIsometric.h
//  Henchmen
//
//  Created by Martin Grider on 12/15/12.
//  Copyright (c) 2012 Abstract Puzzle. All rights reserved.
//

#import "GGM_UIView.h"


// keys for viewDictInDrawOrderArray
#define kGGM_IsoViewDict_x @"kGGM_IsoViewDict_x"
#define kGGM_IsoViewDict_y @"kGGM_IsoViewDict_y"
#define kGGM_IsoViewDict_view @"kGGM_IsoViewDict_view"


@interface GGM_UIViewIsometric : GGM_UIView


@property (strong) NSArray *viewDictInDrawOrderArray;

@property (assign) int dragBeganAtX;
@property (assign) int dragBeganAtY;


- (void)setupInitialGridViewArray;


@end
