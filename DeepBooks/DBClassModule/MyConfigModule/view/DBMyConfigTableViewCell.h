//
//  DBMyConfigTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBBaseTableViewCell.h"
#import "DBMyConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBMyConfigTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBMyConfigModel *model;
@end

NS_ASSUME_NONNULL_END
