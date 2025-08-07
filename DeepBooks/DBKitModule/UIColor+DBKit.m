//
//  UIColor+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIColor+DBKit.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIColor (DBKit)
#pragma clang diagnostic pop

+ (BOOL)resolveClassMethod:(SEL)selector{
    NSString *string = NSStringFromSelector(selector);
    RESOLVE_CLASS_METHOD([NSStringFromSelector(selector) hasPrefix:@"c"] && (string.length == 7 || string.length == 9), @selector(classMethodRedefine))
    return [super resolveClassMethod:selector];
}

+ (UIColor *)classMethodRedefine{
    return [self dynamicAllusionTomethod:@"rgbString:" object:NSStringFromSelector(_cmd)];
}

+ (UIColor *)rgbString:(NSString *)cString{
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


- (UIImage *)toImage{
    return [self toImageSize:CGSizeMake(1.0, 1.0)];
}

- (UIImage *)toImageSize:(CGSize)size{
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (instancetype)gradientColorSize:(CGSize)size
                            direction:(DBColorDirection)direction
                           startColor:(UIColor *)startcolor
                         endColor:(UIColor *)endColor{
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
         return nil;
     }
     
     CAGradientLayer *gradientLayer = [CAGradientLayer layer];
     gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
     
     CGPoint startPoint = CGPointMake(0.0, 0.0);
     if (direction == DBColorDirectionUpwardDiagonalLine) {
         startPoint = CGPointMake(0.0, 1.0);
     }
     
     CGPoint endPoint = CGPointMake(0.0, 0.0);
     switch (direction) {
         case DBColorDirectionVertical:
             endPoint = CGPointMake(0.0, 1.0);
             break;
         case DBColorDirectionDownDiagonalLine:
             endPoint = CGPointMake(1.0, 1.0);
             break;
         case DBColorDirectionUpwardDiagonalLine:
             endPoint = CGPointMake(1.0, 0.0);
             break;
         default:
             endPoint = CGPointMake(1.0, 0.0);
             break;
     }
     gradientLayer.startPoint = startPoint;
     gradientLayer.endPoint = endPoint;
     
     gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
     UIGraphicsBeginImageContext(size);
     [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return [UIColor colorWithPatternImage:image];
}


- (NSString *)toColorHexString{
    UIColor *color = self;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor *)randomBrightColor {
    CGFloat hue = arc4random_uniform(256) / 255.0;  // 色调 (0.0 到 1.0)
    CGFloat saturation = (arc4random_uniform(128) / 255.0) + 0.5;  // 饱和度 (0.5 到 1.0)
    CGFloat brightness = (arc4random_uniform(128) / 255.0) + 0.5;  // 亮度 (0.5 到 1.0)
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

+ (NSString *)stringFromColor:(UIColor *)color {
    CGFloat red, green, blue, alpha;
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return [NSString stringWithFormat:@"%.2f,%.2f,%.2f,%.2f", red, green, blue, alpha];
    }
    return nil;
}

+ (UIColor *)colorFromRGBString:(NSString *)rgbString {
    NSArray *components = [rgbString componentsSeparatedByString:@","];
    if (components.count == 4) {
        CGFloat red = [components[0] floatValue];
        CGFloat green = [components[1] floatValue];
        CGFloat blue = [components[2] floatValue];
        CGFloat alpha = [components[3] floatValue];
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    return nil;
}
@end
