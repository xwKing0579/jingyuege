//
//  NSData+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (DBKit)

- (NSData *)AES128EncryptWithKey:(NSString *)key Iv:(NSString *)Iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key Iv:(NSString *)Iv;

@end

NS_ASSUME_NONNULL_END
