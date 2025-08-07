//
//  DBCollectionIndexViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/4.
//

#import "DBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBCollectionIndexViewController : DBBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
