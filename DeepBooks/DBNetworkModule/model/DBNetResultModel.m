//
//  DBNetResultModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBNetResultModel.h"


@implementation DBNetResultModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data" : DBDataResultModel.class,
    };
}
@end

@implementation DBDataResultModel

@end
