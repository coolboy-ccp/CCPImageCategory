//
//  UIImage+CCPImage.h
//  CCPImageCategory
//
//  Created by 储诚鹏 on 17/2/28.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CCPImage)

/*
 根据字符串生成二维码
 size：生成的尺寸
 red：color.red
 green: color.green
 blue: color.blue
 qrString: 需要生成二维码的字符串
 */
- (UIImage*)imageWithSize:(CGFloat)size andColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andQRString:(NSString *)qrString;

/*
 为图片添加文字
 text:需要添加的文字
 font：字体
 color：颜色
 rect：文字rect
 
 */
- (UIImage *)addTextWithString:(NSString *)text font:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect;

/*
 为图片添加水印(合并两张图片)
 waterImg:水印图片
 rect:水印图片rect
 */
- (UIImage *)addWatermarkWithImage:(UIImage *)waterImg rect:(CGRect)rect;

/*
 截取图片(不规则)
 rect:图片rect
 */

- (void)clipImageWithPath:(UIBezierPath *)path rect:(CGRect)rect;

/*
 截取图片的一部分(矩形)
 */
- (UIImage *)clipImageInRect:(CGRect)rect;

/*
 切出指定形状的透明圈
 path：指定形状
 */
+ (UIImage *)clearCircleImageWithPath:(UIBezierPath *)path;

/*
 在指定位置截取一个指定大小的透明圈
 rect：截取rect
 */

+ (UIImage *)clearCircleImageWithRect:(CGRect)rect;

@end
