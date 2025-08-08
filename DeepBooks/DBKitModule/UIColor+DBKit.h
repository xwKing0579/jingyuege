//
//  UIColor+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DBColorDirection) {
    DBColorDirectionLevel,//水平渐变
    DBColorDirectionVertical,//竖直渐变
    DBColorDirectionDownDiagonalLine,//向上对角线渐变
    DBColorDirectionUpwardDiagonalLine,//向下对角线渐变
};
NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DBKit)

+ (UIColor *)cCDAF7B;
+ (UIColor *)cD0CFD0;

+ (UIColor *)cF9703D;
+ (UIColor *)c4B4B4B;
+ (UIColor *)c060708;
+ (UIColor *)cD8D9D8;
+ (UIColor *)cF5C164;
+ (UIColor *)cFFE09E;
+ (UIColor *)c0A0B17;
+ (UIColor *)cF5F5F5;
+ (UIColor *)c7C7C7C;
+ (UIColor *)cFFEAE2;
+ (UIColor *)cFFFAF7;
+ (UIColor *)cFFE5DC;
+ (UIColor *)cADADAD;
+ (UIColor *)c502516;
+ (UIColor *)c5F554E;
+ (UIColor *)cF7E0D0;
+ (UIColor *)cFFF5E8;
+ (UIColor *)cF7D0D0;
+ (UIColor *)cFFE8EF;
+ (UIColor *)cBBD3FE;
+ (UIColor *)cE7ECFC;
+ (UIColor *)cFA8744;
+ (UIColor *)cF65C3A;
+ (UIColor *)c171929;
+ (UIColor *)cE6E6E6;
+ (UIColor *)c3E3E3E;
+ (UIColor *)cC3C3C3;
+ (UIColor *)c303132;
+ (UIColor *)cF8CA23;
+ (UIColor *)c2964F4;
+ (UIColor *)cD9F2F6;
+ (UIColor *)cF6F6F6;
+ (UIColor *)cFAF0E6;
+ (UIColor *)cD2E4D2;
+ (UIColor *)cFFE4E1;
+ (UIColor *)cC9B282;
+ (UIColor *)cE6CEAD;
+ (UIColor *)c1A1A1A;
+ (UIColor *)c262626;
+ (UIColor *)c302303;
+ (UIColor *)c132013;
+ (UIColor *)c330500;
+ (UIColor *)c4D4D4D;
+ (UIColor *)c000000;
+ (UIColor *)c000001;
+ (UIColor *)c191919;
+ (UIColor *)cFFFFFF;
+ (UIColor *)cFFFFFE;
+ (UIColor *)cE8E8E8;
+ (UIColor *)cEB7802;
+ (UIColor *)c2C2C2C;
+ (UIColor *)c333333;
+ (UIColor *)c333334;
+ (UIColor *)cA2A2A2;
+ (UIColor *)cB2B2B2;
+ (UIColor *)c666666;
+ (UIColor *)c747474;
+ (UIColor *)cCCCCCC;
+ (UIColor *)cDDDDDD;
+ (UIColor *)cEEEEEE;
+ (UIColor *)cEEEEEF;
+ (UIColor *)cE0E0E0;
+ (UIColor *)cFC7D7C;
+ (UIColor *)cF7F7F7;
+ (UIColor *)c080808;
+ (UIColor *)c898989;
+ (UIColor *)cFF0000;
+ (UIColor *)c808080;
+ (UIColor *)cFF6F60; 
+ (UIColor *)cC8A2C8;
+ (UIColor *)c0077BE;
+ (UIColor *)cFF7E00;
+ (UIColor *)cB76E79;
+ (UIColor *)c01796F;
+ (UIColor *)cF8C3AF; 
+ (UIColor *)c87CEEB;


- (UIImage *)toImage;
- (UIImage *)toImageSize:(CGSize)size;

+ (instancetype)gradientColorSize:(CGSize)size
                            direction:(DBColorDirection)direction
                           startColor:(UIColor *)startcolor
                             endColor:(UIColor *)endColor;

- (NSString *)toColorHexString;
+ (UIColor *)rgbString:(NSString *)cString;
+ (UIColor *)randomBrightColor;

+ (NSString *)stringFromColor:(UIColor *)color;
+ (UIColor *)colorFromRGBString:(NSString *)rgbString;
@end

NS_ASSUME_NONNULL_END
