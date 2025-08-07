//
//  DBBooksListModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/1.
//

#import "DBBooksListModel.h"

@implementation DBBooksListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"books": DBBooksModel.class,
    };
}
@end


@implementation DBBooksModel
- (NSString *)image{
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_image];
}
@end
