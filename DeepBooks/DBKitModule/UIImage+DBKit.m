//
//  UIImage+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIImage+DBKit.h"
#import <CoreImage/CoreImage.h>
@implementation UIImage (DBKit)

- (UIImage *)original{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)stretchable{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

- (NSData *)compressImageMaxSize:(NSInteger)maxSize scale:(CGFloat)scale{
    NSData *data = UIImageJPEGRepresentation(self, scale);
    NSUInteger sizeOrigin = [data length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB <= maxSize) {
        return data;
    }
    return [self compressImageMaxSize:maxSize scale:0.8 * scale];
}



// 生成二维码图片（基础方法）
+ (UIImage *)generateQRCodeWithString:(NSString *)inputString size:(CGSize)size {
    // 1. 创建二维码滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    
    // 2. 设置输入数据（UTF-8编码）
    NSData *inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:inputData forKey:@"inputMessage"];
    
    // 3. 设置纠错级别（可选）
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"]; // L/M/Q/H（H容错率最高）
    
    // 4. 获取输出图像
    CIImage *outputImage = [qrFilter outputImage];
    
    // 5. 调整大小并转换为UIImage
    UIImage *qrImage = [self createNonInterpolatedUIImageFromCIImage:outputImage size:size];
    
    return qrImage;
}

// 将CIImage转换为高清UIImage
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image size:(CGSize)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    
    // 创建位图上下文
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 生成UIImage
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *resultImage = [UIImage imageWithCGImage:scaledImage];
    
    // 释放内存
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    CGColorSpaceRelease(cs);
    
    return resultImage;
}


@end
