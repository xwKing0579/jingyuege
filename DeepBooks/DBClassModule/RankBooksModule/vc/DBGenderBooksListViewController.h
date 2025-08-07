//
//  DBGenderBooksListViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBaseViewController.h"
#import <JXCategoryView.h>
NS_ASSUME_NONNULL_BEGIN

@interface DBGenderBooksListViewController : DBBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
