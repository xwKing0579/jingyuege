//
//  NSUserDefaults+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "NSUserDefaults+DBKit.h"

@implementation NSUserDefaults (DBKit)

+ (void)saveValue:(id)value forKey:(NSString *)key{
    if (!value || !key) return;
    [NSUserDefaults.standardUserDefaults setValue:value forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (id)takeValueForKey:(NSString *)key{
    if (!key) return nil;
    return [NSUserDefaults.standardUserDefaults valueForKey:key];
}

+ (BOOL)boolValueForKey:(NSString *)key{
    return [[self takeValueForKey:key] boolValue];
}

+ (void)removeValueForKey:(NSString *)key{
    [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
}
@end
