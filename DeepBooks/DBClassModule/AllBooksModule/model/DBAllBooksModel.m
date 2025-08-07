//
//  DBAllBooksModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import "DBAllBooksModel.h"

@implementation DBAllBooksModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data": DBDataModel.class,
        @"banner": DBBannerModel.class,
        @"icon": DBIconModel.class,
    };
}
@end

@implementation DBDataModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data": DBBooksDataModel.class,
    };
}
@end

@implementation DBBannerModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data": DBBooksDataModel.class,
    };
}

- (NSString *)image{
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_image];
}

@end

@implementation DBIconModel

@end

