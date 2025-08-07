//
//  DBLeaderboardBooksTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBaseTableViewCell.h"
#import "DBGenderBooksListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBLeaderboardBooksTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBooksDataModel *model;

@property (nonatomic, assign) NSInteger rank;
@end

NS_ASSUME_NONNULL_END
