//
//  NSDate+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DBKit)
- (NSInteger)year;

- (NSInteger)timeStampInterval;
- (NSString *)timeSignString;

+ (NSInteger)currentInterval;

+ (NSString *)hourMinuteString;

- (NSString *)dateToTimeString;
@end

NS_ASSUME_NONNULL_END
