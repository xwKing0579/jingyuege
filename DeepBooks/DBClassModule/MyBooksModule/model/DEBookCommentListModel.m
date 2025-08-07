//
//  DEBookCommentListModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DEBookCommentListModel.h"


@implementation DEBookCommentListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"lists": DBBookCommentModel.class,
    };
}
@end
