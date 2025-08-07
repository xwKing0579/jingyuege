//
//  UIFont+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIFont+DBKit.h"

#import <CoreText/CoreText.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIFont (DBKit)
#pragma clang diagnostic pop

+ (BOOL)resolveClassMethod:(SEL)selector{
    NSString *string = NSStringFromSelector(selector);
    CGFloat size = [[string substringFromIndex:string.length-2] floatValue];
    RESOLVE_CLASS_METHOD(size > 0 && size < 99, @selector(classMethodRedefine))
    return [super resolveClassMethod:selector];
}

+ (UIFont *)classMethodRedefine{
    NSString *cmdString = NSStringFromSelector(_cmd);
    NSString *selectorString = [NSString stringWithFormat:@"%@:",[cmdString substringToIndex:cmdString.length-2]];
    NSString *sizeString = [cmdString substringFromIndex:cmdString.length-2];
    return [self dynamicAllusionTomethod:selectorString object:sizeString];
}

+ (UIFont *)pingFangRegular:(NSString *)size{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size.floatValue];
}

+ (UIFont *)pingFangMedium:(NSString *)size{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size.floatValue];
}

+ (UIFont *)pingFangSemibold:(NSString *)size{
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size.floatValue];
}

@end
