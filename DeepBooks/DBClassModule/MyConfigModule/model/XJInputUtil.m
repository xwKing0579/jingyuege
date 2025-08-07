//
//  XJInputUtil.m
//  XJ_WeChat
//
//  Created by mac on 2019/5/9.
//  Copyright © 2019 mac. All rights reserved.
//

#import "XJInputUtil.h"

@implementation XJInputUtil

/// 真实长度
+ (CGFloat)getStringRealLengthText:(NSString *)text
                        statisticsType:(XJStatisticsType)statisticsType{
    __block CGFloat stringLength = 0.0;
    __weak typeof(self) weakSelf = self;
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        //NSLog(@"%@  \t%zd", substring, strlen([substring UTF8String]));
        if (substring.length) {
            NSInteger l = strlen([substring UTF8String]);
            /// 表情
            if (l >= 4) stringLength += 1.0;
            /// 汉字
            else if (l == 3) stringLength += 1.0;
            /// 其它
            else stringLength += [weakSelf getZimuLength:statisticsType];
        }
    }];
    return stringLength;
}

/// 显示的长度
+ (NSInteger)getStringShowLengthText:(NSString *)text
                          statisticsType:(XJStatisticsType)statisticsType
{
    CGFloat length = [self getStringRealLengthText:text statisticsType:statisticsType];
    return (NSInteger)roundf(length);
}

/// 字母、空格等长度
+ (CGFloat)getZimuLength:(XJStatisticsType)statisticsType {
    return (statisticsType == XJStatisticsNormal ? 1 : 0.5);
}

+ (NSMutableAttributedString *)getLbAttributedText:(NSString *)text
                                                length:(NSInteger)length
                                                 color:(UIColor *)color
{
    NSString *attText = [NSString stringWithFormat:@"%ld",length];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attText.length)];
    return attributeStr;
}

@end

