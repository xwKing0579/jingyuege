//
//  DBSearchBooksModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBSearchBooksModel.h"

@implementation DBSearchBooksModel
- (NSString *)image{
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_image];
}
@end

@implementation DBSearchBookDateModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"book": DBSearchBooksModel.class,
    };
}
@end
