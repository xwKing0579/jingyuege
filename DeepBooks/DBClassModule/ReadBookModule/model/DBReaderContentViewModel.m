//
//  DBReaderContentViewModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBReaderContentViewModel.h"
#import "DBBookChapterModel.h"
#import "DBFeedbackPanView.h"
#import "DBAdReadSetting.h"
#import "DBBookSourceModel.h"
#import "DBBookCatalogModel.h"
#import "DBSpeechVoicePanView.h"
#import "DBReadBookSetting.h"
#import "DBReadBookCatalogsViewController.h"
#import "DBReaderSetting.h"
#import "DBBookSettingView.h"
#import "DBScanningView.h"

@interface DBReaderContentViewModel ()
@property (nonatomic, assign) NSInteger speechTime;
@property (nonatomic, strong) NSDate *speechDate;
@property (nonatomic, strong) NSMutableArray <NSTextCheckingResult *> *speechMatches;
@property (nonatomic, strong) DBBookSettingView *readerSettingView;
@property (nonatomic, strong) DBScanningView *scanningView;

@end

@implementation DBReaderContentViewModel

- (instancetype)init{
    if (self == [super init]){
        [DBCommonConfig migrateUserInReading:YES];
    }
    return self;
}

- (void)getChapterContentWithChapterForm:(NSString *)chapterForm chapterId:(NSString *)chapterId chapterIndex:(NSInteger)chapterIndex completion:(void (^ _Nullable)(BOOL successfulRequest, NSInteger chapterIndex, NSString * _Nullable message))completion{
    if (chapterForm.length == 0 || chapterId.length == 0) {
        if (completion) completion(NO, chapterIndex, nil);
        return;
    }
    
    //cache
    DBBookChapterModel *chapterModel = [DBBookChapterModel getBookChapter:chapterForm chapterId:chapterId];
    if (chapterModel){
        if (completion) completion(YES, chapterIndex, @"cached");
        return;
    }
    
    [DBAFNetWorking getServiceRequestType:DBLinkBookChapter combine:chapterId parameInterface:nil modelClass:DBBookChapterModel.class serviceData:^(BOOL successfulRequest, DBBookChapterModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            result.id = chapterId;
//            result.chapter_index = chapterIndex;
            if (result.is_encrypt){
                result.title = result.name.aesDecryptText;
                result.body = result.content.aesDecryptText;
            }else{
                result.title = result.name;
                result.body = result.content;
            }
            
            if ([result updateChapterWithChapterForm:chapterForm]){
                if (completion) completion(YES, chapterIndex, message);
            }else{
                if (completion) completion(NO, chapterIndex, message);
            }
        }else{
            if (completion) completion(NO, chapterIndex, message);
        }
    }];
}

#pragma readerPanelView action
- (void)addReaderPanelView{
    [self.readerVc.view addSubview:self.readerPanelView];
    self.readerPanelView.bookgroundColor = DBReadBookSetting.setting.backgroundColor;
    [self.readerPanelView showPanelViewAnimation];
}

- (void)removeReaderPanelClickAction{
    [self.readerSettingView removeFromSuperview];
    self.readerVc.fd_interactivePopDisabled = YES;
}

- (void)feedbackClickAction{
    [self removeReaderPanelView];
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    
    DBFeedbackPanView *feedbackView = [[DBFeedbackPanView alloc] init];
    feedbackView.book = self.readerVc.book;
    [feedbackView presentInView:UIScreen.appWindow];
}

- (void)downloadClickAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }

    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceCacheBooksContent];
    if (DBUnityAdConfig.openAd && posAd.ads.count && posAd.extra.free_count > 0){
        DBAdReadSetting *adSetting = DBAdReadSetting.setting;
        NSInteger limit = adSetting.cacheChapterCount;
        if (!adSetting.isFreeCacheBook){
            adSetting.isFreeCacheBook = YES;
            limit = posAd.extra.free_count*posAd.extra.limit;
            adSetting.cacheChapterCount = limit;
            [adSetting reloadSetting];
        }
        [self chapterDownloadReminderInLimit:limit adReward:YES];
    }else{
        NSInteger limit = MAX(100, DBCommonConfig.appConfig.force.ad_chapter_count);
        [self chapterDownloadReminderInLimit:limit adReward:NO];
    }
}

