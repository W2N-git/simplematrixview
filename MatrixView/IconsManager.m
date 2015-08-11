//
//  IconsManager.m
//  GDE
//
//  Created by qqqqq on 24/07/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import "IconsManager.h"

#define DEFAULT_NUMBER_OF_ICONS 12

@implementation IconsManager
- (NSInteger)maxNumberOfCells {
    return DEFAULT_NUMBER_OF_ICONS;
}

- (NSInteger)numberOfIcons {
    return DEFAULT_NUMBER_OF_ICONS;
}

- (NSString *)iconNameAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"icon%d", (int)index + 1];
}

- (NSInteger)indexForIconName:(NSString *)iconName {
    if ([iconName hasPrefix:@"icon"]) {
        NSString *suffix = [iconName stringByReplacingOccurrencesOfString:@"icon"
                                                               withString:@""
                                                                  options:kNilOptions range:NSMakeRange(0, iconName.length)];
        return suffix.integerValue - 1;
    }
    return -1;
}


- (void)configureCell:(id<MatrixCell>)cell atIndex:(NSInteger)index {
    if (index < self.numberOfIcons) {
        NSString *icon = [self iconNameAtIndex:index];
        cell.image     = [UIImage imageNamed:icon
                                    inBundle:[NSBundle bundleForClass:[self class]]
               compatibleWithTraitCollection:nil];
    }
}

@end
