//
//  DBBookTypesListViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBookTypesListViewController : DBBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
