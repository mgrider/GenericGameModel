//
//  GGMEx_Model.h
//  GGM-Example
//
//  Created by Martin Grider on 4/7/14.
//  Copyright (c) 2014 Abstract Puzzle. All rights reserved.
//

#import "GGM_BaseModel.h"


typedef enum {
	GGMEx_State_none,
	GGMEx_State_1,
	GGMEx_State_2,
	GGMEx_State_3,
	GGMEx_State_4
} GGMEx_State;


@interface GGMEx_Model : GGM_BaseModel


- (void)setStatesToCheckerboard;
- (void)setStatesForTextViews;


@end
