//
//  UIView+DBSkin.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/3.
//

#import "UIView+DBSkin.h"

@implementation UIView (DBSkin)


+ (void)load{
    [self swizzleInstanceMethod:@selector(setBackgroundColor:) withSwizzleMethod:@selector(skin_setBackgroundColor:)];
    [self swizzleInstanceMethod:@selector(traitCollectionDidChange:) withSwizzleMethod:@selector(skin_traitCollectionDidChange:)];
}

- (void)skin_setBackgroundColor:(UIColor *)backgroundColor{
    NSDictionary *backgroundColorDict = DBColorExtension.userInterfaceStyle ? DBSkinChangeManager.backgroundColorDict : DBSkinChangeManager.backgroundColorInvertedDict;
    if (backgroundColor && [backgroundColorDict.allKeys containsObject:backgroundColor]){
       [self skin_setBackgroundColor:backgroundColorDict[backgroundColor]];
    }else{
        [self skin_setBackgroundColor:backgroundColor];
    }
}

- (void)skin_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self skin_traitCollectionDidChange:previousTraitCollection];
    if (self.backgroundColor) self.backgroundColor = self.backgroundColor;
}

@end
