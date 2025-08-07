//
//  DBBannerAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBannerAdConfig : DBAdBase

- (void)setBannerAdPreLoadSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController;
- (void)getBannerAdAndSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion;

@end

NS_ASSUME_NONNULL_END
