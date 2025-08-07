//
//  DBSpeechVoiceTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/18.
//

#import "DBBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBSpeechVoiceTableViewCell : DBBaseTableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
