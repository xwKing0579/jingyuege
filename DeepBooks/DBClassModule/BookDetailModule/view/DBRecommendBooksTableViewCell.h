//
//  DBRecommendBooksTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBaseTableViewCell.h"
#import "DBBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBRecommendBooksTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBookDetailCustomModel *model;
@end

NS_ASSUME_NONNULL_END
