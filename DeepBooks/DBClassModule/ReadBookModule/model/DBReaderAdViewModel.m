//
//  DBReaderAdViewModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/7.
//

#import "DBReaderAdViewModel.h"
#import "DBReadBookSetting.h"
#import "DBReadBookSettingView.h"
#import "DBAudiobookViewController.h"
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
    DBAdPosModel *posAdBottom = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderBottom];
    NSInteger interval = posAdBottom.extra.interval;
    if (interval && diffTime && (diffTime % interval == 0)){
        [self loadReaderBottomBannerAd:YES];
    }
}

- (void)loadReaderSlotAdInDiffTime:(NSInteger)diffTime{
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

    DBAdPosModel *posAdEndPage = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderChapterEnd];
    if (posAdEndPage.ads.count) {
        return YES;
    }
    return NO;
}

+ (BOOL)gridEndReaderAd{
    if (!DBUnityAdConfig.openAd) return NO;
    
    DBAdPosModel *posAdEndGrid = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderChapterEndGrid];
    if (posAdEndGrid.ads.count) {
        return YES;
    }
    return NO;
}

+ (NSInteger)getReaderAdSlotValue{
    if (!DBUnityAdConfig.openAd) return 0;
    
    DBAdPosModel *posAdPage = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderPage];
    if (posAdPage.ads.count && posAdPage.extra.interval > 0){
        return posAdPage.extra.interval;
    }
    return 0;
}

+ (NSInteger)getReaderAdGridValue{
    if (!DBUnityAdConfig.openAd) return 0;
    
    DBAdPosModel *posAdGrid = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceReaderPageGrid];
    if (posAdGrid.ads.count && posAdGrid.extra.interval > 0){
        return posAdGrid.extra.interval;
    }
    return 0;
}

+ (DBReaderAdType)getReaderAdTypeWithModel:(DBReaderModel *)model after:(BOOL)after{
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

@end
