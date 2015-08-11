//
//  ColorButton.m
//  GDE
//
//  Created by Anton on 7/8/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit {
    self.layer.cornerRadius           = 20.0f;
    _selection                        = [[UIView alloc] init];
    _selection.frame                  = CGRectMake(6, 6, 28, 28);
    _selection.backgroundColor        = [UIColor clearColor];
    _selection.layer.borderColor      = [UIColor whiteColor].CGColor;
    _selection.layer.borderWidth      = 2.0f;
    _selection.layer.cornerRadius     = 14.0f;
    _selection.tag                    = SELECTED_COLOR_BUTTON_TAG;
    _selection.hidden                 = YES;
    _selection.userInteractionEnabled = NO;
    [self addSubview:_selection];
}

- (void) setSelected:(BOOL)selected {
    _selection.hidden = !selected;
    [super setSelected:selected];
}

@end
