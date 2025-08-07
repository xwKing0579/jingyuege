//
//  DBSelfAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import <Foundation/Foundation.h>


@class DBSelfAdConfig;
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,DBSelfAdType) {
    DBSelfAdLaunch,
    DBSelfAdBanner,
    DBSelfAdReward,
    DBSelfAdExpress,
    DBSelfAdSlot,
    DBSelfAdGrid,
};

@protocol DBSelfAdDelegate <NSObject>
@optional

- (void)selfAdLoadSuccess:(DBSelfAdConfig *)splashAd;
- (void)selfAdLoadFailure:(DBSelfAdConfig *)splashAd;
- (void)selfAdViewDidRemoved:(UIView *)adContainerView spaceType:(DBAdSpaceType)spaceType;
- (void)selfAdObjectDidRemoved:(DBSelfAdConfig *)adObject spaceType:(DBAdSpaceType)spaceType;
- (void)selfAdDidClick:(DBSelfAdConfig *)splashAd;

@end

@interface DBSelfAdConfig : NSObject

@property (nonatomic, assign) DBAdSpaceType spaceType;


- (void)loadSelfAdModel:(DBSelfAdModel *)selfAd delegate:(id<DBSelfAdDelegate>)delegate;
- (void)showAdInView:(UIView *)view adType:(DBSelfAdType)adType;
- (UIView *)selfAdViewWithAdType:(DBSelfAdType)adType;

@end


NS_ASSUME_NONNULL_END
