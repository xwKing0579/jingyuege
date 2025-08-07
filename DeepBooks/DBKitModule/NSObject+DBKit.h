//
//  NSObject+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXTERN NSString *const kNSObjectClassObjectName;
@interface NSObject (DBKit)

- (id)dynamicAllusionTomethod:(NSString *)action;
- (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object;
- (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object1 object:(id __nullable)object2;
- (id)dynamicAllusionTomethod:(NSString *)action objects:(NSDictionary * __nullable)objects;

+ (id)dynamicAllusionTomethod:(NSString *)action;
+ (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object;
+ (id)dynamicAllusionTomethod:(NSString *)action object:(id __nullable)object1 object:(id __nullable)object2;
+ (id)dynamicAllusionTomethod:(NSString *)action objects:(NSDictionary * __nullable)objects;

+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action;
+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action object:(id __nullable)object;
+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action object:(id __nullable)object1 object:(id __nullable)object2;
+ (id)dynamicAllusionTomethod:(NSString *)target action:(NSString *)action objects:(NSDictionary * __nullable)objects;

+ (void)swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;
- (void)swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;

@end



NS_ASSUME_NONNULL_END
