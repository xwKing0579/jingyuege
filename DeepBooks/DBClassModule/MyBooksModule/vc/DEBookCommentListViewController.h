//
//  DEBookCommentListViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DEBookCommentListViewController : DBBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *book_id;

@property (nonatomic, strong) NSString *bookName;
@end

NS_ASSUME_NONNULL_END