- (void)chapterDownloadReminderInLimit:(NSInteger)limit adReward:(BOOL)adReward{
    DBWeakSelf
    DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceCacheBooksContent];
    NSString *content = [NSString stringWithFormat:@"点击按钮，即可免费缓存后面%ld章节内容！",limit<=0?posAd.extra.free_count*posAd.extra.limit:limit];
    LEEAlert.alert.config.LeeTitle(@"缓存模式").
    LeeContent(content).
    LeeCancelAction(@"取消", ^{
        
    }).LeeAction(@"开始缓存", ^{
        DBStrongSelfElseReturn
        
        DBBookModel *book = self.readerVc.book;
        NSArray <DBBookCatalogModel *>*chapterList = [DBBookCatalogModel getBookCatalogs:book.catalogForm];
        NSInteger currentChapter = book.chapter_index;
        if (adReward){
            if (limit <= 0) {
                [DBUnityAdConfig.manager openRewardAdSpaceType:DBAdSpaceCacheBooksContent completion:^(BOOL removed,BOOL reward) {
                    if (removed) {
                        DBAdPosModel *posAd = [DBUnityAdConfig adPosWithSpaceType:DBAdSpaceCacheBooksContent];
                        DBAdReadSetting *adSetting = DBAdReadSetting.setting;
                        NSInteger adLimit = MAX(100, posAd.extra.limit);
                        adSetting.cacheChapterCount = limit;
                        [adSetting reloadSetting];
                        
                        [self downloadWithStartChapterIndex:currentChapter currentChapterIndex:currentChapter chapterForm:book.chapterForm chapterList:chapterList downloadCount:0 limit:adLimit adReward:adReward];
                    }
                }];
            }else{
                [self downloadWithStartChapterIndex:currentChapter currentChapterIndex:currentChapter chapterForm:book.chapterForm chapterList:chapterList downloadCount:0 limit:limit adReward:adReward];
            }
        }else{
            [self downloadWithStartChapterIndex:currentChapter currentChapterIndex:currentChapter chapterForm:book.chapterForm chapterList:chapterList downloadCount:0 limit:limit adReward:adReward];
        }
    }).LeeShow();
}


- (void)downloadWithStartChapterIndex:(NSInteger)startChapter currentChapterIndex:(NSInteger)currentChapterIndex chapterForm:(NSString *)chapterForm chapterList:(NSArray *)chapterList downloadCount:(NSInteger)downloadCount limit:(NSInteger)limit adReward:(BOOL)adReward{
    if (downloadCount >= limit) {
        self.readerPanelView.cacheText = nil;
        [self.readerVc.view showAlertText:@"缓存完成"];
        return;
    }
    
    if (currentChapterIndex > chapterList.count-1) {
        if (startChapter == 0){
            self.readerPanelView.cacheText = nil;
            [self.readerVc.view showAlertText:@"缓存完成"];
            return;
        }else{
            currentChapterIndex = 0;
        }
    }else if (currentChapterIndex == startChapter-1){
        self.readerPanelView.cacheText = nil;
        [self.readerVc.view showAlertText:@"缓存完成"];
        return;
    }
    
    self.readerPanelView.cacheText = [NSString stringWithFormat:@"正在缓存中 (%ld/%ld) ...",downloadCount,limit];
    DBBookCatalogModel *catalog = chapterList[currentChapterIndex];
    self.readerPanelView.downloadButton.userInteractionEnabled = NO;
    [self getChapterContentWithChapterForm:chapterForm chapterId:catalog.path chapterIndex:currentChapterIndex completion:^(BOOL successfulRequest, NSInteger chapterIndex, NSString * _Nullable message) {
        self.readerPanelView.downloadButton.userInteractionEnabled = YES;
        if (successfulRequest){
            NSInteger downloadValue = downloadCount;
            if (![message isEqualToString:@"cached"]){
                if (adReward) {
                    DBAdReadSetting *adSetting = DBAdReadSetting.setting;
                    adSetting.cacheChapterCount = MAX(0, adSetting.cacheChapterCount-1);
                    [adSetting reloadSetting];
                }
                downloadValue += 1;
            }
            [self downloadWithStartChapterIndex:startChapter currentChapterIndex:currentChapterIndex+1 chapterForm:chapterForm chapterList:chapterList downloadCount:downloadValue limit:limit adReward:adReward];
        }else{
            self.readerPanelView.cacheText = nil;
            [self.readerVc.view showAlertText:message];
        }
    }];
}


