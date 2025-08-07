//
//  DBExpressAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/28.
//

#import "DBExpressAdConfig.h"
#import "DBSelfAdView.h"
#import "DBMangoAdConfig.h"

@interface DBExpressAdConfig ()<DBMangoAdDelegate,DBSelfAdDelegate>
@property (nonatomic, strong) NSMutableDictionary *showAdDict;
@end

@implementation DBExpressAdConfig

- (void)setExpressAdPreLoadSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController{
    NSMutableArray *splashAds = [NSMutableArray array];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
    for (DBAdsModel *adModel in posAd.ads) {
        if (adModel.id.length == 0) continue;
        adModel.position = posAd.position;
        adModel.selfAd.muted = YES;
        if ([adModel.platform isEqualToString:kAd_gm_key]){
         
        }else if ([adModel.platform isEqualToString:kAd_gdt_key]){
      
        }else if ([adModel.platform isEqualToString:kAd_mg_key]){
            DBMangoAdConfig *splashAdConfig = [[DBMangoAdConfig alloc] init];
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            splashAdConfig.showAdController = showAdController;
            [splashAdConfig loadAdDataExpressAdId:adModel.id delegate:self];
            [splashAds addObject:splashAdConfig];
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

- (void)getExpressAdsAndSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(NSArray <UIView *>*adViews))completion{
    if (completion) [self.adCompleteDict setObject:completion forKey:@(spaceType)];
    
    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    NSMutableArray <UIView *>*adObjects = [NSMutableArray arrayWithArray:adArray];
    if (adObjects.count){
        if (completion) completion(adObjects);
        [DBUnityAdConfig.manager trackDataAdDict:adObjects.firstObject.adTrackModel actionType:YES];
        [adObjects removeObjectAtIndex:0];
        [self.adViewsDict setObject:adObjects forKey:@(spaceType)];
    }else{
        [self.showAdDict setObject:@1 forKey:@(spaceType)];
        [self setExpressAdPreLoadSpaceType:spaceType showAdController:showAdController];
    }
}


#pragma mark - DBMangoAdDelegate
- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd adContainerView:(UIView *)adContainerView{
    NSNumber *key = @(splashAd.spaceType);
    adContainerView.adTrackModel = splashAd.adTrackModel;
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    BOOL isShowingAd = [[self.showAdDict objectForKey:key] boolValue];
    if (isShowingAd && completion){
        [self.showAdDict setObject:@0 forKey:key];
        completion(@[adContainerView]);
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

#pragma mark - DBSelfAdDelegate
- (void)selfAdLoadSuccess:(DBSelfAdConfig *)splashAd{
    NSNumber *key = @(splashAd.spaceType);
    AdViewsBlock completion = [self.adCompleteDict objectForKey:key];
    DBSelfAdView *selfAdView = (DBSelfAdView *)[splashAd selfAdViewWithAdType:DBSelfAdExpress];
    selfAdView.spaceType = splashAd.spaceType;
    selfAdView.adTrackModel = splashAd.adTrackModel;
    BOOL isShowingAd = [[self.showAdDict objectForKey:key] boolValue];
    if (isShowingAd && completion){
        if (!selfAdView) return;
        [self.showAdDict setObject:@0 forKey:key];
        completion(@[selfAdView]);
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

- (void)removeAdView:(UIView *)adContainerView withKey:(NSNumber *)key{
    if (!adContainerView) return;
    NSArray *adArray = [self.adViewsDict objectForKey:key];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if ([adObjects containsObject:adContainerView]){
        [adObjects removeObject:adContainerView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    
    AdViewsBlock completion = [self.adCompleteDict objectForKey:key];
    if (!completion) return;
    if (adContainerView.superview.spaceType == key.intValue){
        completion(@[adContainerView.superview]);
    }else{
        completion(@[adContainerView]);
    }
}

- (void)selfAdDidClick:(DBSelfAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

- (NSMutableDictionary *)showAdDict{
    if (!_showAdDict){
        _showAdDict = [NSMutableDictionary dictionary];
    }
    return _showAdDict;
}


@end



