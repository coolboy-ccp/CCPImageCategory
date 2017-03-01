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
 截取图片的一部分(矩形)
 */
- (UIImage *)clipImageInRect:(CGRect)rect {
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:imgRef];
}

/*
 截取图片(不规则)
 rect:图片rect
 */

- (void)clipImageWithPath:(UIBezierPath *)path rect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
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
    NSMutableParagraphStyle *mps = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    mps.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSParagraphStyleAttributeName : mps, NSForegroundColorAttributeName : color, NSFontAttributeName : font };
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [text drawInRect:rect withAttributes:dic];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/*——————————————————————————————————————————二维码生成——————————————————————————————————————————————*/


/*
 根据字符串生成二维码
 size：生成的尺寸
 red：color.red
 green: color.green
 blue: color.blue
 qrString: 需要生成二维码的字符串
 */
- (UIImage*)imageWithSize:(CGFloat)size andColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andQRString:(NSString *)qrString {
    
    UIImage *resultImage = [self createInterPolatedUIImage:[self createQRFromString:qrString] withSize:size];
    return [self imageBlackToTransParent:resultImage withRed:red andGreen:green andBlur:blue];
}
//
- (UIImage *)imageBlackToTransParent:(UIImage *)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlur:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProViderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

void ProViderReleaseData (void *info,const void *data,size_t size) {
    free((void *)data);
}

- (CIImage *)createQRFromString:(NSString *)qrSring {
    NSData *stringData = [qrSring dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // set内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

- (UIImage *)createInterPolatedUIImage:(CIImage *)ciimage withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(ciimage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef  = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciimage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage* imageView=[UIImage imageWithCGImage:scaledImage];
    CGColorSpaceRelease(cs);
    CGImageRelease(scaledImage);
    return imageView;
}


@end
