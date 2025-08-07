//
//  DBBookCommentModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBookCommentModel.h"

@implementation DBBookCommentModel

- (NSString *)avatar{
    return [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:_avatar];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"fav_arr": DBBookFavModel.class,
        @"reply_arr":   DBBookReplyModel.class,
    };
}

@end

@implementation DBBookFavModel

- (NSString *)avatar{
    return [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:_avatar];
}

@end

@implementation DBBookReplyModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"reply_to_comment": DBBookReplyModel.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"nick": @[@"nick",@"nick_name"]};
}

- (NSString *)avatar{
    return [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:_avatar];
}
@end
