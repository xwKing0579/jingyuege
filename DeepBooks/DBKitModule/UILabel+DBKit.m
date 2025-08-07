//
//  UILabel+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/8.
//

#import "UILabel+DBKit.h"

@implementation UILabel (DBKit)

+ (void)load{
    [self swizzleInstanceMethod:@selector(setText:) withSwizzleMethod:@selector(setMultilingualText:)];
}

- (void)setMultilingualText:(NSString *)text{
    [self setMultilingualText:text.textMultilingual];
}

@end
