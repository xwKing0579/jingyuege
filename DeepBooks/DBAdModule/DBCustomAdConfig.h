//
//  DBCustomAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DBAdCustomType) {
    DBAdCustomLaunch,
    DBAdCustomBanner,
    DBAdCustomReward,
    DBAdCustomExpress,
    DBAdCustomSlot,
};

@interface DBCustomAdConfig : NSObject



@end

NS_ASSUME_NONNULL_END
