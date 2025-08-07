//
//  DBTypeBookTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBBaseTableViewCell.h"
#import "DBTypeBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBTypeBookTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBTypeBookModel *model;
@end

NS_ASSUME_NONNULL_END
