//
//  NSArray+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "NSArray+DBKit.h"

@implementation NSArray (DBKit)

- (NSArray *)mapIvar:(NSString *)ivar containsString:(NSString *)string{
    NSString *predicateFormat = [ivar stringByAppendingString:@" == %@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, string];
    return [self filteredArrayUsingPredicate:predicate];
}

- (BOOL)containIvar:(NSString *)ivar value:(NSString *)value{
    return [self mapIvar:ivar containsString:value].count;
}

@end
