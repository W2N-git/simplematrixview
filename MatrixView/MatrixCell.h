//
//  MatrixCell.h
//  MatrixView
//
//  Created by Anton Belousov on 11/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#ifndef MatrixView_MatrixCell_h
#define MatrixView_MatrixCell_h
#import <UIKit/UIKit.h>
@protocol MatrixCell <NSObject>
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIImage *image;
@end

#endif
