//
//  DBUnityAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBUnityAdConfig.h"

#import "DBLaunchAdConfig.h"
#import "DBBannerAdConfig.h"
#import "DBRewardAdConfig.h"
#import "DBExpressAdConfig.h"
#import "DBSlotAdConfig.h"
#import "DBGridAdConfig.h"

#import "DBSelfAdConfig.h"
#import "DBAppSetting.h"
#import "DBReadBookSetting.h"

#import "DBAppSwitchModel.h"

@interface DBUnityAdConfig ()


@property (nonatomic, strong) DBLaunchAdConfig *launchAd;
@property (nonatomic, strong) DBBannerAdConfig *bannerAd;
@property (nonatomic, strong) DBRewardAdConfig *rewardAd;
@property (nonatomic, strong) DBExpressAdConfig *expressAd;
@property (nonatomic, strong) DBSlotAdConfig *slotAd;
@property (nonatomic, strong) DBGridAdConfig *gridAd;

@property (nonatomic, assign) NSInteger bannerIndex;

@property (nonatomic, assign) BOOL isAdStart;
@property (nonatomic, assign) BOOL isBackground;
@property (nonatomic, assign) NSInteger attemptCount;

@property (nonatomic, strong) dispatch_source_t gcdTimer;
@end


@implementation DBUnityAdConfig

//是否开启广告
+ (BOOL)openAd{
#ifdef DEBUG
    return YES;
    NSNumber *value = [NSUserDefaults takeValueForKey:@"DBAdvertisingSwitch"];
    if (value) return [value boolValue];
#endif
    
    if (DBCommonConfig.switchAudit) return NO;
    DBAppSetting *appSetting = DBAppSetting.setting;
    DBAdNoviceModel *novice = DBUnityAdConfig.adConfigModel.novice;
    if (novice.switchOn && appSetting.launchCount > novice.count && appSetting.launchTimeStamp > 0 && NSDate.now.timeStampInterval-appSetting.launchTimeStamp >= novice.days*24*60*60 && DBReadBookSetting.setting.readTotalTime >= novice.time*60) {
        return YES;
    }
    return NO;
}

+ (instancetype)manager {
    static DBUnityAdConfig *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DBUnityAdConfig new];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(gcdTimer,dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), 1.0 * NSEC_PER_SEC,0.1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(gcdTimer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                manager.cumulativeTime++;
                [[NSNotificationCenter defaultCenter] postNotificationName:DBsecondsTimeChange object:nil userInfo:nil];
                
                if (manager.cumulativeTime%(30*60) == 0){
                    [DBAppSwitchModel getNetSafetyProvidePlan:nil];
                }
                if (manager.cumulativeTime%(60*60) == 0){
                    [DBAdServerDataModel loadAdServerData];
                }
            });
        });
        dispatch_resume(gcdTimer);
        manager.gcdTimer = gcdTimer;
    });
    return manager;
}

- (void)initAdConfig{
    if (!DBUnityAdConfig.openAd) return;
    
    DBAdPlatformModel *platform = DBUnityAdConfig.adConfigModel.platform;
    dispatch_group_t group = dispatch_group_create();

    if (platform.mg.appid.length > 0){
        dispatch_group_enter(group);
        [SFAdSDKManager registerAppId:platform.mg.appid];
        [SFAdSDKManager enableDefaultAudioSessionSetting:NO];
        self.isAdStart = YES;
        dispatch_group_leave(group);
    }else{
        self.isAdStart = YES;
    }
    
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.isAdStart) {
            [self startLaunchSpaceType:DBAdSpaceSplashScreen];
        }
    });
}

