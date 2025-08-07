//
//  DBRouter.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const kDBRouterPathJumpStyle;
FOUNDATION_EXTERN NSString *const kDBRouterPathNoAnimation;
FOUNDATION_EXTERN NSString *const kDBRouterPathRootIndex;
FOUNDATION_EXTERN NSString *const kDBRouterDrawerSideslip;
FOUNDATION_EXTERN NSString *const kDBRouterPathSetNavigation;
@interface DBRouter : NSObject

+ (UIViewController *)openPageUrl:(NSString *)url;
+ (UIViewController *)openPageUrl:(NSString *)url params:(NSDictionary * _Nullable)params;

+ (void)closePage;
+ (void)closePageRoot;
+ (void)closePage:(NSString * _Nullable)obj params:(NSDictionary * _Nullable)params;

@end

NS_ASSUME_NONNULL_END
