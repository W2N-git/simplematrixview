//
//  UIView+MatrixCell.h
//  MatrixView
//
//  Created by Anton Belousov on 11/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MatrixCell)
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIImage *image;
@end
