//
//  DBRewardAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN



@interface DBRewardAdConfig : DBAdBase
- (void)setRewardAdPreLoadSpaceType:(DBAdSpaceType)spaceType;
- (void)getRewardAdsAndSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(NSObject *adObject, BOOL reward))completion;
@end

NS_ASSUME_NONNULL_END
