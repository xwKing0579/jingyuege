//
//  BFString.m
//  OCProject
//
//  Created by 王祥伟 on 2024/3/14.
//




#import "BFString.h"

#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation BFString
#pragma clang diagnostic pop

+ (NSString *)prefix_app{ return @"BF"; }
+ (NSString *)prefix_viewController{ return @"vc_"; }
+ (NSString *)suffix_viewController{ return @"ViewController"; }
+ (NSString *)prefix_tableViewCell{ return @"tc_"; }
+ (NSString *)suffix_tableViewCell{ return @"TableViewCell"; }

+ (NSString *)vc_base_tabbar{ return @"BFBaseTabBarController"; }
+ (NSString *)vc_base_navigation{ return @"BFBaseNavigationController"; };
+ (NSString *)vc_tabbar{ return @"BFTabBarController"; };


#define BF_RESOLVE_CLASS_METHOD(_conditions, _selector) \
if ( _conditions ) {\
    Method method = class_getClassMethod([self class],_selector);\
    Class metacls = objc_getMetaClass(NSStringFromClass([self class]).UTF8String);\
    class_addMethod(metacls,selector,method_getImplementation(method),method_getTypeEncoding(method));\
    return YES;\
}\

+ (BOOL)resolveClassMethod:(SEL)selector{
    BF_RESOLVE_CLASS_METHOD([NSStringFromSelector(selector) hasPrefix:self.prefix_tableViewCell], @selector(string_tableViewCell))
    BF_RESOLVE_CLASS_METHOD([NSStringFromSelector(selector) hasPrefix:self.prefix_viewController], @selector(string_viewController))
    BF_RESOLVE_CLASS_METHOD([NSStringFromSelector(selector) hasPrefix:[self.prefix_app lowercaseString]], @selector(string_selector))
    BF_RESOLVE_CLASS_METHOD(NSStringFromSelector(selector).length, @selector(string_selector_unknow))
    return [super resolveClassMethod:selector];
    return YES;
}

+ (NSString *)string_tableViewCell{
    NSArray <NSString *>*names = [NSStringFromSelector(_cmd) componentsSeparatedByString:@"_"];
    NSString *cellString = self.prefix_app;
    for (int i = 1; i < names.count; i++) {
        cellString = [cellString stringByAppendingString:names[i].prefixCapital];
    }
    return [NSString stringWithFormat:@"%@%@",cellString,self.suffix_tableViewCell];
}

+ (NSString *)string_viewController{
    NSArray <NSString *>*names = [NSStringFromSelector(_cmd) componentsSeparatedByString:@"_"];
    NSString *cellString = self.prefix_app;
    for (int i = 1; i < names.count; i++) {
        cellString = [cellString stringByAppendingString:names[i].prefixCapital];
    }
    return [NSString stringWithFormat:@"%@%@",cellString,self.suffix_viewController];
}

+ (NSString *)string_selector{
    NSArray <NSString *>*names = [NSStringFromSelector(_cmd) componentsSeparatedByString:@"_"];
    NSString *cellString = self.prefix_app;
    for (int i = 1; i < names.count; i++) {
        cellString = [cellString stringByAppendingString:names[i].prefixCapital];
    }
    return cellString;
}

+ (NSString *)string_selector_unknow{
    return NSStringFromSelector(_cmd);
}

@end

@implementation NSString (SelectorName)

- (Class)toClass{
    return NSClassFromString(self);
}

- (NSString *)prefixCapital{
    if (self.length){
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self substringToIndex:1] capitalizedString]];
    }
    return self;
}

- (NSString *)abbr{
    NSString *temp = self;
    NSString *prefix = [BFString.prefix_app uppercaseString];
    NSString *suffix = BFString.suffix_viewController;
    if ([temp hasPrefix:prefix]){
        temp = [temp stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
    }
    if ([temp hasSuffix:suffix]){
        temp = [temp stringByReplacingCharactersInRange:NSMakeRange(temp.length-suffix.length, suffix.length) withString:@""];
    }
    return convertStringToSnakeCase(temp);
}

NSString *convertStringToSnakeCase(NSString *input) {
    for (int i = 0; i < input.length; i++) {
        unichar currentChar = [input characterAtIndex:i];
        if (currentChar >= 'A' && currentChar <= 'Z'){
            NSString *lowString = [NSString stringWithFormat:@"_%c", tolower(currentChar)];
            if (i == 0 || i == input.length - 1){
                lowString = [lowString substringFromIndex:1];
            }
            input = [input stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:lowString];
        }
    }
    return input;
}

@end
