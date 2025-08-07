//
//  UIImage+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DBKit)

- (UIImage *)original;
- (UIImage *)stretchable;
- (NSData *)compressImageMaxSize:(NSInteger)maxSize scale:(CGFloat)scale;


+ (UIImage *)generateQRCodeWithString:(NSString *)inputString size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
