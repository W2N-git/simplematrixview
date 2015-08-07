//
//  MatrixView.h
//  MatrixView
//
//  Created by Anton Belousov on 07/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MatrixView : UIView
@property (nonatomic) IBInspectable         NSInteger numberOfRows;
@property (nonatomic) IBInspectable         NSInteger numberOfCoulmns;
@property (nonatomic, strong) IBInspectable NSString *cellClassName;
@property (nonatomic, strong) Class cellClass;
@end
