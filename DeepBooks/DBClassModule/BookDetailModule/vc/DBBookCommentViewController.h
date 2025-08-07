//
//  DBBookCommentViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/10.
//

#import "DBBaseViewController.h"
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookCommentViewController : DBBaseViewController
@property (nonatomic, strong) DBBookCommentModel *model;
@property (nonatomic, strong) NSString *bookName;
@end

NS_ASSUME_NONNULL_END
