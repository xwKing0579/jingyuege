//
//  DBMangoAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/8.
//

#import "DBMangoAdConfig.h"
#import "DBReadBookSetting.h"

@interface DBMangoAdConfig ()<SFNativeDelegate,SFBannerDelegate,SFRewardVideoDelegate,SFInterstitialDelegate>
@property (nonatomic, strong) SFNativeManager *splashAdConfig;
@property (nonatomic, strong) SFBannerManager *bannerAdConfig;
@property (nonatomic, strong) SFRewardVideoManager *rewardAdConfig;
@property (nonatomic, strong) SFInterstitialManager *slotAdConfig;
@property (nonatomic, assign) id<DBMangoAdDelegate> delegate;
@property (nonatomic, strong) UIView *bannerView;
@end

@implementation DBMangoAdConfig

- (void)loadAdDataExpressAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate{
    SFNativeManager *splashAdConfig = [[SFNativeManager alloc] init];
    splashAdConfig.delegate = self;
    splashAdConfig.mediaId = adId;
    splashAdConfig.adCount = 1;
    splashAdConfig.intervalTime = 0;
    SFVideoConfig *videoConfig = [[SFVideoConfig alloc] init];
    videoConfig.videoMuted = YES;
    videoConfig.isVideoMutedConfig = NO;
    splashAdConfig.videoConfig = videoConfig;
    splashAdConfig.showAdController = self.showAdController;
    [splashAdConfig loadAdData];
    self.splashAdConfig = splashAdConfig;
    self.delegate = delegate;
}

- (void)loadAdDataBannerAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate{
    SFBannerManager *bannerAdConfig = [[SFBannerManager alloc] init];
    bannerAdConfig.mediaId = adId;
    bannerAdConfig.loop = NO;
    bannerAdConfig.size = DBReadBookSetting.setting.canvasAdSize;
    SFVideoConfig *videoConfig = [[SFVideoConfig alloc] init];
    videoConfig.videoMuted = YES;
    videoConfig.isVideoMutedConfig = NO;
    bannerAdConfig.videoConfig = videoConfig;
    bannerAdConfig.showAdController = self.showAdController;
    [bannerAdConfig loadAdData];
    self.bannerAdConfig = bannerAdConfig;
    self.delegate = delegate;
}

- (void)loadAdDataRewardAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate{
    SFRewardVideoManager *rewardAdConfig = [[SFRewardVideoManager alloc] init];
    rewardAdConfig.mediaId = adId;
    rewardAdConfig.delegate = self;
    [rewardAdConfig loadAdData];
    self.rewardAdConfig = rewardAdConfig;
    self.delegate = delegate;
}

- (void)loadAdDataSlotAdId:(NSString *)adId delegate:(id<DBMangoAdDelegate>)delegate{
    SFInterstitialManager *slotAdConfig = [[SFInterstitialManager alloc] init];
    slotAdConfig.mediaId = adId;
    slotAdConfig.delegate = self;
    slotAdConfig.showAdController = self.showAdController;
    [slotAdConfig loadAdData];
    self.slotAdConfig = slotAdConfig;
    self.delegate = delegate;
}

#pragma mark - SFNativeDelegate
- (void)nativeAdDidLoadDatas:(NSArray<__kindof SFFeedAdData *> *)datas{
    dispatch_async(dispatch_get_main_queue(), ^{
        SFFeedAdData *adData = datas.firstObject;
        UIView *adContainerView = adData.adView;
        if (adContainerView == nil){
            CGRect adViewRect = CGRectMake(0, 0, UIScreen.screenWidth, 200);
            if (adData.imageWidth && adData.imageHeight){
                adViewRect = CGRectMake(0, 0, UIScreen.screenWidth, adData.imageHeight*UIScreen.screenWidth/adData.imageWidth);
            }
            SFTemplateAdView *templateAdView = [[SFTemplateAdView alloc] initWithFrame:adViewRect Model:adData Style:SFTemplateStyleDefault LRMargin:8 TBMargin:8];
            DBAdBannerView *bannerView = [[DBAdBannerView alloc] initWithFrame:adViewRect];
            bannerView.adData = adData;
            bannerView.splashAdConfig = self.splashAdConfig;
            [bannerView addSubview:templateAdView];
            
            DBWeakSelf
            bannerView.adViewCloseAction = ^(UIView * _Nonnull adContainerView) {
                DBStrongSelfElseReturn
                [self nativeAdDidCloseWithADView:adContainerView];
            };
            adContainerView = bannerView;
        }
        
        if (adContainerView && self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadSuccess: adContainerView:)]){
            [self.delegate mangoAdLoadSuccess:self adContainerView:adContainerView];
        }
    });
   
}

- (void)nativeAdDidFailed:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadFailure:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadFailure:self];
        });
    }
}


- (void)nativeAdDidCloseWithADView:(UIView *)nativeAdView{
    if (nativeAdView && self.delegate && [self.delegate respondsToSelector:@selector(mangoAdObjectDidRemoved:adContainerView:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdObjectDidRemoved:self adContainerView:nativeAdView];
        });
    }
}

#pragma mark - DBMangoAdDelegate
- (void)bannerAdDidLoad{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadSuccess:adContainerView:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize size = DBReadBookSetting.setting.canvasAdSize;
            UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake((UIScreen.screenWidth-size.width)*0.5, 0, size.width, size.height)];
            self.bannerView = bannerView;
            [self.bannerAdConfig showBannerAdWithView:bannerView];
            [self.delegate mangoAdLoadSuccess:self adContainerView:bannerView];
        });
    }
}

- (void)bannerAdDidFailed:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadFailure:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadFailure:self];
        });
    }
}

- (void)bannerAdDidClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadDidClick:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadDidClick:self];
        });
    }
}

- (void)nativeAdDidClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadDidClick:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadDidClick:self];
        });
    }
}

- (void)bannerAdDidClose{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdObjectDidRemoved:adContainerView:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdObjectDidRemoved:self adContainerView:self.bannerView];
        });
    }
}

#pragma mark - SFRewardVideoDelegate
- (void)rewardedVideoDidLoad{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadSuccess:rewardAd:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadSuccess:self rewardAd:self.rewardAdConfig];
        });
    }
}

- (void)rewardedVideoDidFailWithError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadFailure:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadFailure:self];
        });
    }
}

- (void)rewardedVideoDidClose{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdObjectDidRemoved:rewardAd:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdObjectDidRemoved:self rewardAd:self.rewardAdConfig];
        });
    }
}

- (void)rewardedVideoDidClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadDidClick:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadDidClick:self];
        });
    }
}

- (void)rewardedVideoDidRewardEffectiveWithExtra:(NSDictionary *)extra{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidRewardEffectiveWithExtra:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdObjectDidReward:self rewardAd:self.rewardAdConfig extra:extra];
        });
    }
}

#pragma mark - SFInterstitialDelegate
- (void)interstitialAdDidLoad{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadSuccess:slotAd:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadSuccess:self slotAd:self.slotAdConfig];
        });
    }
}

- (void)interstitialAdDidFailed:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadFailure:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadFailure:self];
        });
    }
}

- (void)interstitialAdDidAutoClose:(BOOL)autoClose{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdObjectDidRemoved:slotAd:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdObjectDidRemoved:self slotAd:self.slotAdConfig];
        });
    }
}

- (void)interstitialAdDidClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mangoAdLoadDidClick:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate mangoAdLoadDidClick:self];
        });
    }
}

- (UIView *)bannerView{
    if (!_bannerView){
        _bannerView = [[UIView alloc] init];
    }
    return _bannerView;
}

@end
