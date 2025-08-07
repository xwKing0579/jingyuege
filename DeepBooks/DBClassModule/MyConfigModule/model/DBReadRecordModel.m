//
//  DBReadRecordModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBReadRecordModel.h"

@implementation DBReadRecordModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"dataList": DBBookModel.class,
    };
}
@end
