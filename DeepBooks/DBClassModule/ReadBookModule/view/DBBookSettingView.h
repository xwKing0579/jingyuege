//
//  DBBookSettingView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookSettingView : UIView

@property (nonatomic, copy) void (^clickMenuAction)(UIButton *sender,NSInteger index);
- (void)showAnimate;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSInteger styleIndex;
@property (nonatomic, copy) UIColor *bookgroundColor;
@end

NS_ASSUME_NONNULL_END
