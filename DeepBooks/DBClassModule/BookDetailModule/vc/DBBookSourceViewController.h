//
//  DBBookSourceViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBookSourceViewController : DBBaseViewController
@property (nonatomic, copy) NSString *bookId;

@property (nonatomic, strong) DBBookModel *book;
@end

NS_ASSUME_NONNULL_END
