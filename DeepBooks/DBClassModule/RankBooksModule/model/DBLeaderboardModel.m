//
//  DBLeaderboardModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBLeaderboardModel.h"

@implementation DBLeaderboardModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"comics": DBLeaderboardItemModel.class,
        @"male":   DBLeaderboardItemModel.class,
        @"female": DBLeaderboardItemModel.class,
    };
}
@end

@implementation DBLeaderboardItemModel

@end

