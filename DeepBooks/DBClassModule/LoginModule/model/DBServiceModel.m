//
//  DBServiceModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBServiceModel.h"

@implementation DBServiceModel

+ (NSArray *)dataSourceList{
    NSArray *dataList= @[
    @{@"name":DBConstantString.ks_termsAndPrivacy,@"url":DBService,@"params":@{@"type":@1,@"title":DBConstantString.ks_terms}},
    @{@"name":DBConstantString.ks_disclaimer,@"url":DBService,@"params":@{@"type":@2,@"title":DBConstantString.ks_disclaimer}},
    ];
    return [NSArray yy_modelArrayWithClass:self.class json:dataList];
}

@end
