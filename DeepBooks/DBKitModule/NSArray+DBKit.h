//
//  NSArray+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DBKit)

- (NSArray *)mapIvar:(NSString *)ivar containsString:(NSString *)string;

- (BOOL)containIvar:(NSString *)ivar value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
