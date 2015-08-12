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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)matrixViewChangedSelectedCell:(MatrixView *)sender {
    NSLog(@"%s, LINE:%d, selected index: %ld", __PRETTY_FUNCTION__, __LINE__, (long)sender.selectedIndex);
}

@end
