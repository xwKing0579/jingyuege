//
//  DBBookCommentTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/10.
//

#import "DBBaseTableViewCell.h"
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookCommentTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBookCommentModel *model;
@end

NS_ASSUME_NONNULL_END
