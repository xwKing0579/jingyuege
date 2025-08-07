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
    @{@"name":@"软件许可及用户服务协议/隐私声明",@"url":DBService,@"params":@{@"type":@1,@"title":@"软件许可及用户服务协议"}},
    @{@"name":@"免责声明",@"url":DBService,@"params":@{@"type":@2,@"title":@"免责声明"}},
    ];
    return [NSArray yy_modelArrayWithClass:self.class json:dataList];
}

@end
