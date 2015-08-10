//
//  MatrixView.m
//  MatrixView
//
//  Created by Anton Belousov on 07/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import "MatrixView.h"

@interface MatrixView ()
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic) BOOL cellsNeedToBeUpdated;
@end

@implementation MatrixView

#pragma mark - Properties

- (void)setCellClassName:(NSString *)cellClassName {
    _cellClassName = cellClassName;
    self.cellClass = NSClassFromString(cellClassName);
    self.cellsNeedToBeUpdated = YES;
}

- (void)setCellClass:(Class)cellClass {
    Class oldValue = self.cellClass;
    _cellClass = cellClass;
    if (oldValue != cellClass) {
        self.cellsNeedToBeUpdated = YES;
    }
}

- (void)setNumberOfRows:(NSInteger)numberOfRows {
    NSInteger oldValue = self.numberOfRows;
    _numberOfRows = numberOfRows;
    if (oldValue != numberOfRows) {
        self.cellsNeedToBeUpdated = YES;
    }
}

- (void)setNumberOfCoulmns:(NSInteger)numberOfCoulmns {
    NSInteger oldValue = self.numberOfCoulmns;
    _numberOfCoulmns = numberOfCoulmns;
    if (oldValue != numberOfCoulmns) {
        self.cellsNeedToBeUpdated = YES;
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.cellsNeedToBeUpdated) {
        [self clearCells];
        [self createAndPlaceCells];
        self.cellsNeedToBeUpdated = NO;
    }
}

- (void)clearCells {
    for (UIView *cell in _cells) {
        [cell removeFromSuperview];
    }
    self.cells = nil;
}

- (void)createAndPlaceCells {
    
    self.cells = [NSMutableArray array];
    
    for (NSInteger rowIndex = 0; rowIndex < self.numberOfRows; rowIndex++) {
        for (NSInteger columnIndex = 0; columnIndex < self.numberOfCoulmns; columnIndex++) {

            UIView *cell = [self createAndConfigureCellForRow:rowIndex column:columnIndex];
            [self.cells addObject:cell];
            [self addSubview:cell];
            [self configureConstraintsForCell:cell atRow:rowIndex colunm:columnIndex];
        }
    }
}

- (UIView *)createAndConfigureCellForRow:(NSInteger)row column:(NSInteger)column {
    
    if ([self.cellClass isSubclassOfClass:[UIView class]]) {
        UIView *cell;
        if ([cell isKindOfClass:[UIButton class]]) {
            cell = [UIButton buttonWithType:UIButtonTypeCustom];
        } else {
            cell = [[self.cellClass alloc] init];
        }
       
        
        [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self configureCell:cell atFor:row column:column];
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UIView *)cell atFor:(NSInteger)row column:(NSInteger)column {
    //TODO: Implement this method (maybe use delegate or closure)
    if (self.onCellConfigure){
        self.onCellConfigure(cell, row, column);
    }
}

- (void)configureConstraintsForCell:(UIView *)cell atRow:(NSInteger)row colunm:(NSInteger)column {
    if (cell.superview == nil) {
        abort();
    }
    [self setHorizontalConstraintsForCell:cell atRow:row column:column];
    [self setVerticalConstraintsForCell:cell   atRow:row column:column];
}

- (void)setHorizontalConstraintsForCell:(UIView *)cell atRow:(NSInteger)row column:(NSInteger)column {

    //TODO: Implement this method
    if (column == 0) {
        //TODO: C to left
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:0.0]];
    } else {
        //TODO: C to cell at left
        UIView *cellAtLeft = [self cellAtRow:row column:column - 1];
        if (cellAtLeft.superview == nil) {
            abort();
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cellAtLeft
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0.0]];
        //TODO: C for Width
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cellAtLeft
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
    
    if (column == self.numberOfCoulmns - 1) {
        //TODO: C to right
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
}


- (void)setVerticalConstraintsForCell:(UIView *)cell atRow:(NSInteger)row column:(NSInteger)column {
    
    if (row == 0) {
        //TODO: c to top
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
        
    } else {
        //TODO: C to cell at top
        UIView *cellAtTop = [self cellAtRow:row - 1 column:column];
        if (cellAtTop.superview == nil) {
            abort();
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cellAtTop
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        //TODO: C for Height
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cellAtTop
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
    
    if (row == self.numberOfRows - 1) {
        //TODO: c to bottom
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cell
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
}



#pragma mark -

- (UIView *)cellAtRow:(NSInteger)row column:(NSInteger)column {
    NSInteger index = [self arrayIndexForRow:row column:column];
    if (index < _cells.count) {
        return _cells[index];
    }
    return nil;
}


#pragma mark - Geometry

- (NSInteger)arrayIndexForRow:(NSInteger)row column:(NSInteger)column {
    return self.numberOfCoulmns * row + column;
}


- (void)getRow:(NSInteger *)row column:(NSInteger *)column forArrayIndex:(NSInteger)arrayIndex {
 
    *row    = arrayIndex/self.numberOfCoulmns;
    *column = arrayIndex%self.numberOfCoulmns;
}

//
- (void)prepareForInterfaceBuilder {
    
    if (self.cellClass == nil)
        self.cellClass = UIButton.class;

    self.onCellConfigure = ^(UIView *cell, NSInteger row, NSInteger column){
        if ((row + column) % 2 == 0) {
            cell.backgroundColor = [UIColor greenColor];
        } else {
            cell.backgroundColor = [UIColor redColor];
        }
        
        if ([cell isKindOfClass:[UIButton class]]) {
            [(UIButton *)cell setTitle:[NSString stringWithFormat:@"%ld - %ld", (long)row, (long)column]
                              forState:UIControlStateNormal];
        }
    };
}

@end
