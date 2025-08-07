//
//  DBBannerAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBBannerAdConfig.h"
#import "DBReadBookSetting.h"
#import "DBSelfAdView.h"
#import <MSaas/MSaas.h>
#import "DBMangoAdConfig.h"

@interface DBBannerAdConfig ()<DBMangoAdDelegate,DBSelfAdDelegate>
@property (nonatomic, strong) NSMutableDictionary *showAdDict;
@property (nonatomic, assign) NSInteger timeInterval;
@end

@implementation DBBannerAdConfig

- (void)setBannerAdPreLoadSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController{
    NSMutableArray *splashAds = [NSMutableArray array];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
    for (DBAdsModel *adModel in posAd.ads) {
        if (adModel.id.length == 0) continue;
        adModel.position = posAd.position;
        adModel.selfAd.muted = YES;
        CGSize canvasAdSize = DBReadBookSetting.setting.canvasAdSize;
        if ([adModel.platform isEqualToString:kAd_gm_key]){
            
        }else if ([adModel.platform isEqualToString:kAd_gdt_key]){
         
        }else if ([adModel.platform isEqualToString:kAd_mg_key]){
            DBMangoAdConfig *splashAdConfig = [[DBMangoAdConfig alloc] init];
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            splashAdConfig.timeInterval = self.timeInterval;
            splashAdConfig.showAdController = showAdController;
            [splashAdConfig loadAdDataBannerAdId:adModel.id delegate:self];
            [splashAds addObject:splashAdConfig];
        }else if ([adModel.platform isEqualToString:kAd_self_key]){
            DBSelfAdConfig *splashAdConfig = [[DBSelfAdConfig alloc] init];
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            splashAdConfig.timeInterval = self.timeInterval;
            [splashAdConfig loadSelfAdModel:adModel.selfAd delegate:self];
            [splashAds addObject:splashAdConfig];
        }
    }

    [self.adLoadersDict setObject:splashAds forKey:@(spaceType)];
}

- (void)getBannerAdAndSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion{

    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    NSMutableArray <UIView *>*adObjects = [NSMutableArray arrayWithArray:adArray];
    if (adObjects.count){
        if (completion) completion(adObjects.firstObject);
        [DBUnityAdConfig.manager trackDataAdDict:adObjects.firstObject.adTrackModel actionType:YES];
        [adObjects removeObjectAtIndex:0];
        [self.adViewsDict setObject:adObjects forKey:@(spaceType)];
    }else{
        self.timeInterval = NSDate.currentInterval;
        [self.showAdDict setObject:@1 forKey:@(spaceType)];
        [self setBannerAdPreLoadSpaceType:spaceType showAdController:showAdController];
        if (completion) [self.adCompleteDict setObject:completion forKey:@(self.timeInterval)];
    }
}


#pragma mark - DBSelfAdDelegate
- (void)selfAdLoadSuccess:(DBSelfAdConfig *)splashAd{
    NSNumber *key = @(splashAd.spaceType);
    AdObjectBlock completion = [self.adCompleteDict objectForKey:@(splashAd.timeInterval)];
    DBSelfAdView *selfAdView = (DBSelfAdView *)[splashAd selfAdViewWithAdType:DBSelfAdBanner];
    selfAdView.adTrackModel = splashAd.adTrackModel;
    selfAdView.timeInterval = splashAd.timeInterval;
    BOOL isShowingAd = [[self.showAdDict objectForKey:key] boolValue];
    if (isShowingAd && completion){
        [self.showAdDict setObject:@0 forKey:key];
        completion(selfAdView);
        [DBUnityAdConfig.manager trackDataAdDict:selfAdView.adTrackModel actionType:YES];
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:selfAdView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    
    DBWeakSelf
    selfAdView.didRemovedBlock = ^(UIView * _Nonnull adContainerView, DBSelfAdType adType) {
        DBStrongSelfElseReturn
        [self selfAdViewDidRemoved:adContainerView spaceType:splashAd.spaceType];
    };
    selfAdView.didClickBlock = ^(UIView * _Nonnull adContainerView, DBSelfAdType adType) {
        DBStrongSelfElseReturn
        [self selfAdDidClick:splashAd];
    };
}

- (void)selfAdLoadFailure:(DBSelfAdConfig *)splashAd{

}

- (void)selfAdViewDidRemoved:(UIView *)adContainerView spaceType:(DBAdSpaceType)spaceType{
    [self removeAdView:adContainerView withKey:@(spaceType)];
}

- (void)selfAdDidClick:(DBSelfAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

#pragma mark - DBMangoAdDelegate
- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd adContainerView:(UIView *)adContainerView{
    NSNumber *key = @(splashAd.spaceType);
    adContainerView.adTrackModel = splashAd.adTrackModel;
    adContainerView.timeInterval = splashAd.timeInterval;
    AdObjectBlock completion = [self.adCompleteDict objectForKey:@(splashAd.timeInterval)];
    BOOL isShowingAd = [[self.showAdDict objectForKey:key] boolValue];
    if (isShowingAd && completion){
        [self.showAdDict setObject:@0 forKey:key];
        completion(adContainerView);
        [DBUnityAdConfig.manager trackDataAdDict:adContainerView.adTrackModel actionType:YES];
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:adContainerView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
}

- (void)mangoAdLoadFailure:(DBMangoAdConfig *)splashAd{
    
}

- (void)mangoAdObjectDidRemoved:(DBMangoAdConfig *)splashAd adContainerView:(UIView *)adContainerView{
    [self removeAdView:adContainerView withKey:@(splashAd.spaceType)];
}

- (void)mangoAdLoadDidClick:(DBMangoAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

#pragma public
- (void)removeAdView:(NSObject *)adContainerView withKey:(id)key{
    NSArray *adArray = [self.adViewsDict objectForKey:key];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if ([adObjects containsObject:adContainerView]){
        [adObjects removeObject:adContainerView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    AdObjectBlock completion = [self.adCompleteDict objectForKey:@(adContainerView.timeInterval)];
    if (completion) completion(adContainerView);
}


- (NSMutableDictionary *)showAdDict{
    if (!_showAdDict){
        _showAdDict = [NSMutableDictionary dictionary];
    }
    return _showAdDict;
}

@end
