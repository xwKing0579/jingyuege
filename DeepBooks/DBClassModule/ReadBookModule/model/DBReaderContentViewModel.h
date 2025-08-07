//
//  DBReaderContentViewModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import <Foundation/Foundation.h>
#import "DBReadBookSettingView.h"
#import "DBSpeechMenuView.h"
#import "DBReaderManagerViewController.h"

#import "DBSpeechManager.h"

#import "DBChapterNameView.h"
#import "DBBatteryDateView.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DBMenuType) {
    DBMenuDownLoad,
    DBMenuClickBookSource,
    DBMenuOpenCatalog,
    DBMenuChangeChapter,
    DBMenuChangeFont,
    DBMenuChangeLinSpacing,
    DBMenuChangeBackgroundColor,
    DBMenuChangeTransition,
    DBMenuReaderAutomatic,
    DBMenuScanningNext,
    DBMenuReaderAudiobook,
    DBMenuSpeechNext,
    DBMenuSpeechEnd,
};


@interface DBReaderContentViewModel : NSObject

@property (nonatomic, weak) DBReaderManagerViewController *readerVc;

@property (nonatomic, strong) DBReadBookSettingView *readerPanelView;
@property (nonatomic, strong) DBSpeechMenuView *speechPanelView;

@property (nonatomic, strong) DBChapterNameView *chapterNameView;
@property (nonatomic, strong) DBBatteryDateView *batteryDateView;

@property (nonatomic, strong, nullable) DBSpeechManager *speechManager;

@property (nonatomic, copy) void (^menuBlock)(DBMenuType type, NSInteger index);


- (void)addReaderPanelView;
- (void)removeReaderPanelView;

- (void)getChapterContentWithChapterForm:(NSString *)chapterForm chapterId:(NSString *)chapterId chapterIndex:(NSInteger)chapterIndex completion:(void (^ _Nullable)(BOOL successfulRequest, NSInteger chapterIndex, NSString * _Nullable message))completion;


@end

NS_ASSUME_NONNULL_END
