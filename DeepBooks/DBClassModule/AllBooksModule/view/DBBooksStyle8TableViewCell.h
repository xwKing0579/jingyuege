//
//  DBBooksStyle8TableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBaseTableViewCell.h"
#import "DBAllBooksModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBooksStyle8TableViewCell : DBBaseTableViewCell

@property (nonatomic, copy) DBDataModel *model;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
