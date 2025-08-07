//
//  DBSlotAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN


@interface DBSlotAdConfig : DBAdBase

- (void)setSlotAdPreLoadSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController;
- (void)getSlotAdsAndSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(NSObject *adObject))completion;

@end

NS_ASSUME_NONNULL_END
