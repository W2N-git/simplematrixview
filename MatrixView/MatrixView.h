//
//  MatrixView.h
//  MatrixView
//
//  Created by Anton Belousov on 07/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixCell.h"

@protocol MatrixViewConfigurator;

IB_DESIGNABLE
@interface MatrixView : UIView

// Matrix Layout
@property (nonatomic) IBInspectable NSInteger rowsCount;
@property (nonatomic) IBInspectable NSInteger columnsCount;
@property (nonatomic) IBInspectable NSInteger selectedIndex;


// Matrix Geometry
@property (nonatomic) IBInspectable CGFloat cellWidth;
@property (nonatomic) IBInspectable CGFloat cellHeight;

@property (nonatomic) IBInspectable CGFloat hOffset;
@property (nonatomic) IBInspectable CGFloat vOffset;

@property (nonatomic) IBInspectable CGFloat hMarginOffset;
@property (nonatomic) IBInspectable CGFloat vMarginOffset;

@property (nonatomic, strong) IBInspectable NSString  *cellClassName;
@property (nonatomic, strong) Class cellClass;

@property (nonatomic, strong) id<MatrixViewConfigurator> matrixViewConfigurator;
@property (nonatomic, strong) IBInspectable NSString *configuratorClassName;


///  Two properties bellow - to use instead of delegate pattern or target/action pattern
@property (nonatomic, copy) BOOL (^onShouldConfigureCellAtIndex)(NSInteger index);
@property (nonatomic, copy) void (^onCellConfigure)(UIView *cell, NSInteger index);
@property (nonatomic, copy) void (^onCellSelectedConfigure)(UIView *cell, NSInteger index);
@property (nonatomic, copy) void (^onCellSelected) (UIView *cell, NSInteger index);
@end


@interface MatrixView ()
- (NSInteger)arrayIndexForRow:(NSInteger)row column:(NSInteger)column;
- (void)getRow:(NSInteger *)row column:(NSInteger *)column forArrayIndex:(NSInteger)arrayIndex;
- (NSInteger)columnForArrayIndex:(NSInteger)arrayIndex;
- (NSInteger)rowForArrayIndex:(NSInteger)arrayIndex;
@end
