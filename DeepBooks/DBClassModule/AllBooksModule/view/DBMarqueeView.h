//
//  DBMarqueeView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBMarqueeView : UIView
@property (nonatomic, strong) NSArray<NSString *> *messages;
@property (nonatomic, assign) NSTimeInterval duration;

- (void)startAnimation;
- (void)pauseAnimation;
- (void)resumeAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
