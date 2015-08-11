//
//  ToggleButton.m
//  GDE
//
//  Created by Anton on 7/8/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import "ToggleButton.h"
#import "UIImage+CircleIcon.h"

#define SELECTED_COLOR [UIColor colorWithWhite:236.0f/255.0f  alpha:1.0f]
#define SELECTED_CIRCLE_IMAGE_DIAMETER 40.0

@implementation ToggleButton

- (void) setSelected:(BOOL)selected {
    if (selected) {

        UIImage *circleImage = [UIImage circleWithDiameter:SELECTED_CIRCLE_IMAGE_DIAMETER color:SELECTED_COLOR];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:circleImage];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:imageView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        imageView.tag = 666;
        
    } else {
        [[self viewWithTag:666] removeFromSuperview];
    }
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (UIImage *)image {
    return [self imageForState:UIControlStateNormal];
}

- (void)setColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (UIColor *)color {
    return self.backgroundColor;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self sendSubviewToBack:[self viewWithTag:666]];
}


@end
