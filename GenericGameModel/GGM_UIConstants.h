//
//  GGM_UIConstants.h
//  DrawCade
//
//  Created by Martin Grider on 1/8/13.
//  Copyright (c) 2013 Abstract Puzzle. All rights reserved.
//

#ifndef GGM_UIConstants_h
#define GGM_UIConstants_h


// IS_IPAD
#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )

// IS_IPHONE_TALL
#define IS_IPHONE_TALL (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone \
&& [[UIScreen mainScreen] bounds].size.height == 568)


#endif
