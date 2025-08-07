//
//  DEBookCommentListTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DBBaseTableViewCell.h"
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEBookCommentListTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBookCommentModel *model;
@property (nonatomic, copy) NSString *bookName;
@end

NS_ASSUME_NONNULL_END
