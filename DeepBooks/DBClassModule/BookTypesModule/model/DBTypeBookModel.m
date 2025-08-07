//
//  DBTypeBookModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBTypeBookModel.h"

@implementation DBTypeBookModel
- (NSString *)image{
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_image];
}
@end

@implementation DBTypeBookListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"lists": DBTypeBookModel.class,
    };
}
@end
