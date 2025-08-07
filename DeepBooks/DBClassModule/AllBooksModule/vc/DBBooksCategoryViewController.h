//
//  DBBooksCategoryViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/3.
//

#import "DBBaseAdViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBooksCategoryViewController : DBBaseAdViewController
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
