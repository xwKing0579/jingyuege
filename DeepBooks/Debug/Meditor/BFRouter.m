//
//  BFRouter.m
//  OCProject
//
//  Created by 王祥伟 on 2023/11/29.
//

#import "BFRouter.h"

NSString *const kBFRouterPathURLName = @"native/";
NSString *const kBFRouterPathJumpStyle = @"present";
NSString *const kBFRouterPathNoAnimation = @"noanimation";
NSString *const kBFRouterPathTabbarIndex = @"index_";
NSString *const kBFRouterPathPresentStyle = @"modalPresentationStyle";
NSString *const kBFRouterPathBackRoot = @"root";

static NSString *_lastJumpUrl = nil;
@implementation BFRouter

+ (__kindof UIViewController *)jumpUrl:(NSString *)url{
    return [self jumpUrl:url params:nil];
}

+ (__kindof UIViewController *)jumpUrl:(NSString *)url params:(NSDictionary * _Nullable )params{
    if (![url isKindOfClass:[NSString class]]) return nil;
    ///处理一些业务逻辑
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSString *path = urlComponents.path;
    
    if ([path hasPrefix:@"/"]){
        path = [path stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    if ([path hasPrefix:kBFRouterPathURLName]) {
        path = [path stringByReplacingOccurrencesOfString:kBFRouterPathURLName withString:@""];
    }
    
    if ([path hasPrefix:kBFRouterPathTabbarIndex]){
        [self backUrl:path];
        return nil;
    }
    
    NSArray <NSString *>*dataComponent = [path componentsSeparatedByString:@"/"];
    if (dataComponent.count == 0) return nil;
    
    NSString *classString = [self classValue][dataComponent.firstObject];
    if (!classString) classString = dataComponent.firstObject;
    Class class = NSClassFromString(classString);
    if (!class) return nil;
    
    //记录本次跳转路径，与下次对比去重
    NSString *jsonString = [url stringByAppendingString:[NSString stringWithFormat:@"%@",params]];
    if ([_lastJumpUrl isEqualToString:jsonString]) {
        return nil;
    }else{
        _lastJumpUrl = jsonString;
        [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(multipleClicks) object:nil];
        [self performSelector:@selector(multipleClicks) withObject:self afterDelay:0.1];
    }
    
    NSMutableDictionary *propertys = [NSMutableDictionary dictionaryWithDictionary:params];
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value) [propertys setObject:obj.value forKey:obj.name];
    }];
    
    __kindof UIViewController *vc = [class yy_modelWithDictionary:propertys];
    __kindof UIViewController *currentVC = UIViewController.currentViewController;
    if (!currentVC) return nil;
    
    ///设置动画和跳转方式
    BOOL push = ![dataComponent containsObject:kBFRouterPathJumpStyle];
    BOOL animation = ![dataComponent containsObject:kBFRouterPathNoAnimation];
    
    if (push) {
        vc.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:vc animated:animation];
    }else{
        ///自定义nav
        Class navClass = NSClassFromString([propertys valueForKey:@"navigationClass"]);
        __kindof UINavigationController *nav = [navClass alloc];
        if (nav && [nav isKindOfClass:[UINavigationController class]]) {
            vc = [nav initWithRootViewController:vc];
        }
        
        ///自定义model
        UIModalPresentationStyle modalStyle;
        switch ([[NSString stringWithFormat:@"%@",propertys[kBFRouterPathPresentStyle]] intValue]) {
            case 0:  modalStyle = UIModalPresentationFullScreen; break;
            case 1:  modalStyle = UIModalPresentationPageSheet; break;
            case 2:  modalStyle = UIModalPresentationFormSheet; break;
            case 3:  modalStyle = UIModalPresentationCurrentContext; break;
            case 4:  modalStyle = UIModalPresentationCustom; break;
            case 5:  modalStyle = UIModalPresentationOverFullScreen; break;
            case 6:  modalStyle = UIModalPresentationOverCurrentContext; break;
            case 7:  modalStyle = UIModalPresentationPopover; break;
            case -2: modalStyle = UIModalPresentationAutomatic; break;
            default: modalStyle = UIModalPresentationFullScreen; break;
        }
        vc.modalPresentationStyle = modalStyle;
        [currentVC presentViewController:vc animated:animation completion:nil];
    }
    return vc;
}

