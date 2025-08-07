//
//  DBReadBookCatalogsViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import "DBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBReadBookCatalogsViewController : DBBaseViewController
@property (nonatomic, strong) DBBookModel *book;

@property (nonatomic, copy) void (^clickChapterIndex)(NSInteger chapterIndex);
@end

NS_ASSUME_NONNULL_END
