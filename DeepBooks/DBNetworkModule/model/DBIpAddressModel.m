//
//  DBIpAddressModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/13.
//

#import "DBIpAddressModel.h"

@implementation DBIpAddressModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"ip_map" : DBIpAddressMapModel.class,
    };
}
@end

@implementation DBIpAddressMapModel

@end
