//
//  DBGridAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/22.
//

#import "DBGridAdConfig.h"
#import "DBSelfAdView.h"

@interface DBGridAdConfig ()<DBSelfAdDelegate>

@end


@implementation DBGridAdConfig

- (void)setGridAdPreLoadSpaceType:(DBAdSpaceType)spaceType{
    NSMutableArray *splashAds = [NSMutableArray array];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
    for (DBAdsModel *adModel in posAd.ads) {
        if (adModel.id.length == 0) continue;
        adModel.position = posAd.position;
        if ([adModel.platform isEqualToString:kAd_gm_key]){
            
        }else if ([adModel.platform isEqualToString:kAd_gdt_key]){
            
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

- (void)getGridAdsAndSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion{
    if (completion) [self.adCompleteDict setObject:completion forKey:@(spaceType)];
    
    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if (adObjects.count){
        [adObjects removeObjectAtIndex:0];
        [self.adViewsDict setObject:adObjects forKey:@(spaceType)];
        
        NSObject *object = adObjects.firstObject;
        if ([object isKindOfClass:[DBSelfAdConfig class]]){
            UIView *selfAdView = [(DBSelfAdConfig *)object selfAdViewWithAdType:DBSelfAdGrid];
            if (completion) completion(selfAdView);
            [DBUnityAdConfig.manager trackDataAdDict:selfAdView.adTrackModel actionType:YES];
        }
    }else{
        [self setGridAdPreLoadSpaceType:spaceType];
    }
}

#pragma mark - DBSelfAdDelegate
- (void)selfAdLoadSuccess:(DBSelfAdConfig *)splashAd{
    NSNumber *key = @(splashAd.spaceType);
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    DBSelfAdView *selfAdView = (DBSelfAdView *)[splashAd selfAdViewWithAdType:DBSelfAdGrid];
    selfAdView.spaceType = splashAd.spaceType;
    selfAdView.adTrackModel = splashAd.adTrackModel;
    if (completion){
        completion(selfAdView);
        [DBUnityAdConfig.manager trackDataAdDict:selfAdView.adTrackModel actionType:YES];
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:splashAd];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    
    DBWeakSelf
    selfAdView.didRemovedBlock = ^(UIView * _Nonnull adContainerView, DBSelfAdType adType) {
        DBStrongSelfElseReturn
        [self selfAdViewDidRemoved:adContainerView spaceType:adContainerView.spaceType];
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

- (void)removeAdView:(UIView *)adContainerView withKey:(id)key{
    NSArray *adArray = [self.adViewsDict objectForKey:key];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if ([adObjects containsObject:adContainerView]){
        [adObjects removeObject:adContainerView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    if (completion) completion(adContainerView);
}

@end
