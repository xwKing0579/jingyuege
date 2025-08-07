//
//  UIColor+Category.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/5.
//

#import "UIColor+Category.h"
#import <objc/runtime.h>
#import "NSObject+Mediator.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIColor (Category)
#pragma clang diagnostic pop

+ (UIColor *)bf_c000000{
    return [UIColor bf_rgbString:@"c000000"];
}

+ (UIColor *)bf_cFFFFFF{
    return [UIColor bf_rgbString:@"cFFFFFF"];
}

+ (UIColor *)bf_c333333{
    return [UIColor bf_rgbString:@"c333333"];
}

+ (UIColor *)bf_cEEEEEE{
    return [UIColor bf_rgbString:@"cEEEEEE"];
}

+ (UIColor *)bf_cBFBFBF{
    return [UIColor bf_rgbString:@"cBFBFBF"];
}

+ (UIColor *)bf_rgbString:(NSString *)cString{
    cString = [cString substringFromIndex:1];
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
   
    unsigned int r, g, b, a = 0;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (cString.length == 8){
        NSString *aString = [cString substringWithRange:NSMakeRange(6, 2)];
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:cString.length == 6 ? 1.0 : a/255.0];
}

+ (UIColor *)bf_RGB:(int)rgb {return [self bf_RGB:rgb A:1.0];}
+ (UIColor *)bf_RGB:(int)rgb A:(CGFloat)a {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a];
}

- (NSString *)bf_hexStringWithAlpha:(BOOL)withAlpha {
    CGColorRef color = self.CGColor;
    size_t count = CGColorGetNumberOfComponents(color);
    const CGFloat *components = CGColorGetComponents(color);
    static NSString *stringFormat = @"%02x%02x%02x";
    NSString *hex = nil;
    if (count == 2) {
        NSUInteger white = (NSUInteger)(components[0] * 255.0f);
        hex = [NSString stringWithFormat:stringFormat, white, white, white];
    }else if (count == 4) {
        hex = [NSString stringWithFormat:stringFormat,
               (NSUInteger)(components[0] * 255.0f),
               (NSUInteger)(components[1] * 255.0f),
               (NSUInteger)(components[2] * 255.0f)];
    }
    
    if (hex && withAlpha) {
        hex = [hex stringByAppendingFormat:@"%02lx",(unsigned long)(self.bf_alpha * 255.0 + 0.5)];
    }
    return hex;
}

- (CGFloat)bf_alpha{
    return CGColorGetAlpha(self.CGColor);
}


@end