+ (void)multipleClicks{
    _lastJumpUrl = nil;
}

+ (void)back{
    [self backUrl:nil];
}

+ (void)backRoot{
    [self backUrl:kBFRouterPathBackRoot];
}

+ (void)backUrl:(NSString * _Nullable)url{
    NSArray <NSString *>*dataComponent = [url componentsSeparatedByString:@"/"];
    BOOL animation = ![dataComponent containsObject:kBFRouterPathNoAnimation];
    url = [url stringByReplacingOccurrencesOfString:kBFRouterPathNoAnimation withString:@""];
    __kindof UIViewController *currentVC = UIViewController.currentViewController;
    if (!currentVC) return;

    NSString *obj = dataComponent.lastObject;
    if ([obj hasPrefix:kBFRouterPathTabbarIndex]) {
        if (currentVC.presentingViewController) {
            [currentVC dismissViewControllerAnimated:animation completion:^{
                [self backUrl:url];
            }];
        }else{
            [[UIViewController currentViewController].navigationController popToRootViewControllerAnimated:animation];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([UIViewController.rootViewController isKindOfClass:[UITabBarController class]]) {
                    __kindof UITabBarController *tabbarController = (UITabBarController *)UIViewController.rootViewController;
                    NSUInteger selectedIndex = [obj stringByReplacingOccurrencesOfString:kBFRouterPathTabbarIndex withString:@""].integerValue;
                    if (selectedIndex < tabbarController.viewControllers.count) tabbarController.selectedIndex = selectedIndex;
                }
            });
        }
    }else{
        if (currentVC.navigationController.viewControllers.count > 1){
            __kindof UINavigationController *nav = currentVC.navigationController;
            if ([self isEmptyData:dataComponent]) {
                [nav popViewControllerAnimated:animation];
                return;
            }
            
            if ([dataComponent.firstObject isEqualToString:kBFRouterPathBackRoot]){
                [nav popToRootViewControllerAnimated:animation];
                return;
            }
            
            Class class = NSClassFromString([self classValue][dataComponent.firstObject]);
            if (!class) class = NSClassFromString(dataComponent.firstObject);
            if (!class) return;
            
            __kindof UIViewController *toVc;
            for (UIViewController *controller in nav.viewControllers) {
                if ([controller isMemberOfClass:class]) {
                    toVc = controller;
                    break;
                }
            }
            
            toVc ? [nav popToViewController:toVc animated:animation] : [nav popToRootViewControllerAnimated:animation];
        }else if (currentVC.presentingViewController) {
            [currentVC dismissViewControllerAnimated:animation completion:^{
                if (![self isEmptyData:dataComponent]) [self backUrl:url];
            }];
        }
    }
}

+ (BOOL)isEmptyData:(NSArray <NSString *>*)dataComponent{
    __block BOOL DBEmptyObj = NO;
    NSMutableArray *data = [NSMutableArray arrayWithArray:dataComponent];
    [data removeObject:kBFRouterPathNoAnimation];
    if (data.count == 0) DBEmptyObj = YES;
    [data enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length == 0) {
            DBEmptyObj = YES;
            return;
        }
    }];
    return DBEmptyObj;
}

+ (NSDictionary *)classValue {
    return nil;
}

@end

@implementation NSString (Router)
- (NSString *)present{
    return [NSString stringWithFormat:@"%@/%@",self,kBFRouterPathJumpStyle];
}

- (NSString *)noAnimation{
    return [NSString stringWithFormat:@"%@/%@",self,kBFRouterPathNoAnimation];
}

- (NSString *)baseNavigation{
    return [NSString stringWithFormat:@"%@?navigationClass=%@",self,BFString.vc_base_navigation];
}
@end
