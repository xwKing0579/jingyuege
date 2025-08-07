//
//  DBWantBookListTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBBaseTableViewCell.h"
#import "DBWantBookListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBWantBookListTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBWantBookModel *model;
@end

NS_ASSUME_NONNULL_END
