//
//  DBSelfAdConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/20.
//

#import "DBSelfAdConfig.h"
#import <SDWebImage/SDWebImage.h>
#import "DeepBooks-Swift.h"
#import "DBSelfAdView.h"
#import "DBAdBase.h"
@interface DBSelfAdConfig ()
@property (nonatomic, strong) DBSelfAdModel *selfAd;
@property (nonatomic, assign) id<DBSelfAdDelegate> delegate;

@end

@implementation DBSelfAdConfig


- (void)loadSelfAdModel:(DBSelfAdModel *)selfAd delegate:(id<DBSelfAdDelegate>)delegate{
    self.selfAd = selfAd;
    self.delegate = delegate;
   
    __block BOOL adResult = YES;
    dispatch_group_t group = dispatch_group_create();

    if ([selfAd.type isEqualToString:@"grid"]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSArray *grid in selfAd.grid) {
            NSArray <DBSelfAdModel *>*adList = [NSArray modelArrayWithClass:DBSelfAdModel.class json:grid];
            [temp addObject:adList];
        }
        
        selfAd.grid = temp;
        for (NSArray <DBSelfAdModel *>*grid in selfAd.grid) {
            NSString *imageUrl = grid.firstObject.image;
            if (imageUrl.length > 0){
                dispatch_group_enter(group);
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (image){
                        grid.firstObject.adSize = image.size;
                    }else{
                        adResult = NO;
                    }
                    dispatch_group_leave(group);
                }];
            }else{
                adResult = NO;
            }
        }
    }else{
      
        if (selfAd.image.length > 0){
            dispatch_group_enter(group);
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:selfAd.image] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image){
                    selfAd.adSize = CGSizeMake(UIScreen.screenWidth, (UIScreen.screenWidth*image.size.height/image.size.width)+50.0);
                }else{
                    adResult = NO;
                }
                dispatch_group_leave(group);
            }];
        }
       
        if (selfAd.video.length > 0){
            dispatch_group_enter(group);
            [DBVideoDownload videoDownloadWithUrl:selfAd.video completion:^(BOOL success) {
                if (!success) {
                    adResult = NO;
                }
                dispatch_group_leave(group);
            }];
        }
        
        if (selfAd.image.length == 0 && selfAd.video.length == 0) {
            dispatch_group_enter(group);
            adResult = NO;
            dispatch_group_leave(group);
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self selfAdLoadCompleted:adResult];
    });
}


- (void)selfAdLoadCompleted:(BOOL )success {
    if (!self.delegate) return;
    if (success){
        if ([self.delegate respondsToSelector:@selector(selfAdLoadSuccess:)]){
            [self.delegate selfAdLoadSuccess:self];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(selfAdLoadFailure:)]){
            [self.delegate selfAdLoadFailure:self];
        }
    }
}

- (void)showAdInView:(UIView *)view adType:(DBSelfAdType)adType{
    DBSelfAdView *selfAdView = [[DBSelfAdView alloc] initWithSelfAdModel:self.selfAd adType:adType];
    selfAdView.adTrackModel = self.adTrackModel;
    DBWeakSelf
    selfAdView.didRemovedBlock = ^(UIView * _Nonnull adContainerView, DBSelfAdType adType) {
        DBStrongSelfElseReturn
        if ([self.delegate respondsToSelector:@selector(selfAdViewDidRemoved:spaceType:)]){
            [self.delegate selfAdViewDidRemoved:adContainerView spaceType:self.spaceType];
        }
        if ([self.delegate respondsToSelector:@selector(selfAdObjectDidRemoved:spaceType:)]){
            [self.delegate selfAdObjectDidRemoved:self spaceType:self.spaceType];
        }
    };
    selfAdView.didClickBlock = ^(UIView * _Nonnull adContainerView, DBSelfAdType adType) {
        DBStrongSelfElseReturn
        if ([self.delegate respondsToSelector:@selector(selfAdDidClick:)]){
            [self.delegate selfAdDidClick:self];
        }
    };
    selfAdView.didFinishRewardBlock = ^(UIView * _Nonnull adContainerView, DBSelfAdType adType) {
        DBStrongSelfElseReturn
        if ([self.delegate respondsToSelector:@selector(selfAdViewDidFinishReward:spaceType:)]){
            [self.delegate selfAdViewDidFinishReward:self spaceType:self.spaceType];
        }
    };
    [view addSubview:selfAdView];
}

- (UIView *)selfAdViewWithAdType:(DBSelfAdType)adType{
    DBSelfAdView *selfAdView = [[DBSelfAdView alloc] initWithSelfAdModel:self.selfAd adType:adType];
    return selfAdView;
}

@end
