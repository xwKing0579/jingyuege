//
//  DBBookSocreTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/20.
//

#import "DBBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBookSocreTableViewCell : DBBaseTableViewCell
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) void (^commentListBlock)(void);
@property (nonatomic, copy) void (^commentInputBlock)(CGFloat score);
@end

NS_ASSUME_NONNULL_END
