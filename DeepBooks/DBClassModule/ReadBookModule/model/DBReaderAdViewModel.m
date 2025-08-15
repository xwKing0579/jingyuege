//
//  DBReaderAdViewModel.m
//  DeepBooks
//
//  Created by king on 2025/7/7.
//

#import "DBReaderAdViewModel.h"
#import "DBReadBookSetting.h"
#import "DBReadBookSettingView.h"
#import "DBAudiobookViewController.h"
#import "DBUserModel.h"
#import "DBUserActivityModel.h"

@interface DBReaderAdViewModel ()
@property (nonatomic, strong) UIView *adContainerView;
@end

@implementation DBReaderAdViewModel

- (instancetype)init{
    if (self == [super init]){
        [self loadReaderAd];
    }
    return self;
}

- (void)loadReaderAd{
    [self loadReaderBottomBannerAd:YES];
}

- (void)loadReaderBottomBannerAd:(BOOL)reload{
    if (DBReaderAdViewModel.freeVipReadingTime) return;
    
    DBWeakSelf
    [DBUnityAdConfig.manager openBannerAdSpaceType:DBAdSpaceReaderBottom showAdController:self.readerVc reload:reload completion:^(UIView * _Nonnull adContainerView) {
        DBStrongSelfElseReturn
        if (!adContainerView) return;
        if (!self.readerVc) return;
        
        if (self.adContainerView) [self.adContainerView removeFromSuperview];
        
        self.adContainerView = adContainerView;
        UIView *settingView;
        for (UIView *subView in self.readerVc.view.subviews) {
            if ([subView isKindOfClass:DBReadBookSettingView.class]){
                settingView = subView;
            }
        }
        
        if (settingView){
            [self.readerVc.view insertSubview:self.adContainerView belowSubview:settingView];
        }else{
            [self.readerVc.view addSubview:self.adContainerView];
        }
        
        [self.adContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.readerVc.view);
            make.bottom.mas_equalTo(-UIScreen.tabbarSafeHeight-30);
            make.size.mas_equalTo(DBReadBookSetting.setting.canvasAdSize);
        }];
        
    }];
}

- (void)loadReaderBottomBannerAdInDiffTime:(NSInteger)diffTime{
    if (DBReaderAdViewModel.freeVipReadingTime) return;
    
    DBAdPosModel *posAdBottom = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderBottom];
    NSInteger interval = posAdBottom.extra.interval;
    if (interval && diffTime && (diffTime % interval == 0)){
        [self loadReaderBottomBannerAd:YES];
    }
}

- (void)loadReaderSlotAdInDiffTime:(NSInteger)diffTime{
    if (DBReaderAdViewModel.freeVipReadingTime) return;
    
    DBAdPosModel *posAdReder = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderInterstitial];
    NSInteger readInterval = posAdReder.extra.interval*60;
    if (diffTime && (diffTime % readInterval) == 0){
        [DBUnityAdConfig.manager openSlotAdSpaceType:DBAdSpaceReaderInterstitial showAdController:self.readerVc completion:^(BOOL removed) {
            UIViewController *vc = self.readerVc.childViewControllers.firstObject;
            if ([vc isKindOfClass:DBAudiobookViewController.class]) {
                DBAudiobookViewController *audiobookVc = (DBAudiobookViewController *)vc;
                if (removed){
                    [audiobookVc audiobookContinuePlayback];
                }else{
                    [audiobookVc audiobookPausePlayback];
                }
            }
        }];
    }
}


+ (BOOL)slotEndReaderAd{
    if (!DBUnityAdConfig.openAd) return NO;
    if (DBReaderAdViewModel.freeVipReadingTime) return NO;
    
    DBAdPosModel *posAdEndPage = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderChapterEnd];
    if (posAdEndPage.ads.count) {
        return YES;
    }
    return NO;
}

+ (BOOL)gridEndReaderAd{
    if (!DBUnityAdConfig.openAd) return NO;
    if (DBReaderAdViewModel.freeVipReadingTime) return NO;
    
    DBAdPosModel *posAdEndGrid = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderChapterEndGrid];
    if (posAdEndGrid.ads.count) {
        return YES;
    }
    return NO;
}

+ (NSInteger)getReaderAdSlotValue{
    if (!DBUnityAdConfig.openAd) return 0;
    if (DBReaderAdViewModel.freeVipReadingTime) return 0;
    
    DBAdPosModel *posAdPage = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderPage];
    if (posAdPage.ads.count && posAdPage.extra.interval > 0){
        return posAdPage.extra.interval;
    }
    return 0;
}

+ (NSInteger)getReaderAdGridValue{
    if (!DBUnityAdConfig.openAd) return 0;
    if (DBReaderAdViewModel.freeVipReadingTime) return 0;
    
    DBAdPosModel *posAdGrid = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderPageGrid];
    if (posAdGrid.ads.count && posAdGrid.extra.interval > 0){
        return posAdGrid.extra.interval;
    }
    return 0;
}

