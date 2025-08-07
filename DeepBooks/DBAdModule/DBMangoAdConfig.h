//
//  DBMangoAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/8.
//

#import "DBAdBase.h"

NS_ASSUME_NONNULL_BEGIN
@class DBMangoAdConfig;
@protocol DBMangoAdDelegate <NSObject>
@optional

- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd adContainerView:(UIView *)adContainerView;
- (void)mangoAdLoadFailure:(DBMangoAdConfig *)splashAd;
- (void)mangoAdObjectDidRemoved:(DBMangoAdConfig *)splashAd adContainerView:(UIView *)adContainerView;
- (void)mangoAdLoadDidClick:(DBMangoAdConfig *)splashAd;

- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd rewardAd:(SFRewardVideoManager *)rewardAd;
- (void)mangoAdObjectDidRemoved:(DBMangoAdConfig *)splashAd rewardAd:(SFRewardVideoManager *)rewardAd;

- (void)mangoAdLoadSuccess:(DBMangoAdConfig *)splashAd slotAd:(SFInterstitialManager *)slotAd;
- (void)mangoAdObjectDidRemoved:(DBMangoAdConfig *)splashAd slotAd:(SFInterstitialManager *)slotAd;

@end

@interface DBMangoAdConfig : DBAdBase

@property (nonatomic, weak) UIViewController *showAdController;

- (void)loadAdDataExpressAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate;
- (void)loadAdDataBannerAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate;
- (void)loadAdDataRewardAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate;
- (void)loadAdDataSlotAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