#pragma readerPanelView action
- (void)exterLinkClickAction{
    NSString *sourceUrl = @"";
    NSString *sourceSite = @"";
    NSString *address = @"转码地址";
    
    DBBookModel *book = self.readerVc.book;
    NSArray *sourceList = [DBBookSourceModel getBookSources:book.sourceForm];
    for (DBBookSourceModel *model in sourceList) {
        if ([model.site_path isEqualToString:book.site_path]){
            sourceSite = model.site_name;
        }
    }
    
    if ([sourceSite isEqualToString:@"聚合校对"]) {
        address = @"搜索转码地址";
        sourceSite = @"聚合搜索";
        sourceUrl = [NSString stringWithFormat:@"https://m.baidu.com/s?word=%@",book.name];
    }
    
    DBBookCatalogModel *model = [DBBookCatalogModel getBookCatalogs:self.readerVc.book.catalogForm].firstObject;
    sourceUrl = model.url;
    
    NSString *content = [NSString stringWithFormat:@"转码来源:\n%@\n\n此转码内容来源于%@，如有内容侵权请联系转码原站，谢谢您的支持",sourceSite,sourceSite];
    if (sourceUrl.length > 0){
        content = [NSString stringWithFormat:@"%@:\n%@\n\n此转码内容来源于%@，如有内容侵权请联系转码原站，谢谢您的支持",address,sourceUrl,sourceSite];
    }
    DBWeakSelf
    LEEAlert.alert.config.LeeContent(content).
    LeeCancelAction(@"取消", ^{
        
    }).LeeAction(@"去看看", ^{
        DBStrongSelfElseReturn
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:sourceUrl.characterSet] options:@{} completionHandler:nil];
    }).LeeShow();
}

- (void)speechClickAction{
    if (self.menuBlock) self.menuBlock(DBMenuReaderAudiobook, 0);
}

- (void)changeBookSourceClickAction{
    [DBRouter openPageUrl:DBBookSource params:@{@"bookId":self.readerVc.book.book_id,kDBRouterDrawerSideslip:@1}];
}

- (void)openCatalogsClickAction{
    DBBookModel *book = self.readerVc.book;
    NSArray <DBBookCatalogModel *>*chapterList = [DBBookCatalogModel getBookCatalogs:book.catalogForm];
    DBReadBookCatalogsViewController *catalogsVc = (DBReadBookCatalogsViewController *)[DBRouter openPageUrl:DBReadBookCatalogs params:@{@"book":book,@"dataList":chapterList?:@[],kDBRouterDrawerSideslip:@1}];
    DBWeakSelf
    catalogsVc.clickChapterIndex = ^(NSInteger chapterIndex) {
        DBStrongSelfElseReturn
        [self.readerPanelView removeFromSuperview];
        if (self.menuBlock) self.menuBlock(DBMenuChangeChapter, chapterIndex);
    };
}

- (void)eyeModeClickAction:(UIButton *)sender{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    sender.selected = !sender.selected;
    setting.isDark = sender.selected;
    [setting reloadSetting];
    [DBReaderSetting openEyeProtectionMode];
}

- (void)openBookSettingClickAction{
    [self.readerVc.view addSubview:self.readerSettingView];
    self.readerSettingView.bookgroundColor = DBReadBookSetting.setting.backgroundColor;
    [self.readerSettingView showAnimate];
}