+ (DBReaderAdType)getReaderAdTypeWithModel:(DBReaderModel *)model after:(BOOL)after{
    if (DBReaderAdViewModel.freeVipReadingTime) return DBReaderNoAd;
    if (after) {
        if (model.currentPage == model.contentList.count-1){
            if (model.gridEndAd) {
                return DBReaderAdPageEndGrid;
            }
            
            if (model.slotEndAd) {
                return DBReaderAdPageEndSlot;
            }
        }
    }else{
        if (model.currentPage == 0){
            if (model.gridEndAd) {
                return DBReaderAdPageEndGrid;
            }
            if (model.slotEndAd) {
                return DBReaderAdPageEndSlot;
            }
        }
    }
    
    NSInteger pageNum = after ? model.readPageNum : model.readPageNum-1;
    if (pageNum != 0 && model.gridAdDiff > 0 && (pageNum % model.gridAdDiff == 0)){
        return DBReaderAdPageGrid;
    }
    
    
    if (pageNum != 0 && model.slotAdDiff > 0 && (pageNum % model.slotAdDiff == 0)){
        return DBReaderAdPageSlot;
    }
    
    return DBReaderNoAd;
}

+ (DBReaderAdType)getReaderAdTypeWithPageNum:(NSInteger)pageNum isLastIndex:(BOOL)lastIndex{
    if (DBReaderAdViewModel.freeVipReadingTime) return DBReaderNoAd;
    
    NSInteger slotAdDiff = [self getReaderAdSlotValue];
    NSInteger gridAdDiff = [self getReaderAdGridValue];
    BOOL slotAdEnd = [self slotEndReaderAd];
    BOOL gridAdEnd = [self gridEndReaderAd];
    
    if (lastIndex) {
        if (gridAdEnd) {
            return DBReaderAdPageEndGrid;
        }
        if (slotAdEnd){
            return DBReaderAdPageEndSlot;
        }
    }
    
    if (pageNum != 0) {
        if (gridAdDiff > 0 && pageNum % (gridAdDiff+1) == 0) {
            return DBReaderAdPageGrid;
        }
        if (slotAdDiff > 0 && pageNum % (slotAdDiff+1) == 0) {
            return DBReaderAdPageSlot;
        }
    }
    
    return DBReaderNoAd;
}

+ (BOOL)freeVipReadingTime{
    if (!DBCommonConfig.isLogin) return NO;
    id obj = [NSUserDefaults takeValueForKey:DBUserVipInfoValue];
    DBUserVipModel *vipModel = [DBUserVipModel modelWithJSON:obj];
    if (vipModel.level == 1 && vipModel.free_vip_seconds > 0) return YES;
    return NO;
}

+ (void)checkFreeAdActivityCompletion:(void (^ __nullable)(DBUserVipModel *vipModel, DBUserActivityModel *activityModel))completion{
    if (!DBCommonConfig.isLogin || !DBUnityAdConfig.openAd || DBUserVipConfig.isUserVip) {
        if (completion) completion(nil, nil);
        return;
    }
    
    DBAdPosModel *posAdFreeVip = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceUserFreeVip];
    DBAdPosModel *posAdBottom = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderBottom];
    DBAdPosModel *posAdInterstitial = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderInterstitial];
    DBAdPosModel *posAdChapterEnd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderChapterEnd];
    DBAdPosModel *posAdChapterEndGrid = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderChapterEndGrid];
    DBAdPosModel *posAdPage = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderPage];
    DBAdPosModel *posAdPageGrid = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderPageGrid];
    
    if (posAdFreeVip.ads.count &&
        (posAdBottom.ads.count ||
         posAdInterstitial.ads.count ||
         posAdChapterEnd.ads.count ||
         posAdChapterEndGrid.ads.count ||
         posAdPage.ads.count ||
         posAdPageGrid.ads.count)) {
        [DBUserModel getUserVipInfoCompletion:^(BOOL successfulRequest, DBUserVipModel * _Nonnull model) {
            if (successfulRequest && (model.level == 0 || (model.level == 1 && model.free_vip_seconds == 0))){
                [DBUserVipConfig checkFreeVipActivityCompletion:^(DBUserActivityModel * _Nonnull activityModel) {
                    if (completion) completion(model, activityModel);
                }];
            }else{
                if (completion) completion(nil, nil);
            }
        }];
    }else{
        if (completion) completion(nil, nil);
    }
}

- (void)clearAllReaderAdView{
    [self.activityView removeFromSuperview];
    [self.adContainerView removeFromSuperview];
}

- (DBActivityEntranceView *)activityView{
    if (!_activityView){
        _activityView = [[DBActivityEntranceView alloc] init];
    }
    return _activityView;
}

@end