- (void)trackDataAdDict:(DBAdsModel *)adModel actionType:(BOOL)adShow{
    if (adModel == nil){
        return;
    }
    NSMutableDictionary *parameInterface = [NSMutableDictionary dictionary];
    [parameInterface setValue:adModel.platform forKey:@"ad_from"];
    [parameInterface setValue:adModel.id forKey:@"ad_id"];
    [parameInterface setValue:adModel.position forKey:@"ad_type"];
    [parameInterface setValue:UIDevice.deviceuuidString forKey:@"uid"];
    [parameInterface setValue:adShow?@"adShow":@"clickAd" forKey:@"action"];
    [parameInterface setValue:@"ios" forKey:@"device_type"];
    [parameInterface setValue:UIDevice.currentDeviceModel forKey:@"device_model"];
    [parameInterface setValue:UIDevice.systemVersion forKey:@"device_os_version"];
  
    [DBAFNetWorking postServiceRequestType:DBLinkTrackAdData combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        
    }];
}

- (void)startLaunchSpaceType:(DBAdSpaceType)spaceType{
    [self.launchAd getLaunchAdsAndSpaceType:spaceType reload:spaceType == DBAdSpaceBackgroundToForeground completion:^(NSObject * _Nonnull adObject) {
        if ([adObject isKindOfClass:[DBSelfAdConfig class]]){
            [(DBSelfAdConfig *)adObject showAdInView:UIScreen.appWindow adType:DBSelfAdLaunch];
        }else if ([adObject isKindOfClass:[SFSplashManager class]]){
            [(SFSplashManager *)adObject showSplashAdWithWindow:UIScreen.appWindow];
        }
        [self trackDataAdDict:adObject.adTrackModel actionType:YES];
    }];
}


- (void)openBannerAdSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion{
    if (!DBUnityAdConfig.openAd || self.isBackground) return;
    if (self.isAdStart){
        [self.bannerAd getBannerAdAndSpaceType:spaceType showAdController:showAdController reload:reload completion:completion];
    }else{
        if (self.attemptCount > 5) return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.attemptCount++;
            [self openBannerAdSpaceType:spaceType showAdController:showAdController reload:reload completion:completion];
        });
    }
}

- (void)preloadingRewardAdPreLoadSpaceType:(DBAdSpaceType)spaceType{
    if (!DBUnityAdConfig.openAd || !self.isAdStart) return;
    [self.rewardAd setRewardAdPreLoadSpaceType:spaceType];
}

- (void)openRewardAdSpaceType:(DBAdSpaceType)spaceType completion:(void (^ _Nullable)(BOOL removed))completion{
    if (!DBUnityAdConfig.openAd || !self.isAdStart) return;
    
    [self.rewardAd getRewardAdsAndSpaceType:spaceType reload:YES completion:^(NSObject * _Nonnull adObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([adObject isKindOfClass:DBSelfAdConfig.class]){
                [(DBSelfAdConfig *)adObject showAdInView:UIScreen.appWindow adType:DBSelfAdReward];
            }else if ([adObject isKindOfClass:SFRewardVideoManager.class]){
                [(SFRewardVideoManager *)adObject showRewardVideoAdWithController:UIScreen.appWindow.rootViewController];
            }
            if (completion) completion(adObject == nil);
            [self trackDataAdDict:adObject.adTrackModel actionType:YES];
        });
    }];
}

- (void)openSlotAdSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController completion:(void (^ _Nullable)(BOOL removed))completion{
    if (!DBUnityAdConfig.openAd || self.isBackground) return;
    if (self.isAdStart){
        [self.slotAd getSlotAdsAndSpaceType:spaceType showAdController:showAdController reload:YES completion:^(NSObject * _Nonnull adObject) {
            if ([adObject isKindOfClass:DBSelfAdConfig.class]){
                [(DBSelfAdConfig *)adObject showAdInView:UIScreen.appWindow adType:DBSelfAdSlot];
            }else if ([adObject isKindOfClass:SFInterstitialManager.class]){
                [(SFInterstitialManager *)adObject showInterstitialAd];
            }
            
            if (completion) completion(adObject == nil);
            [self trackDataAdDict:adObject.adTrackModel actionType:YES];
        }];
    }else{
        if (self.attemptCount > 5) return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.attemptCount++;
            [self openSlotAdSpaceType:spaceType showAdController:showAdController completion:completion];
        });
    }
}

