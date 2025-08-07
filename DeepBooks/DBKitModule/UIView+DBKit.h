//
//  UIView+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DBKit)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

- (void)addSubviews:(NSArray *)subviews;
- (void)removeAllSubView;
- (void)removeAllSubViewExcept:(NSArray *)views;


- (void)showAlertText:(NSString *)text;
- (void)showAlertText:(NSString *)text afterDelay:(NSTimeInterval)delay;
- (void)showCloseAndText:(NSString *)text completion:(void (^ __nullable)(BOOL close))completion;

- (void)showHudLoading;
- (void)removeHudLoading;
- (void)removeCloseHudLoading;

- (void)addRoudCorners:(UIRectCorner)corners cornerRadii:(CGSize)radii;

- (void)addTapGestureTarget:(id)target action:(SEL)action;

- (UIImage *)imageShot;
- (UIImage *)captureMirrorImage;

- (void)addTopEdgeShadow;

- (void)addOuterShadow;
- (void)removeOuterShadow;

- (void)traverseAllSubviewsWithBlock:(void (^)(UIView *subview))block;

@end

NS_ASSUME_NONNULL_END
