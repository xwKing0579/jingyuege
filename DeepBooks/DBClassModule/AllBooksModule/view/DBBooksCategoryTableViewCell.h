//
//  DBBooksCategoryTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBBaseTableViewCell.h"
#import "DBAuthorBooksModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBooksCategoryTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBAuthorBooksModel *model;
@end

NS_ASSUME_NONNULL_END
