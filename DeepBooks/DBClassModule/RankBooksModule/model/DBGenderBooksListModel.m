//
//  DBGenderBooksListModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBGenderBooksListModel.h"

@implementation DBGenderBooksListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"dataList": DBBooksDataModel.class,
    };
}
@end
