//
//  AppDelegate+UMLink.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/30.
//
#import "DeepBooks-Swift.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMLink/UMLink.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (UMLink)<MobClickLinkDelegate>
+ (void)umLinkConfig;
+ (void)umGetInstallParams;
@end

NS_ASSUME_NONNULL_END
