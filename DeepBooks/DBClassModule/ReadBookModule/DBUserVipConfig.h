//
//  DBUserVipConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/8/13.
//

#import <Foundation/Foundation.h>
#import "DBUserActivityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBUserVipConfig : NSObject

+ (BOOL)isUserVip;

+ (NSString *)readerButtonContent;
+ (UIColor *)readerButtonBgColor;
+ (UIColor *)readerButtonTextColor;

+ (void)checkFreeVipActivityCompletion:(void (^ __nullable)(DBUserActivityModel *activityModel))completion;

@end

NS_ASSUME_NONNULL_END
