//
//  AppDelegate+UMLink.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/30.
//

#import "AppDelegate+UMLink.h"
#import <UMPush/UMPush.h>
#import <UMAPM/UMAPMConfig.h>
#import <UMAPM/UMCrashConfigure.h>

static BOOL _isLoading = false;
@implementation AppDelegate (UMLink)

+ (void)umLinkConfig{
    UMAPMConfig *config = [UMAPMConfig defaultConfig];
    [UMCrashConfigure setAPMConfig:config];
    [UMConfigure initWithAppkey:UMLinkAppKey channel:@"App Store"];
    [UMConfigure setEncryptEnabled:YES];
    [UMConfigure setLogEnabled:NO];
    
    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:delegate.launchOptions
                                                       Entity:nil
                                            completionHandler:^(BOOL granted, NSError * _Nullable error) {
    }];
}

+ (void)umGetInstallParams{
    if (_isLoading) return;
    _isLoading = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isLoading = NO;
    });
    [MobClickLink getInstallParams:^(NSDictionary *params, NSURL *URL, NSError *error) {
        if (URL.absoluteString.length){
            AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
            [delegate getLinkPath:URL.absoluteString params:params];
        }
    }];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    [MobClickLink handleUniversalLink:userActivity delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication*)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id>*)options{
    [MobClickLink handleLinkURL:url delegate:self];
    return YES;
}



- (BOOL)application:(UIApplication*)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString*)sourceApplication annotation:(nonnull id)annotation{
    [MobClickLink handleLinkURL:url delegate:self];
    return YES;
}

//

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                       ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                       ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                       ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    [NSUserDefaults saveValue:DBSafeString(token) forKey:@"kPushDeviceToken"];
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UMessage didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter*)center willPresentNotification:(UNNotification*)notification withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary* userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
    [UMessage setAutoAlert:NO];
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];

    }else{
    //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionList | UNNotificationPresentationOptionBanner);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter*)center didReceiveNotificationResponse:(UNNotificationResponse*)response withCompletionHandler:(void(^)(void))completionHandler{
    NSDictionary* userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    }else{
    //应用处于后台时的本地推送接受
    }
}

- (void)getLinkPath:(NSString *)path params:(NSDictionary *)params{
    if (path.length){
        [DBCommonConfig bindInvitationLink:path completion:^(BOOL open) {
            
        }];
    }
}

- (UIWindow *)window{
    return UIScreen.appWindow;
}

@end
