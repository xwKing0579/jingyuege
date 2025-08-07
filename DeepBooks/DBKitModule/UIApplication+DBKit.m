//
//  UIApplication+DBKit.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "UIApplication+DBKit.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIApplication (DBKit)

//项目名称
+ (NSString *)bundleName{
    return DBSafeString([NSBundle mainBundle].infoDictionary[@"CFBundleName"]);
}

+ (NSString *)appName{
    return DBSafeString([NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]);
}

+ (NSString *)appBundle{
#ifdef DEBUG
    return @"com.xixixiaowu.app";
    NSString *bundleName = [NSUserDefaults takeValueForKey:@"changeBundleName"];
    if (bundleName.length > 0) return bundleName;
#endif
  
    return DBSafeString([NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"]);
}

+ (NSString *)appVersion{
    return DBSafeString([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]);
}

+ (NSString *)appBuild{
    return DBSafeString([NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]);
}

+ (NSString *)appMinSystemVersion{
    return DBSafeString([NSBundle mainBundle].infoDictionary[@"MinimumOSVersion"]);
}


+ (unsigned long long)getURLCacheSize {
    NSURLCache *cache = [NSURLCache sharedURLCache];
    NSUInteger cacheSize = [cache currentDiskUsage]; // 磁盘缓存大小
    return cacheSize;
}

+ (void)calculateDiskCacheSize:(void(^)(NSString *sizeString))completion{
    NSUInteger size = [SDImageCache.sharedImageCache totalDiskSize];
    NSString *sizeString = @"";
    if (size < 1024) {
        sizeString = [NSString stringWithFormat:@"%luB", (unsigned long)size];
    } else if (size < 1024 * 1024) {
        sizeString = [NSString stringWithFormat:@"%.1fKB", size / 1024.0];
    } else if (size < 1024 * 1024 * 1024) {
        sizeString = [NSString stringWithFormat:@"%.1fMB", size / (1024.0 * 1024.0)];
    } else {
        sizeString = [NSString stringWithFormat:@"%.1fGB", size / (1024.0 * 1024.0 * 1024.0)];
    }
    if (completion) completion(sizeString);
  
}

+ (void)clearAllNetworkCache {
    [SDImageCache.sharedImageCache clearMemory];
}

+ (void)clearNetworkCacheWithCompletion:(void(^)(void))completion {
    [SDImageCache.sharedImageCache clearDiskOnCompletion:^{
        if (completion) completion();
    }];
}


+ (BOOL)isRunningInDevelopment {

    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSString *bundlePath = [bundleURL absoluteString];
    BOOL isSimulatorOrDebug = [bundlePath containsString:@"/var/containers/Bundle/Application/"];
    
    NSString *profilePath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    if (profilePath) {
        NSString *profileContent = [NSString stringWithContentsOfFile:profilePath encoding:NSASCIIStringEncoding error:nil];
        BOOL isDevProfile = [profileContent containsString:@"get-task-allow"];
        return isSimulatorOrDebug || isDevProfile;
    }
    
    return isSimulatorOrDebug;
}

+ (BOOL)isRunningInTestFlight {
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSString *receiptPath = [receiptURL path];
    return [receiptPath containsString:@"sandboxReceipt"];
}

@end
