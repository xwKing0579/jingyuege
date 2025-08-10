//
//  DBRewardAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import "DBRewardAdConfig.h"
#import "DBMangoAdConfig.h"

@interface DBRewardAdConfig ()<DBSelfAdDelegate,DBMangoAdDelegate>
@property (nonatomic, assign) BOOL isShowingAd; //加载广告并显示
@property (nonatomic, assign) NSInteger errorCount;

@property (nonatomic, copy) void (^ _Nullable completion)(NSObject *adObject);
@end

@implementation DBRewardAdConfig

- (void)setRewardAdPreLoadSpaceType:(DBAdSpaceType)spaceType{
    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    if (adArray.count > 1) return;
    
    NSMutableArray *splashAds = [NSMutableArray array];
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
    
    NSString *extra = posAd.extra.modelToJSONString;
    for (DBAdsModel *adModel in posAd.ads) {
        if (adModel.id.length == 0) continue;
        adModel.position = posAd.position;
        if ([adModel.platform isEqualToString:kAd_gm_key]){
           
        }else if ([adModel.platform isEqualToString:kAd_gdt_key]){
        
        }else if ([adModel.platform isEqualToString:kAd_mg_key]){
            DBMangoAdConfig *splashAdConfig = [[DBMangoAdConfig alloc] init];
            splashAdConfig.spaceType = spaceType;
            splashAdConfig.adTrackModel = adModel;
            [splashAdConfig loadAdDataRewardAdId:adModel.id delegate:self];
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


- (void)getRewardAdsAndSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(NSObject *adObject))completion{
    if (completion) {
        self.completion = completion;
        DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:spaceType];
        if (posAd.ads.count == 0){
            completion(nil);
            return;
        }
    }
    
    NSArray *adArray = [self.adViewsDict objectForKey:@(spaceType)];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if (adObjects.count){
        if (completion){
            self.isShowingAd = NO;
            completion(adObjects.firstObject);
        }
        
        [adObjects removeObjectAtIndex:0];
        [self.adViewsDict setObject:adObjects forKey:@(spaceType)];
    }else{
        self.errorCount = 0;
        self.isShowingAd = YES;
        [self setRewardAdPreLoadSpaceType:spaceType];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutCompletionBack) object:nil];
        [self performSelector:@selector(timeoutCompletionBack) withObject:self afterDelay:2];
    }
}

- (void)timeoutCompletionBack{
    if (self.isShowingAd){
        self.isShowingAd = NO;
        if (self.completion) self.completion(nil);
    }
}


#pragma mark - DBSelfAdDelegate
- (void)selfAdLoadSuccess:(DBSelfAdConfig *)splashAd{
    NSNumber *key = @(splashAd.spaceType);
    if (self.isShowingAd && self.completion){
        self.isShowingAd = NO;
        self.completion(splashAd);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutCompletionBack) object:nil];
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:splashAd];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
}

- (void)selfAdLoadFailure:(DBSelfAdConfig *)splashAd{
    if (self.isShowingAd) {
        self.errorCount++;
        NSArray *adLoaders = (NSArray *)[self.adLoadersDict objectForKey:@(splashAd.spaceType)];
        if (self.errorCount == adLoaders.count){
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutCompletionBack) object:nil];
            self.isShowingAd = NO;
            if (self.completion) self.completion(nil);
        }
    }
}

- (void)selfAdObjectDidRemoved:(DBSelfAdConfig *)adObject spaceType:(DBAdSpaceType)spaceType{
    [self removeAdObject:adObject withKey:@(spaceType)];
}

- (void)selfAdDidClick:(DBSelfAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

#pragma mark - SFRewardVideoDelegate
- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd rewardAd:(SFRewardVideoManager *)rewardAd{
    NSNumber *key = @(splashAd.spaceType);
    if (self.isShowingAd && self.completion){
        self.isShowingAd = NO;
        self.completion(rewardAd);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutCompletionBack) object:nil];
    }else{
        NSArray *adArray = [self.adViewsDict objectForKey:key];
        NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
        [adObjects addObject:rewardAd];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
}

- (void)mangoAdLoadFailure:(DBMangoAdConfig *)splashAd{

}

- (void)mangoAdLoadDidClick:(DBMangoAdConfig *)splashAd{
    [DBUnityAdConfig.manager trackDataAdDict:splashAd.adTrackModel actionType:NO];
}

- (void)mangoAdObjectDidRemoved:(DBMangoAdConfig *)splashAd rewardAd:(SFRewardVideoManager *)rewardAd{
    [self removeAdObject:rewardAd withKey:@(splashAd.spaceType)];
}


#pragma public
- (void)removeAdObject:(NSObject *)adContainerView withKey:(id)key{
    NSArray *adArray = [self.adViewsDict objectForKey:key];
    NSMutableArray *adObjects = [NSMutableArray arrayWithArray:adArray];
    if ([adObjects containsObject:adContainerView]){
        [adObjects removeObject:adContainerView];
        [self.adViewsDict setObject:adObjects forKey:key];
    }
    if (self.completion) self.completion(nil);
}

@end
