//
//  UIColor+Category.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/5.
//

#import <UIKit/UIKit.h>
#import "UIFont+Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Category)

+ (UIColor *)bf_c000000;

+ (UIColor *)bf_cFFFFFF;


+ (UIColor *)bf_c333333;
+ (UIColor *)bf_cEEEEEE;
+ (UIColor *)bf_cBFBFBF;


+ (UIColor *)bf_rgbString:(NSString *)cString;
- (NSString *)bf_hexStringWithAlpha:(BOOL)withAlpha;

@end

NS_ASSUME_NONNULL_END
