//
//  DBReaderScrollCollectionViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/19.
//

#import <UIKit/UIKit.h>
#import "DBReaderScrollModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBReaderScrollCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) DBReaderScrollModel *model;
@property (nonatomic, copy) NSAttributedString *attri;
@end

NS_ASSUME_NONNULL_END
