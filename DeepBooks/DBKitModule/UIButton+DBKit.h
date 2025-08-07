//
//  UIButton+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TitlePositionType) {
    TitlePositionLeft,
    TitlePositionRight,
    TitlePositionTop,
    TitlePositionBottom
};

@interface UIButton (DBKit)

- (void)setTitlePosition:(TitlePositionType)type spacing:(CGFloat)spacing;


@end

NS_ASSUME_NONNULL_END
