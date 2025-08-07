//
//  DBBookTypesModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import "DBBookTypesModel.h"

@implementation DBBookTypesModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"comics": DBBookTypesGenderModel.class,
        @"female": DBBookTypesGenderModel.class,
        @"male":   DBBookTypesGenderModel.class,
        @"banner": DBBookTypesBannerModel.class,
    };
}
@end

@implementation DBBookTypesGenderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"ltype_list": DBBookTypesListModel.class,
    };
}

- (NSString *)ltype_image{
    return [DBLinkManager combineLinkWithType:DBLinkIconResUrl combine:_ltype_image];
}
@end


@implementation DBBookTypesBannerModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"data": DBBookTypesDataModel.class,
    };
}
@end

@implementation DBBookTypesListModel

@end

@implementation DBBookTypesDataModel

@end
