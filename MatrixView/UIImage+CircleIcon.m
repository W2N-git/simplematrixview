//
//  UIImage+CircleIcon.m
//  GDE
//
//  Created by qqqqq on 24/07/15.
//  Copyright (c) 2015 C-Plex. All rights reserved.
//

#import "UIImage+CircleIcon.h"

@implementation UIImage (CircleIcon)

+ (UIImage *)circleIconFromImage:(UIImage *)image backgroundColor:(UIColor *)color circleRadius:(CGFloat)radius {

    if (radius == 0) {
        return nil;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
//    NSLog(@"%s, LINE:%d, context: %@", __PRETTY_FUNCTION__, __LINE__, UIGraphicsGetCurrentContext());

    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius * 2, radius * 2), NO, scale);
    
//    NSLog(@"%s, LINE:%d, context: %@", __PRETTY_FUNCTION__, __LINE__, UIGraphicsGetCurrentContext());
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, radius * 2, radius * 2)];
    
    [color set];
    [path fill];
    
    if (image != nil) {
        [[image imageTintedWithColor:[UIColor whiteColor] fraction:0.0] drawInRect:(CGRectMake(radius - image.size.width/2, radius - image.size.height/2, image.size.width, image.size.height))];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    NSLog(@"%s, LINE:%d, context: %@", __PRETTY_FUNCTION__, __LINE__, UIGraphicsGetCurrentContext());
//    NSLog(@"\n\n\n\n");
    
    return newImage;
}


- (UIImage *)imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
        } else {
            UIGraphicsBeginImageContext([self size]);
        }
#else
        UIGraphicsBeginImageContext([self size]);
#endif
        CGRect rect = CGRectZero;
        rect.size = [self size];
        // Composite tint color at its own opacity.
        [color set];
        UIRectFill(rect);
        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        // Finally, composite this image over the tinted mask at desired opacity.
        if (fraction > 0.0) {
            // We want behaviour like NSCompositeSourceOver on Mac OS X.
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    return self;
}

- (UIImage *)addCircleBorderWithColor:(UIColor *)color width:(CGFloat)border {

    if (border == 0) {
        return self;
    }

    CGFloat scale       = [UIScreen mainScreen].scale;
    CGSize  contextSize = CGSizeMake(self.size.width + 2 * border, self.size.height + 2 * border);
    
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, scale);
   
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, contextSize.width, contextSize.height)];
    
    [color set];
    [path fill];
    
    [self drawInRect:(CGRectMake(contextSize.width/2 - self.size.width/2, contextSize.height/2 - self.size.height/2, self.size.width, self.size.height))];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)circleWithDiameter:(CGFloat)diameter color:(UIColor *)color{
    
    UIGraphicsPushContext(UIGraphicsGetCurrentContext());
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx   = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, diameter, diameter)];
    [color setFill];
    [path fill];
    CGContextAddPath(ctx, path.CGPath);
    CGContextDrawPath(ctx, kCGPathFill);
    
    UIImage *image     = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsPopContext();
    return image;
}

@end
