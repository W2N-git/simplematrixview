//
//  ViewController.m
//  MatrixView
//
//  Created by Anton Belousov on 07/08/15.
//  Copyright (c) 2015 novilab-mobile. All rights reserved.
//

#import "ViewController.h"
#import "MatrixView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MatrixView *matrixView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.matrixView.cellClass = [UIButton class];
    self.matrixView.onCellConfigure = ^(UIView *cell, NSInteger row, NSInteger column){
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
    
    self.matrixView.layer.borderWidth = 1.0;
    self.matrixView.layer.cornerRadius = 25.0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
