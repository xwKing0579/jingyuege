//
//  DBServiceTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBBaseTableViewCell.h"
#import "DBServiceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBServiceTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBServiceModel *model;
@end

NS_ASSUME_NONNULL_END
