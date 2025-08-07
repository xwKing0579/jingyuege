//
//  DBReadBookCatalogsTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/7.
//

#import "DBBaseTableViewCell.h"
#import "DBBookCatalogModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBReadBookCatalogsTableViewCell : DBBaseTableViewCell
@property (nonatomic, copy) DBBookCatalogModel *model;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isLoaded;
@end

NS_ASSUME_NONNULL_END
