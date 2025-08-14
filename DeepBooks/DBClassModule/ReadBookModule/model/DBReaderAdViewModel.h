//
//  DBReaderAdViewModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/7.
//

#import <Foundation/Foundation.h>
#import "DBReaderManagerViewController.h"
#import "DBReaderModel.h"
#import "DBUserVipConfig.h"
#import "DBActivityEntranceView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, DBReaderAdType) {
    DBReaderNoAd               = 0,
    DBReaderAdPageSlot         = 1 << 0,
    DBReaderAdPageGrid         = 1 << 1,
    DBReaderAdPageEndSlot      = 1 << 2,
    DBReaderAdPageEndGrid      = 1 << 3,
};

@interface DBReaderAdViewModel : NSObject

@property (nonatomic, weak) DBReaderManagerViewController *readerVc;

@property (nonatomic, assign) BOOL vipFree;
@property (nonatomic, strong) DBActivityEntranceView *activityView;

+ (BOOL)slotEndReaderAd;
+ (BOOL)gridEndReaderAd;
+ (NSInteger)getReaderAdSlotValue;
+ (NSInteger)getReaderAdGridValue;

- (void)loadReaderBottomBannerAdInDiffTime:(NSInteger)diffTime;

- (void)loadReaderSlotAdInDiffTime:(NSInteger)diffTime;

+ (DBReaderAdType)getReaderAdTypeWithModel:(DBReaderModel *)model after:(BOOL)after;

+ (DBReaderAdType)getReaderAdTypeWithPageNum:(NSInteger)pageNum isLastIndex:(BOOL)lastIndex;

+ (void)checkFreeAdActivityCompletion:(void (^ __nullable)(DBUserVipModel *vipModel, DBUserActivityModel *activityModel))completion;
+ (BOOL)freeVipReadingTime;
- (void)clearAllReaderAdView;

@end

NS_ASSUME_NONNULL_END
