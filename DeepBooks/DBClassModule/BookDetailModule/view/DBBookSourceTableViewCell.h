//
//  DBBookSourceTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBaseTableViewCell.h"
#import "DBBookSourceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookSourceTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBookSourceModel *model;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
