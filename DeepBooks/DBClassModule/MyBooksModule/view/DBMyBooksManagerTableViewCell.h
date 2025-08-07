//
//  DBMyBooksManagerTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBBaseTableViewCell.h"
#import "DBMyBooksManagerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBMyBooksManagerTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBMyBooksManagerModel *model;

@end

NS_ASSUME_NONNULL_END
