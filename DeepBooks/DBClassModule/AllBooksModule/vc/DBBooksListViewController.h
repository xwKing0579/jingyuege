//
//  DBBooksListViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBBaseAdViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBBooksListViewController : DBBaseAdViewController
@property (nonatomic, copy) NSString *list_id;
@property (nonatomic, assign) BOOL isCollected;
@end

NS_ASSUME_NONNULL_END
