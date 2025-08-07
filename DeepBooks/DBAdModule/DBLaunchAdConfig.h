//
//  DBLaunchAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN


@interface DBLaunchAdConfig : DBAdBase

- (void)setLaunchAdPreLoadSpaceType:(DBAdSpaceType)spaceType;
- (void)getLaunchAdsAndSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(NSObject *adObject))completion;

@end

NS_ASSUME_NONNULL_END
