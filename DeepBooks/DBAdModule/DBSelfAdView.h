//
//  DBSelfAdView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import <UIKit/UIKit.h>
#import "DBSelfAdConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBSelfAdView : UIView

@property (nonatomic, copy) void (^didRemovedBlock)(UIView *adContainerView, DBSelfAdType adType);
@property (nonatomic, copy) void (^didClickBlock)(UIView *adContainerView, DBSelfAdType adType);
- (instancetype)initWithSelfAdModel:(DBSelfAdModel *)selfAd adType:(DBSelfAdType)adType;

@end

NS_ASSUME_NONNULL_END
