//
//  UIImage+CCPImage.m
//  CCPImageCategory
//
//  Created by 储诚鹏 on 17/2/28.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "UIImage+CCPImage.h"

@implementation UIImage (CCPImage)
/*
 在指定位置截取一个指定大小的透明圈
 rect：截取rect
 */

+ (UIImage *)clearCircleImageWithRect:(CGRect)rect {
    //    CGRect mainBounds = [UIScreen mainScreen].bounds;
    //    UIGraphicsBeginImageContextWithOptions(mainBounds.size, NO, 1.0);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor);
    //    CGContextFillRect(context, mainBounds);
    //    CGContextAddEllipseInRect(context, rect);
    //    CGContextSetBlendMode(context, kCGBlendModeClear);
    //    CGContextFillPath(context);
    //    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return img;
    return [UIImage clearCircleImageWithPath:[UIBezierPath bezierPathWithOvalInRect:rect]];
}

/*
 切出指定形状的透明圈
 path：指定形状
 */
+ (UIImage *)clearCircleImageWithPath:(UIBezierPath *)path {
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContextWithOptions(mainBounds.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor);
    CGContextFillRect(context, mainBounds);
    CGContextAddPath(context, path.CGPath);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextFillPath(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
