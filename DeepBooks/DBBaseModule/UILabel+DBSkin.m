//
//  UILabel+DBSkin.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/3.
//

#import "UILabel+DBSkin.h"

@implementation UILabel (DBSkin)

+ (void)load{
    [self swizzleInstanceMethod:@selector(setTextColor:) withSwizzleMethod:@selector(skin_setTextColor:)];
    [self swizzleInstanceMethod:@selector(traitCollectionDidChange:) withSwizzleMethod:@selector(skin_traitCollectionDidChange:)];
}

- (void)skin_setTextColor:(UIColor *)textColor{
    NSDictionary *textColorDict = DBColorExtension.userInterfaceStyle ? DBSkinChangeManager.textColorDict : DBSkinChangeManager.textColorInvertedDict;
    if (textColor && [textColorDict.allKeys containsObject:textColor]){
        [self skin_setTextColor:textColorDict[textColor]];
    }else{
        [self skin_setTextColor:textColor];
    }
}

- (void)skin_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self skin_traitCollectionDidChange:previousTraitCollection];
    if (self.textColor && self.attributedText.string.length == 0) self.textColor = self.textColor;
}

@end
