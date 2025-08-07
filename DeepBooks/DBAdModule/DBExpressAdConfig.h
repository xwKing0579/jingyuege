//
//  DBExpressAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/28.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBExpressAdConfig : DBAdBase

- (void)setExpressAdPreLoadSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController;
- (void)getExpressAdsAndSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(NSArray <UIView *>*adViews))completion;

@end



NS_ASSUME_NONNULL_END
