//
//  NSAttributedString+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (DBKit)
+ (NSMutableAttributedString *)combineAttributeTexts:(NSArray *)texts colors:(NSArray *)colors fonts:(NSArray *)fonts;
+ (NSMutableAttributedString *)combineAttributeTexts:(NSArray *)texts colors:(NSArray *)colors fonts:(NSArray *)fonts attrs:(NSArray <NSDictionary *>* __nullable)attrs;

@end

NS_ASSUME_NONNULL_END