- (void)openExpressAdsSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(NSArray <UIView *>*adViews))completion{
    if (!DBUnityAdConfig.openAd || !self.isAdStart) return;
    
    [self.expressAd getExpressAdsAndSpaceType:spaceType showAdController:(UIViewController *)showAdController reload:reload completion:completion];
}

- (void)openGridAdSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion{
    if (!DBUnityAdConfig.openAd || !self.isAdStart) return;
    
    [self.gridAd getGridAdsAndSpaceType:spaceType reload:reload completion:completion];
}

- (instancetype)init{
    if (self = [super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                  name:UIApplicationWillEnterForegroundNotification
                                                object:nil];
    }
    return self;
}

- (void)appDidEnterBackgroundNotification:(NSNotification *)noti{
    self.isBackground = YES;
    if (!DBUnityAdConfig.openAd || !self.isAdStart) return;
    
    self.enterBgTime = NSDate.now.timeStampInterval;
    [self.launchAd setLaunchAdPreLoadSpaceType:DBAdSpaceBackgroundToForeground];
}

- (void)applicationWillEnterForeground:(NSNotification *)noti{
    self.isBackground = NO;
    if (!DBUnityAdConfig.openAd || !self.isAdStart) return;
    
    //时间差
    double timeDiff = NSDate.now.timeStampInterval - self.enterBgTime;
    DBAdPosModel *adConfig = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceBackgroundToForeground];
    NSInteger limit = adConfig.extra.limit;
    if (limit == 0) limit = 10;
    if (timeDiff < limit) return;
    
    [self startLaunchSpaceType:DBAdSpaceBackgroundToForeground];
}


- (DBLaunchAdConfig *)launchAd{
    if (!_launchAd){
        _launchAd = [[DBLaunchAdConfig alloc] init];
    }
    return _launchAd;
}

- (DBBannerAdConfig *)bannerAd{
    if (!_bannerAd){
        _bannerAd = [[DBBannerAdConfig alloc] init];
    }
    return _bannerAd;
}

- (DBRewardAdConfig *)rewardAd{
    if (!_rewardAd){
        _rewardAd = [[DBRewardAdConfig alloc] init];
    }
    return _rewardAd;
}

- (DBExpressAdConfig *)expressAd{
    if (!_expressAd){
        _expressAd = [[DBExpressAdConfig alloc] init];
    }
    return _expressAd;
}

- (DBSlotAdConfig *)slotAd{
    if (!_slotAd){
        _slotAd = [[DBSlotAdConfig alloc] init];
    }
    return _slotAd;
}

- (DBGridAdConfig *)gridAd{
    if (!_gridAd){
        _gridAd = [[DBGridAdConfig alloc] init];
    }
    return _gridAd;
}

- (NSMutableDictionary *)apperTimeDict{
    if (!_apperTimeDict){
        _apperTimeDict = [NSMutableDictionary dictionary];
    }
    return _apperTimeDict;
}

+ (DBAdServerDataModel *)adConfigModel{
    NSString *result = [NSUserDefaults takeValueForKey:DBAdServerDataValue];
    if (result) {
        return [DBAdServerDataModel yy_modelWithJSON:result];
    }
    return nil;
}

