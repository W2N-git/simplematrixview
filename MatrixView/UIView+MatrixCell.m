//
//  UIView+MatrixCell.m
//  MatrixView
//
//  Created by Anton Belousov on 11/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import "UIView+MatrixCell.h"

@implementation UIView (MatrixCell)
- (void)setColor:(UIColor *)color {
    self.backgroundColor = color;
}
- (UIColor *)color {
    return self.backgroundColor;
}

- (void)setImage:(UIImage *)image {
}
- (UIImage *)image{
    return nil;
}

- (void)setSelected:(BOOL)selected {}

- (BOOL)isSelected {
    return NO;
}

@end
