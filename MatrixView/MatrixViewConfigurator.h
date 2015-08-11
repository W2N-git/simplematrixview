//
//  MatrixViewConfigurator.h
//  MatrixView
//
//  Created by Anton Belousov on 11/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#ifndef MatrixView_MatrixViewConfigurator_h
#define MatrixView_MatrixViewConfigurator_h
#import <UIKit/UIKit.h>

@protocol MatrixCell;
@protocol MatrixViewConfigurator <NSObject>
- (NSInteger)maxNumberOfCells;
- (void)configureCell:(id<MatrixCell>)cell atIndex:(NSInteger)index;
@end

#endif