+ (DBAdPosModel *)adPosWithSpaceType:(DBAdSpaceType)spaceType{
    NSString *position = @"";
    switch (spaceType) {
        case DBAdSpaceSplashScreen:
            position = @"splash_screen";
            break;
        case DBAdSpaceBackgroundToForeground:
            position = @"background_to_foreground";
            break;
        case DBAdSpaceBookDetailBottom:
            position = @"book_detail_bottom";
            break;
        case DBAdSpaceBookshelfTop:
            position = @"bookshelf_top";
            break;
        case DBAdSpaceBookshelfListModeMiddle:
            position = @"bookshelf_list_mode_middle";
            break;
        case DBAdSpaceFatAreaTop:
            position = @"fat_area_top";
            break;
        case DBAdSpaceReaderBottom:
            position = @"reader_bottom";
            break;
        case DBAdSpaceSearchPageTop:
            position = @"search_page_top";
            break;
        case DBAdSpaceBookCityCategoryTop:
            position = @"book_city_category_top";
            break;
        case DBAdSpaceBookCitySelectedTop:
            position = @"book_city_selected_top";
            break;
        case DBAdSpaceBookCitySelectedMiddle:
            position = @"book_city_selected_middle";
            break;
        case DBAdSpaceBookCitySelectedBottom:
            position = @"book_city_selected_bottom";
            break;
        case DBAdSpaceBookCityMaleTop:
            position = @"book_city_male_top";
            break;
        case DBAdSpaceBookCityMaleMiddle:
            position = @"book_city_male_middle";
            break;
        case DBAdSpaceBookCityMaleBottom:
            position = @"book_city_male_bottom";
            break;
        case DBAdSpaceBookCityFemaleTop:
            position = @"book_city_female_top";
            break;
        case DBAdSpaceBookCityFemaleMiddle:
            position = @"book_city_female_middle";
            break;
        case DBAdSpaceBookCityFemaleBottom:
            position = @"book_city_female_bottom";
            break;
        case DBAdSpaceCategoryDetailTop:
            position = @"category_detail_top";
            break;
        case DBAdSpaceCategoryDetailMiddle:
            position = @"category_detail_middle";
            break;
        case DBAdSpaceCategoryDetailBottom:
            position = @"category_detail_bottom";
            break;
        case DBAdSpaceBookDetailPageTop:
            position = @"book_detail_page_top";
            break;
        case DBAdSpaceBookDetailPageMiddle:
            position = @"book_detail_page_middle";
            break;
        case DBAdSpaceBookDetailPageBottom:
            position = @"book_detail_page_bottom";
            break;
        case DBAdSpaceReaderPage:
            position = @"reader_page";
            break;
        case DBAdSpaceReaderChapterEnd:
            position = @"reader_chapter_end";
            break;
        case DBAdSpaceBookCitySelectedTopGrid:
            position = @"book_city_selected_top_grid";
            break;
        case DBAdSpaceBookCityMaleTopGrid:
            position = @"book_city_male_top_grid";
            break;
        case DBAdSpaceBookCityFemaleTopGrid:
            position = @"book_city_female_top_grid";
            break;
        case DBAdSpaceBookDetailTopGrid:
            position = @"book_detail_top_grid";
            break;
        case DBAdSpaceBookDetailMiddleGrid:
            position = @"book_detail_middle_grid";
            break;
        case DBAdSpaceReaderPageGrid:
            position = @"reader_page_grid";
            break;
        case DBAdSpaceReaderChapterEndGrid:
            position = @"reader_chapter_end_grid";
            break;
        case DBAdSpaceEnterBookDetailPage:
            position = @"enter_book_detail_page";
            break;
        case DBAdSpaceEnterBookshelfPage:
            position = @"enter_bookshelf_page";
            break;
        case DBAdSpaceEnterBookCity:
            position = @"enter_book_city";
            break;
        case DBAdSpaceReaderInterstitial:
            position = @"reader_interstitial";
            break;
        case DBAdSpaceAddToBookshelf:
            position = @"add_to_bookshelf";
            break;
        case DBAdSpaceRequestBooks:
            position = @"request_books";
            break;
        case DBAdSpaceCacheBooksContent:
            position = @"cache_books_content";
            break;
        case DBAdSpaceListenBooks:
            position = @"listen_books";
            break;
        default:
            break;
    }
    
    for (DBAdPosModel *adPos in DBUnityAdConfig.adConfigModel.ad_pos) {
        if ([adPos.position isEqualToString:position]){
            return adPos;
        }
    }
    return nil;
}

@end
