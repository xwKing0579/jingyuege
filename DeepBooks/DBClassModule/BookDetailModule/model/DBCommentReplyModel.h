//
//  DBCommentReplyModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/11.
//

#import <Foundation/Foundation.h>
#import "DBBookCommentModel.h"
NS_ASSUME_NONNULL_BEGIN
@class DBCommentReplyListModel;
@interface DBCommentReplyModel : NSObject
@property (nonatomic, strong) DBCommentReplyListModel *lists;
@property (nonatomic, assign) NSInteger limit;
@end

@interface DBCommentReplyListModel : NSObject
@property (nonatomic, strong) NSArray <DBBookCommentModel *> *comment_reply_list;
@end


NS_ASSUME_NONNULL_END
