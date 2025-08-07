//
//  UIScreen+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (DBKit)

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

+ (CGFloat)navbarHeight;
+ (CGFloat)tabbarHeight;
+ (CGFloat)navbarNetHeight;
+ (CGFloat)tabbarNetHeight;
+ (CGFloat)navbarSafeHeight;
+ (CGFloat)tabbarSafeHeight;

+ (UIWindow *)appWindow;
+ (__kindof UIViewController *)currentViewController;


@end

NS_ASSUME_NONNULL_END
