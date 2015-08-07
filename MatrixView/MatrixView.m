//
//  MatrixView.m
//  MatrixView
//
//  Created by Anton Belousov on 07/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import "MatrixView.h"

@implementation MatrixView {
    NSArray *_cells;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)clearCells {
    for (UIView *cell in _cells) {
        [cell removeFromSuperview];
    }
}

- (void)createAndPlaceCells {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger rowIndex = 0; rowIndex < self.numberOfRows; rowIndex++) {
        for (NSInteger columnIndex = 0; columnIndex < self.numberOfCoulmns; columnIndex++) {
            [array addObject:[self createCellForRow:rowIndex column:columnIndex]];
        }
    }
    _cells = array;
}

- (UIView *)createCellForRow:(NSInteger)row column:(NSInteger)column {
    
    if ([self.cellClass isSubclassOfClass:[UIView class]]) {
        UIView *cell = [[self.cellClass alloc] init];
        [self configureCell:cell atFor:row column:column];
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UIView *)cell atFor:(NSInteger)row column:(NSInteger)column {
    //TODO: Implement this method (maybe use delegate or closure)
}

- (void)configureConstraintsForCell:(UIView *)cell atRow:(NSInteger)row colunm:(NSInteger)column {
    //TODO: Implement this method
}


- (UIView *)cellAtRow:(NSInteger)row column:(NSInteger)column {
    NSInteger index = [self arrayIndexForRow:row column:column];
    if (index < _cells.count) {
        return _cells[index];
    }
    return nil;
}

- (NSInteger)arrayIndexForRow:(NSInteger)row column:(NSInteger)column {
    return self.numberOfCoulmns * row + column;
}


- (void)getRow:(NSInteger *)row column:(NSInteger *)column forArrayIndex:(NSInteger)arrayIndex {
 
    *row    = arrayIndex/self.numberOfCoulmns;
    *column = arrayIndex%self.numberOfCoulmns;
}

@end
