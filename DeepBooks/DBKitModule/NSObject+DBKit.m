//
//  NSObject+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "NSObject+DBKit.h"
#import <UIKit/UIKit.h>

NSString *const kNSObjectClassObjectName = @"_Class";

#define CASE_TYPE(_typeChar, _type, _method) case _typeChar: ACTION_TYPE(_type, _method)
#define STRUCT_TYPE(_type, _method) if (strcmp(paramType, @encode(_type)) == 0) ACTION_TYPE(_type, _method)
#define STRING_TYPE(_type, _method) if (strcmp(paramType, @encode(_type)) == 0) { _type param = _method; ACTION_SET_ARGUMENT }
#define ACTION_TYPE(_type, _method) { _type param = [value _method]; ACTION_SET_ARGUMENT }
#define ACTION_SET_ARGUMENT [invocation setArgument:&param atIndex:idx]; break;

#define CASE_GET_TYPE(_typeChar, _type) case _typeChar: ACTION_GET_VALUE(_type)
#define STRUCT_GET_TYPE(_type) if (strcmp(returnType, @encode(_type)) == 0) ACTION_GET_VALUE(_type)
#define ACTION_GET_VALUE(_type) { _type result; [invocation getReturnValue:&result]; return @(result); }

#define SAFE_PERFORM_SELECTOR SEL sel = NSSelectorFromString(action);\
return [self respondsToSelector:sel] ? [NSObject safedynamicAllusionTomethod:self selector:sel objects:objects] : nil;\

#define CREATE_OBJECTS NSMutableDictionary *objects = [NSMutableDictionary dictionary];\
if(object1) [objects setValue:object1 forKey:@"1"];\
if(object2) [objects setValue:object2 forKey:@"2"];\

@implementation NSObject (DBKit)
- (id)dynamicAllusionTomethod:(NSString *)action{
    return [self dynamicAllusionTomethod:action object:nil];
}

