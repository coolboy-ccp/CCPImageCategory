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

/*
 截取图片的一部分
 */
- (UIImage *)clipImageInRect:(CGRect)rect {
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:imgRef];
}

/*
 为图片添加水印(合并两张图片)
 waterImg:水印图片
 rect:水印图片rect
 */
- (UIImage *)addWatermarkWithImage:(UIImage *)waterImg rect:(CGRect)rect {
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [waterImg drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/*
 为图片添加文字
 text:需要添加的文字
 font：字体
 color：颜色
 rect：文字rect
 
 */
- (UIImage *)addTextWithString:(NSString *)text font:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect {
    return nil;
}

@end
