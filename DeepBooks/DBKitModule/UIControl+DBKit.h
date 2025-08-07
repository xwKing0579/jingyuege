//
//  UIControl+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (DBKit)

@property (nonatomic,assign) UIEdgeInsets enlargedEdgeInsets;

- (void)addTagetHandler:(void (^)(id sender))handler controlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
