//
//  GGM_UIConstants.h
//  DrawCade
//
//  Created by Martin Grider on 1/8/13.
//  Copyright (c) 2013 Abstract Puzzle. All rights reserved.
//

#ifndef GGM_UIConstants_h
#define GGM_UIConstants_h


// enums
typedef enum {
	GGM_GRIDTYPE_IMAGE,
	GGM_GRIDTYPE_COLOR,
	GGM_GRIDTYPE_TEXTLABEL,
	GGM_GRIDTYPE_HEX,
	GGM_GRIDTYPE_CUSTOM
} GGM_GridType;

typedef enum {
	GGM_DRAG_DIRECTION_NONE,
	GGM_DRAG_DIRECTION_HORIZONTAL,
	GGM_DRAG_DIRECTION_VERTICAL,
} GGM_DragDirection;

typedef enum {
	GGM_MOVE_DIRECTION_NONE,
	GGM_MOVE_DIRECTION_UP,
	GGM_MOVE_DIRECTION_DOWN,
	GGM_MOVE_DIRECTION_LEFT,
	GGM_MOVE_DIRECTION_RIGHT
} GGM_MoveDirection;


// IS_IPAD
#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )

// IS_IPHONE_TALL
#define IS_IPHONE_TALL (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone \
&& [[UIScreen mainScreen] bounds].size.height == 568)


#endif
