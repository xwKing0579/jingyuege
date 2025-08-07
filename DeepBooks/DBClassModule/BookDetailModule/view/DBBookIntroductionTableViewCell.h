//
//  DBBookIntroductionTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/3.
//

#import "DBBaseTableViewCell.h"
#import "DBBookDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookIntroductionTableViewCell : DBBaseTableViewCell
@property (nonatomic, strong) DBBookDetailModel *model;
@end

NS_ASSUME_NONNULL_END
