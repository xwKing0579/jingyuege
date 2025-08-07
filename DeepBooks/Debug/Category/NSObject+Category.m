//
//  NSObject+Category.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/12.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>
#import "UIColor+Category.h"
#import "NSObject+Mediator.h"

@implementation NSObject (Category)



- (NSArray <NSDictionary *>*)propertyList{
    NSMutableArray *propertyArray = [NSMutableArray array];
    if ([self isKindOfClass:[NSString class]] ||
        [self isKindOfClass:[NSDate class]] ||
        [self isKindOfClass:[NSData class]]){
        return @[@{@"description":self.description}];
    }
    NSMutableArray *keys = [NSMutableArray array];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        if ([keys containsObject:key]) continue;
        id value = [self performAction:key];
        if (value) {
            [keys addObject:key];
            [propertyArray addObject:@{key:value}];
        }
    }
    free(properties);
    return propertyArray;
}

- (NSArray <NSDictionary *>*)customPropertyList:(NSArray <NSString *>*)properties{
    NSMutableArray *propertyArray = [NSMutableArray array];
    for (NSString *key in properties) {
        id value = [self performAction:key];
        ///特殊处理非对象类型数据
        if ([key isEqualToString:@"borderColor"]){
            value = [UIColor colorWithCGColor:(__bridge CGColorRef _Nonnull)([self valueForKey:key])];
        }
        if (!value) continue;
        if ([value isKindOfClass:[UIColor class]]) {
            UIColor *color = (UIColor *)value;
            [propertyArray addObject:@{key:[color bf_hexStringWithAlpha:YES]}];
        }else{
            [propertyArray addObject:@{key:value}];
        }
    }
    return propertyArray;
}

@end
