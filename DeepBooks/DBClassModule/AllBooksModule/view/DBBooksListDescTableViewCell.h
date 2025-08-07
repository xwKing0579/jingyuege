//
//  DBBooksListDescTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/1.
//

#import "DBBaseTableViewCell.h"
#import "DBBooksListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBooksListDescTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBooksListModel *model;
@end

NS_ASSUME_NONNULL_END
