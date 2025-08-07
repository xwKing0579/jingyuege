//
//  DBReadBookTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/10.
//

#import "DBBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBReadBookTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) NSAttributedString *content;
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