- (void)chapterChagingWithSliderValue:(CGFloat)value finish:(BOOL)finish{
    DBBookModel *book = self.readerVc.book;
    NSArray <DBBookCatalogModel *>*chapterList = [DBBookCatalogModel getBookCatalogs:book.catalogForm];
    NSInteger index = MAX(0, (int)(value*chapterList.count-1));
    DBBookCatalogModel *catalogModel = chapterList[index];
    self.readerPanelView.chapterName = catalogModel.name.aesDecryptText;
    self.readerPanelView.rateValue = [NSString stringWithFormat:@"%.2lf%%",value*100];
    
    if (finish && self.menuBlock) self.menuBlock(DBMenuChangeChapter, index);
}

- (void)removeReaderPanelView{
    [self.readerPanelView removeFromSuperview];
    [self.readerSettingView removeFromSuperview];
}

#pragma readerSettingView action
- (void)changeReaderModelClickAction:(NSInteger)index{
    self.readerSettingView.styleIndex = index;
    
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    setting.turnStyle = index;
    setting.isAutoScroll = NO;
    [setting reloadSetting];
    
    if (self.menuBlock) self.menuBlock(DBMenuChangeTransition, index);
}

- (void)changeReaderAutomaticClickAction{
    DBWeakSelf
    LEEAlert.alert.config.LeeTitle(@"温馨提示").
    LeeContent(@"开启自动阅读会使您的屏幕保持常亮，退出自动阅读会还原为您的系统设置。").
    LeeAddAction(^(LEEAction * _Nonnull action) {
        action.type = LEEActionTypeDefault;
        action.title = @"知道啦";
        action.titleColor = DBColorExtension.grayColor;
        action.font = DBFontExtension.bodySixTenFont;
        action.clickBlock = ^{
            DBStrongSelfElseReturn
            if (self.menuBlock) self.menuBlock(DBMenuReaderAutomatic, 3);
        };
    }).LeeShow();
}

- (void)eyeModeChangeValue:(UIButton *)sender{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    sender.selected = !sender.selected;
    setting.isEyeShaow = sender.selected;
    [setting reloadSetting];
    [DBReaderSetting openEyeProtectionMode];
}

- (void)reduceFontSizeClickAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    if (setting.textFontSize <= 10) return;
    setting.textFontSize--;
    self.readerSettingView.fontSize = setting.textFontSize;
    [setting reloadSetting];
    if (self.menuBlock) self.menuBlock(DBMenuChangeFont, 0);
}

- (void)addFontSizeClickAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    if (setting.textFontSize >= 35) return;
    setting.textFontSize++;
    self.readerSettingView.fontSize = setting.textFontSize;
    [setting reloadSetting];
    if (self.menuBlock) self.menuBlock(DBMenuChangeFont, 0);
}

- (void)reduceLineSpacingClickAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    if (setting.lineSpacing <= 1) return;
    setting.lineSpacing--;
    self.readerSettingView.lineSpacing = setting.lineSpacing;
    [setting reloadSetting];
    if (self.menuBlock) self.menuBlock(DBMenuChangeFont, 0);
}

- (void)addLineSpacingClickAction{
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    if (setting.lineSpacing >= 30) return;
    setting.lineSpacing++;
    self.readerSettingView.lineSpacing = setting.lineSpacing;
    [setting reloadSetting];
    if (self.menuBlock) self.menuBlock(DBMenuChangeFont, 0);
}

- (void)changeFontNameClickAction{
    if (self.menuBlock) self.menuBlock(DBMenuChangeFont, 0);
}

- (void)changeReaderBackgroundColorClickAction:(NSInteger)index{
    NSInteger color_index = index;
    DBReadBookSetting *setting = DBReadBookSetting.setting;
    if (color_index < 0 || color_index > DBReadBookSetting.settingTextColors.count-1) return;

    UIColor *textColor = DBReadBookSetting.settingTextColors[color_index];
    UIColor *backgroundColor = DBReadBookSetting.settingBackgroundColors[color_index];
    setting.textColor = textColor;
    setting.backgroundColor = backgroundColor;
    if (index < DBReadBookSetting.settingTextColors.count-1) setting.oldColorIndex = index;
    [setting reloadSetting];
    
    self.chapterNameView.textColor = textColor;
    self.batteryDateView.textColor = textColor;
    self.readerPanelView.bookgroundColor = backgroundColor;
    self.readerSettingView.bookgroundColor = backgroundColor;
    self.readerVc.view.backgroundColor = backgroundColor;
    
    if (self.menuBlock) self.menuBlock(DBMenuChangeBackgroundColor, 0);
}

