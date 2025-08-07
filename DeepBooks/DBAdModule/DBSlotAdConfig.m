//
//  DBSlotAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import "DBSlotAdConfig.h"
#import "DBMangoAdConfig.h"
@interface DBSlotAdConfig ()<DBSelfAdDelegate,DBMangoAdDelegate>
@property (nonatomic, assign) BOOL isShowingAd; //加载广告并显示
@end

@implementation DBSlotAdConfig

- (void)setSlotAdPreLoadSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController{
    NSMutableArray *splashAds = [NSMutableArray array];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
    for (DBAdsModel *adModel in posAd.ads) {
        if (adModel.id.length == 0) continue;
        adModel.position = posAd.position;
        if ([adModel.platform isEqualToString:kAd_gm_key]){
            
        }else if ([adModel.platform isEqualToString:kAd_gdt_key]){
          
        }else if ([adModel.platform isEqualToString:kAd_mg_key]){
            DBMangoAdConfig *splashAdConfig = [[DBMangoAdConfig alloc] init];
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            splashAdConfig.showAdController = showAdController;
            [splashAdConfig loadAdDataSlotAdId:adModel.id delegate:self];
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

- (void)getSlotAdsAndSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(NSObject *adObject))completion{
    if (completion) [self.adCompleteDict setObject:completion forKey:@(spaceType)];
    
    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if (adObjects.count){
        if (completion) completion(adObjects.firstObject);
        [adObjects removeObjectAtIndex:0];
        [self.adViewsDict setObject:adObjects forKey:@(spaceType)];
    }else{
        self.isShowingAd = YES;
        [self setSlotAdPreLoadSpaceType:spaceType showAdController:showAdController];
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

- (void)selfAdObjectDidRemoved:(DBSelfAdConfig *)adObject spaceType:(DBAdSpaceType)spaceType;{
    [self removeAdObject:adObject withKey:@(spaceType)];
}

- (void)selfAdDidClick:(DBSelfAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

#pragma mark - DBMangoAdDelegate
- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd slotAd:(SFInterstitialManager *)slotAd{
    NSNumber *key = @(splashAd.spaceType);
    AdObjectBlock completion = [self.adCompleteDict objectForKey:key];
    if (self.isShowingAd && completion){
        self.isShowingAd = NO;
        completion(slotAd);
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:slotAd];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
}


- (void)mangoAdLoadFailure:(DBMangoAdConfig *)splashAd{
}

- (void)mangoAdObjectDidRemoved:(DBMangoAdConfig *)splashAd slotAd:(SFInterstitialManager *)slotAd{
    [self removeAdObject:slotAd withKey:@(splashAd.spaceType)];
}

- (void)mangoAdLoadDidClick:(DBMangoAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
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
