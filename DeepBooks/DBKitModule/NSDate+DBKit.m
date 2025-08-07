//
//  NSDate+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/11.
//

#import "NSDate+DBKit.h"

@implementation NSDate (DBKit)
- (NSInteger)year{
    return [NSCalendar.currentCalendar component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)timeStampInterval{
    return (NSInteger)[self timeIntervalSince1970];
}

- (NSString *)timeSignString{
    return [[NSString stringWithFormat:@"%@%@2%ldvhjJVz1St6tK7!8n#B0MqRIuE2Dh7!C#",UIApplication.appBundle,DBCommonConfig.userToken,self.timeStampInterval] md532BitLower];
}

+ (NSInteger)currentInterval{
    return (NSInteger)[NSDate.date timeIntervalSince1970];
}

+ (NSString *)hourMinuteString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:NSDate.date];
}


- (NSString *)dateToTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:self];
}
@end
