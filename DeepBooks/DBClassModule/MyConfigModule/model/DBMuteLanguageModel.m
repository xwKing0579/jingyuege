//
//  DBMuteLanguageModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/18.
//

#import "DBMuteLanguageModel.h"
#import "DBAppSetting.h"

@implementation DBMuteLanguageModel

+ (NSArray *)dataSourceList{
    NSArray *data = @[@{@"language":@"简体中文",@"abbrev":@"zh-Hans"},
                      @{@"language":@"繁体中文",@"abbrev":@"zh-Hant"},
                      @{@"language":@"English",@"abbrev":@"en"}];
    return [NSArray modelArrayWithClass:self.class json:data];
}

+ (void)saveLanguageAbbrev:(NSString *)abbrev{
    NSDictionary *textList = [self getLocalizedStringsForLanguage:DBAppSetting.languageAbbrev];
    [NSUserDefaults saveValue:abbrev forKey:DBLocalLanguageValue];
    [self traverseAllViewsFromRootViewController:UIScreen.appWindow.rootViewController block:^(UIView * _Nonnull view) {
        if ([view isKindOfClass:UILabel.class]){
            DBBaseLabel *labelView = (DBBaseLabel *)view;
            NSString *text = labelView.text;
            if ([textList.allValues containsObject:text]){
                [textList enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([text isEqualToString:obj]){
                        labelView.text = key;
                        *stop = YES;
                    }
                }];
            }else{
                labelView.text = text;
                if (labelView.attributedText.string.length){
                    
                }
            }
        }else if ([view isKindOfClass:UIButton.class]){
            UIButton *buttonView = (UIButton *)view;
            NSString *text = buttonView.titleLabel.text;
            if ([textList.allValues containsObject:text]){
                [textList enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([text isEqualToString:obj]){
                        [buttonView setTitle:key forState:buttonView.state];
                        *stop = YES;
                    }
                }];
            }else{
                [buttonView setTitle:text forState:buttonView.state];
            }
        }else if ([view isKindOfClass:UITableView.class]){
            [((UITableView *)view) reloadData];
        }else if ([view isKindOfClass:UICollectionView.class]){
            [((UICollectionView *)view) reloadData];
        }
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:DBLocalLanguageChange object:nil];
}

+ (NSDictionary *)getLocalizedStringsForLanguage:(NSString *)language {
    NSString *lprojPath = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    if (!lprojPath) return nil;
    
    NSBundle *languageBundle = [NSBundle bundleWithPath:lprojPath];
    NSString *stringsPath = [languageBundle pathForResource:@"InfoPlist" ofType:@"strings"];
    return [NSDictionary dictionaryWithContentsOfFile:stringsPath];
}

+ (void)traverseAllViewsFromRootViewController:(UIViewController *)rootViewController block:(void (^)(UIView *view))block {
    if (!rootViewController || !block) return;
    
    [self traverseAllViewsFromView:rootViewController.view block:block];
    
    for (UIViewController *childVC in rootViewController.childViewControllers) {
        [self traverseAllViewsFromRootViewController:childVC block:block];
    }

    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)rootViewController;
        for (UIViewController *vc in navController.viewControllers) {
            [self traverseAllViewsFromRootViewController:vc block:block];
        }
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        for (UIViewController *vc in tabController.viewControllers) {
            [self traverseAllViewsFromRootViewController:vc block:block];
        }
    }
    
    if (rootViewController.presentedViewController) {
        [self traverseAllViewsFromRootViewController:rootViewController.presentedViewController block:block];
    }
}

+ (void)traverseAllViewsFromView:(UIView *)view block:(void (^)(UIView *view))block {
    if (!view || !block) return;
    block(view);
    
    for (UIView *subview in view.subviews) {
        [self traverseAllViewsFromView:subview block:block];
    }
}
@end
