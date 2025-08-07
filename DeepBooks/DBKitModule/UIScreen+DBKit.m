//
//  UIScreen+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIScreen+DBKit.h"

@implementation UIScreen (DBKit)

+ (CGFloat)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)navbarHeight{
    return self.navbarNetHeight+self.navbarSafeHeight;
}

+ (CGFloat)tabbarHeight{
    return self.tabbarNetHeight+self.tabbarSafeHeight;
}

+ (CGFloat)navbarNetHeight{
    return 44.0;
}

+ (CGFloat)tabbarNetHeight{
    return 49.0;
}

+ (CGFloat)navbarSafeHeight{
    return self.appWindow.safeAreaInsets.top;
}

+ (CGFloat)tabbarSafeHeight{
    return self.appWindow.safeAreaInsets.bottom;
}

+ (__kindof UIViewController *)currentViewController{
    __block UIViewController *controller = nil;
    void (^block)(void) = ^{
        controller = [self topViewController:self.appWindow.rootViewController];
    };
    NSThread.isMainThread ? block() : dispatch_sync(dispatch_get_main_queue(), block);
    return controller;
}

+ (UIWindow *)appWindow{
    __block UIWindow *window = nil;
    void (^block)(void) = ^{
        if (@available(iOS 13.0, *)) {
            NSSet *set = [UIApplication sharedApplication].connectedScenes;
            UIWindowScene *windowScene = [set anyObject];
            window = windowScene.windows.lastObject;
            
            for (UIWindow *tagWindow in windowScene.windows) {
                if (tagWindow.tag == 111111){
                    window = tagWindow;
                    break;
                }
            }
        }else{
            window = [UIApplication sharedApplication].delegate.window;
        }
    };
    NSThread.isMainThread ? block() : dispatch_sync(dispatch_get_main_queue(), block);
    return window;
}


+ (__kindof UIViewController *)topViewController:(UIViewController *)vc{
    if (vc.presentedViewController && ![vc.presentedViewController isKindOfClass:[UIAlertController class]]) {
        return [self topViewController:vc.presentedViewController];
    }else if ([vc isKindOfClass:[UISplitViewController class]]){
        UISplitViewController *tmp = (UISplitViewController *)vc;
        return tmp.viewControllers.count?[self topViewController:tmp.viewControllers.lastObject]:vc;
    }else if ([vc isKindOfClass:[UINavigationController class]]){
        UINavigationController *tmp = (UINavigationController *)vc;
        return tmp.viewControllers.count?[self topViewController:tmp.topViewController]:vc;
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tmp = (UITabBarController *)vc;
        return tmp.viewControllers.count?[self topViewController:tmp.selectedViewController]:vc;
    }
    return vc;
}

@end
