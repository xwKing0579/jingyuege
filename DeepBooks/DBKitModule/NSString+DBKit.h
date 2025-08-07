//
//  NSString+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DBKit)

- (NSString *)classString;

- (NSString*)md532BitLower;

- (NSString *)timeFormat;


- (NSDate *)timeToDate;

//首字母大写
- (NSString *)prefixCapital;

//处理链接中中文
- (NSString *)characterSet;

//解密
- (NSString *)aesDecryptText;

- (NSString *)whitespace;

- (NSString *)removeBookMarks;

- (NSMutableAttributedString *)lightContent:(NSString *)content lightColor:(UIColor *)lightColor;

- (BOOL)isMobile;
- (BOOL)isPassword;
- (BOOL)isEmail;

- (BOOL)isChapterStringEqual:(NSString *)str1 toString:(NSString *)str2;

- (NSString *)textMultilingual;

@end

NS_ASSUME_NONNULL_END
