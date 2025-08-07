//
//  DBSearchResultViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBBaseAdViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBSearchResultViewController : DBBaseViewController
@property (nonatomic, copy) NSString *searchWords;
@property (nonatomic, copy) NSString *form; //1小说，2听书，3漫画
@end

NS_ASSUME_NONNULL_END
