//
//  DBMyBookListModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBMyBookListModel.h"

@implementation DBMyBookListModel

@end

@implementation DBBookIdsListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"lists": DBBookIdModel.class,
    };
}
@end

@implementation DBBookIdModel

@end
