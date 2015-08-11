//
//  ColorsManager.m
//  GDE
//
//  Created by qqqqq on 24/07/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import "ColorsManager.h"
#import "UIColor+HexColors.h"
//#import "Storage.h"

@implementation ColorsManager {
    NSArray *_colors;
}

+ (instancetype)sharedManager {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    if (self = [super init]) {
        _colors = @[
                    @"1399de",
                    @"59d0fe",
                    @"0d3890",
                    @"d8ef38",
                    @"a5b925",
                    @"1fd510",
                    @"fa1aae",
                    @"d51042",
                    @"fb5438",
                    @"be00fc",
                    ];
    }
    return self;
}

- (NSInteger)numberOfColors {
    return _colors.count;
}

- (NSInteger)indexForColorWithCode:(NSString *)colorCode {
    
    for (int i = 0; i < _colors.count; i++) {
        if ([_colors[i] caseInsensitiveCompare:colorCode] == NSOrderedSame) {
            return i;
        }
    }
    return 0;
}

- (NSString *)colorCodeAtIndex:(NSInteger)index {
    return _colors[index];
}

- (BOOL)configureCell:(id<MatrixCell>)cell atIndex:(NSInteger)index {
    if (index < _colors.count) {
        cell.color = [UIColor colorWithHexString:_colors[index]];
        return YES;
    }
    return NO;
}

@end
