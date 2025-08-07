//
//  DBWantBookListModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBWantBookListModel.h"

@implementation DBWantBookListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"lists": DBWantBookModel.class,
    };
}
@end


@implementation DBWantBookModel

@end
