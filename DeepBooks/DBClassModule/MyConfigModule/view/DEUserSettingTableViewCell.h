//
//  DEUserSettingTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/25.
//

#import "DBBaseTableViewCell.h"
#import "DBUserSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DEUserSettingTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBUserSettingModel *model;
@end

NS_ASSUME_NONNULL_END
