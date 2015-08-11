//
//  ColorButton.h
//  GDE
//
//  Created by Anton on 7/8/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixCell.h"
#define SELECTED_COLOR_BUTTON_TAG 3333
@interface ColorButton : UIButton <MatrixCell>
@property (strong, nonatomic) UIView* selection;
@end
