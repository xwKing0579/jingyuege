//
//  DBUnityAdConfig.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/23.
//

#import <Foundation/Foundation.h>
#import "DBAdServerDataModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,DBAdSpaceType) {
    //launch
    DBAdSpaceSplashScreen,
    DBAdSpaceBackgroundToForeground,
    
    //banner
    DBAdSpaceBookDetailBottom,
    DBAdSpaceBookshelfTop,
    DBAdSpaceBookshelfListModeMiddle,
    DBAdSpaceFatAreaTop,
    DBAdSpaceReaderBottom,
    DBAdSpaceSearchPageTop,
    DBAdSpaceBookCityCategoryTop,
    
    //信息流
    DBAdSpaceBookCitySelectedTop,
    DBAdSpaceBookCitySelectedMiddle,
    DBAdSpaceBookCitySelectedBottom,
    
    DBAdSpaceBookCityMaleTop,
    DBAdSpaceBookCityMaleMiddle,
    DBAdSpaceBookCityMaleBottom,
    
    DBAdSpaceBookCityFemaleTop,
    DBAdSpaceBookCityFemaleMiddle,
    DBAdSpaceBookCityFemaleBottom,
    
    DBAdSpaceCategoryDetailTop,
    DBAdSpaceCategoryDetailMiddle,
    DBAdSpaceCategoryDetailBottom,
    
    DBAdSpaceBookDetailPageTop,
    DBAdSpaceBookDetailPageMiddle,
    DBAdSpaceBookDetailPageBottom,
    
    DBAdSpaceReaderPage,
    DBAdSpaceReaderChapterEnd,
    
    //网格
    DBAdSpaceBookCitySelectedTopGrid,
    DBAdSpaceBookCityFemaleTopGrid,
    DBAdSpaceBookCityMaleTopGrid,
    DBAdSpaceBookDetailMiddleGrid,
    DBAdSpaceBookDetailTopGrid,
    DBAdSpaceReaderPageGrid,
    DBAdSpaceReaderChapterEndGrid,
    
    //插屏：
    DBAdSpaceEnterBookshelfPage,
    DBAdSpaceEnterBookCity,
    DBAdSpaceEnterBookDetailPage,
    DBAdSpaceReaderInterstitial,
    

    //激励
    DBAdSpaceAddToBookshelf,
    DBAdSpaceCacheBooksContent,
    DBAdSpaceListenBooks,
    DBAdSpaceRequestBooks,
 
};

@interface DBUnityAdConfig : NSObject

@property (nonatomic, assign) double enterBgTime;
@property (nonatomic, assign) NSInteger cumulativeTime;

@property (nonatomic, strong) NSMutableDictionary *apperTimeDict;

+ (instancetype)manager;


//接口数据
+ (DBAdServerDataModel *)adConfigModel;

+ (BOOL)openAd;

+ (DBAdPosModel *)adPosWithSpaceType:(DBAdSpaceType)spaceType;

//初始化&开屏广告
- (void)initAdConfig;
- (void)trackDataAdDict:(DBAdsModel *)adModel actionType:(BOOL)adShow;

//banner广告
- (void)openBannerAdSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion;

//激励广告
- (void)preloadingRewardAdPreLoadSpaceType:(DBAdSpaceType)spaceType;
- (void)openRewardAdSpaceType:(DBAdSpaceType)spaceType completion:(void (^ _Nullable)(BOOL removed))completion;

//插屏广告
- (void)openSlotAdSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController completion:(void (^ _Nullable)(BOOL removed))completion;

//信息流广告
- (void)openExpressAdsSpaceType:(DBAdSpaceType)spaceType showAdController:(UIViewController *)showAdController reload:(BOOL)reload completion:(void (^ _Nullable)(NSArray <UIView *>*adViews))completion;

//网格
- (void)openGridAdSpaceType:(DBAdSpaceType)spaceType reload:(BOOL)reload completion:(void (^ _Nullable)(UIView *adContainerView))completion;

@end

NS_ASSUME_NONNULL_END
