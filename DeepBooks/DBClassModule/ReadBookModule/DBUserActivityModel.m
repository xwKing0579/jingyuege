//
//  DBUserActivityModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/14.
//

#import "DBUserActivityModel.h"

@implementation DBUserActivityModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
        @"desc":@"description",
        @"idStr":@"id",
    };
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"rules": DBRulesModel.class,
    };
}
@end


@implementation DBRulesModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"sign_in_rules": DBReadRulesModel.class,
        @"read_rules": DBReadRulesModel.class,
        @"first_login_rules": DBReadRulesModel.class,
        @"continuous_rules": DBReadRulesModel.class,
        @"watch_ad_rules": DBReadRulesModel.class,
        @"free_vip_rules": DBReadRulesModel.class,
        @"share_rules": DBReadRulesModel.class,
        @"special_rules": DBReadRulesModel.class,
        @"invite_rules": DBReadRulesModel.class,
    };
}
@end

@implementation DBReadRulesModel

@end
