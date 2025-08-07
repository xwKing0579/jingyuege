//
//  DBPageScrollCollectionViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import <UIKit/UIKit.h>
#import "DBPageIGModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBPageScrollCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) DBPageIGModel *model;

@end

NS_ASSUME_NONNULL_END
