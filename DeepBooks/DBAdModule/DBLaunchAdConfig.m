//
//  DBLaunchAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBLaunchAdConfig.h"


@interface DBLaunchAdConfig ()<DBSelfAdDelegate,SFSplashDelegate>

@property (nonatomic, assign) BOOL isShowingAd; //加载广告并显示
@property (nonatomic, weak) SFSplashManager *splashAdConfig;
@end

@implementation DBLaunchAdConfig

- (void)setLaunchAdPreLoadSpaceType:(DBAdSpaceType)spaceType{
    NSMutableArray *splashAds = [NSMutableArray array];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
    for (DBAdsModel *adModel in posAd.ads) {
        if (adModel.id.length == 0) continue;
        adModel.position = posAd.position;
        if ([adModel.platform isEqualToString:kAd_gm_key]){
           
        }else if ([adModel.platform isEqualToString:kAd_gdt_key]){
         
        }else if ([adModel.platform isEqualToString:kAd_mg_key]){
            SFSplashManager *splashAdConfig = [[SFSplashManager alloc] init];
            splashAdConfig.delegate = self;
            splashAdConfig.mediaId = adModel.id;
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            splashAdConfig.showAdController = UIScreen.appWindow.rootViewController;
            [splashAdConfig loadAdData];
            [splashAds addObject:splashAdConfig];
            self.splashAdConfig = splashAdConfig;
        }else if ([adModel.platform isEqualToString:kAd_self_key]){
            DBSelfAdConfig *splashAdConfig = [[DBSelfAdConfig alloc] init];
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            [splashAdConfig loadSelfAdModel:adModel.selfAd delegate:self];
            [splashAds addObject:splashAdConfig];
        }
    }
    
    [self.adLoadersDict setObject:splashAds forKey:@(spaceType)];
}

- (void)getLaunchAdsAndSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(NSObject *adObject))completion{
    if (completion) [self.adCompleteDict setObject:completion forKey:@(spaceType)];
    
    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if (adObjects.count){
        if (completion) completion(adObjects.firstObject);
        
        [adObjects removeObjectAtIndex:0];
        [self.adViewsDict setObject:adObjects forKey:@(spaceType)];
    }else{
        self.isShowingAd = YES;
        [self setLaunchAdPreLoadSpaceType:spaceType];
    }
}




#pragma mark - DBSelfAdDelegate
- (void)selfAdLoadSuccess:(DBSelfAdConfig *)splashAd{
    NSNumber *key = @(splashAd.spaceType);
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    if (self.isShowingAd && completion){
        self.isShowingAd = NO;
        completion(splashAd);
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:splashAd];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
}

- (void)selfAdLoadFailure:(DBSelfAdConfig *)splashAd{
}

- (void)selfAdObjectDidRemoved:(DBSelfAdConfig *)adObject spaceType:(DBAdSpaceType)spaceType{
    [self removeAdObject:adObject withKey:@(spaceType)];
}

- (void)selfAdDidClick:(DBSelfAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

#pragma mark - SFSplashDelegate
- (void)splashAdDidLoad{
    NSNumber *key = @(self.splashAdConfig.spaceType);
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    if (self.isShowingAd && completion){
        self.isShowingAd = NO;
        completion(self.splashAdConfig);
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:self.splashAdConfig];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
}

- (void)splashAdDidFailed:(NSError *)error{
}

- (void)splashAdDidVisible{
   
}

- (void)splashAdDidShowFinish{
    [self removeAdObject:self.splashAdConfig withKey:@(self.splashAdConfig.spaceType)];
}

- (void)splashAdDidClickedWithUrlStr:(NSString *_Nullable)urlStr{
    [DBUnityAdConfig.manager trackDataAdDict:self.splashAdConfig.adTrackModel actionType:NO];
}

#pragma public
- (void)removeAdObject:(NSObject *)adContainerView withKey:(id)key{
    NSArray *adArray = [self.adViewsDict objectForKey:key];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if ([adObjects containsObject:adContainerView]){
        [adObjects removeObject:adContainerView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    if (completion) completion(nil);
}

@end
