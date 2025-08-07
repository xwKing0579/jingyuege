//
//  DBReadDetailTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/22.
//

#import "DBBaseTableViewCell.h"
#import "DBBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBReadDetailTableViewCell : DBBaseTableViewCell
@property (nonatomic, strong) DBBookDetailModel *model;
@property (nonatomic, copy) void (^remarkBlock)(void);
@end

NS_ASSUME_NONNULL_END
