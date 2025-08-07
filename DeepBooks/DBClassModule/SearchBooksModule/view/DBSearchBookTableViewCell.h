//
//  DBSearchBookTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBBaseTableViewCell.h"
#import "DBSearchBooksModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBSearchBookTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) NSString *searchWords;
@property (nonatomic, copy) DBSearchBooksModel *model;
@end

NS_ASSUME_NONNULL_END
