//
//  DBGridAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/22.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBGridAdConfig : DBAdBase

- (void)setGridAdPreLoadSpaceType:(DBAdSpaceType)spaceType;
- (void)getGridAdsAndSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion;

@end

NS_ASSUME_NONNULL_END
