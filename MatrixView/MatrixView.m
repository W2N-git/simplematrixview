//
//  MatrixView.m
//  MatrixView
//
//  Created by Anton Belousov on 07/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import "MatrixView.h"

#define ROW_MULTIPLIER 1000
#define CELL_TAG_SHIFT 345



@interface MatrixView ()
@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, strong) NSMutableArray *verticalPaddingsConstraints;
@property (nonatomic, strong) NSMutableArray *horizontalPaddingsConstraints;

@property (nonatomic) BOOL cellsNeedToBeUpdated;
@property (nonatomic) BOOL selectedCellIndexChanged;
@property (nonatomic, strong) UIView *selectedCell;
@property (nonatomic) CGFloat oldWidth;
@property (nonatomic) CGFloat oldHeight;
@end

@interface MatrixView (Layout)
- (void)configureCellsLayout;
- (void)updatePaddingsConstraints;
@end;


@implementation MatrixView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.cellClass == nil) {
        self.cellClass = [UIView class];
    }
}

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

- (void)setRowsCount:(NSInteger)rowsCount {
    NSInteger oldValue = self.rowsCount;
    _rowsCount = rowsCount;
    if (oldValue != rowsCount) {
        self.cellsNeedToBeUpdated = YES;
    }
}

- (void)setColumnsCount:(NSInteger)columnsCount {
    NSInteger oldValue = self.columnsCount;
    _columnsCount = columnsCount;
    if (oldValue != columnsCount) {
        self.cellsNeedToBeUpdated = YES;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    NSInteger oldValue = self.selectedIndex;
    _selectedIndex   = selectedIndex;
    if (oldValue != selectedIndex) {
        self.selectedCellIndexChanged = YES;
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];

    NSDate *date = [NSDate date];

    if (self.cellsNeedToBeUpdated) {
        [self clearCells];
        [self createCells];
        [self configureCellsLayout];
        self.cellsNeedToBeUpdated = NO;
    } else {
        if (self.frame.size.height != self.oldHeight ||
            self.frame.size.width  != self.oldWidth
            ) {
            [self updatePaddingsConstraints];
            self.oldWidth  = self.frame.size.width;
            self.oldHeight = self.frame.size.height;
        }
    }

    if (self.selectedCellIndexChanged) {
        NSInteger row    = [self rowForArrayIndex:self.selectedIndex];
        NSInteger column = [self columnForArrayIndex:self.selectedIndex];
        UIView *cell     = [self cellAtRow:row column:column];
        [self configureCellAsSelected:cell row:row column:column];
    }
    
    NSLog(@"%s, LINE:%d, time: %f", __PRETTY_FUNCTION__, __LINE__, [[NSDate date] timeIntervalSinceDate:date]);
}

- (void)clearCells {
    for (UIView *cell in _cells) {
        [cell removeFromSuperview];
    }
    self.cells = nil;
}

- (void)createCells {
    
    self.cells = [NSMutableArray array];
    
    for (NSInteger rowIndex = 0; rowIndex < self.rowsCount; rowIndex++) {
        for (NSInteger columnIndex = 0; columnIndex < self.columnsCount; columnIndex++) {

            UIView *cell = [self createAndConfigureCellForRow:rowIndex column:columnIndex];
            [self.cells addObject:cell];
            [self addSubview:cell];
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

        [self configureCell:cell atRow:row column:column];
        
        [self configureCellForActions:cell atRow:row column:column];
        return cell;
    }
    
    return nil;
}

- (void)configureCellForActions:(UIView *)cell atRow:(NSInteger)row column:(NSInteger)column {
    if ([cell isKindOfClass:[UIButton class]]) {
        [(UIButton *)cell addTarget:self action:@selector(cellSelected:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelected:)]];
    }
}

- (void)configureCell:(UIView *)cell atRow:(NSInteger)row column:(NSInteger)column {
    //TODO: Implement this method (maybe use delegate or closure)
//    cell.hidden = YES;
    cell.tag = [self tagForCellAtRow:row column:column];
    if (self.onCellConfigure){
        self.onCellConfigure(cell, row, column);
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


#pragma mark - Matrix and Indexes

- (NSInteger)arrayIndexForRow:(NSInteger)row column:(NSInteger)column {
    return self.columnsCount * row + column;
}

- (void)getRow:(NSInteger *)row column:(NSInteger *)column forArrayIndex:(NSInteger)arrayIndex {
 
    *row    = arrayIndex/self.columnsCount;
    *column = arrayIndex%self.columnsCount;
}

- (NSInteger)columnForArrayIndex:(NSInteger)arrayIndex {
    return arrayIndex%self.columnsCount;
}

- (NSInteger)rowForArrayIndex:(NSInteger)arrayIndex {
    return arrayIndex/self.columnsCount;
}


- (NSInteger)tagForCellAtRow:(NSInteger)row column:(NSInteger)column {
    return row * ROW_MULTIPLIER + column + CELL_TAG_SHIFT;
}

- (void)getRow:(NSInteger *)row column:(NSInteger *)column forCellTag:(NSInteger)tag {

    NSInteger realTag = tag - CELL_TAG_SHIFT;
    *row              = realTag/ROW_MULTIPLIER;
    *column           = realTag%ROW_MULTIPLIER;
}

#pragma mark - actions
//???: Here are selection logic
/* 
 1. Once cell selected matrix view will always have selected cell
 2. If user tries selecting already selected cell - nothing changes
 Complex challenges (e.g. multiple selections) may require more complex cell selection logic
 */

- (void)cellSelected:(UIView *)cell {

    NSInteger row    = 0;
    NSInteger column = 0;
    
    [self getRow:&row column:&column forCellTag:cell.tag];
    
    NSInteger selectedIndex = [self arrayIndexForRow:row column:column];
    
    if (selectedIndex != self.selectedIndex) {
        
        [self configureCellAsSelected:cell row:row column:column];
        
        if (self.onCellSelected){
            self.onCellSelected(cell, row, column);
        }
    }
}

- (void)configureCellAsSelected:(UIView *)cell row:(NSInteger)row column:(NSInteger)column {
    
    NSLog(@"%s, LINE:%d, cell: %@", __PRETTY_FUNCTION__, __LINE__, cell);

    
    if ([cell conformsToProtocol:@protocol(MatrixCell)]) {
        
        UIView <MatrixCell> *newCell = (UIView <MatrixCell> *)cell;
        UIView <MatrixCell> *oldCell = (UIView <MatrixCell> *)self.selectedCell;
        
        if (newCell != oldCell) {
            
            NSInteger selectedIndex = [self arrayIndexForRow:row column:column];
            
            oldCell.selected = NO;
            newCell.selected = YES;
            
//            newCell.backgroundColor = [UIColor blueColor];
            
            self.selectedCell  = cell;
            self.selectedIndex = selectedIndex;
        }
    }
}

@end


@implementation MatrixView (some_ext)

- (void)prepareForInterfaceBuilder {
    
//    if (self.cellClass == nil)
  //      self.cellClass = UIButton.class;
    
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


#pragma mark - Configuring Layout

@implementation MatrixView (Layout)

- (void)configureCellsLayout {

    [self adjustGeometryPropertiesValues];
    
//    self.horizontalBorderPaddingsConstraints = [NSMutableArray array];
    self.horizontalPaddingsConstraints       = [NSMutableArray array];
//    self.verticalBorderPaddingsConstraints   = [NSMutableArray array];
    self.verticalPaddingsConstraints         = [NSMutableArray array];
    
    for (NSInteger rowIndex = 0; rowIndex < self.rowsCount; rowIndex++) {
        for (NSInteger columnIndex = 0; columnIndex < self.columnsCount; columnIndex++) {
            UIView *cell = [self cellAtRow:rowIndex column:columnIndex];
            [self configureCellsLayoutWithStaticCellSizesForCell:cell atRow:rowIndex colunm:columnIndex];
        }
    }
}

- (void)adjustGeometryPropertiesValues {
    if (self.cellHeight != 0 && self.cellWidth != 0) {
        self.vOffset = 0;
        self.hOffset = 0;
    } else {
        self.cellWidth  = 0;
        self.cellHeight = 0;
    }
}

- (void)configureCellsLayoutWithStaticCellSizesForCell:(UIView *)cell atRow:(NSInteger)row colunm:(NSInteger)column {
    if (cell.superview == nil) {
        abort();
    }
    [self setHorizontalConstraintsForCell:cell atRow:row column:column];
    [self setVerticalConstraintsForCell:cell   atRow:row column:column];
}

#pragma mark - Horizontal Layout

- (void)setHorizontalConstraintsForCell:(UIView *)cell atRow:(NSInteger)row column:(NSInteger)column {

    if (column == 0) {
        [self setHorizontalConstraintsFromCellToLeftBorder:cell];
    } else {
        UIView *cellAtLeft = [self cellAtRow:row column:column - 1];
        if (cellAtLeft.superview == nil) {
            abort();
        }
        [self pinHorizontallyCell:cell toCell:cellAtLeft];
    }
    
    if (column == self.columnsCount - 1) {
        [self setHorizontalConstraintsFromCellToRightBorder:cell];
    }
}

- (void)setHorizontalConstraintsFromCellToLeftBorder:(UIView *)cell {
    //TODO: C to left
    NSLayoutConstraint *horizontalBorderPaddingC = [NSLayoutConstraint constraintWithItem:cell
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0
                                                                                 constant:self.hMarginOffset];
    
    [self addConstraint:horizontalBorderPaddingC];
}

- (void)pinHorizontallyCell:(UIView *)rightCell toCell:(UIView *)leftCell {

    //TODO: C to cell at left
    
    CGFloat padding = 0.0;
    
    if (self.cellWidth == 0) {
    
        padding = self.hOffset;
    
    } else {
        if (self.columnsCount > 1)
        padding = (self.frame.size.width - 2 * self.hMarginOffset - self.columnsCount * self.cellWidth)/(self.columnsCount - 1);
    }
    
    NSLayoutConstraint *horizontalPaddingC = [NSLayoutConstraint constraintWithItem:rightCell
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:leftCell
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:padding];
    horizontalPaddingC.priority = 999;

    [self.horizontalPaddingsConstraints addObject:horizontalPaddingC];
    
    //TODO: C for Width
    NSLayoutConstraint *equalWidthsC =[NSLayoutConstraint constraintWithItem:rightCell
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:leftCell
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0
                                                                    constant:0.0];

    [self addConstraints:@[horizontalPaddingC, equalWidthsC]];
}

- (void)setHorizontalConstraintsFromCellToRightBorder:(UIView *)cell {
    //TODO: C to right
    NSLayoutConstraint *horizontalBorderPaddingC =[NSLayoutConstraint constraintWithItem:self
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:cell
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1.0
                                                                                constant:self.hMarginOffset];
    [self addConstraint:horizontalBorderPaddingC];
}

#pragma mark - Vertical Layout

- (void)setVerticalConstraintsForCell:(UIView *)cell atRow:(NSInteger)row column:(NSInteger)column {
    
    if (row == 0) {
        [self setVerticalConstraintsFromCellToTopBorder:cell];
        
    } else {
        //TODO: C to cell at top
        UIView *cellAtTop = [self cellAtRow:row - 1 column:column];
        if (cellAtTop.superview == nil) {
            abort();
        }
        
        [self pinVerticallyCell:cell toCell:cellAtTop];
    }
    
    if (row == self.rowsCount - 1) {
        [self setVerticalConstraintsFromCellToBottomBorder:cell];
    }
}

- (void)setVerticalConstraintsFromCellToTopBorder:(UIView *)cell {
    //TODO: c to top
    NSLayoutConstraint *verticalBorderPaddingC = [NSLayoutConstraint constraintWithItem:cell
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:self.vMarginOffset];
    [self addConstraint:verticalBorderPaddingC];
}

- (void)pinVerticallyCell:(UIView *)bottomCell toCell:(UIView *)topCell {

    CGFloat padding = 0.0;
    
    if (self.cellHeight == 0) {
        
        padding = self.vOffset;
        
    } else {
        if (self.rowsCount > 1)
            padding = (self.frame.size.height - 2 * self.vMarginOffset - self.rowsCount * self.cellHeight)/(self.rowsCount - 1);
    }
    
    NSLayoutConstraint *verticalPaddingC = [NSLayoutConstraint constraintWithItem:bottomCell
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:topCell
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:padding];
    verticalPaddingC.priority = 999;
    //TODO: C for Height
    NSLayoutConstraint *equalHeightsC = [NSLayoutConstraint constraintWithItem:bottomCell
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:topCell
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:1.0
                                                                      constant:0.0];
    
    [self.verticalPaddingsConstraints addObject:verticalPaddingC];
    [self addConstraints:@[verticalPaddingC, equalHeightsC]];
}

- (void)setVerticalConstraintsFromCellToBottomBorder:(UIView *)cell {
    //TODO: c to bottom
    NSLayoutConstraint *verticalBorderPaddingC = [NSLayoutConstraint constraintWithItem:self
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:cell
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:self.vMarginOffset];
    [self addConstraint:verticalBorderPaddingC];
}

#pragma mark - constraints update

- (void)updatePaddingsConstraints {
    if (self.cellHeight != 0 && self.cellWidth != 0) {
        [self updateHorizontalPaddingsConstraints];
        [self updateVerticalPaddingsConstraints];
    }
}

- (void)updateHorizontalPaddingsConstraints {
    if (self.columnsCount > 1) {
        for (NSLayoutConstraint *c in self.horizontalPaddingsConstraints) {
            c.constant = (self.frame.size.width - 2 * self.hMarginOffset - self.columnsCount * self.cellWidth)/(self.columnsCount - 1);
        }
    }
}

- (void)updateVerticalPaddingsConstraints {
    if (self.rowsCount > 1) {
        for (NSLayoutConstraint *c in self.verticalPaddingsConstraints) {
            c.constant = (self.frame.size.height - 2 * self.vMarginOffset - self.rowsCount * self.cellHeight)/(self.rowsCount - 1);
        }
    }
}

@end

