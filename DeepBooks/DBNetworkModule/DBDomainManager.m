//
//  DBDomainManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBDomainManager.h"

#import "DBReaderSetting.h"
#import "DBAppConfigModel.h"
#import "DBFontModel.h"
#import "DBReadBookSetting.h"
#import "DBAppSetting.h"
#import <Reachability/Reachability.h>
#import "DBTabBarRootController.h"
#import "DBSwitchAuditTabBarController.h"

#import "AppDelegate+UMLink.h"

#import "DeviceCheck/DeviceCheck.h"
#import "DBAppSwitchModel.h"
#import "DBAppSwitchModel.h"

#import "DBBookActionManager.h"
#import <SDWebImage/SDWebImage.h>
@implementation DBDomainManager

static Reachability *_reachability;
static BOOL _loadDoaminSuccess = NO;
static NSString *_deviceCheck;


void registerExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&handleException);
}

void handleException(NSException *exception) {
    NSString *reason = [exception reason];
    if ([reason containsString:@"SFNetTool"] ||  [reason containsString:@"NSNull length"]) {
        return;
    }
}

+ (void)setAppConfig{
    registerExceptionHandler();
    SDWebImageDownloader.sharedDownloader.config.maxConcurrentDownloads = 4;
    [self deviceCheckToken];
    
    //umLink
    [AppDelegate umLinkConfig];
    
    //启动配置
    DBAppSetting *setting = DBAppSetting.setting;
    setting.lastLaunchTimeStamp = setting.currentLaunchTimeStamp;
    setting.currentLaunchTimeStamp = NSDate.currentInterval;
    setting.launchCount++;
    [setting reloadSetting];
    
    if (setting.inviteLink.length && DBCommonConfig.isLogin){
        [DBCommonConfig bindInvitationLink:DBAppSetting.setting.inviteLink completion:nil];
    }
    [self getAppDomain];
}

+ (void)deviceCheckToken{
    if (_deviceCheck.length > 0) return;
    DCDevice *device = [DCDevice currentDevice];
    if (device.isSupported){
        [device generateTokenWithCompletionHandler:^(NSData * _Nullable token, NSError * _Nullable error) {
            if (token){
                NSString *deviceCheck = [token base64EncodedStringWithOptions:0];
                DBAppSetting *setting = DBAppSetting.setting;
                setting.deviceCheck = deviceCheck;
                [setting reloadSetting];
                _deviceCheck = deviceCheck;
            }
        }];
    }
}

+ (void)getAppDomain{
    if (_loadDoaminSuccess) return;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
        {
            if (_reachability){
                [_reachability stopNotifier];
                _reachability = nil;
            }
            
            Reachability *reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
            _reachability = reachability;
            
            DBWeakSelf
            _reachability.reachableBlock = ^(Reachability *reach) {
                DBStrongSelfElseReturn
                [self deviceCheckToken];
                [self appNetworkingRequest];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NSNotificationCenter.defaultCenter postNotificationName:DBNetReachableChange object:nil];
                });
            };
            [_reachability startNotifier];
        }
            break;
            
        default:
        {
            [self appNetworkingRequest];
        }
            break;
    }
}

+ (void)appNetworkingRequest{
    _loadDoaminSuccess = YES;
    [DBAppSwitchModel getNetSafetyProvidePlan:^(BOOL success) {
        NSString *domain = DBAppSetting.setting.domain;
        if (domain.length){
            DBBaseAlamofire.domainString = domain;
            [DBAppSwitchModel getApiStateCompletion:^(BOOL enable) {
                if (enable){
                    _loadDoaminSuccess = NO;
                    [self getApplicationConfigCompletion:^(BOOL success) {
                        
                    }];
                }else{
                    [self carryOutBusinessTest:NO completion:nil];
                }
            }];
        }else{
            [self carryOutBusinessTest:NO completion:nil];
        }
    }];
}

+ (void)carryOutBusinessTest:(BOOL)test completion:(void (^ __nullable)(BOOL success))completion{
    [DBAppSwitchModel getDomainLinkTest:test completion:^(BOOL success) {
        _loadDoaminSuccess = NO;
        if (success) {
            DBAppSetting *setting = DBAppSetting.setting;
            setting.domain = DBBaseAlamofire.domainString;
            [setting reloadSetting];
            
            [self getApplicationConfigCompletion:^(BOOL success) {
                
            }];
        }
        if (completion) completion(success);
    }];
}


+ (void)getApplicationConfigCompletion:(void (^ __nullable)(BOOL successfulRequest))completion{
    [DBAppSwitchModel getAppSwitchCompletion:^(BOOL successfulRequest) {
        [self resetConfig];
        [self configThirdSDK];
        [self appBaseConfig];
        
        if (completion) completion(successfulRequest);
    }];
}

+ (void)resetConfig{
    if (!DBCommonConfig.switchAudit){
        [NSUserDefaults saveValue:@1 forKey:@"KGuidePageKey"];
        UIViewController *vc = UIScreen.appWindow.rootViewController;
        if ([vc isKindOfClass:[DBSwitchAuditTabBarController class]]){
            UIScreen.appWindow.rootViewController = DBTabBarRootController.new;
        }
    }
}

+ (void)appBaseConfig{
    if (DBCommonConfig.switchAudit) return;
    [DBAFNetWorking postServiceRequestType:DBLinkBaseConfig combine:nil parameInterface:nil modelClass:DBAppConfigModel.class serviceData:^(BOOL successfulRequest, DBAppConfigModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            if (!DBCommonConfig.switchAudit) _loadDoaminSuccess = YES;
            [DBCommonConfig updateAppConfig:result];
            
            DBAppSetting *setting = DBAppSetting.setting;
            
            //判断是否是新手
            if (setting.isNewbie){
                setting.isNewbie = [DBCommonConfig isNewbie];
            }
            
            NSString *marqueeContent = result.notify.notify_content;
            NSString *marqueeLink = result.notify.notify_url;
   
            if (!setting.isNewbie){
                NSString *content = result.migrate_data.notify.notify_content;
                NSString *link = result.migrate_data.notify.notify_url;
                if (content.length > 0)  marqueeContent = content;
                if (link.length > 0)  marqueeLink = link;
            }
            setting.marqueeLink = marqueeLink;
            setting.marqueeContent = marqueeContent;
            if (marqueeContent.length){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateMarqueeContent object:nil];
                });
                
            }
            
            BOOL isNotice = NO;
            if (result.notify.notify_tips_type == 2 && marqueeContent.length && ![setting.noticeContent isEqualToString:marqueeContent]){
                setting.noticeContent = marqueeContent;
                setting.noticeLink = result.notify.notify_url;
                isNotice = YES;
            }
            
            [setting reloadSetting];
            
            //导流
            [DBCommonConfig migrateUserInReading:NO];
            if (isNotice) [DBCommonConfig announcementNotice];
            
            if ([UIScreen.appWindow.rootViewController isKindOfClass:DBTabBarRootController.class]){
                [DBBookActionManager bookFirstRecommendation];
            }
        }
    }];
}

+ (void)configThirdSDK{
    [AppDelegate umGetInstallParams];
    
    [DBAdServerDataModel loadAdServerData];
}

+ (void)supportWebpImage{
 
}

@end

