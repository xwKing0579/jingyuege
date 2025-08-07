//
//  NSUserDefaults+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (DBKit)

+ (void)saveValue:(id)value forKey:(NSString *)key;

+ (id)takeValueForKey:(NSString *)key;
+ (BOOL)boolValueForKey:(NSString *)key;
+ (void)removeValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