- (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object{
    return [self dynamicAllusionTomethod:action object:object object:nil];
}

- (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object1 object:(id __nullable)object2{
    CREATE_OBJECTS
    return [self dynamicAllusionTomethod:action objects:objects];
}

- (id)dynamicAllusionTomethod:(NSString *)action objects:(NSDictionary * __nullable)objects{
    SAFE_PERFORM_SELECTOR
}

+ (id)dynamicAllusionTomethod:(NSString *)action{
    return [self dynamicAllusionTomethod:action object:nil];
}

+ (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object{
    return [self dynamicAllusionTomethod:action object:object object:nil];
}

+ (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object1 object:(id __nullable)object2{
    CREATE_OBJECTS
    return [self dynamicAllusionTomethod:action objects:objects];
}

+ (id)dynamicAllusionTomethod:(NSString *)action objects:(NSDictionary * __nullable)objects{
    SAFE_PERFORM_SELECTOR
}

#pragma mark - public methods
+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action {
    return [self dynamicAllusionTomethod:target action:action objects:@{}];
}

+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action object:(id __nullable)object {
    return [self dynamicAllusionTomethod:target action:action object:object object:@{}];
}

+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action object:(id __nullable)object1 object:(id __nullable)object2{
    CREATE_OBJECTS
    return [self dynamicAllusionTomethod:target action:action objects:objects];
}

+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action objects:(NSDictionary * __nullable)objects{
    if (!(target && action)) return nil;
    
    id targetObject = nil;
    if ([target hasSuffix:kNSObjectClassObjectName]) {
        targetObject = NSClassFromString([target stringByReplacingOccurrencesOfString:kNSObjectClassObjectName withString:@""]);
    }else{
        targetObject = [[NSClassFromString(target) alloc] init];
    }
    
    SEL selector = NSSelectorFromString(action);
    if ([targetObject respondsToSelector:selector]) {
        return [self safedynamicAllusionTomethod:targetObject selector:selector objects:objects];
    }
    return nil;
}

+ (id)safedynamicAllusionTomethod:(id)target selector:(SEL)selector objects:(NSDictionary * __nullable)objects{
    NSMethodSignature *methodSig = [target methodSignatureForSelector:selector];
    if (!methodSig) return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    
    for (NSString *key in objects.allKeys) {
        NSUInteger idx = [key intValue] + 1;
        if (methodSig.numberOfArguments > idx) {
            id obj = objects[key];
            char paramType[255];
            strcpy(paramType, [methodSig getArgumentTypeAtIndex:idx]);
            if (strncmp(paramType, "@", 1) == 0) {
                [invocation setArgument:&obj atIndex:idx];
            }else{
                char type = paramType[0] == 'r' ? paramType[1] : paramType[0];
                
                if ([obj isKindOfClass:[NSNumber class]]) {
                    NSNumber *value = (NSNumber *)obj;
                    switch (type) {
                            CASE_TYPE('c', char, charValue)
                            CASE_TYPE('C', unsigned char, unsignedCharValue)
                            CASE_TYPE('s', short, shortValue)
                            CASE_TYPE('S', unsigned short, unsignedShortValue)
                            CASE_TYPE('i', int, intValue)
                            CASE_TYPE('I', unsigned int, unsignedIntValue)
                            CASE_TYPE('l', long, longValue)
                            CASE_TYPE('L', unsigned long, unsignedLongValue)
                            CASE_TYPE('q', long long, longLongValue)
                            CASE_TYPE('Q', unsigned long long, unsignedLongLongValue)
                            CASE_TYPE('f', float, floatValue)
                            CASE_TYPE('d', double, doubleValue)
                            CASE_TYPE('B', BOOL, boolValue)
                        default:
                            break;
                    }
                }else if ([obj isKindOfClass:[NSString class]]){
                    NSString *value = (NSString *)obj;
                    switch (type) {
                            CASE_TYPE('c', const char *, UTF8String)
                            CASE_TYPE('C', const char *, UTF8String)
                            CASE_TYPE('s', short, intValue)
                            CASE_TYPE('S', unsigned short, intValue)
                            CASE_TYPE('i', int, intValue)
                            CASE_TYPE('I', unsigned int, intValue)
                            CASE_TYPE('l', long, longLongValue)
                            CASE_TYPE('L', unsigned long, longLongValue)
                            CASE_TYPE('q', long long, longLongValue)
                            CASE_TYPE('Q', unsigned long long, longLongValue)
                            CASE_TYPE('f', float, floatValue)
                            CASE_TYPE('d', double, doubleValue)
                            CASE_TYPE('B', BOOL, boolValue)
                            break;
                        case '{':{
                            STRING_TYPE(CGRect, CGRectFromString(value))
                            STRING_TYPE(CGSize, CGSizeFromString(value))
                            STRING_TYPE(CGPoint, CGPointFromString(value))
                            STRING_TYPE(CGVector, CGVectorFromString(value))
                            STRING_TYPE(CGAffineTransform, CGAffineTransformFromString(value))
                            break;
                        }
                        case '*':
                        case '^':{
                            STRING_TYPE(UIOffset, UIOffsetFromString(value))
                            STRING_TYPE(UIEdgeInsets, UIEdgeInsetsFromString(value))
                            STRING_TYPE(NSDirectionalEdgeInsets, NSDirectionalEdgeInsetsFromString(value))
                            break;
                        }
                        case ':': {
                            STRING_TYPE(SEL, NSSelectorFromString(value))
                            break;
                        }
                        default:
                            break;
                    }
                }else if ([obj isKindOfClass:[NSValue class]]){
                    NSValue *value = (NSValue *)obj;
                    switch (type) {
                        case '{':{
                            STRUCT_TYPE(CGRect, CGRectValue)
                            STRUCT_TYPE(CGSize, CGSizeValue)
                            STRUCT_TYPE(CGPoint, CGPointValue)
                            STRUCT_TYPE(CGVector, CGVectorValue)
                            STRUCT_TYPE(CGAffineTransform, CGAffineTransformValue)
                            break;
                        }
                        case '*':
                        case '^':{
                            STRUCT_TYPE(UIOffset, UIOffsetValue)
                            STRUCT_TYPE(UIEdgeInsets, UIEdgeInsetsValue)
                            STRUCT_TYPE(NSDirectionalEdgeInsets, directionalEdgeInsetsValue)
                            break;
                        }
                        default:
                            break;
                    }
                }else {
                    switch (type) {
                        case '#':{
                            [invocation setArgument:&obj atIndex:idx];
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
        }
        
    }
    
    [invocation invoke];
    
    char returnType[255];
    strcpy(returnType, [methodSig methodReturnType]);
    
    if (strcmp(returnType, @encode(void)) == 0){
        return nil;
    }else if (strncmp(returnType, "@", 1) == 0) {
        void *result;
        [invocation getReturnValue:&result];
        return [self transferSelector:selector] ? (__bridge_transfer id)result : (__bridge id)result;
    }else{
        char type = returnType[0] == 'r' ? returnType[1] : returnType[0];
        switch (type) {
                CASE_GET_TYPE('c', char)
                CASE_GET_TYPE('C', unsigned char)
                CASE_GET_TYPE('s', short)
                CASE_GET_TYPE('S', unsigned short)
                CASE_GET_TYPE('i', int)
                CASE_GET_TYPE('I', unsigned int)
                CASE_GET_TYPE('l', long)
                CASE_GET_TYPE('L', unsigned long)
                CASE_GET_TYPE('q', long long)
                CASE_GET_TYPE('Q', unsigned long long)
                CASE_GET_TYPE('f', float)
                CASE_GET_TYPE('d', double)
                CASE_GET_TYPE('B', BOOL)
                break;
            case '{':
                STRUCT_GET_TYPE(CGRect)
                STRUCT_GET_TYPE(CGSize)
                STRUCT_GET_TYPE(CGPoint)
                STRUCT_GET_TYPE(CGVector)
                break;
            case '*':
            case '^': {
                STRUCT_GET_TYPE(UIOffset)
                STRUCT_GET_TYPE(UIEdgeInsets)
                STRUCT_GET_TYPE(NSDirectionalEdgeInsets)
                break;
            }
            case '#': {
                Class result;
                [invocation getReturnValue:&result];
                return result;
            }
            default:{
                break;
            }
        }
    }
    
    return nil;
}

+ (BOOL)transferSelector:(SEL)selector{
    NSArray *retainSelectors = @[@"alloc",@"new",@"copy",@"mutableCopy"];
    return [retainSelectors containsObject:NSStringFromSelector(selector)];
}




#pragma mark - private methods
+ (void)noTarget:(NSString *)target action:(NSString *)action targetObject:(id)targetObject{
    if (targetObject) {
        if ([target hasSuffix:kNSObjectClassObjectName]) {
            target = [target stringByReplacingOccurrencesOfString:kNSObjectClassObjectName withString:@""];
        }else{
        }
    }else{
        if ([target hasSuffix:kNSObjectClassObjectName]) {
            target = [target stringByReplacingOccurrencesOfString:kNSObjectClassObjectName withString:@""];
        }
    }
}



+ (void)swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector{
    swizzleClassMethod(self.class, originSelector, swizzleSelector);
}

- (void)swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector{
    swizzleInstanceMethod(self.class, originSelector, swizzleSelector);
}

static void swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector){
    if (!class_isMetaClass(object_getClass(cls))) {
        return;
    }

    Method originalMethod = class_getClassMethod(cls, originSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzleSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(metacls,
                            swizzleSelector,
                            class_replaceMethod(metacls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

static void swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector){
    if (!class_isMetaClass(object_getClass(cls))) {
        return;
    }
    
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzleSelector);
    
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        originSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            swizzleSelector,
                            class_replaceMethod(cls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}
@end
