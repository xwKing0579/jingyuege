//
//  DBMuteLanguageTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/18.
//

#import "DBBaseTableViewCell.h"
#import "DBMuteLanguageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBMuteLanguageTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBMuteLanguageModel *model;
@property (nonatomic, copy) NSString *abbrev;
@end

NS_ASSUME_NONNULL_END
