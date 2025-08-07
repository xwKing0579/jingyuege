//
//  DBDecryptManager.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBDecryptManager : NSObject

+ (NSString *)decryptText:(NSString *)text ver:(NSInteger)ver;

@end

NS_ASSUME_NONNULL_END
