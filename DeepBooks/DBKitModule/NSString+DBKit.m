//
//  NSString+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "NSString+DBKit.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"


@implementation NSString (DBKit)

- (NSString *)classString{
    return [self stringByAppendingString:kNSObjectClassObjectName];
}

- (NSString*)md532BitLower{
    const char *cStr = [self UTF8String];
    unsigned char result[16];

    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );

    return [[NSString stringWithFormat:
    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
    result[0], result[1], result[2], result[3],
    result[4], result[5], result[6], result[7],
    result[8], result[9], result[10], result[11],
    result[12], result[13], result[14], result[15]
    ] lowercaseString];
}

- (NSString *)timeFormat{
    NSString *time = self;
    NSArray *timeArray = @[DBConstantString.ks_hours,DBConstantString.ks_minutes,DBConstantString.ks_justNow,DBConstantString.ks_yesterday,@"."];
    for (NSString *timeString in timeArray) {
        if ([time containsString:timeString]) return time;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:+28800];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:time];
    
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    NSString *result;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date toDate:now options:0];

    if (timeInterval < 60) {
        result = DBConstantString.ks_justNow;
    } else if (timeInterval < 3600) {
        NSInteger minutes = (NSInteger)(timeInterval / 60);
        result = [NSString stringWithFormat:DBConstantString.ks_minutesAgo, (long)minutes];
    } else if (timeInterval < 86400) {
        NSInteger hours = (NSInteger)(timeInterval / 3600);
        result = [NSString stringWithFormat:DBConstantString.ks_hoursAgo, (long)hours];
    } else if ([calendar isDateInYesterday:date]) {
        [dateFormatter setDateFormat:DBConstantString.ks_yesterdayTimeFormat];
        result = [dateFormatter stringFromDate:date];
    } else if (components.year == 0) {
        [dateFormatter setDateFormat:@"MM.dd"];
        result = [dateFormatter stringFromDate:date];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        result = [dateFormatter stringFromDate:date];
    }
    return result;
}

- (NSDate *)timeToDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-d HH:mm:ss"];
    return [dateFormatter dateFromString:self];
}

- (NSString *)prefixCapital{
    if (self.length){
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self substringToIndex:1] capitalizedString]];
    }
    return self;
}

- (NSString *)characterSet{
    if (self.length == 0) return self;
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)aesDecryptText{
    NSData *data = [GTMBase64 decodeString:self];
    NSData *decryptData = [data AES128DecryptWithKey:@"Pxga!h*e4@T8xfOm" Iv:@"E&z!EHGLd$fli*8R"];
    NSString *content = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return content;
}

- (NSString *)whitespace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)removeBookMarks{
    NSString *newString = [self stringByReplacingOccurrencesOfString:@"《" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"》" withString:@""];
    return newString;
}

- (NSMutableAttributedString *)lightContent:(NSString *)content lightColor:(UIColor *)lightColor{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    if (!content.length) return attributedString;
    NSRange range = [attributedString.string rangeOfString:content];
    if (range.location != NSNotFound) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:lightColor range:range];
    }
    return attributedString;
}

- (BOOL)isMobile{
    NSString *mobileRegex = @"^[1]([3-9][0-9])[0-9]{8}$";
    DBContryCodeModel *model = DBCommonConfig.contyCodeModel;
    if (model) {
        mobileRegex = model.regexp_literal;
    }
    return [self isValidateByRegex:mobileRegex];
}

- (BOOL)isPassword{
    return [self isValidateByRegex:@"^.{6,20}$"];
}

- (BOOL)isEmail{
    return [self isValidateByRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"];
}

- (BOOL)isValidateByRegex:(NSString *)regex{
    if (regex.length <= 0) return NO;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)isChapterStringEqual:(NSString *)str1 toString:(NSString *)str2 {
    // 1. 提取数字部分
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(第)([零一二三四五六七八九十百千万0-9]+)(章)" options:0 error:nil];
    
    // 处理第一个字符串
    NSString *normalizedStr1 = [self normalizeChapterString:str1 withRegex:regex];
    // 处理第二个字符串
    NSString *normalizedStr2 = [self normalizeChapterString:str2 withRegex:regex];
    
    // 比较规范化后的字符串
    return [normalizedStr1 isEqualToString:normalizedStr2];
}

- (NSString *)normalizeChapterString:(NSString *)chapter withRegex:(NSRegularExpression *)regex {
    __block NSString *result = [chapter copy];
    
    [regex enumerateMatchesInString:chapter options:0 range:NSMakeRange(0, chapter.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        if (match.numberOfRanges >= 3) {
            NSRange numberRange = [match rangeAtIndex:2];
            NSString *numberStr = [chapter substringWithRange:numberRange];
            
            // 将中文数字转换为阿拉伯数字
            NSString *arabicNumber = [self chineseNumberToArabic:numberStr];
            
            // 替换为统一格式
            result = [result stringByReplacingCharactersInRange:numberRange withString:arabicNumber];
        }
    }];
    
    return result;
}

- (NSString *)chineseNumberToArabic:(NSString *)chineseNum {
    NSDictionary *numberMap = @{
        @"零": @"0", @"一": @"1", @"二": @"2", @"三": @"3", @"四": @"4",
        @"五": @"5", @"六": @"6", @"七": @"7", @"八": @"8", @"九": @"9",
        @"十": @"10", @"百": @"100", @"千": @"1000", DBConstantString.ks_tenThousand: @"10000"
    };
    
    NSString *result = chineseNum;
    for (NSString *key in numberMap) {
        result = [result stringByReplacingOccurrencesOfString:key withString:numberMap[key]];
    }
    return result;
}

- (NSString *)textMultilingual{
    NSString *path = [[NSBundle mainBundle] pathForResource:DBAppSetting.languageAbbrev ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:DBSafeString(self) value:nil table:@"InfoPlist"];;
}

@end
