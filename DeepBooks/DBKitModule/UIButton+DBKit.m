//
//  UIButton+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIButton+DBKit.h"

@implementation UIButton (DBKit)

+ (void)load{
    [self swizzleInstanceMethod:@selector(setTitle:forState:) withSwizzleMethod:@selector(setMultilingualText:forState:)];
}

- (void)setMultilingualText:(NSString *)title forState:(UIControlState)state{
    [self setMultilingualText:title.textMultilingual forState:state];
}

- (void)setTitlePosition:(TitlePositionType)type spacing:(CGFloat)spacing{
    // 1. 提前返回检查
     UIImage *image = [self imageForState:self.state];
     NSString *title = [self titleForState:self.state];
     
     if (CGSizeEqualToSize(image.size, CGSizeZero) || title.length == 0) {
         return;
     }
     
     // 2. 计算尺寸
     CGSize imageSize = image.size;
     CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
     
     // 3. 设置边距
     UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
     UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
     
     switch (type) {
         case TitlePositionLeft:
             titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width + spacing);
             imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing, 0, -titleSize.width);
             break;
             
         case TitlePositionRight:
             titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
             imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
             break;
             
         case TitlePositionTop: {
             CGFloat totalVerticalSpace = imageSize.height + spacing;
             titleEdgeInsets = UIEdgeInsetsMake(-totalVerticalSpace, -imageSize.width, 0, 0);
             imageEdgeInsets = UIEdgeInsetsMake(0, 0, -(titleSize.height + spacing), -titleSize.width);
             break;
         }
             
         case TitlePositionBottom: {
             CGFloat totalVerticalSpace = imageSize.height + spacing;
             titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -totalVerticalSpace, 0);
             imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width);
             break;
         }
     }
     
     // 4. 应用布局
     self.titleEdgeInsets = titleEdgeInsets;
     self.imageEdgeInsets = imageEdgeInsets;
     
     // 5. 标记需要布局更新
     [self setNeedsLayout];
}

@end
