//
//  UIApplication+DBKit.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (DBKit)

+ (NSString *)bundleName;
+ (NSString *)appName;
+ (NSString *)appBundle;
+ (NSString *)appBuild;
+ (NSString *)appVersion;
+ (NSString *)appMinSystemVersion;

//缓存大小
+ (unsigned long long)getURLCacheSize;
+ (void)calculateDiskCacheSize:(void(^)(NSString *sizeString))completion;

//清除缓存
+ (void)clearAllNetworkCache;
+ (void)clearNetworkCacheWithCompletion:(void(^)(void))completion;


//debug
+ (BOOL)isRunningInDevelopment;

//tf
+ (BOOL)isRunningInTestFlight;

@end

NS_ASSUME_NONNULL_END
