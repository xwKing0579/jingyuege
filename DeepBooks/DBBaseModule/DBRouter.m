//
//  DBRouter.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBRouter.h"
#import "UIViewController+CWLateralSlide.h"
#import "DBWebViewController.h"
NSString *const kDBRouterPathJumpStyle = @"routerPathJumpStyle";
NSString *const kDBRouterPathNoAnimation = @"routerPathNoAnimation";
NSString *const kDBRouterPathRootIndex = @"routerPathRootIndex";
NSString *const kDBRouterDrawerSideslip = @"routerDrawerSideslip";
NSString *const kDBRouterPathSetNavigation = @"routerPathSetNavigation";
static NSString *_lastOpenLink = nil;

@implementation DBRouter

+ (UIViewController *)openPageUrl:(NSString *)url{
    return [self openPageUrl:url params:@{}];
}

+ (UIViewController *)openPageUrl:(NSString *)url params:(NSDictionary * _Nullable)params{
    if (DBEmptyObj(url) || [url isEqualToString:_lastOpenLink]) return nil;
    
    _lastOpenLink = url;
    [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(setMultipleClick) object:nil];
    [self performSelector:@selector(setMultipleClick) withObject:self afterDelay:0.1];
    
    
    UIViewController *currentVc = UIScreen.currentViewController;
    if (!currentVc) return nil;

    NSURLComponents *comp = [[NSURLComponents alloc] initWithString:url];
    NSString *path = [comp.path componentsSeparatedByString:@"/"].lastObject;
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:params];
    [comp.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value) [temp setValue:obj.value forKey:obj.name];
    }];
    
    UIViewController *targetVc = [NSClassFromString(path) modelWithDictionary:temp];
    if (!targetVc) return nil;

    BOOL animation = ![[params valueForKey:kDBRouterPathNoAnimation] boolValue];
    if ([params valueForKey:kDBRouterDrawerSideslip]){
        [currentVc cw_showDefaultDrawerViewController:targetVc];
    }else if ([params valueForKey:kDBRouterPathJumpStyle]) {
        if ([params valueForKey:kDBRouterPathSetNavigation]){
            targetVc = [[UINavigationController alloc] initWithRootViewController:targetVc];
        }
        targetVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentVc presentViewController:targetVc animated:animation completion:nil];
    }else{
        targetVc.hidesBottomBarWhenPushed = YES;
        [currentVc.navigationController pushViewController:targetVc animated:animation];
    }
    return targetVc;
}

+ (void)closePage{
    [self closePage:nil params:nil];
}

+ (void)closePageRoot{
    [UIScreen.currentViewController.navigationController popToRootViewControllerAnimated:YES];
}

+ (void)closePage:(NSString * _Nullable)obj params:(NSDictionary * _Nullable)params{
    UIViewController *currentVc = UIScreen.currentViewController;
    if (!currentVc) return;
    
    BOOL animation = ![[params valueForKey:kDBRouterPathNoAnimation] boolValue];
    if ([params valueForKey:kDBRouterPathRootIndex]){
        if (currentVc.presentingViewController){
            [currentVc dismissViewControllerAnimated:animation completion:nil];
        }else{
            [currentVc.navigationController popToRootViewControllerAnimated:animation];
        }
        
        UITabBarController *rootVC = (UITabBarController *)UIScreen.appWindow.rootViewController;
        NSInteger rootIndex = [[params valueForKey:kDBRouterPathRootIndex] integerValue];
        if (rootIndex >= 0 && rootIndex < rootVC.childViewControllers.count){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                rootVC.selectedIndex = rootIndex;
            });
        }
    }else if (currentVc.navigationController.childViewControllers.count > 1){
        [currentVc.navigationController popViewControllerAnimated:animation];
    }else if (currentVc.presentingViewController) {
        [currentVc dismissViewControllerAnimated:animation completion:nil];
    }
}


+ (void)setMultipleClick{
    _lastOpenLink = nil;
}

@end
