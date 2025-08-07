//
//  NSDate+Category.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Category)

+ (NSString *)currentTime;
+ (NSString *)timeFromDate:(NSDate *)date;
+ (NSString *)currentTimeFormatterString:(NSString *)formatterString;

- (NSString *)toString;

+ (NSDate *)yearBefore:(int)n;

- (NSDateComponents *)dateComponents;

+ (NSInteger)daysInYear:(NSInteger)year month:(NSInteger)month;
@end

NS_ASSUME_NONNULL_END
