//
//  DBLeaderboardTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBaseTableViewCell.h"
#import "DBLeaderboardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBLeaderboardTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBLeaderboardItemModel *model;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
