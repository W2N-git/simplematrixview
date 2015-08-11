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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"%s, LINE:%d, cells: %@", __PRETTY_FUNCTION__, __LINE__, self.matrixView.subviews);
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.matrixView.cellClass = [UIButton class];
//    __weak typeof(self) weak_self = self;
//    self.matrixView.onCellConfigure = ^(UIView *cell, NSInteger index){
//        NSInteger row    = [weak_self.matrixView rowForArrayIndex:index];
//        NSInteger column = [weak_self.matrixView columnForArrayIndex:index];
//        if ((row + column) % 2 == 0) {
//            cell.backgroundColor = [UIColor greenColor];
//        } else {
//            cell.backgroundColor = [UIColor redColor];
//        }
//
//        if ([cell isKindOfClass:[UIButton class]]) {
//            [(UIButton *)cell setTitle:[NSString stringWithFormat:@"%ld - %ld", (long)row, (long)column]
//                              forState:UIControlStateNormal];
//        }
//    };
    
    self.matrixView.layer.borderWidth = 1.0;
    self.matrixView.layer.cornerRadius = 25.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
