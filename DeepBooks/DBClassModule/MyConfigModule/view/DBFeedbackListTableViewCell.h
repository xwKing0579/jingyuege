//
//  DBFeedbackListTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBBaseTableViewCell.h"
#import "DBFeedbackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBFeedbackListTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBFeedbackModel *model;
@end

NS_ASSUME_NONNULL_END
