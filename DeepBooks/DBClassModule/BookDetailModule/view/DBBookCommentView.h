//
//  DBBookCommentView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import <UIKit/UIKit.h>
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBookCommentView : UIView
@property (nonatomic, copy) DBBookCommentModel *model;
@property (nonatomic, copy) NSString *bookName;
@end

NS_ASSUME_NONNULL_END
