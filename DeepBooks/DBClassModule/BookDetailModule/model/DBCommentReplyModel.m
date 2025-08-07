//
//  DBCommentReplyModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/11.
//

#import "DBCommentReplyModel.h"

@implementation DBCommentReplyModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"lists": DBCommentReplyListModel.class,
    };
}
@end

@implementation DBCommentReplyListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"comment_reply_list": DBBookCommentModel.class,
    };
}
@end
