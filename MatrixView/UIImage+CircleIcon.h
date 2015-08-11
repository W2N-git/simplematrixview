//
//  UIImage+CircleIcon.h
//  GDE
//
//  Created by qqqqq on 24/07/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleIcon)
+ (UIImage *)circleIconFromImage:(UIImage *)image backgroundColor:(UIColor *)color circleRadius:(CGFloat)radius;
- (UIImage *)addCircleBorderWithColor:(UIColor *)color width:(CGFloat)border;
+ (UIImage *)circleWithDiameter:(CGFloat)diameter color:(UIColor *)color;
@end