- (DBReadBookSettingView *)readerPanelView{
    if (!_readerPanelView){
        _readerPanelView = [[DBReadBookSettingView alloc] init];
        
        DBWeakSelf
        _readerPanelView.clickMenuAction = ^(UIButton * _Nullable sender, NSInteger index) {
            DBStrongSelfElseReturn
            
            switch (index) {
                case 0:
                    [self removeReaderPanelClickAction];
                    break;
                case 1:
                    [DBRouter closePage];
                    break;
                case 10: //反馈
                    [self feedbackClickAction];
                    break;
                case 11: //下载
                    [self downloadClickAction];
                    break;
                case 12: //评论
                    if (self.readerVc.book) [DBRouter openPageUrl:DEBookComment params:@{@"book":self.readerVc.book}];
                    break;
                case 13: //第三方数据，点击访问
                    [self exterLinkClickAction];
                    break;
                case 20: //听书
                    [self speechClickAction];
                    break;
                case 21: //书源
                    [self changeBookSourceClickAction];
                    break;
                case 30: //目录
                    [self openCatalogsClickAction];
                    break;
                case 31: //护眼
                    [self eyeModeClickAction:sender];
                    break;
                case 32: //设置
                    [self openBookSettingClickAction];
                    break;
                default:
                    break;
            }
        };
        
        _readerPanelView.scrollSliderAction = ^(CGFloat value, BOOL finish) {
            DBStrongSelfElseReturn
            [self chapterChagingWithSliderValue:value finish:finish];
        };
    }
    return _readerPanelView;
}

- (DBSpeechMenuView *)speechPanelView{
    if (!_speechPanelView){
        _speechPanelView = [[DBSpeechMenuView alloc] init];
    }
    return _speechPanelView;
}

- (DBBookSettingView *)readerSettingView{
    if (!_readerSettingView){
        _readerSettingView = [[DBBookSettingView alloc] init];
        
        DBWeakSelf
        _readerSettingView.clickMenuAction = ^(UIButton * _Nonnull sender, NSInteger index) {
            DBStrongSelfElseReturn
            switch (index) {
                case 0:case 1:case 2:
                    [self changeReaderModelClickAction:index];
                    break;
                case 3:
                    [self changeReaderAutomaticClickAction];
                    break;
                case 10:
                    [self eyeModeChangeValue:sender];
                    break;
                case 20:
                    [self reduceFontSizeClickAction];
                    break;
                case 21:
                    [self addFontSizeClickAction];
                    break;
                case 22:
                    [self changeFontNameClickAction];
                    break;
                case 23:
                    [self reduceLineSpacingClickAction];
                    break;
                case 24:
                    [self addLineSpacingClickAction];
                    break;
                default:
                   if (index >= 30) [self changeReaderBackgroundColorClickAction:index-30];
                    break;
            }
        };
    }
    return _readerSettingView;
}

- (DBChapterNameView *)chapterNameView{
    if (!_chapterNameView){
        _chapterNameView = [[DBChapterNameView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarSafeHeight+20)];
        _chapterNameView.textColor = DBReadBookSetting.setting.textColor;
    }
    return _chapterNameView;
}

- (DBBatteryDateView *)batteryDateView{
    if (!_batteryDateView){
        _batteryDateView = [[DBBatteryDateView alloc] initWithFrame:CGRectMake(0, UIScreen.screenHeight-UIScreen.tabbarSafeHeight-20, UIScreen.screenWidth, 20+UIScreen.tabbarSafeHeight)];
        _batteryDateView.textColor = DBReadBookSetting.setting.textColor;
    }
    return _batteryDateView;
}

@end
