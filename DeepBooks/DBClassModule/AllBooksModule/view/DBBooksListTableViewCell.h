//
//  DBBooksListTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBaseTableViewCell.h"
#import "DBBooksListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBooksListTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBooksModel *model;
@end

NS_ASSUME_NONNULL_END
