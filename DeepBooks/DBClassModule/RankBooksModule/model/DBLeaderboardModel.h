//
//  DBLeaderboardModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBLeaderboardItemModel;


@interface DBLeaderboardModel : NSObject
@property (nonatomic, strong) NSArray <DBLeaderboardItemModel *> *comics;
@property (nonatomic, strong) NSArray <DBLeaderboardItemModel *> *male;
@property (nonatomic, strong) NSArray <DBLeaderboardItemModel *> *female;
@end

@interface DBLeaderboardItemModel : NSObject

@property (nonatomic, copy) NSString *rank_title;
@property (nonatomic, copy) NSString *rank_id;

@end


NS_ASSUME_NONNULL_END
