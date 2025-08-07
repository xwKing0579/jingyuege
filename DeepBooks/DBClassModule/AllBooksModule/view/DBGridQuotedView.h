//
//  DBGridQuotedView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBGridQuotedView : UIControl

@property (nonatomic, strong) id imageObj;
@property (nonatomic, copy) NSString *nameStr;

- (void)gradientStartColor:(UIColor *)startcolor endColor:(UIColor *)endColor;

@end

NS_ASSUME_NONNULL_END
